package com.prm.container;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet{
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Invalidate Session Object
		HttpSession session = req.getSession();
		session.invalidate();
		
		// Delete Cookies
		Cookie [] cookies = req.getCookies();
		if(cookies!=null) {
			for(Cookie cookie : cookies) {
				cookie.setMaxAge(0);  // Deleting the cookies by setiing the duration/life to 0.
				cookie.setPath("/");
				resp.addCookie(cookie);
			}
		}
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
//		resp.setContentType("text/html");
//		resp.getWriter().println("<h1>Logged Out Successfully</h1>");
		req.setAttribute("logoutMessage", "Logout Successful");
		dispatcher.include(req, resp);
 	}
}
