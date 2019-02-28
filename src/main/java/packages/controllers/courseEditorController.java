package packages.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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
    
    /*
    @GetMapping("")
    public String courseEditor(Model model){
        model.addAttribute("courseWeeks", getCourseContent());
        return "course-editor";
    }*/
    
    //List<CourseContent>
    
    @RequestMapping("")
    public ModelAndView courseEditor() {
        ModelAndView mav = new ModelAndView("course-editor");
        mav.addObject("courseWeeks", getCourseContent());
        mav.addObject("updatedWeek", new CourseWeek(0));
        return mav;
    }
    
    @RequestMapping(value = "/update-week/{id}", method = RequestMethod.PUT)
    public String saveUpdate(@PathVariable Integer id, 
                             @ModelAttribute("updatedWeek") CourseWeek updatedWeek,
                             HttpServletRequest request) {
        
        Optional<CourseWeek> originalWeekOptional = courseContentRepo.findById(id);
        
        if (originalWeekOptional.isPresent()){
            CourseWeek originalWeek = originalWeekOptional.get();
            
            String newTitle = updatedWeek.getTitle();
            String newDescription = updatedWeek.getDescription();
            String newHabitChoices = updatedWeek.getHabitChoices();
            
            if (newTitle != null)
                originalWeek.setTitle(newTitle);
            
            if (newDescription != null)
                originalWeek.setDescription(newDescription);

            if (newHabitChoices != null)
                originalWeek.setHabitChoices(newHabitChoices);
            
            //System.out.println(updatedWeek.getHabitChoices());
            
            courseContentRepo.save(originalWeek);
        }
        
        return "redirect:" + request.getHeader("referer");
    }
    
    /*
    @RequestMapping(path="/update-week")
    public String updateWeek(@RequestParam("id") Integer id,
                             @RequestParam("title") String title,
                             @RequestParam("description") String description,
                             @RequestParam("habitChoices") String habitChoices,
                             Model model, HttpServletRequest request) {

        Optional<CourseContent> weekOptional = courseContentRepo.findById(id);
        
        if (weekOptional.isPresent()){
            CourseWeek week = weekOptional.get();
            
            week.setTitle(title);
            week.setDescription(description);
            week.setHabitChoices(habitChoices);
            
            courseContentRepo.save(week);
        }
        
        return "redirect:" + request.getHeader("referer");
    }
    */
    
    @RequestMapping(path="/add-week")
    public String addWeek(@RequestParam("title") String title,
                          @RequestParam("description") String description,
                          @RequestParam("habitChoices") String habitChoices,
                          HttpServletRequest request, Model model) {
        
        CourseWeek week = new CourseWeek(title, description, habitChoices);
        courseContentRepo.save(week);
        
        return "redirect:/course-editor";
    }
    
    @RequestMapping(path="/delete-week")
    public String deleteWeek(@RequestParam("id") Integer id, HttpServletRequest request, Model model) {
        
        if (courseContentRepo.existsById(id)){
            courseContentRepo.deleteById(id);
        } 
        
        return "redirect:/course-editor";
    }
    
    private List<CourseWeek> getCourseContent(){
        List<CourseWeek> weeksList = new ArrayList<>();
        courseContentRepo.findAll().forEach(weeksList::add);
        return weeksList;
    }
    
}

