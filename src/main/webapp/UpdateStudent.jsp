<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.prm.entity.Student"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="jakarta.servlet.RequestDispatcher"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Update Student</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <style>
    body { font-family: "Poppins", sans-serif; background: #f5f7fa; min-height: 100vh; color: #333; }
    .sidebar { min-height: 100vh; background: rgba(0, 0, 0, 0.9); color: white; padding-top: 20px; }
    .sidebar a { color: #ddd; display: block; padding: 14px 22px; margin: 10px 0; text-decoration: none; transition: all 0.3s ease; border-radius: 10px; }
    .sidebar a:hover, .sidebar a.active { background: #0d6efd; color: #fff; transform: translateX(5px); }   
    h2 { color: #0d6efd; margin-bottom: 20px; text-align: center; }
    .form-container { background: #fff; padding: 30px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    .form-label { font-weight: 600; }
    .btn-submit { background-color: #0d6efd; color: white; }
    .btn-submit:hover { background-color: #0b5ed7; }
  </style>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <!-- Sidebar -->
    <%
      HttpSession var = request.getSession(false);
      if(var == null) {
          response.sendRedirect("Login.jsp");
          return;
      }
     
      String role = (String)var.getAttribute("role");
      // If role is null then might be HttpSession Objet destroyed/ invalidated so to avoid, Login again
      if (session == null || session.getAttribute("role") == null) {
    	    response.sendRedirect("Login.jsp");
    	    return;
    	}
      
      String profile="";
      if(role.equalsIgnoreCase("Admin")) profile = "bi bi-person-gear";
      else if(role.equalsIgnoreCase("HR")) profile= "bi-person-workspace";
      else if(role.equalsIgnoreCase("SuperAdmin")) profile= "bi bi-shield-lock";
      
      Student student = (Student) 
    		  request.getAttribute("student");
    %>
    <div class="col-md-2 sidebar">
      <h4 class="text-center mb-4"><i class="<%=profile %>"></i> <%=role %></h4>
      <a href="UsersDashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
      <% if (!role.equalsIgnoreCase("HR")) { %>
          <a href="CreateStudent.jsp"><i class="bi bi-person-plus"></i> Create Student</a>
      <% } %>
      <a href="ManageStudent.jsp"><i class="bi bi-people"></i> Manage Students</a>  
      <a href="SearchSingleStudent.jsp"><i class="bi bi-search"></i> Search Student</a>
      <a href="UpdateStudent.jsp" class="active"><i class="bi bi-pencil-square"></i> Update Student</a>
      <a href="Settings.jsp"><i class="bi bi-gear"></i> Settings</a>
      <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
    </div>

    <!-- Main Content -->
    <div class="col-md-10 p-4">
      <div class="form-container mx-auto" style="max-width: 700px;">
        <h2>Update Student</h2>

        <% if(student == null) { %>
        <!-- Step 1: Enter Student ID -->
        <form action="fetchsinglestudent" method="get" class ="searchForm">
          <div class="mb-3">
            <input type="hidden" value="UpdateStudent.jsp" name ="redirectURL">
            <label class="form-label">Enter Student ID:</label>
            <input type="number" class="form-control" name="studentid" required>
          </div>
          <div class="text-center">
            <button type="submit" class="btn btn-submit">Fetch Student</button>
          </div>
        </form>
        <% } else { %>
        <!-- Step 2: Show Update Form -->
        <form action="updatestudent" method="post" class ="updateForm">
          <input type="hidden" name="id" value="<%=student.getId()%>">
          <input type="hidden" value="UpdateStudent.jsp" name ="redirectURL">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="name" class="form-label">Full Name:</label>
              <input type="text" class="form-control" id="name" name="name" value="<%=student.getName()%>" required>
            </div>
            <div class="col-md-6 mb-3">
              <label for="dob" class="form-label">Date of Birth:</label>
              <input type="date" class="form-control" id="dob" name="dob" value="<%=student.getDOB()%>" required>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="gender" class="form-label">Gender:</label>
              <select class="form-select" id="gender" name="gender" required>
                <option value="Male" <%= "Male".equals(student.getGender()) ? "selected" : "" %>>Male</option>
                <option value="Female" <%= "Female".equals(student.getGender()) ? "selected" : "" %>>Female</option>
              </select>
            </div>
            <div class="col-md-6 mb-3">
              <label for="mobile" class="form-label">Mobile Number:</label>
              <input type="number" class="form-control" id="mobile" name="mobileNumber" value="<%=student.getMobileNumber()%>" required>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="email" class="form-label">Email:</label>
              <input type="email" class="form-control" id="email" name="email" value="<%=student.getEmail()%>" required>
            </div>
            <div class="col-md-6 mb-3">
              <label for="aadhaar" class="form-label">Aadhaar Number:</label>
              <input type="number" class="form-control" id="aadhaar" name="aadhaarNumber" value="<%=student.getAadhaarNumber()%>" required>
            </div>
          </div>

          <h5 class="mt-4">Academic Details</h5>
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="tenthMark" class="form-label">10th Marks (%):</label>
              <input type="number" step="0.01" class="form-control" id="tenthMark" name="tenthMark" value="<%=student.getTenthMark()%>" required>
            </div>
            <div class="col-md-6 mb-3">
              <label for="twelveMark" class="form-label">12th Marks (%):</label>
              <input type="number" step="0.01" class="form-control" id="twelveMark" name="twelveMark" value="<%=student.getTwelveMark()%>" required>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="gradMark" class="form-label">Graduation Marks (%):</label>
              <input type="number" step="0.01" class="form-control" id="gradMark" name="gradMark" value="<%=student.getGradMark()%>" required>
            </div>
          </div>

          <div class="mb-3">
            <label for="address" class="form-label">Address:</label>
            <textarea class="form-control" id="address" name="address" rows="2" required><%=student.getAddress()%></textarea>
          </div>

          <div class="text-center">
            <button type="button" class="btn btn-danger cancel-btn">Cancel</button>
            <button type="submit" class="btn btn-submit">Update Student</button>
          </div>
        </form>
        <% } %>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<%-- SweetAlert --%>
<%
  String msg = (String) request.getAttribute("message");
  String type = (String) request.getAttribute("msgType");
  String title = "Notice";
  String icon = "info"; 
  if (msg != null && type != null) { 
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
    timerProgressBar: true
  });
</script>
<% } %>

 <script type="text/javascript">
 	const updateForm = document.querySelector(".updateForm");  
 	if(updateForm){
		const cancelBtn = document.querySelector(".cancel-btn");
		cancelBtn.addEventListener("click", () => {
	  	window.location.href = "UpdateStudent.jsp";
	   });
 	}
</script>
</body>
</html>
