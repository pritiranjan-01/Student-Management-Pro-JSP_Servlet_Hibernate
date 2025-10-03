package com.prm.container;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Map;

import com.prm.dao.StudentDAO;
import com.prm.entity.AuthorizeRoleEnum;
import com.prm.entity.Student;
import com.prm.util.UserAuthorizationValidUtil;
import com.prm.util.UserAuthenticationUtil;
import com.prm.util.UserResponseObject;

import jakarta.servlet.GenericServlet;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/savestudent")
public class SaveStudentServlet extends HttpServlet {

	private final StudentDAO studentdao = StudentDAO.getStudentDAO();
	private final UserAuthenticationUtil authenticateUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
	private final UserAuthorizationValidUtil authorizeutil = UserAuthorizationValidUtil.getAuthorizationValidUtil();

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

		UserResponseObject autherizeRoleResponseObject = authorizeutil.getRoleAuthorizationCheckByCookies(req, res,
				AuthorizeRoleEnum.INSERTSTUDENT);

		if (!authenticateUtil.getCookieAuthenticate(req, res)) {
			RequestDispatcher dispatcher = req.getRequestDispatcher("Login.jsp");
//			res.setContentType("text/html");
//			res.getWriter().println("<h3> User not Logged In so forward to User Login Page </h3>");
			req.setAttribute("message", "User not Logged In so forward to User Login Page");
			req.setAttribute("msgType", "error");
			dispatcher.forward(req, res);
		} else {
			// If user is loggined but Current Role Dont match to do this operation
			if (!autherizeRoleResponseObject.getStatus()) {
				RequestDispatcher dispatcher = req.getRequestDispatcher("CreateStudent.jsp");
//				res.setContentType("text/html");
//				res.getWriter().println("<h3>"+autherizeRoleResponseObject.getMessage() +"</h3>");
				req.setAttribute("message", autherizeRoleResponseObject.getMessage());
				req.setAttribute("msgType", "warning");
				dispatcher.forward(req, res);
				return;
			}

			try {
				String name = req.getParameter("name");
				String dobStr = req.getParameter("DOB"); 
				System.out.println(dobStr);
				LocalDate dob = LocalDate.parse(dobStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));

				String gender = req.getParameter("gender");
				Long mobile = Long.parseLong(req.getParameter("mobileNumber"));
				String email = req.getParameter("email");
				Long aadhaar = Long.parseLong(req.getParameter("aadhaarNumber"));

				Double tenthMark = Double.parseDouble(req.getParameter("tenthMark"));

				Double twelveMark = Double.parseDouble(req.getParameter("twelveMark"));

				Double gradMark = Double.parseDouble(req.getParameter("gradMark"));

				String address = req.getParameter("address");

				// Create Student object
				Student student = new Student(name, dob, gender, mobile, 
						email, aadhaar, tenthMark, twelveMark, gradMark, address);

				String response = studentdao.saveStudent(student);
				System.out.println(response);

				req.setAttribute("message", response);
				req.setAttribute("msgType", "success");
				RequestDispatcher dispatcher = req.getRequestDispatcher("CreateStudent.jsp");
				dispatcher.forward(req, res);

			} catch (Exception e) {
				RequestDispatcher dispatcher = req.getRequestDispatcher("exception");
				dispatcher.forward(req, res);
			}
		}
	}
}