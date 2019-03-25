package tests;

import java.util.ArrayList;
import javax.transaction.Transactional;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import packages.Application;

import packages.tables.CourseWeek;
import packages.repositories.CourseContentRepository;

@Transactional //Rolls back changes to the database after testing.
@SpringBootTest(classes=Application.class)
@RunWith(SpringJUnit4ClassRunner.class)
public class CourseEditorTests {
    
    @Autowired
    CourseContentRepository courseContentRepo;
    
    @Test
    public void testSaveNullWeekToRepository(){
        
        CourseWeek testWeek = new CourseWeek();
        courseContentRepo.save(testWeek);
        
        Integer id = testWeek.getId();
        assert(courseContentRepo.findById(id).isPresent());
       
        courseContentRepo.delete(testWeek);
        assert(courseContentRepo.findById(id).isPresent() == false);
    }
    
    @Test
    public void testSaveDefaultContructedWeekToRepository(){
        
        CourseWeek testWeek = new CourseWeek("Week Title", 0);
        courseContentRepo.save(testWeek);
        Integer id = testWeek.getId();
        
        assert(courseContentRepo.findById(id).isPresent());
        
        CourseWeek returnedWeek = courseContentRepo.findById(id).get();

        assert("Week Title".equals(returnedWeek.getWeekTitle()));
        assert("JUST_DESCRIPTION".equals(returnedWeek.getWeekType()));
        assert("Week description.".equals(returnedWeek.getWeekDescription()));

        assert("Habit title.".equals(returnedWeek.getHabitTitle()));
        assert("List of experiments.".equals(returnedWeek.getHabitExperiments()));
        assert("List of environment design choices.".equals(returnedWeek.getEnvironmentDesign()));
        
        courseContentRepo.delete(testWeek);
        assert(courseContentRepo.findById(id).isPresent() == false);

    }
    
    @Test
    public void testSettersAndGetters(){
        CourseWeek testWeek = new CourseWeek();
        
        testWeek.setWeekTitle("H");
        assert(testWeek.getWeekTitle().equals("H"));
        
        testWeek.setEnvironmentDesign("Hthodfdnsfughsdgf;sdljgds;lkg jsd;lkfhjg \nsjhsjkfdhask;jfdhk\nsjdfhalkjsdfhalskjhfd\nsdf");
        assert(testWeek.getEnvironmentDesign().equals("Hthodfdnsfughsdgf;sdljgds;lkg jsd;lkfhjg \nsjhsjkfdhask;jfdhk\nsjdfhalkjsdfhalskjhfd\nsdf"));
        
        testWeek.setHabitExperiments("A\nB\nC\nD\nE\nF\r\nOne\r\nTwo\r\n'Three'\r\nFour!");
        assert(testWeek.getHabitExperiments().equals("A\nB\nC\nD\nE\nF\r\nOne\r\nTwo\r\n'Three'\r\nFour!"));
        
        testWeek.setHabitTitle("Example Habit Title");
        assert(testWeek.getHabitTitle().equals("Example Habit Title"));
        assert(testWeek.getHabitKey().equals("Example Habit Title_key"));
    }
    
    @Test
    public void testGetWeekNumberAsString(){
        CourseWeek testWeek = new CourseWeek();
        
        testWeek.setWeekNumber(2);
        assert(testWeek.getWeekNumberAsString().equals("Two"));
        
        testWeek.setWeekNumber(9);
        assert(testWeek.getWeekNumberAsString().equals("Nine"));
        
        testWeek.setWeekNumber(9000);
        assert(testWeek.getWeekNumberAsString().equals("Other"));
    }
    
    @Test
    public void testGettingListsFromWeeks(){
        CourseWeek testWeek = new CourseWeek();
        
        testWeek.setHabitExperiments("Zero\r\nOne\r\nTwo\r\n'Three'\r\nFour!");
        ArrayList<String> habitExperiments = new ArrayList<>(testWeek.getHabitExperimentsList());
        
        assert(habitExperiments.get(0).equals("Zero"));
        assert(habitExperiments.get(1).equals("One"));
        assert(habitExperiments.get(2).equals("Two"));
        assert(habitExperiments.get(3).equals("'Three'"));
        assert(habitExperiments.get(4).equals("Four!"));
    }
    
        
    @Test
    public void testGettingListsFromEnvironmentDesign(){
        CourseWeek testWeek = new CourseWeek();
        
        testWeek.setEnvironmentDesign("Zero\r\nOne\r\nTwo double more four what\r\n'Three'\r\nFour!");
        ArrayList<String> envDesignList = new ArrayList<>(testWeek.getEnvironmentDesignList());
        
        assert(envDesignList.get(0).equals("Zero"));
        assert(envDesignList.get(1).equals("One"));
        assert(envDesignList.get(2).equals("Two double more four what"));
        assert(envDesignList.get(3).equals("'Three'"));
        assert(envDesignList.get(4).equals("Four!"));
    }
    
    private void printRepositoryContents(){
        Iterable<CourseWeek> weeks = courseContentRepo.findAll();
        for (CourseWeek week : weeks){
            printWeekContents(week);
        }
        
        if (weekExistsInRepository() == false){
            System.out.println("There are no weeks in the respository.");
        }
    }
    
    private boolean weekExistsInRepository(){
        Iterable<CourseWeek> weeks = courseContentRepo.findAll();
        for (CourseWeek week : weeks){
            return true; 
        }
        return false;
    }
    
    private void printWeekContents(CourseWeek week){
        System.out.println("# " + week.getId() + " : " + week.getWeekTitle());
        System.out.println(" ~ " +week.getWeekType());
    }
}
