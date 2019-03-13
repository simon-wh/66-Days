package packages.tables;

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
	@Id
        @GeneratedValue(strategy=GenerationType.AUTO)
        private Integer id;
        
        private Integer weekNumber;
        
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
        
        public CourseWeek(String title, Integer weekNumber){
            this.weekTitle = title;
            this.weekNumber = weekNumber;
            this.weekType = "JUST_DESCRIPTION";
            this.weekDescription = "Week description.";
            this.habitTitle = "Habit title.";
            this.habitExperiments = "List of experiments.";
            this.environmentDesign = "List of environment design choices.";
        }
        
        // FUNCTIONS 
        public String getWeekNumberAsString(){
            switch(this.weekNumber){
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
                default: return "Other";
            }
        }        
        
        public String getHabitKey(){
            return this.habitTitle + "_key";
        }

        // GETTERS
        public Integer getId(){
            return id;
        }
        
        public Integer getWeekNumber(){
            return weekNumber;
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
        
        public List<String> getHabitExperimentsList(){
            return Arrays.asList(habitExperiments.split("\r\n"));
        }
        
        public String getEnvironmentDesign(){
            return environmentDesign;
        }
        
        public List<String> getEnvironmentDesignList(){
            return Arrays.asList(environmentDesign.split("\r\n"));
        }
        
        // SETTERS  
        public void setId(Integer id){
            this.id = id;
        }
        
        public void setWeekNumber(Integer number){
            this.weekNumber = number;
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
