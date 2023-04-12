package custom.keycloak.authenticator;

import custom.keycloak.authenticator.gateway.SmsServiceFactory;
import lombok.extern.jbosslog.JBossLog;

import org.hibernate.annotations.common.util.impl.LoggerFactory;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.AuthenticationFlowError;
import org.keycloak.authentication.AuthenticationFlowException;
import org.keycloak.authentication.Authenticator;
import org.keycloak.common.util.SecretGenerator;
import org.keycloak.connections.jpa.JpaConnectionProvider;
import org.keycloak.email.EmailException;
import org.keycloak.email.EmailTemplateProvider;
import org.keycloak.forms.login.LoginFormsProvider;
import org.keycloak.models.AuthenticationExecutionModel;
import org.keycloak.models.AuthenticatorConfigModel;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.sessions.AuthenticationSessionModel;
import org.keycloak.theme.Theme;

import com.fasterxml.jackson.annotation.OptBoolean;
import com.google.protobuf.Timestamp;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * @author Niko Köbler, https://www.n-k.de, @dasniko
 */
@JBossLog
public class SmsAuthenticator implements Authenticator {

	public static final String OTP_CODE = "otpCode";
	private static final String OTP_TYPE_FIELD = "selectedOtpType";
	public static final String TEMPLATE_LAYOUT = "login-sms.ftl";

	@Override
	public void authenticate(AuthenticationFlowContext context) {

		challenge(context);
	}

	private void challenge(AuthenticationFlowContext context) {
		LoginFormsProvider form = context.form()
		.setAttribute("realm", context.getRealm());

		Response response = form.createForm(TEMPLATE_LAYOUT);
		context.challenge(response);
	}

	private String generateOtp(AuthenticationFlowContext context) {
		AuthenticatorConfigModel config = context.getAuthenticatorConfig();
		KeycloakSession session = context.getSession();
		UserModel user = context.getUser();

		int length = Integer.parseInt(config.getConfig().get("length"));
		int ttl = Integer.parseInt(config.getConfig().get("ttl"));

		String code = SecretGenerator.getInstance().randomString(length, SecretGenerator.DIGITS);
		AuthenticationSessionModel authSession = context.getAuthenticationSession();
		authSession.setAuthNote(OTP_CODE, code);
		authSession.setAuthNote("ttl", Long.toString(System.currentTimeMillis() + (ttl * 1000L)));

		try {
			Theme theme = session.theme().getTheme(Theme.Type.LOGIN);
			Locale locale = session.getContext().resolveLocale(user);
			String smsAuthText = theme.getMessages(locale).getProperty("smsAuthText");
			// String smsAuthSmsNotSent =
			// theme.getMessages(locale).getProperty("smsAuthSmsNotSent");
			String message = String.format(smsAuthText, code, Math.floorDiv(ttl, 60));

			// Insert OTP into OPTModel
			OTPModel otpModel = new OTPModel();
			otpModel.setUsername(user.getUsername());
			otpModel.setOtp(code);
			otpModel.setCreatedDate(LocalDateTime.now().toString());
			otpModel.setTtl(ttl);
			otpModel.setLoginAttempt(0);
			otpModel.setId(UUID.randomUUID().toString());
			EntityManager em = session.getProvider(JpaConnectionProvider.class, "user-store").getEntityManager();
			em.persist(otpModel);
			return message;

		} catch (Exception e) {
			context.failureChallenge(AuthenticationFlowError.INTERNAL_ERROR,
					context.form().setError("smsAuthSmsNotSent", e.getMessage())
							.createErrorPage(Response.Status.INTERNAL_SERVER_ERROR));
		}
		return null;
	}

	@Override
	public void action(AuthenticationFlowContext context) {
		KeycloakSession session = context.getSession();
		UserModel user = context.getUser();
		MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();

		if (formData.containsKey("getOtp")) {
			AuthenticatorConfigModel config = context.getAuthenticatorConfig();
			String message = generateOtp(context);
			if (message == null)
				return;
			String selectedOtpType = formData.getFirst(OTP_TYPE_FIELD);

			if (selectedOtpType.equalsIgnoreCase("Mobile")) {
				String mobileNumber = user.getFirstAttribute("mobile_number");
				System.out.println("OTP to number: " + mobileNumber);
				SmsServiceFactory.get(config.getConfig()).send(mobileNumber, message);
			} else {
				String email = user.getFirstAttribute("email_id");
				user.setSingleAttribute("email", email);
				user.setEmail(email);
				System.out.println("OTP to email: " + email);
				sendEmailWithCode(context, user, message);
			}

			challenge(context);

			return;
		}

		String enteredCode = formData.getFirst(OTP_CODE);

		AuthenticationSessionModel authSession = context.getAuthenticationSession();
		String code = authSession.getAuthNote(OTP_CODE);
		String ttl = authSession.getAuthNote("ttl");
		// Get code and ttl from DB
		if (code == null || ttl == null) {
			context.failureChallenge(AuthenticationFlowError.INTERNAL_ERROR,
					context.form().createErrorPage(Response.Status.INTERNAL_SERVER_ERROR));
			return;
		}

		boolean isValid = enteredCode.equals(code);
		if (isValid) {
			if (Long.parseLong(ttl) < System.currentTimeMillis()) {
				// expired
				context.failureChallenge(AuthenticationFlowError.EXPIRED_CODE,
						context.form().setError("smsAuthCodeExpired").createErrorPage(Response.Status.BAD_REQUEST));
			} else {
				// valid
				context.success();
			}
		} else {
			// invalid
			AuthenticationExecutionModel execution = context.getExecution();
			if (execution.isRequired()) {
				context.failureChallenge(AuthenticationFlowError.INVALID_CREDENTIALS,
						context.form().setAttribute("realm", context.getRealm())
								.setError("smsAuthCodeInvalid").createForm(TEMPLATE_LAYOUT));

				// Update OPTModel attempt by 1
				EntityManager em = session.getProvider(JpaConnectionProvider.class, "user-store").getEntityManager();
				TypedQuery<OTPModel> query = em.createNamedQuery("getOTPModelByUsername", OTPModel.class);
				query.setParameter("username", user.getUsername());
				List<OTPModel> result = query.getResultList();
				if (!result.isEmpty()) {
					OTPModel otpModel = result.get(0);
					otpModel.setLoginAttempt(otpModel.getLoginAttempt() + 1);
					em.persist(otpModel);
				}

			} else if (execution.isConditional() || execution.isAlternative()) {
				context.attempted();
			}
		}
	}

	@Override
	public boolean requiresUser() {
		return true;
	}

	@Override
	public boolean configuredFor(KeycloakSession session, RealmModel realm, UserModel user) {
		// return true;
		 return user.getFirstAttribute("mobile_number") != null && user.getFirstAttribute("email_id") != null;
	
	}

	@Override
	public void setRequiredActions(KeycloakSession session, RealmModel realm, UserModel user) {
		// this will only work if you have the required action from here configured:
		// https://github.com/dasniko/keycloak-extensions-demo/tree/main/requiredaction

		// user.addRequiredAction("otp-type-ra");
		//user.addRequiredAction("mobile-number-ra");
		//user.addRequiredAction("email-ra");
		
	}

	@Override
	public void close() {
	}

	private void sendEmailWithCode(AuthenticationFlowContext context, UserModel user, String message) {
		RealmModel realm = context.getRealm();
		log.info(message);
		KeycloakSession session = context.getSession();
		if (user.getEmail() == null) {
			log.warnf("Could not send access code email due to missing email. realm=%s user=%s", realm.getId(),
					user.getUsername());
			throw new AuthenticationFlowException(AuthenticationFlowError.INVALID_USER);
		}

		Map<String, Object> mailBodyAttributes = new HashMap<>();
		mailBodyAttributes.put("username", user.getUsername());
		mailBodyAttributes.put("message", message);

		String realmName = realm.getDisplayName() != null ? realm.getDisplayName() : realm.getName();
		List<Object> subjectParams = List.of(realmName);
		try {
			EmailTemplateProvider emailProvider = session.getProvider(EmailTemplateProvider.class);
			emailProvider.setRealm(realm);
			emailProvider.setUser(user);
			// Don't forget to add the code-email.ftl (html and text) template to your
			// theme.
			emailProvider.send("emailCodeSubject", subjectParams, "code-email.ftl", mailBodyAttributes);
		} catch (EmailException eex) {
			log.errorf(eex, "Failed to send access code email. realm=%s user=%s email=%s", realm.getId(), user.getUsername(), user.getEmail());
		}
	}
}
