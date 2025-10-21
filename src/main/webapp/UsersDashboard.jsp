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
    
    .card {
      border-radius: 20px;
      backdrop-filter: blur(20px);
      background: rgba(255,255,255,0.85);
      box-shadow: 0 8px 20px rgba(0,0,0,0.15);
      transition: transform 0.2s ease-in-out;
    }
    
    .card:hover {
      transform: translateY(-5px);
    }
    
    .card h3 {
      font-weight: 600;
    }
    
    .recent-activity, .quick-links, .recent-students {
      background: rgba(255,255,255,0.9);
      border-radius: 15px;
      padding: 20px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    
    .recent-students ul {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    
    .recent-students li {
      padding: 10px 0;
      border-bottom: 1px solid #eee;
    }
    
    .recent-students li:last-child {
      border-bottom: none;
    }
    
    hr {
      border: none;
      height: 2px;
      background-color: #ddd;
      border-radius: 2px;
      margin: 20px 0;
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
      
      .card h3 {
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
      
      .card h5 {
        font-size: 0.9rem;
      }
      
      .card h3 {
        font-size: 1.3rem;
      }
      
      .recent-students li {
        font-size: 0.85rem;
      }
      
      .quick-links .btn {
        width: 100%;
        margin-bottom: 10px;
      }
      
      .quick-links .d-flex {
        flex-direction: column;
      }
    }
  </style>
</head>
<body>
  <%-- Session and Data Setup --%>
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

  <!-- Mobile Navbar (only visible on mobile) -->
  <nav class="mobile-navbar d-lg-none">
    <div class="navbar-content">
      <span class="navbar-brand">
        <i class="<%=profileIcon %>"></i> <%=role %>
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
      </nav>

      <!-- Main Content -->
      <main class="col-lg-10 col-12 p-4 main-content">
        <h2 class="mb-3">Welcome, <span class="text-danger"><%=fullName %></span> 👋</h2>
        <hr />

        <!-- Stats Cards -->
        <div class="row g-4 mt-2">
          <div class="col-sm-6 col-md-3">
            <div class="card text-center p-3">
              <h5>Total Students</h5>
              <h3 class="text-primary"><%=totalStudents %></h3>
            </div>
          </div>
          <div class="col-sm-6 col-md-3">
            <div class="card text-center p-3">
              <h5>Male Students</h5>
              <h3 class="text-info"><%=maleStudents %></h3>
            </div>
          </div>
          <div class="col-sm-6 col-md-3">
            <div class="card text-center p-3">
              <h5>Female Students</h5>
              <h3 class="text-warning"><%=femaleStudents %></h3>
            </div>
          </div>
          <div class="col-sm-6 col-md-3">
            <div class="card text-center p-3">
              <h5>Avg Graduation Mark</h5>
              <h3 class="text-success"><%=String.format("%.2f", avgGradMark) %></h3>
            </div>
          </div>
        </div>

        <!-- Recent Students -->
        <div class="recent-students mt-4">
          <h5><i class="bi bi-people-fill"></i> Recent Students</h5>
          <ul class="mt-3">
          <%
            for(Student s : recentStudents) {
          %>
            <li>
              <b><%=s.getName()%></b> → 
              DOB: <%=s.getDOB()%>, 
              Email: <%=s.getEmail()%>, 
              Grad Mark: <%=s.getGradMark()%>
            </li>
          <%
            }
          %>
          </ul>
        </div>

        <!-- Quick Links -->
        <div class="quick-links mt-4">
          <h5><i class="bi bi-lightning-fill"></i> Quick Links</h5>
          <div class="d-flex flex-wrap gap-3 mt-3">
            <% if (!role.equalsIgnoreCase("HR")) { %>
              <a href="CreateStudent.jsp" class="btn btn-primary"><i class="bi bi-person-plus"></i> Add Student</a>
            <% } %>
            <a href="ManageStudent.jsp" class="btn btn-success"><i class="bi bi-people"></i> Manage Students</a>
            <a href="SearchSingleStudent.jsp" class="btn btn-warning"><i class="bi bi-search"></i> Search Student</a>
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