package tests;

import javax.transaction.Transactional;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import packages.Application;
import packages.repositories.WhitelistRepository;
import packages.tables.WhitelistMember;

@Transactional
@SpringBootTest(classes=Application.class)
@RunWith(SpringJUnit4ClassRunner.class)
public class WhitelistTests {
    
    @Autowired
    WhitelistRepository whitelistRepo;
    
    @Test
    public void saveLongEmailToWhiteListThenRemoveIt(){
        String emailAddress = "qwertyuiopasdfghjklzxcvbnm@qazwsxedcrfvtgbyhnujmikolp.com";
        
        WhitelistMember testEmailWhitelistMember = new WhitelistMember(emailAddress);
        whitelistRepo.save(testEmailWhitelistMember);
        
        String savedEmailAddress = testEmailWhitelistMember.getEmail();
        assert(savedEmailAddress.equals(emailAddress));
  
        assert(whitelistRepo.findById(savedEmailAddress).isPresent());
        
        WhitelistMember foundTestWhitelistMember = whitelistRepo.findById(savedEmailAddress).get();
        whitelistRepo.delete(foundTestWhitelistMember);
        
        assert(whitelistRepo.findById(savedEmailAddress).isPresent() == false);
    }
    
    @Test
    public void saveShortEmailToWhiteListThenRemoveIt(){
        String emailAddress = "q@n.co";
        
        WhitelistMember testEmailWhitelistMember = new WhitelistMember(emailAddress);
        whitelistRepo.save(testEmailWhitelistMember);
        
        String savedEmailAddress = testEmailWhitelistMember.getEmail();
        assert(savedEmailAddress.equals(emailAddress));
  
        assert(whitelistRepo.findById(savedEmailAddress).isPresent());
        
        WhitelistMember foundTestWhitelistMember = whitelistRepo.findById(savedEmailAddress).get();
        whitelistRepo.delete(foundTestWhitelistMember);
        
        assert(whitelistRepo.findById(savedEmailAddress).isPresent() == false);
    }
    
}
