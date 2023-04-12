package custom.keycloak.federationdb;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.apache.commons.codec.digest.DigestUtils;
import org.keycloak.component.ComponentModel;
import org.keycloak.connections.jpa.JpaConnectionProvider;
import org.keycloak.credential.*;
import org.keycloak.models.*;
import org.keycloak.models.cache.CachedUserModel;
import org.keycloak.models.credential.PasswordCredentialModel;
import org.keycloak.storage.ReadOnlyException;
import org.keycloak.storage.StorageId;
import org.keycloak.storage.UserStorageProvider;
import org.keycloak.storage.adapter.AbstractUserAdapter;
import org.keycloak.storage.user.UserLookupProvider;
import org.keycloak.storage.user.UserQueryProvider;
import org.keycloak.storage.user.UserRegistrationProvider;

import java.util.logging.Logger;
import java.util.stream.Stream;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

public class MySQLUserStorageProvider
        implements UserStorageProvider, UserLookupProvider, UserRegistrationProvider, CredentialInputValidator,
        CredentialInputUpdater {

    private static final Logger logger = Logger.getLogger(MySQLUserStorageProvider.class.getName());
    public static final String PASSWORD_CACHE_KEY = UserAdapter.class.getName() + ".password";
    protected KeycloakSession session;
    protected EntityManager em;
    protected ComponentModel config;

    public MySQLUserStorageProvider(KeycloakSession session, ComponentModel config) {
        this.session = session;
        this.config = config;
        em = session.getProvider(JpaConnectionProvider.class, "user-store").getEntityManager();
    }

    @Override
    public UserModel addUser(RealmModel realm, String username) {
        UserEntity entity = new UserEntity();
        entity.setId(UUID.randomUUID().toString());
        entity.setUsername(username);
        em.persist(entity);
        // logger.info("added user: " + username);
        return new UserAdapter(session, realm, config, entity);
    }

    @Override
    public boolean removeUser(RealmModel realm, UserModel user) {
        String persistenceId = StorageId.externalId(user.getId());
        UserEntity entity = em.find(UserEntity.class, persistenceId);
        if (entity == null)
            return false;
        em.remove(entity);
        return true;
    }

    @Override
    public boolean updateCredential(RealmModel realm, UserModel user, CredentialInput input) {
        if (!supportsCredentialType(input.getType()) || !(input instanceof UserCredentialModel)) {
            // logger.info("updateCredentials: false");
            return false;
        }

        UserCredentialModel cred = (UserCredentialModel) input;
        UserAdapter adapter = getUserAdapter(user);
        adapter.setPassword(cred.getValue());
        // logger.info("updateCredentials: true");
        return true;
    }

    public UserAdapter getUserAdapter(UserModel user) {
        UserAdapter adapter = null;
        if (user instanceof CachedUserModel) {
            adapter = (UserAdapter) ((CachedUserModel) user).getDelegateForUpdate();
        } else {
            adapter = (UserAdapter) user;
        }
        return adapter;
    }

    @Override
    public void disableCredentialType(RealmModel realm, UserModel user, String credentialType) {

    }

    @Override
    public Stream<String> getDisableableCredentialTypesStream(RealmModel realm, UserModel user) {
        return Stream.empty();
    }

    @Override
    public boolean supportsCredentialType(String credentialType) {
        return credentialType.equals(PasswordCredentialModel.TYPE);
    }

    public String getPassword(UserModel user) {
        // logger.info("getPassword: " + user.toString());
        String password = null;
        if (user instanceof CachedUserModel) {
            password = (String) ((CachedUserModel) user).getCachedWith().get(PASSWORD_CACHE_KEY);
        } else if (user instanceof UserAdapter) {
            password = ((UserAdapter) user).getPassword();
        }
        if(password==null){
            TypedQuery<UserEntity> query = em.createNamedQuery("getUserByUsername", UserEntity.class);
            query.setParameter("username", user.getUsername());
        List<UserEntity> result = query.getResultList();
        if (result.isEmpty()) {
            // logger.info("could not find username: " + user.getUsername());
            return null;
        }
        password = ((UserEntity)result.get(0)).getPassword();
        }
        // logger.info("password: " + password);
        return password;
    }

    @Override
    public boolean isConfiguredFor(RealmModel realm, UserModel user, String credentialType) {
        // logger.info("isConfiguredFor: " + credentialType.toString());
        return supportsCredentialType(credentialType) && getPassword(user) != null;
    }

    @Override
    public boolean isValid(RealmModel realm, UserModel user, CredentialInput credentialInput) {
        // logger.info("isValid: " + credentialInput.toString());
        if (!supportsCredentialType(credentialInput.getType()) || !(credentialInput instanceof UserCredentialModel))
            return false;
        UserCredentialModel cred = (UserCredentialModel) credentialInput;
        String password = getPassword(user);
        
        return password != null && password.equals(DigestUtils.sha1Hex(cred.getValue()));
    }

    @Override
    public UserModel getUserById(RealmModel realm, String id) {
        // logger.info("getUserById: " + id);
        String persistenceId = StorageId.externalId(id);
        // logger.info("persistenceId: "+ persistenceId);
        UserEntity entity = em.find(UserEntity.class, persistenceId);
        if (entity == null) {
            // logger.info("could not find user by id: " + id);
            return null;
        }
        // logger.info("persistenceId Entity: "+entity.getUsername());
        return new UserAdapter(session, realm, config, entity);
    }

    @Override
    public UserModel getUserByUsername(RealmModel realm, String username) {
        // logger.info("getUserByUsername: " + username);
        TypedQuery<UserEntity> query = em.createNamedQuery("getUserByUsername", UserEntity.class);
        query.setParameter("username", username);
        List<UserEntity> result = query.getResultList();
        if (result.isEmpty()) {
            // logger.info("could not find username: " + username);
            return null;
        }
        UserEntity userEntity = (UserEntity)result.get(0);
        // logger.info("userEntity Password: "+userEntity.getPassword());
        return new UserAdapter(session, realm, config, result.get(0));
    }

    @Override
    public CredentialValidationOutput getUserByCredential(RealmModel realm, CredentialInput input) {
        return UserLookupProvider.super.getUserByCredential(realm, input);
    }

    @Override
    public UserModel getUserByEmail(RealmModel realm, String email) {
        TypedQuery<UserEntity> query = em.createNamedQuery("getUserByEmail", UserEntity.class);
        query.setParameter("email", email);
        List<UserEntity> result = query.getResultList();
        if (result.isEmpty())
            return null;
        return new UserAdapter(session, realm, config, result.get(0));
    }

    @Override
    public void close() {
    }

}
