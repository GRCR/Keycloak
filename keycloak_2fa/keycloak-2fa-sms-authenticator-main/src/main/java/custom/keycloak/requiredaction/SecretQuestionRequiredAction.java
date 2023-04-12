package custom.keycloak.requiredaction;

import org.keycloak.authentication.CredentialRegistrator;
import org.keycloak.authentication.RequiredActionContext;
import org.keycloak.authentication.RequiredActionProvider;
import org.keycloak.credential.CredentialProvider;
import org.keycloak.models.UserModel;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;

/**
 * @author <a href="mailto:bill@burkecentral.com">Bill Burke</a>
 * @version $Revision: 1 $
 */
public class SecretQuestionRequiredAction implements RequiredActionProvider, CredentialRegistrator {
    public static final String PROVIDER_ID = "secret_question_config";

    @Override
    public void evaluateTriggers(RequiredActionContext context) {
        if (context.getUser().getFirstAttribute("secret_answer") == null) {
            context.getUser().addRequiredAction(PROVIDER_ID);
        }
    }

    @Override
    public void requiredActionChallenge(RequiredActionContext context) {
        List<String> questions = new ArrayList<String>();
        // Have to get question list from DB
        questions.add("What is your mother's name?");
        questions.add("What is your first name?");

        Response challenge = context.form()
                .setAttribute("Questions", questions)
                .createForm("secret-question-config.ftl");
        context.challenge(challenge);

    }

    @Override
    public void processAction(RequiredActionContext context) {
        UserModel user = context.getUser();
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();

        String secretQuestion = formData.getFirst("selectedQuestion");
        String answer = formData.getFirst("secret_answer");

        // SecretQuestionCredentialProvider sqcp = (SecretQuestionCredentialProvider)
        // context.getSession().getProvider(CredentialProvider.class,
        // "secret-question");
        // sqcp.createCredential(context.getRealm(), context.getUser(),
        // SecretQuestionCredentialModel.createSecretQuestion("What is your mom's first
        // name?", answer));

        // Need to store ques & ans into DB, reference Email Required action
        user.setSingleAttribute("secret_answer", answer);
        user.setSingleAttribute("secret_question", secretQuestion);

        user.removeRequiredAction(PROVIDER_ID);

        context.success();
    }

    @Override
    public void close() {

    }
}
