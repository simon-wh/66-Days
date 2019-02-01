package initialPackages;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
     
@Entity //Telling Hibernate to make a table out of this class.
public class UserEngagement {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
     
    private String habitActivity;
    
    public Long getId() {
        return id;
    }
 
    public void setId(Long id) {
        this.id = id;
    }
 
    public String getHabitActivity() {
        return habitActivity;
    }
 
    public void setHabitActivity(String habitActivity) {
        this.habitActivity = habitActivity;
    }
 
 
}