package com.keycloak.federationdb;

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

    protected static final List<ProviderConfigProperty> configMetadata;

    public static final String PROVIDER_NAME = "mysql-users";

    static {
        configMetadata = ProviderConfigurationBuilder.create().property().name("mysql")
                .type(ProviderConfigProperty.STRING_TYPE).label("MySQL URI")
                .defaultValue("jdbc:mysql://127.0.0.1:3306/dbuser").helpText("MySQL URI").add().property()

                .name("table").type(ProviderConfigProperty.STRING_TYPE).label("Users Table").defaultValue("users")
                .helpText("Table where users are stored").add().property().name("username")

                .type(ProviderConfigProperty.STRING_TYPE).label("Username Column").defaultValue("username")
                .helpText("Column name that holds the usernames").add().property().name("password")

                .type(ProviderConfigProperty.STRING_TYPE).label("Password Column").defaultValue("password")
                .helpText("Column name that holds the passwords").add().property().name("hash")

                .type(ProviderConfigProperty.LIST_TYPE).label("Hash Algorithm").defaultValue("SHA1")
                .options(Arrays.asList("SHA1", "MD5")).helpText("Algorithm used for hashing").add().build();
    }

    @Override
    public MySQLUserStorageProvider create(KeycloakSession session, ComponentModel model) {
        String uri = model.getConfig().getFirst("mysql");
        
        Connection conn = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(uri, "root", "Grcr@3943");
        } catch (SQLException ex) {
            // handle any errors
            logger.info("SQLException: " + ex.getMessage());
            logger.info("SQLState: " + ex.getSQLState());
            logger.info("VendorError: " + ex.getErrorCode());
            throw new ComponentValidationException(ex.getMessage());
        } catch (ClassNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return new MySQLUserStorageProvider(session, model, conn);
    }


    @Override
    public String getId() {
        return PROVIDER_NAME;
    }

    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        return configMetadata;
    }

    @Override
    public void validateConfiguration(KeycloakSession session, RealmModel realm, ComponentModel config) throws ComponentValidationException {
        UserStorageProviderFactory.super.validateConfiguration(session, realm, config);
        String uri = config.getConfig().getFirst("mysql");
        if (uri == null)
            throw new ComponentValidationException("MySQL connection URI not present");
        Connection conn = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(uri, "root", "Grcr@3943");
            conn.isValid(1000);
        } catch (SQLException ex) {
            // handle any errors
            logger.info("SQLException: " + ex.getMessage());
            logger.info("SQLState: " + ex.getSQLState());
            logger.info("VendorError: " + ex.getErrorCode());
            throw new ComponentValidationException(ex.getMessage());
        } catch (ClassNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }



}


