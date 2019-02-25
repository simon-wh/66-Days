package packages.tables;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity @Table(name="whitelist")
public class WhitelistMember {
	@Id @Column(length = 128) 
	private final String email;
        
        //Please note that the default length is 256 characters, which is too long to be used as an ID in mySQL.
        
        public String getEmail(){
            return email;
        }
        
        public WhitelistMember(){
            email = "default";
        }

        // See Slide 13 of Simon's intro to Spring databases.
        public WhitelistMember(String emailAddress) {
            email = emailAddress;
        }
}
