package packages.controllers;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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
        
        @GetMapping(path="/get-engagement/{year}/{month}")
        public @ResponseBody ArrayList<Float> getUserEngagementFromMonth(@PathVariable Integer year, @PathVariable Integer month){
            
            //Iterate though all users in user statistics, 
            // convert the JSON into a readable format, 
            // then tallies the score and active user count for each day.
            
            ArrayList<Integer> habitsChecked = new ArrayList(70);
            ArrayList<Integer> usersActive = new ArrayList(70);
            ArrayList<Float> engagementForMonth = new ArrayList(70);
            
            for (int i = 0; i < 70; i++) {
                habitsChecked.add(0);
                usersActive.add(0);
                engagementForMonth.add((float)0);
            }

            Iterable<UserStatistics> allUserStats = userStatisticsRepo.findAll();

            for (UserStatistics user : allUserStats){
                
                JSONArray habitsArray = new JSONArray(user.getJson());
                
                //For each user, we want to find the day they started the course.
                //So we iterate through all the habits they have, and find the earliest start date.
                
                Date userStartDate = new Date();
                userStartDate.setYear(9000);
                
                for (int i = 0; i < habitsArray.length(); i++){
                    JSONObject habit = habitsArray.getJSONObject(i);
                    String startDateString = habit.get("dateStarted").toString();
                    
                    try { 
                        Date habitStartDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateString);
                        if (habitStartDate.compareTo(userStartDate) < 0){
                            userStartDate = habitStartDate;
                        }
                    } catch (ParseException ex) {
                        System.out.println("The date is of the wrong format : " + startDateString);
                    }
                }
                
                //System.out.println("Course start date is " + userStartDate.toString());
                
                //If the earliest start date is in the correct month / year, then we add their habit engagement to the charts.
                if (((int) userStartDate.getYear() + 1900) == year && ((int) userStartDate.getMonth() + 1) == month){
                    
                            
                    for (int i = 0; i < habitsArray.length(); i++){
                        //System.out.println(i + " : " + habitsArray.length());
                                
                        JSONObject habit = habitsArray.getJSONObject(i);
                        
                        String startDateString = habit.get("dateStarted").toString();

                        try { 
                            Date habitStartDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateString);
                            
                            int daysOffset = getDifferenceInDaysBetween(userStartDate, habitStartDate);
                            
                            //System.out.println("Days Offset : " + daysOffset);

                            JSONArray checklist = habit.getJSONArray("daysChecked");
                            
                            for (int j = 0; j < checklist.length(); j++){
                                int checked = checklist.getInt(j);
                                
                                if (checked == 1){
                                    int newTotalHabitsChecked = habitsChecked.get(j + daysOffset) + 1;
                                    habitsChecked.set(j + daysOffset, newTotalHabitsChecked);
                                }
                            }
                            
                            if (userStartDate.equals(habitStartDate)){

                                for (int j = 0; j < checklist.length(); j++){
                                    int totalActiveUsers = usersActive.get(j) + 1;
                                    usersActive.set(j, totalActiveUsers);
                                }
                            }

                        } catch (ParseException ex) {
                            System.out.println("The date is of the wrong format : " + startDateString);
                        }
                    } 
                }
            }
            
            
            
            for (int i = 0; i < 70; i++){
                if (usersActive.get(i) != 0){
                    engagementForMonth.set(i, ((float) habitsChecked.get(i) / (float) usersActive.get(i)));
                } else {
                    engagementForMonth.set(i, (float) 0);
                }
            }
            
            return engagementForMonth;
        }
        
        @RequestMapping(path="/reset-user-statistics")
        public @ResponseBody String resetUserStatistics(){
            
            userStatisticsRepo.deleteAll();
            
            UserStatistics userStats = new UserStatistics("Example1", "[ { 'habitKey': 'eat slowly_key', 'dateStarted': '2019-01-01', 'daysChecked': [1,1,1,1,0,0,0,1,1,1,1,0,1,0,1,1,1,1,1,0,0,1,0,1,0,1,1,0] }, { 'habitKey': 'three meals_key', 'dateStarted': '2019-01-08', 'daysChecked': [1,0,1,1,1,1,0,1,1,0,1,1,1,0,1,1,1,0,0,1,1] }, { 'habitKey': 'whole foods_key', 'dateStarted': '2019-01-15', 'daysChecked': [1,1,1,0,0,1,1,1,0,0,0,1,1,1] } ]");
            userStatisticsRepo.save(userStats);
            
            userStats = new UserStatistics("Example2", "[ { 'habitKey': 'eat slowly_key', 'dateStarted': '2019-01-08', 'daysChecked': [1,1,1,1,0,1,0,1,1,0,1,1,1,0,1,1,0,1,0,1,1] }, { 'habitKey': 'three meals_key', 'dateStarted': '2019-01-15', 'daysChecked': [0,1,1,0,1,0,1,1,0,1,1,1,1,0] }, { 'habitKey': 'whole foods_key', 'dateStarted': '2019-01-22', 'daysChecked': [1,1,0,0,0,1,1] } ]");
            userStatisticsRepo.save(userStats);
            
            userStats = new UserStatistics("Example3", "[ { 'habitKey': 'eat slowly_key', 'dateStarted': '2019-01-15', 'daysChecked': [1,1,1,0,1,1,1,1,1,1,0,1,1,0] }, { 'habitKey': 'whole foods_key', 'dateStarted': '2019-01-22', 'daysChecked': [1,1,1,1,0,1,1] } ]");
            userStatisticsRepo.save(userStats);
            
            return "Successfully reset.";
        }
        
        private int getDifferenceInDaysBetween(Date d1, Date d2) {
            long diff = d2.getTime() - d1.getTime();
            return (int) TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
        }

        //This requires a function that iterates through all the user statistics records, 
        // iterating through their stats for each day,
        // tallying the scores for each day.
        
        //This requires a function that gets the JSON from the user statistics reposistory

}