<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.prm.dao.StudentDAO"%>
<%@ page import="com.prm.entity.Student"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Admin Dashboard - Student Management System</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
  <style>
    body { font-family: "Poppins", sans-serif; background: #f5f7fa; min-height: 100vh; color: #333; }
    .sidebar { height: 100vh; background: rgba(0, 0, 0, 0.9); color: white; padding-top: 20px; }
    .sidebar a { color: #ddd; display: block; padding: 14px 22px; margin: 10px 0; text-decoration: none; transition: all 0.3s ease; border-radius: 10px; }
    .sidebar a:hover, .sidebar a.active { background: #0d6efd; color: #fff; transform: translateX(5px); }
    .card { border-radius: 20px; backdrop-filter: blur(20px); background: rgba(255,255,255,0.85); box-shadow: 0 8px 20px rgba(0,0,0,0.15); transition: transform 0.2s ease-in-out; }
    .card:hover { transform: translateY(-5px); }
    .card h3 { font-weight: 600; }
    .recent-activity, .quick-links, .recent-students { background: rgba(255,255,255,0.9); border-radius: 15px; padding: 20px; margin-top: 20px; }
    hr { border: none; height: 2px; background-color: black; border-radius: 2px; margin: 20px 0; }
  </style>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <%-- Sidebar --%>
    <%
      HttpSession hs = request.getSession(false);
      String role = (String) hs.getAttribute("role");
      String fullName = (String) hs.getAttribute("fullname");
      if(role==null)  {
          request.setAttribute("logoutMessage", "Session Expired");
          request.getRequestDispatcher("Login.jsp").forward(request, response);
          return;
      }

      String profileIcon = "";
      if(role.equalsIgnoreCase("Admin")) profileIcon = "bi bi-person-gear";
      else if(role.equalsIgnoreCase("HR")) profileIcon= "bi-person-workspace";

      // DAO instance
      StudentDAO studentDAO = StudentDAO.getStudentDAO();

      // Stats
      long totalStudents = studentDAO.getTotalStudents();
      long maleStudents = studentDAO.getMaleCount();
      long femaleStudents = studentDAO.getFemaleCount();
      double avgGradMark = studentDAO.getAverageGradMark();

      // Recent students
      List<Student> recentStudents = studentDAO.getRecentStudents(5);
    %>

    <div class="col-md-2 sidebar">
      <h4 class="text-center mb-4"><i class="<%=profileIcon %>"></i> <%=role %></h4>
      <a href="UsersDashboard.jsp" class="active"><i class="bi bi-speedometer2"></i> Dashboard</a>
      <% if (!role.equalsIgnoreCase("HR")) { %>
          <a href="CreateStudent.jsp"><i class="bi bi-person-plus"></i> Create Student</a>
      <% } %>
      <a href="ManageStudent.jsp"><i class="bi bi-people"></i> Manage Students</a>
      <a href="SearchSingleStudent.jsp"><i class="bi bi-search"></i> Search Student</a>
      <a href="UpdateStudent.jsp"><i class="bi bi-pencil-square"></i> Update Student</a>
      <a href="Settings.jsp"><i class="bi bi-gear"></i> Settings</a>
      <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
    </div>

    <%-- Main Content --%>
    <div class="col-md-10 p-4">
      <h2 class="text-black">Welcome, <span class="text-danger"><%=fullName %></span> 👋</h2>
      <hr />

      <%-- Stats Cards --%>
      <div class="row mt-4">
        <div class="col-md-3 mb-3">
          <div class="card text-center p-3">
            <h5>Total Students</h5>
            <h3 class="text-primary"><%=totalStudents %></h3>
          </div>
        </div>
        <div class="col-md-3 mb-3">
          <div class="card text-center p-3">
            <h5>Male Students</h5>
            <h3 class="text-info"><%=maleStudents %></h3>
          </div>
        </div>
        <div class="col-md-3 mb-3">
          <div class="card text-center p-3">
            <h5>Female Students</h5>
            <h3 class="text-warning"><%=femaleStudents %></h3>
          </div>
        </div>
        <div class="col-md-3 mb-3">
          <div class="card text-center p-3">
            <h5>Avg Graduation Mark</h5>
            <h3 class="text-success"><%=String.format("%.2f", avgGradMark) %></h3>
          </div>
        </div>
      </div>

      <%-- Recent Students --%>
      <div class="recent-students mt-4">
        <h5><i class="bi bi-people-fill"></i> Recent Students</h5>
        <ul>
        <%
          for(Student s : recentStudents) {
        %>
          <li><b><%=s.getName()%></b> → DOB: <%=s.getDOB()%>, Email: <%=s.getEmail()%>, Grad Mark: <%=s.getGradMark()%></li>
        <%
          }
        %>
        </ul>
      </div>

      <%-- Quick Links --%>
      <div class="quick-links mt-4">
        <h5><i class="bi bi-lightning-fill"></i> Quick Links</h5>
        <div class="d-flex flex-wrap gap-3 mt-2">
          <% if (!role.equalsIgnoreCase("HR")) { %>
            <a href="CreateStudent.jsp" class="btn btn-primary"><i class="bi bi-person-plus"></i> Add Student</a>
          <% } %>
          <a href="ManageStudent.jsp" class="btn btn-success"><i class="bi bi-people"></i> Manage Students</a>
          <a href="SearchSingleStudent.jsp" class="btn btn-warning"><i class="bi bi-search"></i> Search Student</a>
          <a href="logout" class="btn btn-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>
