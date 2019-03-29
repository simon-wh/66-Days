package packages.controllers;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import packages.repositories.UserStatisticsRepository;
import packages.tables.UserStatistics;

@Controller 
@RequestMapping(path="/web-api")
@Secured("ADMIN")
public class WebAPIController {
    
        @Autowired
        private UserStatisticsRepository userStatisticsRepo;

        @GetMapping(path="/get-statistics")
        public @ResponseBody String getStatistics(){
            return "No statistics returned yet.";
        }
        
        //A function that returns JSON of how well people are checking off habits.
        //Returns an array of the total score achieved by users early on in the course...
        //The array starts on day one. It tallies the number of habits checked off for every person for each day.
        
        @GetMapping(path="/get-total-checkoffs")
        public @ResponseBody String getTotalCheckOffs(){
            
            //Iterate though all users in user statistics, convert the JSON into a readable format, then tallies the score for each day.
            Iterable<UserStatistics> allUserStats = userStatisticsRepo.findAll();

            for (UserStatistics user : allUserStats){
                JSONArray habitsArray = new JSONArray(user.getJson());
                
                for (int i = 0; i < habitsArray.length(); i++){
                    JSONObject habit = habitsArray.getJSONObject(i);
                    
                    String habitKey = habit.get("habitKey").toString();
                    String startDateString = habit.get("dateStarted").toString();
                    JSONArray checklist = habit.getJSONArray("daysChecked");
                    
                    System.out.println(habitKey + " : " + startDateString);
                }

            }
            
            
            return "Null";
        }
        
        //A feature to filter the score progress of users by the month they started the course.
        @GetMapping(path="/get-checkoffs-for-month/{month}")
        public @ResponseBody String getTotalCheckOffsForUsersStartingMonth(){
            return "Null";
        }
        
        @RequestMapping(path="/reset-user-statistics-with-default-values")
        public @ResponseBody String resetUserStatistics(){
            
            UserStatistics userStats = new UserStatistics("[ { 'habitKey': 'eat slowly_key', 'dateStarted': '2017-01-20T12:34:56.123456789Z', 'daysChecked': [1,1,1,0,1,1,0,1,0,1,0,0,1,0] }, { 'habitKey': 'three meals_key', 'dateStarted': '2017-01-23T12:34:56.123456789Z', 'daysChecked': [1,0,1,1,1,1,0,1,1,1,1] }, { 'habitKey': 'whole foods_key', 'dateStarted': '2017-01-26T12:34:56.123456789Z', 'daysChecked': [1,0,1,0,0,1,0,1] } ]");
            userStatisticsRepo.save(userStats);
            
            userStats = new UserStatistics("[ { 'habitKey': 'eat slowly_key', 'dateStarted': '2017-01-10T12:34:56.123456789Z', 'daysChecked': [0,1,0,0,1,1,0,1,0,1,0,1,1,0,1,1,0,1,0,1,0,1,1,0] }, { 'habitKey': 'three meals_key', 'dateStarted': '2017-01-13T12:34:56.123456789Z', 'daysChecked': [0,0,1,1,1,1,0,1,0,0,1,1,1,0,1,0,1,0,1,1,0] }, { 'habitKey': 'whole foods_key', 'dateStarted': '2017-01-16T12:34:56.123456789Z', 'daysChecked': [1,0,1,1,1,1,0,1,1,1,0,1,0,1,0,1,1,0] } ]");
            userStatisticsRepo.save(userStats);
            
            return "Successfully reset.";
        }
        
        //This requires a function that iterates through all the user statistics records, 
        // iterating through their stats for each day,
        // tallying the scores for each day.
        
        //This requires a function that gets the JSON from the user statistics reposistory

}