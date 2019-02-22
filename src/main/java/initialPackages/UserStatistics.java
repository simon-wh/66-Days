package initialPackages;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity //This tells Hibernate to make a table out of this class.
public class UserStatistics {
	@Id
	private String userID;
        
        private String json;
        
        public String getUserID(){
            return userID;
        }
        
        public void setUserID(String userID){
            this.userID = userID;
        }

	public String getJson() {
            return json;
	}
        
	public void setJson(String json) {
            this.json = json;
	}
}
