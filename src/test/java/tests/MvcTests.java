package tests;

import org.junit.Test;
import org.junit.runner.RunWith;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import packages.Application;

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
        
        /*
        @Test
        public void mobileAPIDeniesAccessToWebBrowsers() throws Exception {
            this.mvc.perform(get("/mobile-api")).andExpect(status().isNotFound());
            this.mvc.perform(get("/mobile-api/get-course-content")).andExpect(status().isBadRequest());
            this.mvc.perform(get("/mobile-api/update-statistics")).andExpect(status().isMethodNotAllowed());
        }
*/
        
        @Test
        public void webAPIRequiresLoginBeforeAccess() throws Exception {
            this.mvc.perform(get("/web-api/get-engagement"))
                    .andExpect(status().is3xxRedirection())
                    .andExpect(redirectedUrl("http://localhost/login"));
            
            this.mvc.perform(get("/web-api/get-engagement/2019/01"))
                    .andExpect(status().is3xxRedirection())
                    .andExpect(redirectedUrl("http://localhost/login"));
            
            this.mvc.perform(get("/web-api/get-engagement/2019/01/1"))
                    .andExpect(status().is3xxRedirection())
                    .andExpect(redirectedUrl("http://localhost/login"));
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
        @WithMockUser(username = "ben@66days.co", roles={"ADMIN"})
        public void loginEnablesAccessToAllSitePages() throws Exception {
            this.mvc.perform(get("/")).andExpect(status().isOk());
            this.mvc.perform(get("/legal")).andExpect(status().isOk());
            this.mvc.perform(get("/login")).andExpect(status().isOk());
            this.mvc.perform(get("/whitelist")).andExpect(status().isOk());
            this.mvc.perform(get("/course-editor")).andExpect(status().isOk());
            this.mvc.perform(get("/dashboard")).andExpect(status().isOk());      
        }
        
        @Test
        @WithMockUser(username = "ben@66days.co", roles={"ADMIN"})
        public void loginEnablesAccessToWebAPI() throws Exception {
            this.mvc.perform(get("/web-api/get-engagement/2019/01")).andExpect(status().isOk());
            this.mvc.perform(get("/web-api/get-engagement/2019/01/1")).andExpect(status().isOk());     
        }
        
}