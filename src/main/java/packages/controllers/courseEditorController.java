package packages.controllers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import packages.comparators.WeekNumberComparer;

import packages.repositories.CourseContentRepository;
import packages.tables.CourseWeek;

@Controller
@RequestMapping(path="/course-editor")
public class courseEditorController {
    
    @Autowired
    private CourseContentRepository courseContentRepo;
    
    @RequestMapping("")
    public ModelAndView courseEditor() {
        ModelAndView mav = new ModelAndView("course-editor");
        mav.addObject("courseWeekList", getCourseWeeks());
        return mav;
    }
    
    @RequestMapping("/{weekNumber}")
    public ModelAndView editWeek(@PathVariable Integer weekNumber) {
        
        Iterable<CourseWeek> courseWeeks = courseContentRepo.findAll();
        
        CourseWeek weekToEdit = new CourseWeek("New Week", getNextWeekNumber());

        for (CourseWeek week : courseWeeks){
            if (week.getWeekNumber().equals(weekNumber)){
                weekToEdit = week;
            }
        }
        
        ModelAndView mav = new ModelAndView("course-editor");
        mav.addObject("courseWeekList", getCourseWeeks());
        mav.addObject("courseWeek", weekToEdit);
        return mav;
    }
    
    @RequestMapping(value = "/update-week/{weekNumber}", method = RequestMethod.PUT)
    public String saveUpdate(@PathVariable Integer weekNumber, @ModelAttribute("updatedWeek") CourseWeek updatedWeek) {
        
        CourseWeek weekToUpdate = findWeekByWeekNumber(weekNumber);
        
        boolean weekChangedFromCreateHabit = checkIfWeekTypeChangedFromCreateHabit(weekToUpdate, updatedWeek);
        boolean habitGivenIdenticalName = checkIfUserCreatedTwoHabitsSameName(weekToUpdate, updatedWeek);
        
        weekToUpdate = updateCourseWeekAttributes(weekToUpdate, updatedWeek);
        courseContentRepo.save(weekToUpdate);
        
        String redirectURL = "redirect:/course-editor?updateSuccessful";
        
        if (weekChangedFromCreateHabit){
            redirectURL += "&weekChangedFromCreateHabit";
        }
        if (habitGivenIdenticalName){
            redirectURL += "&identicalHabitName";
        }
        
        return redirectURL;
    }
    
    //At the moment we have to add weeks manually every time we reset the database.
    @RequestMapping(path="/add-week")
    public String addWeek(@RequestParam("title") String title, @RequestParam("number") Integer number) {
        
        CourseWeek week = new CourseWeek(title, number);
        //All the rest of the data attributes for CourseWeek are assigned default values.
        courseContentRepo.save(week);
        
        return "redirect:/course-editor";
    }
    
    @RequestMapping(path="/add-all-weeks")
    public String addAllWeeks(){
        courseContentRepo.deleteAll();
        
        for (int i = 1; i <= 10; i++){
            CourseWeek week = new CourseWeek(i);
            week.setHabitTitle(Integer.toString(i-1));
            courseContentRepo.save(week);
        }
        
        return "redirect:/course-editor";
    }
    
    @RequestMapping(path="/delete-week")
    public String deleteWeek(@RequestParam("id") Integer id) {
        
        if (courseContentRepo.existsById(id)){
            courseContentRepo.deleteById(id);
        } 
        
        return "redirect:/course-editor";
    }
    
    //Used for testing JSON response.
    @RequestMapping(path="/week-json")
    @ResponseBody
    public List<CourseWeek> weekJSON(){
        List<CourseWeek> weeksList = new ArrayList<>();
        courseContentRepo.findAll().forEach(weeksList::add);
        Collections.sort(weeksList, new WeekNumberComparer());
        return weeksList;
    }
    
    private boolean checkIfUserCreatedTwoHabitsSameName(CourseWeek originalWeek, CourseWeek updatedWeek){
      
        boolean twoHabitsCreatedSameName = false;
        
        String newWeekType = updatedWeek.getWeekType();
        String newHabitTitle = updatedWeek.getHabitTitle();
        
        if ("CREATE_NEW_HABIT".equals(newWeekType)){

            Iterable<CourseWeek> weeksOfCourse = getCourseWeeks();
           
            for (CourseWeek week: weeksOfCourse){

                if ("CREATE_NEW_HABIT".equals(week.getWeekType())){
                    
                    if ( !week.getWeekNumber().equals(originalWeek.getWeekNumber())){ //Make sure that the weeks have different week numbers.
                        
                        if (week.getHabitTitle().equals(newHabitTitle)){
                            twoHabitsCreatedSameName = true;
                        }
                    }
                }
            }
        }
        
        return twoHabitsCreatedSameName;
    }
    
    private boolean checkIfWeekTypeChangedFromCreateHabit(CourseWeek originalWeek, CourseWeek updatedWeek){
        String newWeekType = updatedWeek.getWeekType();
        String oldWeekType = originalWeek.getWeekType();
        
        boolean weekTypeChanged = false;
        
        if (oldWeekType.equals("CREATE_NEW_HABIT") && !newWeekType.equals("CREATE_NEW_HABIT")){
            weekTypeChanged = true;
        }
        
        return weekTypeChanged;
    }
    
    private CourseWeek findWeekByWeekNumber(int weekNumber){
        List<CourseWeek> weeksList = new ArrayList<>();
        courseContentRepo.findAll().forEach(weeksList::add);
        Collections.sort(weeksList, new WeekNumberComparer());
        
        return weeksList.get(weekNumber - 1);
    }
    
    private List<CourseWeek> getCourseWeeks(){
        List<CourseWeek> weeksList = new ArrayList<>();
        courseContentRepo.findAll().forEach(weeksList::add);
        Collections.sort(weeksList, new WeekNumberComparer());
        return weeksList;
    }
    
    private CourseWeek updateCourseWeekAttributes(CourseWeek originalWeek, CourseWeek updatedWeek){

        //We update the following attributes directly as they don't effect other weeks.
        originalWeek.setWeekTitle(updatedWeek.getWeekTitle());
        originalWeek.setWeekDescription(updatedWeek.getWeekDescription());
        originalWeek.setHabitExperiments(updatedWeek.getHabitExperiments());
        originalWeek.setEnvironmentDesign(updatedWeek.getEnvironmentDesign());
        
        // The Week Type and Habit Title might potentially have knock on effects, so they are handled with more care.
        String newWeekType = updatedWeek.getWeekType();
        String oldWeekType = originalWeek.getWeekType();
        String newHabitTitle = updatedWeek.getHabitTitle();
        String oldHabitTitle = originalWeek.getHabitTitle();
        
        if (!oldWeekType.equals("UPDATE_OLD_HABIT") && newWeekType.equals("UPDATE_OLD_HABIT")){
            System.out.println("Habit has been changed to Update Old Habit type!");
            
            System.out.println("Previous Habit Title : " + oldHabitTitle);
            System.out.println("New Habit Title : " + newHabitTitle);
        }
        
        //If the user is updating their habit title, and the type of week is Create New Habit...
        //Check to see if that habit title already exists in another week that is creating a habit.
        //If so, prevent the duplication of a habit by appending "New " to the start of the habit title.
        //Warn the user that they've tried to do something, but the intended effect hasn't occurred.
        
        if ("CREATE_NEW_HABIT".equals(newWeekType)){
            //Iterate through all the weeks of the course
            Iterable<CourseWeek> weeksOfCourse = getCourseWeeks();
            
            //System.out.println("Habit is updating for Create New Habit type!");
            //System.out.println("Week number : " + originalWeek.getWeekNumber());
            //System.out.println("Habit title : " + newHabitTitle);
            
            for (CourseWeek week: weeksOfCourse){
                //System.out.println(" - week type : " + week.getWeekType());
                //System.out.println(" - week no. : " + week.getWeekNumber());
                //System.out.println(" - habit title : " + week.getHabitTitle()); 
                
                if ("CREATE_NEW_HABIT".equals(week.getWeekType())){
                    
                    if ( !week.getWeekNumber().equals(originalWeek.getWeekNumber())){
                        
                        //Make sure that the weeks have different week numbers.
                        if (week.getHabitTitle().equals(newHabitTitle)){
                            //System.out.println("Updating Habit Title!");
                            newHabitTitle = "New " + newHabitTitle;
                        }
                    }
                    
                }
            }
        }
        
        
        if (!newHabitTitle.equals(oldHabitTitle) && "CREATE_NEW_HABIT".equals(newWeekType)){ 
            //If the habit title has been changed...
            //And the week is creating a new habit...
            //Then iterate through all the weeks, checking to see if they require updating.
            Iterable<CourseWeek> weeksOfCourse = getCourseWeeks();

            for (CourseWeek week: weeksOfCourse){
                if (week.getHabitTitle().equals(oldHabitTitle)){
                    if(week.getWeekType().equals("UPDATE_OLD_WEEK")){
                        if (week.getWeekNumber() > updatedWeek.getWeekNumber()){
                            week.setHabitTitle(newHabitTitle);
                            courseContentRepo.save(week);                       
                        }
                    }
                }
            }
        }
        
        if (oldWeekType.equals("CREATE_NEW_HABIT") && !newWeekType.equals("CREATE_NEW_HABIT")){
            //If the old week was creating a new habit, but the new week isn't...
            //Then we'll need to update all the future weeks that depend on updating this habit!
            //System.out.println("Habit has been changed from Create New Habit type!");
            
            //We iterate through all the future weeks that depend on this habit and given them a null habit name.
            //We'll set all the habit names to "Habit for Week " + weekNumber, so they don't accidentally link together.
            //"Habit for Week " + weekNumber is used in case Ben changes the week type back to Create New Habit, 
            //so that input will show him something vaguely sensible if it loads into the text-box.
            //The type of the week will be changed to that of JUST_DESCRIPTION, so the app can ignore the habit title.
            //This will hopefully avoid confusion.
            Iterable<CourseWeek> weeksOfCourse = getCourseWeeks();

            for (CourseWeek week: weeksOfCourse){
                if (week.getWeekType().equals("UPDATE_OLD_HABIT")){
                    if (week.getHabitTitle().equals(oldHabitTitle)){
                        week.setHabitTitle("Habit for Week " + week.getWeekNumber());
                        week.setWeekType("JUST_DESCRIPTION");
                        //System.out.println("Updated week " + week.getWeekNumber() + " to Just Description.");
                        courseContentRepo.save(week);
                    }
                }
            }
        }
        
        if (!oldWeekType.equals("UPDATE_OLD_HABIT") && newWeekType.equals("UPDATE_OLD_HABIT")){
            System.out.println("Habit has been changed to Update Old Habit type!");
            
            System.out.println("Previous Habit Title : " + oldHabitTitle);
            System.out.println("New Habit Title : " + newHabitTitle);
        }
        
        originalWeek.setWeekType(newWeekType); 
        originalWeek.setHabitTitle(newHabitTitle);
        
        return originalWeek;
    }
    
    private Integer getNextWeekNumber(){
        Integer largestWeekNumber = 0;
        
        for (CourseWeek week: courseContentRepo.findAll()){
            if (week.getWeekNumber() > largestWeekNumber){
                largestWeekNumber = week.getWeekNumber();
            }
        }
        
        return largestWeekNumber + 1;
    }
}