package com.prm.container;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.prm.dao.StudentDAO;
import com.prm.entity.Student;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/updatestudent")
public class UpdateStudent extends HttpServlet {

	private final StudentDAO studentdao = StudentDAO.getStudentDAO();

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		
		String redirectURL = req.getParameter("redirectURL");
		
		
		Integer id = Integer.parseInt(req.getParameter("id"));
		String name = req.getParameter("name");
		String dobStr = req.getParameter("dob"); 
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
		Student student = new Student(id, name, dob, gender, mobile, 
				email, aadhaar, tenthMark, twelveMark, gradMark, address);

		studentdao.updateStudent(student);

		req.setAttribute("message", "Student details updated successfully");
		req.setAttribute("msgType", "success");
		RequestDispatcher dispatcher = req.getRequestDispatcher(redirectURL);
		dispatcher.forward(req, res);
	}
}
