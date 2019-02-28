package packages.repositories;

import org.springframework.data.repository.CrudRepository;
import packages.tables.CourseWeek;

//The code for this repository is all covered by extending the Crudrepository.
public interface CourseContentRepository extends CrudRepository<CourseWeek, Integer> {

}
