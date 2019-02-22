package repositories;

import org.springframework.data.repository.CrudRepository;
import initialPackages.CourseContent;

//The code for this repository is all covered by extending the Crudrepository.
public interface CourseContentRepository extends CrudRepository<CourseContent, String> {

}
