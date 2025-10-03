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

@WebServlet("/fetchsinglestudent")
public class FetchSingleStudent extends HttpServlet {

	private final UserAuthenticationUtil authenticateUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
	private final UserAuthorizationValidUtil authorizeutil = UserAuthorizationValidUtil.getAuthorizationValidUtil();
	private final StudentDAO studentDAO = StudentDAO.getStudentDAO();

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		String redirectURL = req.getParameter("redirectURL");
		
		if (!authenticateUtil.getCookieAuthenticate(req, res)) {
			RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
//			res.setContentType("text/html");
//			res.getWriter().println("<h3> User not Logged In so forward to User Login Page </h3>");
			req.setAttribute("message", "User not Logged In so forward to User Login Page");
			req.setAttribute("msgType", "error");
			dispatcher.include(req, res);
			return;
		}

		UserResponseObject authorizeResponse = authorizeutil.getRoleAuthorizationCheckByCookies(req, res,
				AuthorizeRoleEnum.FETCHSTUDENT);

		if (!authorizeResponse.getStatus()) {
			RequestDispatcher dispatcher = req.getRequestDispatcher(redirectURL);
//			res.getWriter().println("<h1>" + authorizeResponse.getMessage() + "</h1>");
			req.setAttribute("authorizedMessage", authorizeResponse.getMessage());
			req.setAttribute("msgType", "error");
			dispatcher.include(req, res);
			return;
		}

		Integer id = Integer.parseInt(req.getParameter("studentid"));
		Student s = studentDAO.getSingleStudent(id);
		
		if (s == null) {
			req.setAttribute("message", "Student with id " + id + " not found in database");
			req.setAttribute("msgType", "error");
			RequestDispatcher dispatcher = req.getRequestDispatcher(redirectURL);
			dispatcher.forward(req, res);
			return;
		}

//		String response = "Name - " + s.getName() + 
//				" | DOB - " + s.getDOB() + 
//				" | Gender - " + s.getGender()+
//				" | Mobile - " + s.getMobileNumber() + 
//				" | Email - " + s.getEmail() + 
//				" | Aadhaar - "+ s.getAadhaarNumber() + 
//				" | 10th Marks - " + s.getTenthMark() +
//				" | 12th Marks - " + s.getTwelveMark() +  
//				" | Graduation Marks - "+ s.getGradMark() + 
//				" | Address - " + s.getAddress();

		req.setAttribute("student", s);
		RequestDispatcher dispatcher = req.getRequestDispatcher(redirectURL);
		dispatcher.forward(req, res);
	}
}
