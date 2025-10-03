package com.prm.container;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import com.prm.dao.StudentDAO;
import com.prm.dao.UserDAO;
import com.prm.entity.AuthorizeRoleEnum;
import com.prm.entity.Student;
import com.prm.entity.Users;
import com.prm.entity.Usertype;
import com.prm.util.UserAuthenticationUtil;
import com.prm.util.UserAuthorizationValidUtil;
import com.prm.util.UserResponseObject;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/updateuser")
public class UpdateUser extends HttpServlet {

	private final UserDAO userdao = UserDAO.getUserDAO();
	private final UserAuthenticationUtil authenticateUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
	private final UserAuthorizationValidUtil authorizeutil = UserAuthorizationValidUtil.getAuthorizationValidUtil();
	
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
        if (!authenticateUtil.getCookieAuthenticate(req, resp)) {
          RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
          req.setAttribute("message", "(Session Expired) \\nUser not Logged In so forward to User Login Page");
		  req.setAttribute("msgType", "error");
		  dispatcher.forward(req, resp);		
          return;
        }
		
		UserResponseObject authorizedUser = authorizeutil.
				getRoleAuthorizationCheckByCookies(req, resp, AuthorizeRoleEnum.UPDATEUSER);
		
		if(!authorizedUser.getStatus()) {
	          req.setAttribute("message", authorizedUser.getMessage());
			  req.setAttribute("msgType", "warning");
			  RequestDispatcher dispatcher = req.getRequestDispatcher("ManageUsers.jsp");
			  dispatcher.forward(req, resp);
			  return;
		}

		String role = req.getParameter("userrole");
		Usertype userrole = null;
		
		for(Usertype u : Usertype.values()) {
			if(u.name().equalsIgnoreCase(role)) {
				userrole = u;
				break;
			}
		}
		
		Integer id = Integer.parseInt(req.getParameter("id"));
		String fullName = req.getParameter("fullname");
		String uname = req.getParameter("username");
		String pw = req.getParameter("password");
		
		Users userobj = new Users(id, uname, userrole, pw, fullName);
		userdao.updateUser(userobj);

		req.setAttribute("message", "User updated successfully");
		req.setAttribute("msgType", "success");
		RequestDispatcher dispatcher = req.getRequestDispatcher("ManageUsers.jsp");
		dispatcher.forward(req, resp);
	}
}
