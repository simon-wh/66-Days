package packages.controllers;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import packages.repositories.WhitelistRepository;
import packages.tables.WhitelistMember;

@Controller
@RequestMapping(path="/whitelist")
public class whitelistController {
    
    @Autowired
    private WhitelistRepository whitelistRepo;
    
    @GetMapping("")
    public String whitelist(Model model){
        model.addAttribute("whitelistMembers", getWhitelistMembers());
        return "whitelist";
    }
    
    @RequestMapping(path="/add-email")
    public String addNewUser (@RequestParam("email") String email, Model model, HttpServletRequest request) {
        if(whitelistRepo.existsById(email)){
            return "redirect:" + request.getHeader("referer");
        } else {
            WhitelistMember n = new WhitelistMember(email);
            whitelistRepo.save(n);
            return "redirect:" + request.getHeader("referer");
        }
    }
    
    @RequestMapping(path="/delete-email")
    public String deleteUser(@RequestParam("email") String email, Model model, HttpServletRequest request) {
        
        if (whitelistRepo.existsById(email)){
            whitelistRepo.deleteById(email);
        } else {
            return "redirect:" + request.getHeader("referer");
        }
        
        List<WhitelistMember> members = new ArrayList<>();
        whitelistRepo.findAll().forEach(members::add);
        
        return "redirect:" + request.getHeader("referer");
    }
    
    public List<WhitelistMember> getWhitelistMembers(){
        List<WhitelistMember> memberList = new ArrayList<>();
        Iterable<WhitelistMember> memberIterable =  whitelistRepo.findAll();
        
        for (WhitelistMember member: memberIterable) {
            if (!member.getEmail().replaceAll("[\\n\\t ]", "").equals(""))
                memberList.add(member);
        }
        
        return memberList;
    }
}

