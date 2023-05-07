package ieims.keycloak.requiredaction;

import org.keycloak.Config;
import org.keycloak.authentication.RequiredActionFactory;
import org.keycloak.authentication.RequiredActionProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;


public class SecretQuestionRequiredActionFactory implements RequiredActionFactory {

    private static final SecretQuestionRequiredAction SINGLETON = new SecretQuestionRequiredAction();

    @Override
    public RequiredActionProvider create(KeycloakSession session) {
        return SINGLETON;
    }


    @Override
    public String getId() {
        return SecretQuestionRequiredAction.PROVIDER_ID;
    }

    @Override
    public String getDisplayText() {
        return "Secret Question";
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
