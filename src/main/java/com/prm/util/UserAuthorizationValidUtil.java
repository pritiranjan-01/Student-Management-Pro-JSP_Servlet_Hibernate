package com.prm.util;

import com.prm.entity.AuthorizeRoleEnum;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UserAuthorizationValidUtil {
	
	private static final  UserAuthorizationValidUtil authUtilObject = new UserAuthorizationValidUtil();
	
	private UserAuthorizationValidUtil() {}
	
	public static UserAuthorizationValidUtil getAuthorizationValidUtil() {
		return authUtilObject;
	}
	
	// this function will authorize the role of an logged user with Argument Enum roles.
	
	public UserResponseObject getRoleAuthorizationCheckByCookies
	   (HttpServletRequest req, HttpServletResponse res, AuthorizeRoleEnum action) {
		  String [] roles = action.getActionRoles(); // Get the UserRole from this argument Enum. Ex- Admin or SuperAdmin or HR. 
		  String loggedUserRole = "random";      // Get the current LoggedIn User Role from Cookies.
		  Cookie[] cookies = req.getCookies();
		  if(cookies == null) return new UserResponseObject(false, "Unable to fetch User Role as Cookie is not available");
		  
		  for(Cookie c : cookies) {
		  	  if(c.getName().equalsIgnoreCase("role")){
				  loggedUserRole = c.getValue();
				  break;
			  }
		  }
		  
		  // Match the loggedIn User Role with the argument Enum User roles 
		  // if both roles match then the current logged User can perform the task/action.
		  for(String role : roles) {
			  if(role.equalsIgnoreCase(loggedUserRole)) {
				  return new UserResponseObject(true,"Role Authorized Successfully");
			  }
		  }
		  return new UserResponseObject(false, loggedUserRole+" not allowed for "+action.name());
	}
	
	public UserResponseObject getRoleAuthorizationCheckByHttpSession
	   (HttpServletRequest req, HttpServletResponse res, AuthorizeRoleEnum action) {
		
		HttpSession session = req.getSession();
		
		if(session==null) return new UserResponseObject(false, "Unable to fetch User Role");
		Object loggeduserRole = session.getAttribute("role");
		
		if(loggeduserRole == null)  return new UserResponseObject(false, "Cant find attribute \"role\" from Cookies");
		String logggedinRole = (String)loggeduserRole;
		String [] roles = action.getActionRoles();
		
		for(String role : roles) {
			if(role.equalsIgnoreCase("role")) {
				return new UserResponseObject(true,"Role Authorized Successfully");
			}
		}
		return new UserResponseObject(false, logggedinRole+" not allowed for "+action.name());
	}
}
