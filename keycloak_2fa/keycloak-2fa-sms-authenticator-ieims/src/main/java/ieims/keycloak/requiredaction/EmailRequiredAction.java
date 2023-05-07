package ieims.keycloak.requiredaction;

import org.keycloak.authentication.InitiatedActionSupport;
import org.keycloak.authentication.RequiredActionContext;
import org.keycloak.authentication.RequiredActionProvider;
import org.keycloak.connections.jpa.JpaConnectionProvider;
import org.keycloak.forms.login.LoginFormsProvider;
import org.keycloak.models.UserModel;
import org.keycloak.models.utils.FormMessage;
import org.keycloak.services.validation.Validation;

import ieims.keycloak.federationdb.UserEntity;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;

import java.util.List;
import java.util.function.Consumer;

/**
 * @author Niko Köbler, https://www.n-k.de, @dasniko
 */
public class EmailRequiredAction implements RequiredActionProvider {

	public static final String PROVIDER_ID = "email-id-ra";

	private static final String EMAIL_ID_FIELD = "email_id";

	@Override
	public InitiatedActionSupport initiatedActionSupport() {
		return InitiatedActionSupport.SUPPORTED;
	}

	@Override
	public void evaluateTriggers(RequiredActionContext context) {
		// May need to check into DB for email
		if (context.getUser().getFirstAttribute(EMAIL_ID_FIELD) == null) {
			context.getUser().addRequiredAction(PROVIDER_ID);
		}
	}

	@Override
	public void requiredActionChallenge(RequiredActionContext context) {
		// show initial form
		context.challenge(createForm(context, null));
	}

	@Override
	public void processAction(RequiredActionContext context) {
		// submitted form

		UserModel user = context.getUser();

		MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
		String emailId = formData.getFirst(EMAIL_ID_FIELD);

		if (Validation.isBlank(emailId) || emailId.length() < 5) {
			context.challenge(
					createForm(context, form -> form.addError(new FormMessage(EMAIL_ID_FIELD, "Invalid input"))));
			return;
		}
		// Updating user email into DB
		EntityManager em = context.getSession().getProvider(JpaConnectionProvider.class, "user-store")
				.getEntityManager();
		TypedQuery<UserEntity> query = em.createNamedQuery("getUserByUsername", UserEntity.class);
		query.setParameter("username", user.getUsername());
		List<UserEntity> result = query.getResultList();
		if (!result.isEmpty()) {
			UserEntity userEntity = result.get(0);
			userEntity.setEmail(emailId);
			em.persist(userEntity);
		}

		user.setSingleAttribute(EMAIL_ID_FIELD, emailId);
		user.removeRequiredAction(PROVIDER_ID);

		context.success();
	}

	@Override
	public void close() {
	}

	private Response createForm(RequiredActionContext context, Consumer<LoginFormsProvider> formConsumer) {
		LoginFormsProvider form = context.form();
		form.setAttribute("username", context.getUser().getUsername());

		String emailId = context.getUser().getFirstAttribute(EMAIL_ID_FIELD);
		form.setAttribute(EMAIL_ID_FIELD, emailId == null ? "" : emailId);

		if (formConsumer != null) {
			formConsumer.accept(form);
		}

		return form.createForm("update-email-id.ftl");
	}

}
