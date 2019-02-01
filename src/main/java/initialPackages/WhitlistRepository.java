package initialPackages;

import org.springframework.data.repository.CrudRepository;
import initialPackages.WhitelistUser;



public interface WhitlistRepository extends CrudRepository< WhitelistUser, Integer> {


}
