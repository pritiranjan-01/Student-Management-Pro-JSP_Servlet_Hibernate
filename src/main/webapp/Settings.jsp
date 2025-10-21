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
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Settings - Change Password</title>
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
    
    h1 {
      text-align: center;
      margin-bottom: 30px;
      font-weight: bold;
      color: #0d6efd;
    }
    
    .card {
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
      background: white;
    }
    
    .form-control:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 5px rgba(13,110,253,0.5);
    }
    
    .btn-primary {
      background-color: #0d6efd;
      border: none;
      padding: 12px;
      font-weight: 600;
      transition: all 0.3s ease;
    }
    
    .btn-primary:hover {
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
      
      h1 {
        font-size: 1.8rem;
      }
    }
    
    /* Small Mobile Adjustments */
    @media (max-width: 576px) {
      .sidebar {
        width: 100%;
      }
      
      h1 {
        font-size: 1.5rem;
      }
      
      .card {
        margin: 10px;
      }
      
      .col-md-6 {
        padding: 0 10px;
      }
    }
  </style>
</head>
<body>
  <%-- Session Check --%>
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

  <%-- SweetAlert Popup --%>
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
        <a href="UpdateStudent.jsp"><i class="bi bi-pencil-square"></i> Update Student</a>
        <a href="Settings.jsp" class="active"><i class="bi bi-gear"></i> Settings</a>
        <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
      </nav>

      <!-- Main Content -->
      <main class="col-lg-10 col-12 p-4 main-content">
        <h1><i class="bi bi-key"></i> Change Password</h1>
        
        <div class="row justify-content-center">
          <div class="col-md-6">
            <div class="card p-4">
              <form action="changePassword" method="post"> 
                <input type="hidden" value="<%=id%>" name="id">
                
                <div class="mb-3">
                  <label class="form-label">
                    <i class="bi bi-lock-fill text-primary"></i> New Password
                  </label>
                  <input type="password" class="form-control" name="newPassword" placeholder="Enter new password" required>
                </div>
                
                <div class="mb-3">
                  <label class="form-label">
                    <i class="bi bi-shield-lock-fill text-success"></i> Confirm New Password
                  </label>
                  <input type="password" class="form-control" name="confirmPassword" placeholder="Confirm new password" required>
                </div>
                
                <div class="d-grid mt-4">
                  <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-circle"></i> Update Password
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
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
  </script>
</body>
</html>