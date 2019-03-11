package packages.tables;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;

@Entity
public class CourseWeek {
        //// WEEK ATTRIBUTES ////
	@Id //This is the week number. It controls what order the weeks are displayed.
        @GeneratedValue(strategy=GenerationType.AUTO)
        private Integer id;
        
        private String weekTitle; //For example, "Week One - Observation".
        
        @Lob 
        @Column(name="description", length=1024)
        private String weekDescription;
        
        //The weekType can be CREATE_NEW_HABIT, UPDATE_OLD_HABIT, JUST_DESCRIPTION
        private String weekType;
        
        //// HABIT ATTRIBUTES ////
        //The habit title can reference another habit or be the name of the habit itself, depending on weekType.
        private String habitTitle;
        
        @Lob 
        @Column(name="experiments", length=1024)
        private String habitExperiments; //A list of experiements seperated by newline characters.
        
        @Lob
        @Column(name="environmentDesign", length=1024)
        private String environmentDesign; //A list of environment design options, seperated by newline characters.
        
        // CONSTRUCTORS
        public CourseWeek(){}
        
        public CourseWeek(Integer id){
            this.id = id;
        }
        
        public CourseWeek(String title){
            this.weekTitle = title;
            this.weekType = "JUST_DESCRIPTION";
            this.weekDescription = "Week description.";
            this.habitTitle = "Habit title.";
            this.habitExperiments = "List of experiments.";
            this.environmentDesign = "List of environment design choices.";
        }
        
        // FUNCTIONS 
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
        
        public String getJSON(){
            String JSON = "{";
            
            JSON = addKeyValueToJSON(JSON, "week-id", id.toString());
            JSON = addKeyValueToJSON(JSON, "week-title", weekTitle);
            JSON = addKeyValueToJSON(JSON, "week-description", weekDescription);
            
            JSON = addKeyValueToJSON(JSON, "habit-key", getHabitKey());
            JSON = addKeyValueToJSON(JSON, "habit-title", habitTitle);
            JSON = addKeyListToJSON(JSON, "habit-experiments", habitExperiments);
            JSON = addKeyListToJSON(JSON, "environment-design", environmentDesign);
            
            JSON = JSON.concat("}");
            return JSON;
        }
        
        private String addKeyValueToJSON(String JSON, String key, String value){
            JSON = JSON.concat(key);
            JSON = JSON.concat(":");
            JSON = JSON.concat(value);
            JSON = JSON.concat(",\n");
            return JSON;
        }
        
        private String addKeyListToJSON(String JSON, String key, String newlineSeperatedList){
            JSON = JSON.concat(key);
            JSON = JSON.concat(": [");
            
            List<String> listItems = new ArrayList<>(Arrays.asList(newlineSeperatedList.split("\n")));
            for (String item : listItems){
                JSON = JSON.concat(item);
                JSON = JSON.concat(",\n");
            }
            
            JSON = JSON.concat("],\n");
            return JSON;
        }
        
        private String getHabitKey(){
            return habitTitle;
        }

        // GETTERS
        public Integer getId(){
            return id;
        }
                
        public String getWeekTitle() {
            return weekTitle;
	}
        
        public String getWeekDescription(){
            return weekDescription;
        }
        
        public String getWeekType(){
            return weekType;
        }
        
        public String getHabitTitle(){
            return habitTitle;
        }
        
        public String getHabitExperiments(){
            return habitExperiments;
        }
        
        public String getEnvironmentDesign(){
            return environmentDesign;
        }
        
        // SETTERS  
        public void setId(Integer id){
            this.id = id;
        }
        
	public void setWeekTitle(String title) {
            this.weekTitle = title;
	}
        
        public void setWeekType(String weekType){
            this.weekType = weekType;
        }
        
        public void setWeekDescription(String description){
            this.weekDescription = description;
        }
        
        public void setHabitTitle(String habitTitle){
            this.habitTitle = habitTitle;
        }
        
        public void setHabitExperiments(String habitExperiments){
            this.habitExperiments = habitExperiments;
        }
        
        public void setEnvironmentDesign(String environmentDesign){
            this.environmentDesign = environmentDesign;
        }
}
