package initialPackages;

import org.springframework.data.repository.CrudRepository;
import initialPackages.WhitelistUser;



public interface WhitelistRepository extends CrudRepository< WhitelistUser, String> {


}
