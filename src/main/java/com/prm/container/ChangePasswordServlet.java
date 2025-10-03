package com.prm.container;

import java.io.IOException;

import com.prm.dao.UserDAO;
import com.prm.entity.Users;
import com.prm.util.UserAuthenticationUtil;
import com.prm.util.UserAuthorizationValidUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {
	
	private final UserDAO userDao = UserDAO.getUserDAO();
	private final UserAuthenticationUtil authenticateUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
	private final UserAuthorizationValidUtil authorizeutil = UserAuthorizationValidUtil.getAuthorizationValidUtil();
	
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (!authenticateUtil.getCookieAuthenticate(req, resp)) {
	          RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
	          req.setAttribute("message", "(Session Expired) \\nUser not Logged In so forward to User Login Page");
			  req.setAttribute("msgType", "error");
			  dispatcher.forward(req, resp);		
	          return;
	        }

        Integer userId = Integer.parseInt(req.getParameter("id"));
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        Users user = userDao.getUserbyId(userId);

        if (user == null) {
            req.setAttribute("message", "User not found!");
            req.setAttribute("msgType", "error");
        } else if (newPassword.length()==0 || confirmPassword.length()==0) {
        	 req.setAttribute("message", "New Password Cant be empty");
             req.setAttribute("msgType", "error");	
        } else if (user.getPassword().equals(newPassword)) {
            req.setAttribute("message", "New Password Cant be same as Old Password");
            req.setAttribute("msgType", "error");
        } else if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("message", "New Passwords & Confirm Password must be same");
            req.setAttribute("msgType", "warning");
        } else {
            user.setPassword(newPassword);
            userDao.updateUser(user);

            req.setAttribute("message", "Password changed successfully!");
            req.setAttribute("msgType", "success");
        }

        req.getRequestDispatcher("Settings.jsp").forward(req, resp);
		
	}
}
