package custom.keycloak.requiredaction;

import org.keycloak.authentication.CredentialRegistrator;
import org.keycloak.authentication.RequiredActionContext;
import org.keycloak.authentication.RequiredActionProvider;
import org.keycloak.credential.CredentialProvider;
import org.keycloak.models.UserModel;

import java.util.logging.Logger;

import javax.ws.rs.core.Response;

/**
 * @author <a href="mailto:bill@burkecentral.com">Bill Burke</a>
 * @version $Revision: 1 $
 */
public class OtpTypeRequiredAction implements RequiredActionProvider, CredentialRegistrator {
    public static final String PROVIDER_ID = "otp-type-ra";
    private static final String OTP_TYPE_FIELD = "selectedOtpType";

    @Override
    public void evaluateTriggers(RequiredActionContext context) {
        if (context.getUser().getFirstAttribute(OTP_TYPE_FIELD) == null) {
            context.getUser().addRequiredAction(PROVIDER_ID);
        }
    }

    @Override
    public void requiredActionChallenge(RequiredActionContext context) {
        Response challenge = context.form().createForm("select-otp-type.ftl");
        context.challenge(challenge);

    }

    @Override
    public void processAction(RequiredActionContext context) {
        UserModel user = context.getUser();
        String selectedOtpType = (context.getHttpRequest().getDecodedFormParameters().getFirst(OTP_TYPE_FIELD));

        System.out.println("selectedOtpType: " + selectedOtpType);

        user.setSingleAttribute(OTP_TYPE_FIELD, selectedOtpType);
        user.removeRequiredAction(PROVIDER_ID);

        context.success();
    }

    @Override
    public void close() {

    }
}
