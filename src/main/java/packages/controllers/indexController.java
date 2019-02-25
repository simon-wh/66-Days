package packages.controllers;

import java.util.Date;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class indexController {
    
    @GetMapping("/")
    public String index(Model model){
        //A useful example of how the model can return a Java object for display by thymeleaf
        model.addAttribute("time", new Date());
        return "index";
    }
}

