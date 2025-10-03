package com.prm.container;

import java.io.IOException;
import java.net.http.HttpClient;
import java.util.List;

import com.prm.dao.StudentDAO;
import com.prm.entity.AuthorizeRoleEnum;
import com.prm.entity.Student;
import com.prm.util.UserAuthenticationUtil;
import com.prm.util.UserAuthorizationValidUtil;
import com.prm.util.UserResponseObject;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/fetchAllStudent")
public class FetchAllStudents extends HttpServlet{
	
    StudentDAO studentDAO = StudentDAO.getStudentDAO();
    UserAuthenticationUtil authenticateUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
    UserAuthorizationValidUtil authorizeutil = UserAuthorizationValidUtil.getAuthorizationValidUtil();

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
        if (!authenticateUtil.getCookieAuthenticate(req, resp)) {
          RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
          req.setAttribute("message", "User not Logged In so forward to User Login Page");
		  req.setAttribute("msgType", "error");
		  dispatcher.forward(req, resp);		
          return;
        }
		
		UserResponseObject authorizedUser = authorizeutil.
				getRoleAuthorizationCheckByCookies(req, resp, AuthorizeRoleEnum.FETCHSTUDENT);
		
		if(!authorizedUser.getStatus()) {
			RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
//			resp.getWriter().println("<h1>"+authorizedUser.getMessage()+"</h1>");
			req.setAttribute("message", authorizedUser.getMessage());
			req.setAttribute("msgType", "warning");	
			dispatcher.forward(req, resp);
			return;
		}
		
		resp.setContentType("text/html");
		List<Student> allStudent=studentDAO.getAllStudent();
		
		req.setAttribute("studentList", allStudent);
		RequestDispatcher rd = req.getRequestDispatcher("ManageStudent.jsp");
		rd.forward(req, resp);
	}
}
