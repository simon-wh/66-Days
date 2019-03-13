package tests;

import javax.transaction.Transactional;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import packages.Application;

@Transactional //Rolls back changes to the database after testing.
@SpringBootTest(classes=Application.class)
@RunWith(SpringJUnit4ClassRunner.class)
public class WhitelistTests {
    
    @Test
    public void assertAlive(){
        assert(true);
    }
    
}
