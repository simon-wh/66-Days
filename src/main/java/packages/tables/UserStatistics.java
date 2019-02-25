package packages.tables;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity 
public class UserStatistics {
	@Id @Column(length = 128) 
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
