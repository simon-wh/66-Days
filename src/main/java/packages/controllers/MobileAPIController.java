
package initialPackages.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.UserRecord;

import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.concurrent.ExecutionException;
import java.util.Optional;
import org.springframework.web.bind.annotation.RequestParam;

import packages.repositories.CourseContentRepository;
import packages.repositories.UserStatisticsRepository;
import packages.repositories.WhitelistRepository;

import packages.tables.CourseWeek;


@Controller
@RequestMapping(path="/mobile-api") 
public class MobileAPIController {

    
        // ### VERIFY THE USERS EMAIL ### //
    
    
    	@Autowired
	private WhitelistRepository whitelistRepository;
        
        @RequestMapping(method = RequestMethod.POST, value = "/verify-email", consumes = "application/json")
	public String verifyEmail(@RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            
            //1 - Get the user id from the request.
            String userID = getUserIdFromIdToken(idToken); //Note that idToken comes from the HTTP Header.
            
            //2 - If the user id is null, decline the request.
            if (userID == null){
                return "unauthorized";
            }
            
            //3 - Get the userRecord for the user ID, this contains the user's email address.
            UserRecord userRecord = FirebaseAuth.getInstance().getUser(userID);
            
            //4 - Get the userEmail from the userRecord.
            String email = userRecord.getEmail();
	
            //5 - Check if the email exists in the whitelistRepository.
            boolean isValidEmail = whitelistRepository.existsById(email);
            
            //6 - Return "true" / "false" accordingly.
            return Boolean.toString(isValidEmail);
	}
        
        //Code sourced from... https://thepro.io/post/firebase-authentication-for-spring-boot-rest-api/
        public String getUserIdFromIdToken(String idToken) throws Exception {
            String userID = null;
            
            try {
                userID = FirebaseAuth.getInstance().verifyIdTokenAsync(idToken).get().getUid();
            } catch (InterruptedException | ExecutionException e) {
                //Let the userID remain null.
                //Potential future implementation of logging what the exception was, so we can identify secuirity issues.
            }
            
            return userID;
        }
        
        
        // ### GET THE COURSE CONTENT AS JSON ### //
        
        
        @Autowired
        private CourseContentRepository courseContentRepository;
        
        @RequestMapping(value = "/get-course-content", method = RequestMethod.POST)
        public String getCourseContent(@RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            //1 - Get the user id from the request.
            String userID = getUserIdFromIdToken(idToken); //Note that idToken comes from the HTTP Header.
            
            //2 - If the user id is null, decline the request.
            if (userID == null){
                return "unauthorized";
            }
            
            //3 - Get all the weeks of the course from the database.
            Iterable<CourseWeek> weeksOfCourse = courseContentRepository.findAll();
            
            //4 - Construct a JSON string with all the weeks of the course.
            String completeJSON = "[";
            for (CourseWeek week: weeksOfCourse){
                //System.out.println(week.getJson());
                completeJSON = completeJSON.concat(week.getJSON());
                completeJSON = completeJSON.concat(",");
            }
            completeJSON = completeJSON.concat("{}]");
            
            //5 - Return the resulting JSON content.
            return completeJSON;
        }
        
        
        // ### CREATE AND UPDATE USER STATISTICS ### //

        /*
        @Autowired
        private UserStatisticsRepository userStatisticsRepository;
        
        //// CREATE A NEW ACCOUNT FOR GENERAL USER STATISTICS STORAGE ////
        @RequestMapping(value = "/new-account", method = RequestMethod.POST, consumes = "application/json")
        public String createNewAccount(@RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            
            //1 - Get the user id from the request.
            String userID = getUserIdFromIdToken(idToken); //Note that idToken comes from the HTTP Header.
            
            //2 - If the user id is null, decline the request.
            if (userID == null){
                return "unauthorized";
            }
            
            //3 - Create a new UserStatistics entry for the database.
            UserStatistics u = new UserStatistics();
            u.setUserID(userID);
            u.setJson("{}");
            
            //4 - Save the entry into the database.
            userStatisticsRepository.save(u);
            
            //5 - Respond with confirmation.
            return "success";
        }

        //// UPDATE AN ACCOUNTS USER STATISTICS ////
        
        @RequestMapping(value = "/update-statistics", method = RequestMethod.POST, consumes = "application/json")
        public String updateUserStatistics(@RequestParam String json, @RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            
            //1 - Get the user id from the request.
            String userID = getUserIdFromIdToken(idToken); //Note that idToken comes from the HTTP Header.
            
            //2 - If the user id is null, decline the request.
            if (userID == null){
                return "unauthorized";
            }
            
            //3 - Find the userStatistics entry in the database.
            Optional<UserStatistics> optionalUserStatistics = userStatisticsRepository.findById(userID);
            UserStatistics userStatistics;
            
            if(optionalUserStatistics.isPresent()){
                userStatistics = optionalUserStatistics.get();
            } else {
                return "user not found in database";
            }

            //4 - Delete the old userStatistics entry that was stored in the database.
            userStatisticsRepository.delete(userStatistics);
            
            //5 - Create a new userStatistics entry, with updated json.
            UserStatistics u = new UserStatistics();
            u.setUserID(userID);
            u.setJson(json);
            
            //6 - Save the entry into the database.
            userStatisticsRepository.save(u);
            
            //7 - Respond with confirmation.
            return "success";
        }*/     
}
