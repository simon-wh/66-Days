package packages.controllers;

import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller 
@RequestMapping(path="/web-api")
@Secured("ADMIN")
public class WebAPIController {

        @GetMapping(path="/get-statistics")
        public @ResponseBody String getStatistics(){
            return "No statistics returned yet.";
        }

}