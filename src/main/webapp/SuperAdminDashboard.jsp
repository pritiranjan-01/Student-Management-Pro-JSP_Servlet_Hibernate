<%@page import="com.prm.dao.UserLastLoginDTO"%>
<%@page import="java.util.List"%>
<%@page import="com.prm.dao.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Super Admin Dashboard - Management System</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
  <style>
    body {
      font-family: "Poppins", sans-serif;
      background: #f5f7fa;
      min-height: 100vh;
      color: #333;
    }
    .sidebar {
      min-height: 100vh;
      background: rgba(0, 0, 0, 0.9);
      color: white;
      padding-top: 20px;
    }
    .sidebar a {
      color: #ccc;
      display: block;
      padding: 14px 22px;
      margin: 10px 0;
      text-decoration: none;
      transition: all 0.3s ease;
      border-radius: 10px;
    }
    .sidebar a:hover,
    .sidebar a.active {
      background: #0d6efd;
      color: #fff;
      transform: translateX(5px);
    }
    .card {
      border-radius: 20px;
      background: #fff;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      transition: transform 0.2s ease-in-out;
    }
    .card:hover {
      transform: translateY(-5px);
    }
    .card h3 {
      font-weight: 700;
    }
    .stat-icon {
      font-size: 2rem;
      margin-bottom: 10px;
    }
    .recent-activity {
      background: #fff;
      border-radius: 15px;
      padding: 20px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .recent-activity ul {
      list-style: none;
      padding: 0;
    }
    .recent-activity li {
      padding: 10px 0;
      border-bottom: 1px solid #eee;
    }
    .recent-activity li:last-child {
      border-bottom: none;
    }
    .badge-role {
      font-size: 0.85rem;
      padding: 6px 10px;
      border-radius: 8px;
    }
    .quick-links {
      background: #fff;
      border-radius: 15px;
      padding: 20px;
      margin-top: 20px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
  </style>
</head>
<body>
  <div class="container-fluid">
    <div class="row">
      <!-- Sidebar -->
      <%
      HttpSession hs = request.getSession(false);
      String role = (String) hs.getAttribute("role");
      String fullName = (String) hs.getAttribute("fullname");
      if(role==null)  {
         request.setAttribute("logoutMessage", "Session Expired");
         response.sendRedirect("Login.jsp");
         return;
      }
	
      UserDAO userDAO = UserDAO.getUserDAO();
      long[] counts = userDAO.getUserCounts();
      
      long totalUsers = counts[0];
      long adminCount = counts[1];
      long hrCount =  counts[2];
      %>

      <div class="col-md-2 sidebar">
        <h4 class="text-center mb-4"><i class="bi bi-people-fill"></i> Super Admin</h4>
        <a href="SuperAdminDashboard.jsp" class="active"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="CreateUser.jsp"><i class="bi bi-person-plus"></i> Create User</a>
        <a href="ManageUsers.jsp"><i class="bi bi-people"></i> Manage Users</a>
        <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
      </div>

      <!-- Main Content -->
      <div class="col-md-10 p-4">
        <h2 class="text-black">Hi <span class="text-primary fw-bold"><%=fullName %></span>, Welcome Back 👋</h2>
        <hr />

        <!-- Stats Cards -->
        <div class="row g-4">
          <div class="col-md-4">
            <div class="card text-center p-4">
              <i class="bi bi-people-fill text-primary stat-icon"></i>
              <h5>Total Users</h5>
              <h3 class="text-primary"><%=totalUsers-1 %></h3>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card text-center p-4">
              <i class="bi bi-person-check-fill text-success stat-icon"></i>
              <h5>Admins</h5>
              <h3 class="text-success"><%=adminCount %></h3>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card text-center p-4">
              <i class="bi bi-person-badge-fill text-warning stat-icon"></i>
              <h5>HRs</h5>
              <h3 class="text-warning"><%=hrCount %></h3>
            </div>
          </div>
        </div>

        <!-- Last Login (Name-wise) -->
        <div class="recent-activity mt-5">
          <h5><i class="bi bi-clock-history"></i> Last Login by Users</h5>
          <ul class="mt-3">
          <%
  			List<UserLastLoginDTO> lastLogins = userDAO.getLastLoginDetails();
 			for(UserLastLoginDTO dto : lastLogins) {
		  %>
   			 <li>
   			   <b><%= dto.getFullName() %></b> 
   			   <span class="badge bg-info text-dark badge-role"><%= dto.getRole() %></span>
   			   <span class="float-end text-muted"><i class="bi bi-calendar-event"></i> <%= dto.getLastLogin() %></span>
   			 </li>
		  <%
 			}
		  %>
          </ul>
        </div>

        <!-- Quick Links -->
        <div class="quick-links mt-4">
          <h5><i class="bi bi-lightning-fill"></i> Quick Links</h5>
          <div class="d-flex flex-wrap gap-3 mt-2">
            <a href="CreateUser.jsp" class="btn btn-primary"><i class="bi bi-person-plus"></i> Add User</a>
            <a href="ManageUsers.jsp" class="btn btn-success"><i class="bi bi-people"></i> Manage Users</a>
            <a href="#" class="btn btn-warning"><i class="bi bi-bar-chart"></i> Reports</a>
            <a href="logout" class="btn btn-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
