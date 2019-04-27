package tests;

import java.text.SimpleDateFormat;
import java.util.Date;
import javax.transaction.Transactional;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import packages.Application;

import packages.controllers.WebAPIController;
import packages.repositories.UserStatisticsRepository;
import packages.tables.UserStatistics;

@Transactional
@SpringBootTest(classes=Application.class)
@RunWith(SpringJUnit4ClassRunner.class)
public class DashboardTests {
    
    @Autowired
    UserStatisticsRepository userStatsRepo;
    
    @Test
    public void unitTestGetDifferenceInDaysBetween() throws Exception {
        Date one = new Date();
        Date two = new Date();
        
        assert(WebAPIController.getDifferenceInDaysBetween(one, two) == 0);
        
        one.setYear(1233);
        two.setYear(1234);
        
        assert(WebAPIController.getDifferenceInDaysBetween(one, two) == 365); //Not a leap year.
        
        two.setYear(1233);
        one.setMonth(0);
        two.setMonth(1);
        
        assert(WebAPIController.getDifferenceInDaysBetween(one, two) == 31); //Length of January.
    }
    
    @Test
    public void unitTestDateIsInWeeklyRegion() throws Exception {
        String strOne = "1/3/2019";
        Date one = new SimpleDateFormat("dd/MM/yyyy").parse(strOne);
        String strTwo = "7/3/2019";
        Date two = new SimpleDateFormat("dd/MM/yyyy").parse(strTwo);
        String strThree = "16/3/2019";
        Date three = new SimpleDateFormat("dd/MM/yyyy").parse(strThree);
        String strFour = "30/3/2019";
        Date four = new SimpleDateFormat("dd/MM/yyyy").parse(strFour);

        assert(WebAPIController.dateIsInWeeklyRegion(one, 2019, 3, 1));
        assert(WebAPIController.dateIsInWeeklyRegion(two, 2019, 3, 1));
        assert(WebAPIController.dateIsInWeeklyRegion(three, 2019, 3, 3));
        assert(WebAPIController.dateIsInWeeklyRegion(four, 2019, 3, 4));
    }
    
    @Test
    public void unitTestDateIsInMonthlyRegion() throws Exception {
        String strOne = "1/3/2019";
        Date one = new SimpleDateFormat("dd/MM/yyyy").parse(strOne);
        String strTwo = "7/5/2019";
        Date two = new SimpleDateFormat("dd/MM/yyyy").parse(strTwo);
        String strThree = "16/7/2019";
        Date three = new SimpleDateFormat("dd/MM/yyyy").parse(strThree);
        String strFour = "30/12/2019";
        Date four = new SimpleDateFormat("dd/MM/yyyy").parse(strFour);

        assert(WebAPIController.dateIsInMonthlyRegion(one, 2019, 3));
        assert(WebAPIController.dateIsInMonthlyRegion(two, 2019, 5));
        assert(WebAPIController.dateIsInMonthlyRegion(three, 2019, 7));
        assert(WebAPIController.dateIsInMonthlyRegion(four, 2019, 12));
    }
    
    //A helpful function for debugging.
    private void printUserStatisticsRepositoryContents(){
        Iterable<UserStatistics> userStats = userStatsRepo.findAll();
        for (UserStatistics userStat : userStats){
            printUserStatsRecord(userStat);
        }
    }
    
    private void printUserStatsRecord(UserStatistics userStat){
        System.out.println("# " + userStat.getId() + " : " + userStat.getUserId());
        System.out.println(" ~ " +userStat.getJson());
    }
    
}