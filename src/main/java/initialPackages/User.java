package initialPackages;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
     
@Entity //Telling Hibernate to make a table out of this class.
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;
     
    private String accessCode;
     
    private String habitData;
    
    public Integer getId() {
        return id;
    }
 
    public void setId(Integer id) {
        this.id = id;
    }
 
    public String getAccessCode() {
        return accessCode;
    }
 
    public void setAccessCode(String accessCode) {
        this.accessCode = accessCode;
    }
 
    public String getHabitData() {
        return habitData;
    }
 
    public void setHabitData(String habitData) {
        this.habitData = habitData;
    }
 
 
}