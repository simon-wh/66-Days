/*package initialPackages.config;

import javax.activation.DataSource;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@Configuration
public class MultipleDataSourceConfiguration {
 
    @Bean
    @Primary
    @ConfigurationProperties(prefix="spring.datasource")
    public DataSource primaryDataSource() {
        return (DataSource) DataSourceBuilder.create().build();
    }
 
    @Bean
    @ConfigurationProperties(prefix="spring.secondDatasource")
    public DataSource secondaryDataSource() {
        return (DataSource) DataSourceBuilder.create().build();
    }
}


*/