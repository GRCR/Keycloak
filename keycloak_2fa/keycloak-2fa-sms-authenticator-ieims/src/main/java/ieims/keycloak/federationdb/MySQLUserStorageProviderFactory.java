package ieims.keycloak.federationdb;

import org.keycloak.component.ComponentModel;
import org.keycloak.component.ComponentValidationException;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.provider.ProviderConfigProperty;
import org.keycloak.provider.ProviderConfigurationBuilder;
import org.keycloak.storage.UserStorageProviderFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

public class MySQLUserStorageProviderFactory  implements UserStorageProviderFactory<MySQLUserStorageProvider> {

    private static final Logger logger = Logger.getLogger(MySQLUserStorageProviderFactory.class.getName());

    public static final String PROVIDER_ID = "mysql-users-jpa";


    @Override
    public MySQLUserStorageProvider create(KeycloakSession session, ComponentModel model) {
        
        return new MySQLUserStorageProvider(session, model);
    }

    @Override
    public String getId() {
        return PROVIDER_ID;
    }

    @Override
    public String getHelpText() {
        return "JPA Example User Storage Provider";
    }

    @Override
    public void close() {
        logger.info("<<<<<< Closing factory");

    }

}


