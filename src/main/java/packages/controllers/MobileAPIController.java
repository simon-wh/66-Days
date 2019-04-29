
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
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.server.ResponseStatusException;
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
        
        // ### GET THE COURSE CONTENT AS JSON ### //
       
        @RequestMapping(value = "/get-course-content", method = RequestMethod.GET)
        @ResponseBody
        public Iterable<CourseWeek> getCourseContent(@RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            
            //1 - Get the user id from the request.
            String userId = getUserIdFromIdToken(idToken);
            
            //2 - If the user id is null, decline the request.
            if (userId == null){
                throw new ResponseStatusException( HttpStatus.UNAUTHORIZED, "User ID not found.");
            }
            
            //3 - Verify that the user is authorised.
            if (checkIfUserIdIsAuthorised(userId)){
                
                //4 - Get all the weeks of the course from the database.
                List<CourseWeek> weeksList = new ArrayList<>();
                courseContentRepo.findAll().forEach(weeksList::add);
                Collections.sort(weeksList, new WeekNumberComparer());
                
                //5 - Send the list back as JSON.
                return weeksList;
            }
            
            throw new ResponseStatusException( HttpStatus.UNAUTHORIZED, "User ID not authorized.");
        }
        
        // ### UPDATE USER STATISTICS / CREATE NEW USER STATISTICS RECORD ### //
        //https://stackoverflow.com/questions/29313687/trying-to-use-spring-boot-rest-to-read-json-string-from-post
        
        @RequestMapping(value = "/update-statistics", method = RequestMethod.POST, consumes = "text/plain")
        @ResponseStatus(HttpStatus.OK)
        public ResponseEntity update(@RequestBody String json, @RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            if (json == null) {
                return new ResponseEntity<>("User ID not found.", HttpStatus.BAD_REQUEST); 
            }
            
            String userId = getUserIdFromIdToken(idToken); //Note that idToken comes from the HTTP Header.
            
            //If the user id is null, decline the request.
            if (userId == null){
                return new ResponseEntity<>("User ID not found.", HttpStatus.UNAUTHORIZED); 
            }
            
            //4 - Iterate through the sites users and update the appropriate one.
            Iterable<UserStatistics> allUsers = userStatisticsRepo.findAll();
            for (UserStatistics user : allUsers){
                if (user.getUserId().equals(userId)){
                    user.setJson(json);
                    userStatisticsRepo.save(user);
                    return new ResponseEntity<>("Successfully updated.", HttpStatus.OK); 
                }
            }
            
            //5 - If we never throw that it's been updated, create a new record entry then throw.
            UserStatistics u = new UserStatistics(userId, json);
            userStatisticsRepo.save(u);
            return new ResponseEntity<>("New user created.", HttpStatus.OK);
        }
        
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
