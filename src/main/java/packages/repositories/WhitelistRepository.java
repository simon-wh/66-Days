package packages.repositories;

import org.springframework.data.repository.CrudRepository;
import packages.tables.WhitelistMember;

//The code for this repository is all covered by extending the Crudrepository.
public interface WhitelistRepository extends CrudRepository <WhitelistMember, String> {

}
