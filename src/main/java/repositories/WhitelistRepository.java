package repositories;

import org.springframework.data.repository.CrudRepository;
import initialPackages.WhitelistUser;

//The code for this repository is all covered by extending the Crudrepository.
public interface WhitelistRepository extends CrudRepository< WhitelistUser, String> {

}
