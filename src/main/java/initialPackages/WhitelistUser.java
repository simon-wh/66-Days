package initialPackages;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity //This tells Hibernate to make a table out of this class.
public class WhitelistUser {
	@Id
	@Column(length = 128) //Please note that the default length is 256 characters, which is too long to be used as an ID in mySQL.
	private String email;

	public String getEmail() {
            return email;
	}
        
	public void setEmail(String id) {
            this.email = id;
	}
        
        //Todo: include testing so that the email set is never longer than 128 characters.
}
