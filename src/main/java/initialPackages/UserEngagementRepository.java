package initialPackages;

import org.springframework.data.repository.CrudRepository;
import initialPackages.UserEngagement;

public interface UserEngagementRepository extends CrudRepository<UserEngagement, Integer>{
    
}
