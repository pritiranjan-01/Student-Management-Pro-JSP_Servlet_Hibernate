<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.prm.entity.Student"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="jakarta.servlet.RequestDispatcher"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Student - Admin Dashboard</title>
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
    
    /* Mobile Navbar */
    .mobile-navbar {
      background: rgba(0, 0, 0, 0.9);
      padding: 15px 20px;
      position: sticky;
      top: 0;
      z-index: 1000;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    .mobile-navbar .navbar-content {
      display: flex;
      justify-content: space-between;
      align-items: center;
      width: 100%;
    }
    
    .mobile-navbar .navbar-brand {
      color: white;
      font-size: 1.2rem;
      font-weight: bold;
      margin: 0;
    }
    
    .mobile-navbar .btn-toggle {
      color: white;
      border: none;
      background: transparent;
      font-size: 1.5rem;
      padding: 0;
      line-height: 1;
      cursor: pointer;
    }
    
    /* Sidebar */
    .sidebar {
      background: rgba(0, 0, 0, 0.9);
      color: white;
      min-height: 100vh;
      padding-top: 20px;
      transition: all 0.3s;
      position: fixed;
      top: 0;
      left: 0;
      z-index: 1050;
      overflow-y: auto;
    }
    
    .sidebar h4 {
      padding: 0 20px;
      margin-bottom: 30px;
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
    
    .sidebar a:hover,
    .sidebar a.active {
      background: #0d6efd;
      color: #fff;
      transform: translateX(5px);
    }
    
    .sidebar .btn-close-sidebar {
      display: none;
      position: absolute;
      top: 15px;
      right: 15px;
      color: white;
      background: transparent;
      border: none;
      font-size: 1.5rem;
    }
    
    /* Overlay for mobile */
    .sidebar-overlay {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.5);
      z-index: 1040;
    }
    
    /* Main Content */
    .main-content {
      transition: margin-left 0.3s;
    }
    
    h2 {
      color: #0d6efd;
      margin-bottom: 20px;
      text-align: center;
      font-weight: 600;
    }
    
    .form-container {
      background: #fff;
      padding: 30px;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
      max-width: 700px;
      margin: 0 auto;
    }
    
    .form-label {
      font-weight: 600;
    }
    
    .btn-submit {
      background-color: #0d6efd;
      color: white;
      padding: 10px 30px;
      border: none;
      border-radius: 8px;
      transition: all 0.3s ease;
    }
    
    .btn-submit:hover {
      background-color: #0b5ed7;
      transform: translateY(-2px);
    }
    
    /* Desktop View */
    @media (min-width: 992px) {
      .mobile-navbar {
        display: none;
      }
      
      .sidebar {
        position: relative;
        width: 250px;
      }
      
      .main-content {
        margin-left: 0;
      }
    }
    
    /* Mobile/Tablet View */
    @media (max-width: 991px) {
      .sidebar {
        transform: translateX(-100%);
        width: 280px;
      }
      
      .sidebar.show {
        transform: translateX(0);
      }
      
      .sidebar .btn-close-sidebar {
        display: block;
      }
      
      .sidebar-overlay.show {
        display: block;
      }
      
      .main-content {
        margin-left: 0;
        width: 100%;
      }
      
      .form-container {
        padding: 20px;
      }
      
      h2 {
        font-size: 1.5rem;
      }
    }
    
    /* Small Mobile Adjustments */
    @media (max-width: 576px) {
      .sidebar {
        width: 100%;
      }
      
      .form-container {
        padding: 15px;
        margin: 10px;
        border-radius: 10px;
      }
      
      h2 {
        font-size: 1.3rem;
      }
      
      h5 {
        font-size: 1rem;
      }
      
      .btn-submit,
      .btn-danger {
        width: 100%;
        margin-bottom: 10px;
      }
      
      .text-center .btn {
        display: block;
        width: 100%;
      }
    }
  </style>
</head>
<body>
  <%-- Session Check --%>
  <%
    HttpSession var = request.getSession(false);
    if(var == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
   
    String role = (String)var.getAttribute("role");
    if (session == null || session.getAttribute("role") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    String profile="";
    if(role.equalsIgnoreCase("Admin")) profile = "bi bi-person-gear";
    else if(role.equalsIgnoreCase("HR")) profile= "bi-person-workspace";
    else if(role.equalsIgnoreCase("SuperAdmin")) profile= "bi bi-shield-lock";
    
    Student student = (Student) request.getAttribute("student");
  %>

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

  <!-- Mobile Navbar (only visible on mobile) -->
  <nav class="mobile-navbar d-lg-none">
    <div class="navbar-content">
      <span class="navbar-brand">
        <i class="<%=profile %>"></i> <%=role %>
      </span>
      <button class="btn-toggle" id="sidebarToggle">
        <i class="bi bi-list"></i>
      </button>
    </div>
  </nav>

  <!-- Sidebar Overlay (for mobile) -->
  <div class="sidebar-overlay" id="sidebarOverlay"></div>

  <div class="container-fluid">
    <div class="row flex-nowrap">
      <!-- Sidebar -->
      <nav class="col-lg-2 sidebar" id="sidebar">
        <button class="btn-close-sidebar" id="closeSidebar">
          <i class="bi bi-x-lg"></i>
        </button>
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
      </nav>

      <!-- Main Content -->
      <main class="col-lg-10 col-12 p-4 main-content">
        <div class="form-container">
          <h2>Update Student</h2>

          <% if(student == null) { %>
          <!-- Step 1: Enter Student ID -->
          <form action="fetchsinglestudent" method="get" class="searchForm">
            <div class="mb-3">
              <input type="hidden" value="UpdateStudent.jsp" name="redirectURL">
              <label class="form-label">Enter Student ID:</label>
              <input type="number" class="form-control" name="studentid" placeholder="Enter Student ID" required>
            </div>
            <div class="text-center">
              <button type="submit" class="btn btn-submit">
                <i class="bi bi-search"></i> Fetch Student
              </button>
            </div>
          </form>
          <% } else { %>
          <!-- Step 2: Show Update Form -->
          <form action="updatestudent" method="post" class="updateForm">
            <input type="hidden" name="id" value="<%=student.getId()%>">
            <input type="hidden" value="UpdateStudent.jsp" name="redirectURL">
            
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

            <h5 class="mt-4 mb-3">Academic Details</h5>
            
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
              <textarea class="form-control" id="address" name="address" rows="3" required><%=student.getAddress()%></textarea>
            </div>

            <div class="text-center mt-4">
              <button type="button" class="btn btn-danger cancel-btn">
                <i class="bi bi-x-circle"></i> Cancel
              </button>
              <button type="submit" class="btn btn-submit">
                <i class="bi bi-check-circle"></i> Update Student
              </button>
            </div>
          </form>
          <% } %>
        </div>
      </main>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script type="text/javascript">
    // Sidebar toggle functionality
    const sidebar = document.getElementById('sidebar');
    const sidebarOverlay = document.getElementById('sidebarOverlay');
    const sidebarToggle = document.getElementById('sidebarToggle');
    const closeSidebar = document.getElementById('closeSidebar');

    function openSidebar() {
      sidebar.classList.add('show');
      sidebarOverlay.classList.add('show');
      document.body.style.overflow = 'hidden';
    }

    function closeSidebarFunc() {
      sidebar.classList.remove('show');
      sidebarOverlay.classList.remove('show');
      document.body.style.overflow = '';
    }

    if (sidebarToggle) {
      sidebarToggle.addEventListener('click', openSidebar);
    }

    if (closeSidebar) {
      closeSidebar.addEventListener('click', closeSidebarFunc);
    }

    if (sidebarOverlay) {
      sidebarOverlay.addEventListener('click', closeSidebarFunc);
    }

    // Close sidebar when clicking on a link (mobile)
    const sidebarLinks = sidebar.querySelectorAll('a');
    sidebarLinks.forEach(link => {
      link.addEventListener('click', function() {
        if (window.innerWidth < 992) {
          closeSidebarFunc();
        }
      });
    });

    // Cancel button functionality
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