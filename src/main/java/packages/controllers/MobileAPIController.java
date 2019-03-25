
package packages.controllers;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.concurrent.ExecutionException;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import packages.comparators.WeekNumberComparer;

import packages.repositories.CourseContentRepository;
import packages.repositories.UserStatisticsRepository;
import packages.repositories.WhitelistRepository;

import packages.tables.CourseWeek;
import packages.tables.UserStatistics;


@Controller
@RequestMapping(path="/mobile-api") 
public class MobileAPIController {
    
        @Autowired
	private WhitelistRepository whitelistRepo;
        
        @Autowired
        private CourseContentRepository courseContentRepo;
        
        @Autowired
        private UserStatisticsRepository userStatisticsRepo;

        // ### VERIFY THE USERS EMAIL ### //
    
        @RequestMapping(method = RequestMethod.POST, value = "/verify-email", consumes = "application/json")
	public Boolean verifyEmail(@RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            String userId = getUserIdFromIdToken(idToken);
            return checkIfUserIdIsAuthorised(userId);
	}
        
        // ### GET THE COURSE CONTENT AS JSON ### //
       
        @RequestMapping(value = "/get-course-content", method = RequestMethod.POST)
        @ResponseBody
        public Iterable<CourseWeek> getCourseContent(@RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            
            //1 - Get the user id from the request.
            String userId = getUserIdFromIdToken(idToken);
            
            //2 - Verify that the user is authorised.
            if (checkIfUserIdIsAuthorised(userId)){
                
                //3 - Get all the weeks of the course from the database.
                List<CourseWeek> weeksList = new ArrayList<>();
                courseContentRepo.findAll().forEach(weeksList::add);
                Collections.sort(weeksList, new WeekNumberComparer());
                
                //4 - Send the list back as JSON.
                return weeksList;
            }
            
            return null;
        }
        
        /*
        
        // ### CREATE A RECORD FOR NEW USER'S STATISTICS ### //
        @RequestMapping(value = "/new-user-statistics-record", method = RequestMethod.POST, consumes = "application/json")
        public String createNewAccount(@RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            
            //1 - Get the user id from the request.
            String userId = getUserIdFromIdToken(idToken);
            
            //2 - Verify that the user is authorised.
            if(checkIfUserIdIsAuthorised(userId) == false){
                return "unauthorised";
            }
                    
            //3 - Create a new UserStatistics entry for the database.
            UserStatistics u = new UserStatistics();
            u.setUserID(userId);
            u.setJson("{}");
            
            //4 - Save the entry into the database.
            userStatisticsRepo.save(u);
            
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
            Optional<UserStatistics> optionalUserStatistics = userStatisticsRepos.findById(userID);
            UserStatistics userStatistics;
            
            if(optionalUserStatistics.isPresent()){
                userStatistics = optionalUserStatistics.get();
            } else {
                return "user not found in database";
            }

            //4 - Delete the old userStatistics entry that was stored in the database.
            userStatisticsRepo.delete(userStatistics);
            
            //5 - Create a new userStatistics entry, with updated json.
            UserStatistics u = new UserStatistics();
            u.setUserID(userID);
            u.setJson(json);
            
            //6 - Save the entry into the database.
            userStatisticsRepo.save(u);
            
            //7 - Respond with confirmation.
            return "success";
        }*/ 
        
        //Code sourced from... https://thepro.io/post/firebase-authentication-for-spring-boot-rest-api/
        private String getUserIdFromIdToken(String idToken) throws Exception {
            String userID = null;
            
            try {
                userID = FirebaseAuth.getInstance().verifyIdTokenAsync(idToken).get().getUid();
            } catch (InterruptedException | ExecutionException e) {
                //Let the userID remain null.
                //Potential future implementation of logging what the exception was, so we can identify secuirity issues.
            }
            
            return userID;
        }
        
        private boolean checkIfUserIdIsAuthorised(String userId){
            //1 - If the user id is null, decline the request.
            if (userId == null){
                return false;
            }
            
            try {
                //2 - Get the userRecord for the user ID, this contains the user's email address.
                UserRecord userRecord = FirebaseAuth.getInstance().getUser(userId);
                
                //3 - Get the userEmail from the userRecord.
                String email = userRecord.getEmail();

                //4 - Check if the email exists in the whitelistRepository.        
                return whitelistRepo.existsById(email);
                
            } catch (FirebaseAuthException ex) {
                //Logger.getLogger(MobileAPIController.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            return false;
        }
}
