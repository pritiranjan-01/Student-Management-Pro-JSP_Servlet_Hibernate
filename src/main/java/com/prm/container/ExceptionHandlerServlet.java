package com.prm.container;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.GenericServlet;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/exception")
public class ExceptionHandlerServlet extends GenericServlet {

	@Override
	public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException {
		res.setContentType("text/html"); 
		System.out.println("Exception Handled");
		ServletContext context = getServletContext();
		String appVersion = (String) context.getAttribute("appVersion");
		String appName = (String) context.getAttribute("appName");
		String appTeamname = (String) context.getAttribute("appTeam");
		PrintWriter out = res.getWriter();
	    out.println("<h2> 505 - Internal Error occurred and Issue is going to fix soon</h2>"); 
	    out.println("<h4>"+appName +" "+appVersion+" "+appTeamname+"</h4>"); 
	    		
	}	
}
