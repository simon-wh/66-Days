package packages.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import packages.tables.WhitelistMember;
import packages.repositories.WhitelistRepository;

@Controller 
@RequestMapping(path="/web-api")
@Secured("ADMIN")
public class WebAPIController {

	@Autowired
	private WhitelistRepository whitelistRepo;

        //Adds an email to the whitelist table.
	@RequestMapping(path="/add-email")
	public @ResponseBody String addNewUser (@RequestParam("email") String email) {
            if(whitelistRepo.existsById(email)){
                return "Error: This email is already in the database.";
            } else {
		WhitelistMember n = new WhitelistMember(email);
		whitelistRepo.save(n);
		return email + " saved successfully to the database.";
            }
	}

        //Returns a list of all the valid emails.
	@GetMapping(path="/all-emails")
	public @ResponseBody String getAllUsers() {
            
            String response = "";
            Iterable<WhitelistMember> members = whitelistRepo.findAll();
            
            for (WhitelistMember member: members){
                response += member.getEmail();
                response += ",";
            }
            
            return response;
	}

	@GetMapping(path="/delete-email")
	public @ResponseBody String deleteUser(@RequestParam String email) {
            if (whitelistRepo.existsById(email)){
                whitelistRepo.deleteById(email);
                return email + " deleted.";
            } else {
                return "Error: This email was not found.";
            }
	}

}