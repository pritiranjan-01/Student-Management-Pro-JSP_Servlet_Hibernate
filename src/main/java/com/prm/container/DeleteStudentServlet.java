package com.prm.container;

import java.io.IOException;
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

@WebServlet("/deleteStudent")
public class DeleteStudentServlet extends HttpServlet{
	private final StudentDAO studentDAO = StudentDAO.getStudentDAO();
	private final UserAuthenticationUtil authenticateUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
	private final UserAuthorizationValidUtil authorizeutil = UserAuthorizationValidUtil.getAuthorizationValidUtil();
	
	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
        if (!authenticateUtil.getCookieAuthenticate(req, resp)) {
          RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
          req.setAttribute("message", "(Session Expired) \\nUser not Logged In so forward to User Login Page");
		  req.setAttribute("msgType", "error");
		  dispatcher.forward(req, resp);		
          return;
        }
		
		UserResponseObject authorizedUser = authorizeutil.
				getRoleAuthorizationCheckByCookies(req, resp, AuthorizeRoleEnum.DELETESTUDENT);
		
		if(!authorizedUser.getStatus()) {
	          req.setAttribute("message", authorizedUser.getMessage());
			  req.setAttribute("msgType", "warning");
			  RequestDispatcher dispatcher = req.getRequestDispatcher("ManageStudent.jsp");
			  dispatcher.forward(req, resp);
			  return;
		}
	
		Integer id = Integer.parseInt(req.getParameter("id"));
		Student s = studentDAO.getSingleStudent(id);
		
		if(s==null) {
			req.setAttribute("message", "Student not found");
			req.setAttribute("msgType", "error");
			RequestDispatcher dispatcher = req.getRequestDispatcher("ManageUsers.jsp");
			dispatcher.forward(req, resp);
			return;
		}
		
		studentDAO.deleteStudent(id);

		req.setAttribute("message", "Student deleted successfully!");
		req.setAttribute("msgType", "success");

		RequestDispatcher dispatcher = req.getRequestDispatcher("ManageStudent.jsp");
		dispatcher.forward(req, resp);
	}
}
