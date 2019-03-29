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
        
        @Lob 
        @Column(name="description", length=2048)
        private String json;
        
        //// CONSTRUCTORS ////
        public UserStatistics(){}
        
        public UserStatistics(String json){
            this.json = json;
        }
        
        //// GETTERS ////
        public int getId(){
            return id;
        }
        
        public String getJson() {
            return json;
	}
        
        //// SETTERS ////
        public void setId(int userId){
            this.id = userId;
        }

	public void setJson(String json) {
            this.json = json;
	}
}
