package packages.controllers;

import java.util.ArrayList;
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
        
        Iterable<CourseWeek> courseWeeks = courseContentRepo.findAll();

        for (CourseWeek week : courseWeeks){
            if (week.getWeekNumber().equals(weekNumber)){
                week = updateCourseWeekAttributes(week, updatedWeek);
                courseContentRepo.save(week);
            }
        }
        
        return "redirect:/course-editor";
    }
    
    //At the moment we have to add weeks manually every time we reset the database.
    @RequestMapping(path="/add-week")
    public String addWeek(@RequestParam("title") String title, @RequestParam("number") Integer number) {
        
        CourseWeek week = new CourseWeek(title, number);
        //All the rest of the data attributes for CourseWeek are assigned default values.
        courseContentRepo.save(week);
        
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
    public Iterable<CourseWeek> weekJSON(){
        Iterable<CourseWeek> weeksOfCourse = courseContentRepo.findAll();
        return weeksOfCourse;
    }
    
    private List<CourseWeek> getCourseWeeks(){
        List<CourseWeek> weeksList = new ArrayList<>();
        courseContentRepo.findAll().forEach(weeksList::add);
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
        
        if (!newHabitTitle.equals(oldHabitTitle) && "CREATE_NEW_HABIT".equals(newWeekType)){ 
            //If the title has been changed...
            //And the week is creating a new habit...
            //Then iterate through all the weeks, checking to see if they require updating.
            Iterable<CourseWeek> weeksOfCourse = courseContentRepo.findAll();

            for (CourseWeek week: weeksOfCourse){
                if (week.getHabitTitle().equals(oldHabitTitle)){
                    week.setHabitTitle(newHabitTitle);
                    courseContentRepo.save(week);
                }
            }
        }
        
        if (oldWeekType.equals("CREATE_NEW_HABIT") && !newWeekType.equals("CREATE_NEW_HABIT")){
            //If the old week was creating a new habit, but the new week isn't...
            //Then we'll need to update all the future weeks that depend on updating this habit!
            
            //To start off, we'll see if we can find if any other weeks are creating a habit we can default to.
            Iterable<CourseWeek> weeksOfCourse = courseContentRepo.findAll();
            String replacmentLinkedHabitTitle = "- No Habit To Update - ";

            for (CourseWeek week: weeksOfCourse){
                if (week.getWeekType().equals("CREATE_NEW_HABIT") && !week.getId().equals(updatedWeek.getId())){
                    replacmentLinkedHabitTitle = week.getHabitTitle();
                }
            }
            
            newHabitTitle = replacmentLinkedHabitTitle;
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

