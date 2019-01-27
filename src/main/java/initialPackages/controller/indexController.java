package initialPackages.controller;

import java.util.Date;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class indexController {
    
    @GetMapping("/")
    public String hello(Model model){
        //A useful example of how the model can return a Java object for display by thymeleaf
        model.addAttribute("time", new Date());
        return "index";
    }
    
    @GetMapping("/hello")
    public String hello(){
        //model.addAttribute("time", new Date());
        return "hello";
    }
    
    //The following method should handle the "/getProjectName" url.
    //This code was following the example JSON lecture given by Simon.
    //We will use code like this for REST api requests.
    @RequestMapping("/getProjectName")
    public String getProjectName(@RequestParam("id") String projectID, Model model){
        return "index";
    }
}

