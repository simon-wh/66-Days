/*
package initialPackages.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.oauth2.config.annotation.configurers.ClientDetailsServiceConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configuration.AuthorizationServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableAuthorizationServer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerEndpointsConfigurer;
import org.springframework.security.oauth2.provider.token.TokenStore;

//Following the tutorial at https://www.devglan.com/spring-security/spring-boot-security-oauth2-example

@Configuration
@EnableAuthorizationServer
public class AuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {
    
    static final String CLIENT_ID = "66days-client";
    static final String CLIENT_SECRET = "$2a$04$e/c1/RfsWuThaWFCrcCuJeoyvwCV0URN/6Pn9ZFlrtIWaU/vj/BfG";
    static final String GRANT_TYPE = "password";
    static final String AUTHORIZATION_CODE = "authorization_code";
    static final String REFRESH_TOKEN = "refresh_token";
    static final String IMPLICIT = "implicit";
    static final String SCOPE_READ = "read";
    static final String SCOPE_WRITE = "write";
    static final String TRUST = "trust";
    static final int ACCESS_TOKEN_VALIDITY_SECONDS = 1*60*60;
    static final int FREFRESH_TOKEN_VALIDITY_SECONDS = 6*60*60;
    
    @Autowired
    private TokenStore tokenStore;
    
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Override
    public void configure(ClientDetailsServiceConfigurer configurer) throws Exception {
        configurer
            .inMemory()
            .withClient(CLIENT_ID)
            .secret(CLIENT_SECRET)
            .authorizedGrantTypes(GRANT_TYPE, AUTHORIZATION_CODE, REFRESH_TOKEN, IMPLICIT)
            .scopes(SCOPE_READ, SCOPE_WRITE, TRUST)
            .accessTokenValiditySeconds(ACCESS_TOKEN_VALIDITY_SECONDS)
            .refreshTokenValiditySeconds(FREFRESH_TOKEN_VALIDITY_SECONDS);
    } 
    
    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
        endpoints.tokenStore(tokenStore).authenticationManager(authenticationManager);
    }
}
*/