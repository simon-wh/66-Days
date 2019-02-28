package packages.tables;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class CourseWeek {
	@Id
        @GeneratedValue(strategy=GenerationType.AUTO)
        public Integer id;
        
        public String title;
        
        public String description;
        
        public String habitChoices;
        
        // CONSTRUCTORS
        public CourseWeek(){
            title = null;
            description = null;
            habitChoices = null;
        }
        
        public CourseWeek(Integer id){
            this.id = id;
            title = null;
            description = null;
            habitChoices = null;
        }
        
        public CourseWeek(String title, String description, String habitChoices){
            this.title = title;
            this.description = description;
            this.habitChoices = habitChoices;
        }
        
        // CUSTOM FUNCTIONS 
        public String getWeekNumberAsString(){
            switch(this.id){
                case 1: return "One";
                case 2: return "Two";
                case 3: return "Three";
                case 4: return "Four";
                case 5: return "Five";
                case 6: return "Six";
                case 7: return "Seven";
                case 8: return "Eight";
                case 9: return "Nine";
                case 10: return "Ten";
                case 11: return "Eleven";
                case 12: return "Twelve";
                default: return "Greater than Twelve";
            }
        }

        
        // GETTERS
        public Integer getId(){
            return id;
        }
                
        public String getTitle() {
            return title;
	}
        
        public String getDescription(){
            return description;
        }
        
        public String getHabitChoices(){
            return habitChoices;
        }
        
        
        // SETTERS  
        public void setId(Integer id){
            this.id = id;
        }
        
	public void setTitle(String title) {
            this.title = title;
	}
        
        public void setDescription(String description){
            this.description = description;
        }
        
        public void setHabitChoices(String habitChoices){
            this.habitChoices = habitChoices;
        }
}
