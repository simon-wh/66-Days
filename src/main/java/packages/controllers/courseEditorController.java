package packages.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
        mav.addObject("courseWeeks", getCourseWeeks());
        mav.addObject("updatedWeek", new CourseWeek(0));
        return mav;
    }
    
    @RequestMapping(value = "/update-week/{id}", method = RequestMethod.PUT)
    public String saveUpdate(@PathVariable Integer id, @ModelAttribute("updatedWeek") CourseWeek updatedWeek) {
        
        Optional<CourseWeek> originalWeekOptional = courseContentRepo.findById(id);
        
        if (originalWeekOptional.isPresent()){
            CourseWeek originalWeek = originalWeekOptional.get();
            
            originalWeek = updateCourseWeekAttributes(originalWeek, updatedWeek);
            
            courseContentRepo.save(originalWeek);
        }
        
        return "redirect:/course-editor";
    }
    
    //At the moment we have to add weeks manually every time we reset the database.
    //Can we get a script to do this for us?
    @RequestMapping(path="/add-week")
    public String addWeek(@RequestParam("title") String title) {
        
        CourseWeek week = new CourseWeek(title);
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
    
    @RequestMapping(path="/week-json")
    public String weekJSON(){
        //3 - Get all the weeks of the course from the database.
        Iterable<CourseWeek> weeksOfCourse = courseContentRepo.findAll();

        //4 - Construct a JSON string with all the weeks of the course.
        String completeJSON = "[";
        for (CourseWeek week: weeksOfCourse){
            //System.out.println(week.getJson());
            completeJSON = completeJSON.concat(week.getJSON());
            completeJSON = completeJSON.concat(",");
        }
        completeJSON = completeJSON.concat("]");

        //5 - Return the resulting JSON content.
        return completeJSON;
    }
    
    private List<CourseWeek> getCourseWeeks(){
        List<CourseWeek> weeksList = new ArrayList<>();
        courseContentRepo.findAll().forEach(weeksList::add);
        return weeksList;
    }
    
    private CourseWeek updateCourseWeekAttributes(CourseWeek originalWeek, CourseWeek updatedWeek){

        originalWeek.setWeekTitle(updatedWeek.getWeekTitle());
        originalWeek.setWeekType(updatedWeek.getWeekType());
        originalWeek.setWeekDescription(updatedWeek.getWeekDescription());
        originalWeek.setHabitTitle(updatedWeek.getHabitTitle());
        originalWeek.setHabitExperiments(updatedWeek.getHabitExperiments());
        originalWeek.setEnvironmentDesign(updatedWeek.getEnvironmentDesign());

        return originalWeek;
    }
    
}

