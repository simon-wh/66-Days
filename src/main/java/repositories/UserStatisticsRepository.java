package repositories;

import org.springframework.data.repository.CrudRepository;
import initialPackages.UserStatistics;

//The code for this repository is all covered by extending the Crudrepository.
public interface UserStatisticsRepository extends CrudRepository<UserStatistics, String> {

}
