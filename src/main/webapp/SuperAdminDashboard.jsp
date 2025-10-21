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
    
    /* Mobile Navbar */
    .mobile-navbar {
      background: rgba(0, 0, 0, 0.9);
      padding: 15px;
      position: sticky;
      top: 0;
      z-index: 1000;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    .mobile-navbar .navbar-brand {
      color: white;
      font-size: 1.2rem;
      font-weight: bold;
    }
    
    .mobile-navbar .btn-toggle {
      color: white;
      border: none;
      background: transparent;
      font-size: 1.5rem;
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
      color: #ccc;
      display: block;
      padding: 12px 20px;
      margin: 6px 0;
      text-decoration: none;
      border-radius: 10px;
      transition: all 0.3s ease;
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
    
    .card {
      border-radius: 20px;
      background: #fff;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      transition: transform 0.2s ease-in-out;
    }
    
    .card:hover {
      transform: translateY(-5px);
    }
    
    .stat-icon {
      font-size: 2rem;
      margin-bottom: 10px;
    }
    
    .recent-activity, .quick-links {
      background: #fff;
      border-radius: 15px;
      padding: 20px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    
    .recent-activity ul {
      list-style: none;
      padding: 0;
      margin: 0;
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
      padding: 5px 8px;
      border-radius: 8px;
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
      
      .stat-icon {
        font-size: 1.5rem;
      }
    }
    
    /* Small Mobile Adjustments */
    @media (max-width: 576px) {
      .sidebar {
        width: 100%;
      }
      
      .card {
        margin-bottom: 15px;
      }
      
      .recent-activity li {
        font-size: 0.9rem;
      }
      
      .quick-links .btn {
        width: 100%;
        margin-bottom: 10px;
      }
    }
  </style>
</head>
<body>
  <% 
  HttpSession hs = request.getSession(false);
  String role = (String) hs.getAttribute("role");
  String fullName = (String) hs.getAttribute("fullname");
  if(role == null) {
    request.setAttribute("logoutMessage", "Session Expired");
    response.sendRedirect("Login.jsp");
    return;
  }

  UserDAO userDAO = UserDAO.getUserDAO();
  long[] counts = userDAO.getUserCounts();
  long totalUsers = counts[0];
  long adminCount = counts[1];
  long hrCount = counts[2];
  %>

  <!-- Mobile Navbar (only visible on mobile) -->
  <nav class="mobile-navbar d-lg-none">
    <div class="d-flex justify-content-between align-items-center">
      <span class="navbar-brand">
        <i class="bi bi-people-fill"></i> Super Admin
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
        <h4 class="text-center mb-4"><i class="bi bi-people-fill"></i> Super Admin</h4>
        <a href="SuperAdminDashboard.jsp" class="active"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="CreateUser.jsp"><i class="bi bi-person-plus"></i> Create User</a>
        <a href="ManageUsers.jsp"><i class="bi bi-people"></i> Manage Users</a>
        <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
      </nav>

      <!-- Main Content -->
      <main class="col-lg-10 col-12 p-4 main-content">
        <h2 class="mb-3">Hi <span class="text-primary fw-bold"><%=fullName %></span>, Welcome Back 👋</h2>
        <hr />

        <!-- Stats Cards -->
        <div class="row g-4 mb-4">
          <div class="col-sm-6 col-md-4">
            <div class="card text-center p-4">
              <i class="bi bi-people-fill text-primary stat-icon"></i>
              <h5>Total Users</h5>
              <h3 class="text-primary"><%=totalUsers-1 %></h3>
            </div>
          </div>
          <div class="col-sm-6 col-md-4">
            <div class="card text-center p-4">
              <i class="bi bi-person-check-fill text-success stat-icon"></i>
              <h5>Admins</h5>
              <h3 class="text-success"><%=adminCount %></h3>
            </div>
          </div>
          <div class="col-sm-6 col-md-4">
            <div class="card text-center p-4">
              <i class="bi bi-person-badge-fill text-warning stat-icon"></i>
              <h5>HRs</h5>
              <h3 class="text-warning"><%=hrCount %></h3>
            </div>
          </div>
        </div>

        <!-- Last Login -->
        <div class="recent-activity mb-4">
          <h5><i class="bi bi-clock-history"></i> Last Login by Users</h5>
          <ul class="mt-3">
          <%
            List<UserLastLoginDTO> lastLogins = userDAO.getLastLoginDetails();
            for(UserLastLoginDTO dto : lastLogins) {
          %>
            <li class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center">
              <div class="mb-2 mb-md-0">
                <b><%= dto.getFullName() %></b> 
                <span class="badge bg-info text-dark badge-role"><%= dto.getRole() %></span>
              </div>
              <span class="text-muted"><i class="bi bi-calendar-event"></i> <%= dto.getLastLogin() %></span>
            </li>
          <%
            }
          %>
          </ul>
        </div>

        <!-- Quick Links -->
        <div class="quick-links">
          <h5><i class="bi bi-lightning-fill"></i> Quick Links</h5>
          <div class="d-flex flex-wrap gap-2 mt-3">
            <a href="CreateUser.jsp" class="btn btn-primary"><i class="bi bi-person-plus"></i> Add User</a>
            <a href="ManageUsers.jsp" class="btn btn-success"><i class="bi bi-people"></i> Manage Users</a>
            <a href="#" class="btn btn-warning"><i class="bi bi-bar-chart"></i> Reports</a>
            <a href="logout" class="btn btn-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
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