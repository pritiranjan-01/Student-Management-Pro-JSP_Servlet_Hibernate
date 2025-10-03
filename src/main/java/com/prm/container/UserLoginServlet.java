package com.prm.container;

import java.io.IOException;
import java.io.PrintWriter;

import com.prm.dao.UserDAO;
import com.prm.entity.Users;
import com.prm.util.UserAuthenticationUtil;
import com.prm.util.UserResponseObject;

import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.GenericServlet;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class UserLoginServlet extends HttpServlet {
	
	private final UserAuthenticationUtil userAuthenticateUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	
		UserResponseObject loginResponse = userAuthenticateUtil.
				getUsernameAndPasswordAuthenticate(req, resp);
		
		if(loginResponse.getStatus()) {
			HttpSession session = req.getSession(false);
			String role =(String)session.getAttribute("role");
			if("SUPERADMIN".equalsIgnoreCase(role)) {
			     resp.sendRedirect("SuperAdminDashboard.jsp");
			     return;
			} else {
			     resp.sendRedirect("UsersDashboard.jsp");
			     return;
			}
		}
		else {
			req.setAttribute("message", loginResponse.getMessage());
			RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
			dispatcher.include(req, resp);
		}
	}
}
