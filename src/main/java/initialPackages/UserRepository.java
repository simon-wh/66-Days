package initialPackages;

import org.springframework.data.repository.CrudRepository;
import initialPackages.User;

public interface UserRepository extends CrudRepository<User, Integer>{
    
}
