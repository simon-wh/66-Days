package packages.tables;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;

@Entity 
public class UserStatistics {
        //// COLUMNS ////
	@Id
        @GeneratedValue(strategy=GenerationType.AUTO)
        private Integer id;
        
        @Column
        private String userId;
        
        @Lob 
        @Column(name="json", length=2048)
        private String json;
        
        //// CONSTRUCTORS ////
        public UserStatistics(){}
        
        public UserStatistics(String userId, String json){
            this.userId = userId;
            this.json = json;
        }
        
        //// GETTERS ////
        public Integer getId(){
            return id;
        }
        
        public String getUserId(){
            return userId;
        }
        
        public String getJson() {
            return json;
	}
        
        //// SETTERS ////
        public void setId(Integer id){
            this.id = id;
        }
        
        public void setUserId(String userId){
            this.userId = userId;
        }

	public void setJson(String json) {
            this.json = json;
	}
}
