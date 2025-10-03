<%@page import="com.prm.entity.Users"%>
<%@page import="com.prm.dao.UserDAO"%>
<%@page import="jakarta.servlet.RequestDispatcher"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page import="com.prm.util.UserAuthenticationUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Settings - Change Password</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <style>
    body {
      font-family: "Poppins", sans-serif;
      background: #f5f7fa;
      min-height: 100vh;
      color: #333;
    }
    .sidebar {
      height: 100vh;
      background: rgba(0, 0, 0, 0.9);
      color: white;
      padding-top: 20px;
    }
    .sidebar a {
      color: #ddd;
      display: block;
      padding: 14px 22px;
      margin: 10px 0;
      text-decoration: none;
      transition: all 0.3s ease;
      border-radius: 10px;
    }
    .sidebar a:hover, .sidebar a.active {
      background: #0d6efd;
      color: #fff;
      transform: translateX(5px);
    }
    h1 {
      text-align: center;
      margin-bottom: 20px;
      font-weight: bold;
      color: #0d6efd;
    }
    .card {
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .form-control:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 5px rgba(13,110,253,0.5);
    }
  </style>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <!-- 🔹 Sidebar -->
      <%
         HttpSession var = request.getSession(false);
         String role = (String)var.getAttribute("role");
         Integer id = (Integer)var.getAttribute("id");
         if(role==null)  {
        	 request.setAttribute("logoutMessage", "Session Expired");
        	 RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
        	 dispatcher.forward(request, response);
        	 return;
         }
         
         String profile="";
         if(role.equalsIgnoreCase("Admin")) profile = "bi bi-person-gear";
         else if (role.equalsIgnoreCase("HR")) profile= "bi-person-workspace";
        %>
    <div class="col-md-2 sidebar">
      <h4 class="text-center mb-4"><i class="<%=profile %>"></i>  <%=role %></h4>
      <a href="UsersDashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
     <!-- Not Show Create Student Link  for HR-->
       <% if (!role.equalsIgnoreCase("HR")) { %>
  			<a href="CreateStudent.jsp"><i class="bi bi-person-plus"></i> Create Student</a>
	   <% } %>     
	  <a href="ManageStudent.jsp"><i class="bi bi-people"></i> Manage Students</a>
      <a href="SearchSingleStudent.jsp"><i class="bi bi-search"></i> Search Student</a>
      <a href="UpdateStudent.jsp"><i class="bi bi-pencil-square"></i> Update Student</a>
      <a href="Settings.jsp" class="active"><i class="bi bi-gear"></i> Settings</a>
      <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
    </div>

    <!-- 🔹 Main Content -->
    <div class="col-md-10 p-4">
      <h1>Change Password</h1>
      <div class="row justify-content-center">
        <div class="col-md-6">
          <div class="card p-4">
            <form action="changePassword" method="post"> 
                <input type="hidden" value="<%=id%>" name="id">
              <div class="mb-3">
                <label class="form-label">New Password</label>
                <input type="password" class="form-control" name="newPassword" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Confirm New Password</label>
                <input type="password" class="form-control" name="confirmPassword" required>
              </div>
              <div class="d-grid">
                <button type="submit" class="btn btn-primary">Update Password</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 🔹 SweetAlert Popup -->
<%
	String msg = (String)request.getAttribute("message");
	String type = (String)request.getAttribute("msgType");
	
	if (msg != null && type != null) { 
       	String icon = "info"; 
       	String title = "Notice";
      	if("success".equals(type)) { icon = "success"; title = "Success!"; }
       	else if("error".equals(type)) { icon = "error"; title = "Oops!"; }
       	else if("warning".equals(type)) { icon = "warning"; title = "Warning!"; }
%>
<script>
Swal.fire({
	title: "<%= title %>",
	text: "<%= msg %>",
	icon: "<%= icon %>",
	confirmButtonText: "OK",
	timer: 4000,
	timerProgressBar: true,
	allowOutsideClick: false
});
</script>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
