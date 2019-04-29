package packages.controllers;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
        
        @GetMapping(path="/get-engagement/{year}/{month}")
        public @ResponseBody ArrayList<Float> getUserEngagementFromMonth(@PathVariable Integer year, @PathVariable Integer month){
            
            //Iterate though all users in user statistics, 
            // convert the JSON into a readable format, 
            // then tallies the score and active user count for each day.
            
            ArrayList<Integer> habitsChecked = new ArrayList(70);
            ArrayList<Integer> usersActive = new ArrayList(70);
            ArrayList<Float> engagementForMonth = new ArrayList(71);
            
            // Note that an extra value is returned after the engagement statistics
            // This is a tally of all the users which make up the current graph.
            int activeUsers = 0;
            
            for (int i = 0; i < 70; i++) {
                habitsChecked.add(0);
                usersActive.add(0);
                engagementForMonth.add((float)0);
            }

            Iterable<UserStatistics> allUserStats = userStatisticsRepo.findAll();
            
            int count = 0;
            for (UserStatistics user : allUserStats){
                count += 1;
            }
            
            //System.out.println("~~~ NUMBER OF USERS IN DATABASE : " + count + " ~~~");

            for (UserStatistics user : allUserStats){
                
                JSONArray habitsArray = new JSONArray(user.getJson());
                Date userStartDate = getEarlistHabitStartDate(habitsArray);
                
                //If the earliest start date is in the correct month / year, then we add their habit engagement to the charts.
                if (dateIsInMonthlyRegion(userStartDate, year, month)){
                    habitsChecked = tallyHabits(habitsChecked, userStartDate, habitsArray);
                    usersActive = tallyActiveUsers(usersActive, userStartDate, habitsArray);
                    activeUsers += 1;
                }
            }
            //System.out.println("TALLIED HABITS ENGAGEMENT AND USERS");
            
            for (int i = 0; i < 70; i++){
                if (usersActive.get(i) != 0){
                    engagementForMonth.set(i, ((float) habitsChecked.get(i) / (float) usersActive.get(i)));
                } else {
                    engagementForMonth.set(i, (float) 0);
                }
            }
            
            engagementForMonth.add((float) activeUsers);
            
            return engagementForMonth;
        }
        
        @GetMapping(path="/get-engagement/{year}/{month}/{weekNumberInMonth}")
        public @ResponseBody ArrayList<Float> getUserEngagementFromWeekNumber(@PathVariable Integer year, @PathVariable Integer month, @PathVariable Integer weekNumberInMonth){
            ArrayList<Integer> habitsChecked = new ArrayList(70);
            ArrayList<Integer> usersActive = new ArrayList(70);
            ArrayList<Float> engagementForWeek = new ArrayList(71);
            int activeUsers = 0;
            
            for (int i = 0; i < 70; i++) {
                habitsChecked.add(0);
                usersActive.add(0);
                engagementForWeek.add((float)0);
            }
            
            Iterable<UserStatistics> allUserStats = userStatisticsRepo.findAll();
            
            for (UserStatistics user : allUserStats){
                JSONArray habitsArray = new JSONArray(user.getJson());
                Date userStartDate = getEarlistHabitStartDate(habitsArray);
                
                if (dateIsInWeeklyRegion(userStartDate, year, month, weekNumberInMonth)){
                    habitsChecked = tallyHabits(habitsChecked, userStartDate, habitsArray);
                    usersActive = tallyActiveUsers(usersActive, userStartDate, habitsArray);
                    activeUsers += 1;
                }
            }
            
            //System.out.println("TALLIED HABITS ENGAGEMENT AND USERS");
            
            for (int i = 0; i < habitsChecked.size(); i++){
                if (usersActive.get(i) != 0){
                    engagementForWeek.set(i, ((float) habitsChecked.get(i) / (float) usersActive.get(i)));
                } else {
                    engagementForWeek.set(i, (float) 0);
                }
            }
            
            engagementForWeek.add((float) activeUsers);
            
            return engagementForWeek;
        }
        
        @RequestMapping(path="/add-test-user-statistics")
        public ResponseEntity<String> addTestUserStatisticsRecords(){
            
            try {
                UserStatistics userStats = new UserStatistics("Example1", "[ { 'habitKey': 'eat slowly_key', 'dateStarted': '2019-01-01', 'daysChecked': [1,1,1,1,0,0,0,1,1,1,1,0,1,0,1,1,1,1,1,0,0,1,0,1,0,1,1,0] }, { 'habitKey': 'three meals_key', 'dateStarted': '2019-01-08', 'daysChecked': [1,0,1,1,1,1,0,1,1,0,1,1,1,0,1,1,1,0,0,1,1] }, { 'habitKey': 'whole foods_key', 'dateStarted': '2019-01-15', 'daysChecked': [1,1,1,0,0,1,1,1,0,0,0,1,1,1] } ]");
                userStatisticsRepo.save(userStats);
                userStats = new UserStatistics("Example2", "[ { 'habitKey': 'eat slowly_key', 'dateStarted': '2019-01-08', 'daysChecked': [1,1,1,1,0,1,0,1,1,0,1,1,1,0,1,1,0,1,0,1,1] }, { 'habitKey': 'three meals_key', 'dateStarted': '2019-01-15', 'daysChecked': [0,1,1,0,1,0,1,1,0,1,1,1,1,0] }, { 'habitKey': 'whole foods_key', 'dateStarted': '2019-01-22', 'daysChecked': [1,1,0,0,0,1,1] } ]");
                userStatisticsRepo.save(userStats);
                userStats = new UserStatistics("Example3", "[ { 'habitKey': 'eat slowly_key', 'dateStarted': '2019-01-15', 'daysChecked': [1,1,1,0,1,1,1,1,1,1,0,1,1,0] }, { 'habitKey': 'whole foods_key', 'dateStarted': '2019-01-22', 'daysChecked': [1,1,1,1,0,1,1] } ]");
                userStatisticsRepo.save(userStats);
                userStats = new UserStatistics("Example4", "[{'habitKey':'observation','dateStarted':'2018-12-09','daysChecked':[1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,0,1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,0,0,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1,0,0,0,0,0,0,1,0,1,1,1,1,0,1,1,0,1,0,1,1,0,0,0,0,0,0,0,1,1,1,1,0,0,1,0,1,1]},{'habitKey':'eat_slowly','dateStarted':'2018-12-09','daysChecked':[1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,0,0,1,0,1,0]},{'habitKey':'eat_whole','dateStarted':'2019-02-20','daysChecked':[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0]},{'habitKey':'drink_water','dateStarted':'2019-02-20','daysChecked':[1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,1,0,0,0,1,1,1,0,0,1,1,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1]},{'habitKey':'eat_3meals','dateStarted':'2019-03-01','daysChecked':[1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1]}]");
                userStatisticsRepo.save(userStats);
                
                
                return new ResponseEntity<>("Test users added.", HttpStatus.OK);
            } catch (Exception ex){
                return new ResponseEntity<>("Unable to add new test users.", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
        
        @RequestMapping(path="/delete-test-user-statistics")
        public ResponseEntity<String> deleteAllTestUserStatistics(){
            Iterable<UserStatistics> allUserStats = userStatisticsRepo.findAll();
            
            for (UserStatistics user : allUserStats){
                if ("Example1".equals(user.getUserId())){
                    userStatisticsRepo.deleteById(user.getId());
                }
                if ("Example2".equals(user.getUserId())){
                    userStatisticsRepo.deleteById(user.getId());
                }
                if ("Example3".equals(user.getUserId())){
                    userStatisticsRepo.deleteById(user.getId());
                }
                if ("Example4".equals(user.getUserId())){
                    userStatisticsRepo.deleteById(user.getId());
                }
            }
            
            return new ResponseEntity<>("Users deleted.", HttpStatus.OK);
        }
        
        public static int getDifferenceInDaysBetween(Date d1, Date d2) {
            long diff = d2.getTime() - d1.getTime();
            return (int) TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
        }
        
        public static Boolean dateIsInWeeklyRegion(Date date, int year, int month, int weekOfMonth){
            
            if (((int) date.getYear() + 1900) == year){
                if(((int) date.getMonth() + 1) == month){
                    if((int) date.getDate()>= (weekOfMonth-1) * 7 && (int) date.getDate() <= weekOfMonth * 7){
                        return true;
                    }
                    //Automatically assumes that 29, 30 and 31 are part of the fourth week of the month.
                    if((int) date.getDate() >= 28 && weekOfMonth == 4){
                        return true;
                    }
                }
            }
            return false;
        }
        
        public static Boolean dateIsInMonthlyRegion(Date date, int year, int month){
            return (((int) date.getYear() + 1900) == year && ((int) date.getMonth() + 1) == month);
        }
        
        private Date getEarlistHabitStartDate(JSONArray habitsArray){
            Date userStartDate = new Date();
            userStartDate.setYear(9001);

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
            
            //System.out.println("The start date is : " + userStartDate.toString());
            
            return userStartDate;
        }
        
        private ArrayList<Integer> tallyActiveUsers(ArrayList<Integer> usersActive, Date userStartDate, JSONArray habitsArray){
            for (int i = 0; i < habitsArray.length(); i++){

                JSONObject habit = habitsArray.getJSONObject(i);
                String startDateString = habit.get("dateStarted").toString();

                try { 
                    Date habitStartDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateString);
                    JSONArray checklist = habit.getJSONArray("daysChecked");

                    if (userStartDate.equals(habitStartDate)){ //Only tally active days for one habit.
                        for (int j = 0; j < 70; j++){
                            int totalActiveUsers = usersActive.get(j) + 1;
                            usersActive.set(j, totalActiveUsers);
                        }
                        break;
                    }
                } catch (ParseException ex) {
                    System.out.println("The date is of the wrong format : " + startDateString);
                }
            } 
            
            return usersActive;
        }
        
        private ArrayList<Integer> tallyHabits(ArrayList<Integer> habitsChecked, Date userStartDate, JSONArray habitsArray){
            for (int i = 0; i < habitsArray.length(); i++){

                JSONObject habit = habitsArray.getJSONObject(i);
                String startDateString = habit.get("dateStarted").toString();
                
                //System.out.println("### Tallying habits...");
                //System.out.println(" - The start date is : " + startDateString);

                try { 
                    Date habitStartDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateString);
                    int daysOffset = getDifferenceInDaysBetween(userStartDate, habitStartDate);
                    //System.out.println("- Days offset is : " + daysOffset);
                    JSONArray checklist = habit.getJSONArray("daysChecked");

                    //Iterating through all of the days of the habit, tallying if they are checked to another array.
                    for (int j = 0; j < checklist.length(); j++){
                        int checked = checklist.getInt(j);
                        if (checked == 1){
                            if (j + daysOffset < 70){
                                int newTotalHabitsChecked = habitsChecked.get(j + daysOffset) + 1;
                                habitsChecked.set(j + daysOffset, newTotalHabitsChecked);
                            }
                        }
                    }

                } catch (ParseException ex) {
                    System.out.println("The date is of the wrong format : " + startDateString);
                }
            } 
            
            return habitsChecked;
        }
}