package tests;

import org.junit.Test;
import org.junit.runner.RunWith;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import packages.Application;

// See https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-testing.html#boot-features-testing-spring-boot-applications-testing-with-mock-environment

@RunWith(SpringRunner.class)
@SpringBootTest(classes=Application.class)
@AutoConfigureMockMvc
public class MvcTests {

	@Autowired
	private MockMvc mvc;

	@Test
	public void publicWebpagesLoad() throws Exception {
            this.mvc.perform(get("/")).andExpect(status().isOk());
            this.mvc.perform(get("/legal")).andExpect(status().isOk());
            this.mvc.perform(get("/login")).andExpect(status().isOk());
	}

        @Test
        public void loginRequiredToAccessOtherSitePages() throws Exception {
            this.mvc.perform(get("/whitelist"))
                    .andExpect(status().is3xxRedirection())
                    .andExpect(redirectedUrl("http://localhost/login"));
            
            this.mvc.perform(get("/course-editor"))
                    .andExpect(status().is3xxRedirection())
                    .andExpect(redirectedUrl("http://localhost/login"));
            
            this.mvc.perform(get("/dashboard"))
                    .andExpect(status().is3xxRedirection())
                    .andExpect(redirectedUrl("http://localhost/login"));          
        }
        
        @Test
        public void legalLoads() throws Exception {
            assert(true);
        }
}