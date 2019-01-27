/*
package initialPackages;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service(value = "userService")
public class UserServiceImplementation implements UserDetailsService, UserService {
	
    @Autowired
    private UserDao userDao;

    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
            User user = userDao.findByUsername(userId);
            if(user == null){
                    throw new UsernameNotFoundException("Invalid username or password.");
            }
            return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), getAuthority());
    }

    private List getAuthority() {
            return Arrays.asList(new SimpleGrantedAuthority("ROLE_ADMIN"));
    }

    public List findAll() {
            List list = new ArrayList<>();
            userDao.findAll().iterator().forEachRemaining(list::add);
            return list;
    }

    @Override
    public User findById(long id) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public User findByName(String name) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void saveUser(User user) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void updateUser(User user) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void deleteUserById(long id) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public List<User> findAllUsers() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void deleteAllUsers() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean isUserExist(User user) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
*/