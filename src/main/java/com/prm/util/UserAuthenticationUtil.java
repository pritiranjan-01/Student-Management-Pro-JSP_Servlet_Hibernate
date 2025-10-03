package com.prm.util;

import java.time.LocalDateTime;

import com.prm.dao.UserDAO;
import com.prm.entity.Users;

import jakarta.servlet.SessionCookieConfig;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UserAuthenticationUtil {
	private UserDAO userDao = UserDAO.getUserDAO();
	
	private static final UserAuthenticationUtil userAuth = new 
											UserAuthenticationUtil();
	private UserAuthenticationUtil() {}
	
	public static UserAuthenticationUtil getUserAuthenticationUtil() {
		return userAuth;
	}
		
	public UserResponseObject getUsernameAndPasswordAuthenticate(HttpServletRequest req, HttpServletResponse res) {
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		Users user = userDao.getUserByUserName(username);
		
		if(user == null) {
			return new UserResponseObject(false,"Invalid Username");	
		}
		else if(!user.getPassword().equals(password)) {
			return new UserResponseObject(false, "Invalid Password");
		}

		String userrole = user.getUserrole().name();
		
		// Setting Cookies 
		Cookie cookie1 = new Cookie("role", userrole);
		Cookie cookie2 = new Cookie("loginstatus", "valid");
		cookie1.setMaxAge(10*60);  
		cookie2.setMaxAge(10*60);  // takes time in seconds
		cookie1.setPath("/");
		cookie2.setPath("/");
		res.addCookie(cookie1);
		res.addCookie(cookie2);		
	
		
		// Setting HttpSession Object
		HttpSession session = req.getSession();
		session.setMaxInactiveInterval(10*60);  // takes time in seconds
		session.setAttribute("role", userrole);
		session.setAttribute("loginstatus", "valid");
		session.setAttribute("fullname", user.getFullName());
		session.setAttribute("id", user.getId());
		
		// Setting Last Login time
		user.setLastLogin(LocalDateTime.now());
		userDao.updateUser(user);
		
		return new UserResponseObject(true, "Login Successful");
	}
	
	public boolean getCookieAuthenticate(HttpServletRequest req, HttpServletResponse res) {
		Cookie[] cookie = req.getCookies();
		if(cookie==null || cookie.length==0) return false;
		for(Cookie c : cookie) {
			String name = c.getName();
			String value = c.getValue();
			if(name.equals("loginstatus") && value.equals("valid"))
				return true;
		}
		return false;
	}
	
	public boolean getSessionObjectAuthentication(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession(false);
		if(session == null) return false;
		Object objectValidToken = session.getAttribute("loginstatus");
		if(objectValidToken == null) return false;
		String validToken = (String) objectValidToken;
		return validToken.equals("valid");
	}
}
