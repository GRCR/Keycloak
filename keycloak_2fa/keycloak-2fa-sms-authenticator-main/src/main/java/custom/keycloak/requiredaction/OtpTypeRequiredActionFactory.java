package custom.keycloak.requiredaction;

import org.keycloak.Config;
import org.keycloak.authentication.RequiredActionFactory;
import org.keycloak.authentication.RequiredActionProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;


public class OtpTypeRequiredActionFactory implements RequiredActionFactory {

    private static final OtpTypeRequiredAction SINGLETON = new OtpTypeRequiredAction();

    @Override
    public RequiredActionProvider create(KeycloakSession session) {
        return SINGLETON;
    }

    @Override
    public String getId() {
        return OtpTypeRequiredAction.PROVIDER_ID;
    }

    @Override
    public String getDisplayText() {
        return "Select Otp type";
    }

    @Override
    public void init(Config.Scope config) {

    }

    @Override
    public void postInit(KeycloakSessionFactory factory) {

    }

    @Override
    public void close() {

    }

}
