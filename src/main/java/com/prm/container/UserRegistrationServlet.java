package com.prm.container;

import java.io.IOException;
import java.io.PrintWriter;

import com.prm.dao.UserDAO;
import com.prm.entity.AuthorizeRoleEnum;
import com.prm.entity.Users;
import com.prm.entity.Usertype;
import com.prm.util.UserAuthorizationValidUtil;
import com.prm.util.UserAuthenticationUtil;
import com.prm.util.UserResponseObject;

import jakarta.servlet.GenericServlet;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/createuser")
public class UserRegistrationServlet extends HttpServlet{
	
	private final UserDAO userdao = UserDAO.getUserDAO();
	private final UserAuthenticationUtil authUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
	private final UserAuthorizationValidUtil authorizeUtil = UserAuthorizationValidUtil.getAuthorizationValidUtil();
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		
		UserResponseObject authorizeResponse = authorizeUtil.
				getRoleAuthorizationCheckByCookies(req, res, AuthorizeRoleEnum.INSERTUSER);
		
		if(!authUtil.getSessionObjectAuthentication(req, res)) {
//			res.getWriter().println("<h1>Log in first to use application (Super Admin Login Required)</h1>");
			RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
			req.setAttribute("message", "User not Logged In so forward to User Login Page");
			req.setAttribute("msgType", "error");
			dispatcher.forward(req, res);
		}
		
		else {
			// if User Role dont match with LoggedUserRole then redirect to Login Page
			if(!authorizeResponse.getStatus()) {
//				res.getWriter().println("<h1>"+authorizeResponse.getMessage()+"</h1>");
				req.setAttribute("message", "User not Logged In so forward to User Login Page");
				req.setAttribute("msgType", "error");
				RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
				dispatcher.forward(req, res);
			}
			
		String role = req.getParameter("role");
		Usertype userrole = null;
		
		for(Usertype u : Usertype.values()) {
			if(u.name().equalsIgnoreCase(role)) {
				userrole = u; 
				break;
			}
		}
		
		String fullName = req.getParameter("fullname");
		String uname = req.getParameter("username");
		String pw = req.getParameter("password");
		
		Users userobj = new Users(uname, userrole, pw,fullName);
		String response = userdao.createUser(userobj);
		
		// set MSG type as per the response  
		String msgType = response.equalsIgnoreCase("User Created") ? "success" : "error";
		req.setAttribute("msgType", msgType);
		req.setAttribute("message", response);
		req.getRequestDispatcher("CreateUser.jsp").forward(req, res);
		
//		res.setContentType("text/html");
//		PrintWriter out = res.getWriter();
//		out.println(msg);
	  }
   }
}
