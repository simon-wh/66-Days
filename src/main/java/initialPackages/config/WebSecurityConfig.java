/*
package initialPackages.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
//Imports specific to the Oauth2 code.
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.oauth2.provider.token.TokenStore;
import org.springframework.security.oauth2.provider.token.store.InMemoryTokenStore;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import javax.annotation.Resource;


@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
    
    @Resource(name = "userService")
    private UserDetailsService userDetailsService;
    
    @Override
    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
    
    @Bean
    public BCryptPasswordEncoder encoder(){
        return new BCryptPasswordEncoder();
    }
    
    @Autowired
    public void globalUserDetails(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService)
                .passwordEncoder(encoder()); //BCryptPasswordEncoder, see above.
    }
    
    @Bean
    public FilterRegistrationBean corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.addAllowedOrigin("*");
        config.addAllowedHeader("*");
        config.addAllowedMethod("*");
        source.registerCorsConfiguration("/**", config);
        FilterRegistrationBean bean = new FilterRegistrationBean(new CorsFilter(source));
        bean.setOrder(0);
        return bean;
    }
    
    /
    //This old userDetailsService was created for testing logging in and out of the server.
    //It is no longer suitable for production purposes.
    @Bean
    @Override
    public UserDetailsService userDetailsService(){
        UserDetails user = User.withDefaultPasswordEncoder()
                .username("ben@66days.co")
                .password("password")
                .roles("USER")
                .build();
        
        return new InMemoryUserDetailsManager(user);
    }
    /
    
    /
    //This is once again old code used for testing the login and logout sequence for accessing areas of the site.
    //The question is, how do we combine both aspects of allowing Ben to login and mobile devices to access the API -
    //without completely confusing the two of them? Without causing security leaks / risks? HMMM.
    
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        //The index and home paths require no authentication, but all other paths do.
        //request to login is shown by default if another path is accessed.
        http
            .authorizeRequests()
                .antMatchers("/","/home").permitAll()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
                .permitAll()
                .and()
            .logout()
                .permitAll();
    }
    
    /
}

*/