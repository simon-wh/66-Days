package initialPackages;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity //This tells Hibernate to make a table out of this class**
public class WhitelistUser {
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private Integer id;

	private String email;


	public Integer getID() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}




}
