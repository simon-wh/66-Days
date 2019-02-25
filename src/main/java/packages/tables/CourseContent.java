package packages.tables;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity //This tells Hibernate to make a table out of this class.
public class CourseContent {
	@Id
	private Integer weekNumber;
        
        private String json;
        
        public Integer getWeekNumber(){
            return weekNumber;
        }
        
        public void setWeekNumber(Integer weekNumber){
            this.weekNumber = weekNumber;
        }

	public String getJson() {
            return json;
	}
        
	public void setJson(String json) {
            this.json = json;
	}
}
