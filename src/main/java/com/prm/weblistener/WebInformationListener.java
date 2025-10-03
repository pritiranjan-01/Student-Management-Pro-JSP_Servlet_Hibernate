package com.prm.weblistener;

import com.prm.dao.EntityProxy;
import com.prm.dao.UserDAO;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class WebInformationListener implements ServletContextListener {

	private static final UserDAO userDao = UserDAO.getUserDAO();
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		ServletContext context = sce.getServletContext();
		context.setAttribute("appVersion", "2.0.0");
		context.setAttribute("appName", "Student Management");
		context.setAttribute("appTeam", "qsp thunderstorm team");
		System.out.println("App info initialised");
		
		String superAdminResponse = userDao.addSuperAdmin();
		System.out.println(superAdminResponse);
	}
	
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("Context data destroyed");
		EntityProxy.closeConnection();
	}
}
