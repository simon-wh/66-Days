
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
import org.springframework.web.bind.annotation.ResponseBody;
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
                throw new ResponseStatusException( HttpStatus.UNAUTHORIZED, "no user id found from ID token");
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
            
            throw new ResponseStatusException( HttpStatus.UNAUTHORIZED, "unauthorized");
        }
        
        // ### UPDATE USER STATISTICS / CREATE NEW USER STATISTICS RECORD ### //
        
        @RequestMapping(value = "/update-statistics", method = RequestMethod.POST, consumes = "application/json")
        public void updateUserStatistics(HttpEntity<String> httpEntity, @RequestHeader(value = "ID-TOKEN", required = true) String idToken) throws Exception {
            //1 - Get the JSON from the body of the request.
            String json = httpEntity.getBody();
            
            System.out.println("### JSON ### " + json);
            
            if (json == null) {
                throw new ResponseStatusException( HttpStatus.BAD_REQUEST, "no JSON found in request body");
            }
            
            //2 - Get the user id from the request.
            String userId = getUserIdFromIdToken(idToken); //Note that idToken comes from the HTTP Header.
            
            System.out.println("### USER ID ### " + userId);
            
            //3 - If the user id is null, decline the request.
            if (userId == null){
                throw new ResponseStatusException( HttpStatus.UNAUTHORIZED, "no user id found from ID token");
            }
            
            //4 - Iterate through the sites users and update the appropriate one.
            Iterable<UserStatistics> allUsers = userStatisticsRepo.findAll();
            for (UserStatistics user : allUsers){
                if (user.getUserId() == userId){
                    user.setJson(json);
                    userStatisticsRepo.save(user);
                    System.out.println("### UPDATED USER ###");
                    throw new ResponseStatusException( HttpStatus.OK, "successfully updated"); 
                }
            }
            
            //5 - If we never throw that it's been updated, create a new record entry then throw.
            UserStatistics u = new UserStatistics(userId, json);
            userStatisticsRepo.save(u);
            System.out.println("### CREATED AND SAVED USER ###");
            
            throw new ResponseStatusException( HttpStatus.OK, "new statistics record created"); 
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
