
package initialPackages.controller;

import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

// Only the ADMIN can access this API.
// https://stackoverflow.com/questions/32548372/how-to-secure-rest-api-with-spring-boot-and-spring-security

@Controller
@RequestMapping(value = "/web-api")
@Secured("ADMIN")
public class WebAdminRestAPIController {
    
}
