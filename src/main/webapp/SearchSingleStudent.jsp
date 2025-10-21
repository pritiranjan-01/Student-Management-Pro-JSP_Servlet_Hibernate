<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.prm.entity.Student" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Search Student - Student Management System</title>
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
    
    .card {
      border-radius: 20px;
      backdrop-filter: blur(20px);
      background: rgba(255, 255, 255, 0.85);
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
      transition: transform 0.2s ease-in-out;
    }
    
    .card:hover {
      transform: translateY(-5px);
    }
    
    .card h3, .card h5 {
      font-weight: 600;
    }
    
    hr {
      border: none;
      height: 2px;
      background-color: #ddd;
      border-radius: 2px;
      margin: 20px 0;
    }
    
    .search-form {
      margin-bottom: 0;
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
      
      .card {
        transform: none;
      }
      
      .card:hover {
        transform: none;
      }
    }
    
    /* Small Mobile Adjustments */
    @media (max-width: 576px) {
      .sidebar {
        width: 100%;
      }
      
      h2 {
        font-size: 1.5rem;
      }
      
      .card p {
        font-size: 0.9rem;
      }
      
      .search-form .row {
        margin: 0;
      }
      
      .search-form .col-md-8,
      .search-form .col-md-4 {
        padding: 0;
        margin-bottom: 10px;
      }
      
      .search-form .btn {
        width: 100%;
      }
    }
  </style>
</head>
<body>
  <%-- Session Check --%>
  <%
    HttpSession hs = request.getSession(false);
    String role = (String) hs.getAttribute("role");
    if(role==null)  {
      request.setAttribute("logoutMessage", "Session Expired");
      RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
      dispatcher.forward(request, response);
      return;
    }
    
    String profile="";
    if(role.equalsIgnoreCase("Admin")) profile = "bi bi-person-gear";
    else if (role.equalsIgnoreCase("HR")) profile= "bi-person-workspace";
    else if (role.equalsIgnoreCase("SuperAdmin")) profile= "bi-shield-lock";
  %>

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
        <a href="SearchSingleStudent.jsp" class="active"><i class="bi bi-search"></i> Search Student</a>
        <a href="UpdateStudent.jsp"><i class="bi bi-pencil-square"></i> Update Student</a>
        <a href="Settings.jsp"><i class="bi bi-gear"></i> Settings</a>
        <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
      </nav>

      <!-- Main Content -->
      <main class="col-lg-10 col-12 p-4 main-content">
        <h2 class="mb-3">Search Student 👨‍🎓</h2>
        <hr />

        <!-- Search Form -->
        <div class="card p-4 mb-4">
          <form class="search-form" method="get" action="fetchsinglestudent">
            <input type="hidden" value="SearchSingleStudent.jsp" name="redirectURL">
            <div class="row">
              <div class="col-md-8 mb-3 mb-md-0">
                <input type="text" name="studentid" class="form-control" placeholder="Enter Student ID" required />
              </div>
              <div class="col-md-4">
                <button type="submit" class="btn btn-primary w-100">
                  <i class="bi bi-search"></i> Search
                </button>
              </div>
            </div>
          </form>
        </div>

        <!-- Display Search Result -->
        <%
          Student s = (Student) request.getAttribute("student");
          if (s != null) {
        %>
        <div class="card p-4">
          <h5>Student Details:</h5>
          <hr />
          <div class="row">
            <div class="col-md-6 mb-2">
              <p><strong>ID:</strong> <%=s.getId()%></p>
            </div>
            <div class="col-md-6 mb-2">
              <p><strong>Name:</strong> <%=s.getName()%></p>
            </div>
            <div class="col-md-6 mb-2">
              <p><strong>Gender:</strong> <%=s.getGender()%></p>
            </div>
            <div class="col-md-6 mb-2">
              <p><strong>Email:</strong> <%=s.getEmail()%></p>
            </div>
            <div class="col-md-6 mb-2">
              <p><strong>Mobile Number:</strong> <%=s.getMobileNumber()%></p>
            </div>
            <div class="col-md-6 mb-2">
              <p><strong>Date of Birth:</strong> <%=s.getDOB()%></p>
            </div>
            <div class="col-md-6 mb-2">
              <p><strong>Matriculation (10th):</strong> <%=s.getTenthMark()%>%</p>
            </div>
            <div class="col-md-6 mb-2">
              <p><strong>Intermediate (12th):</strong> <%=s.getTwelveMark()%>%</p>
            </div>
            <div class="col-md-6 mb-2">
              <p><strong>Graduation:</strong> <%=s.getGradMark()%>%</p>
            </div>
            <div class="col-md-12 mb-2">
              <p><strong>Address:</strong> <%=s.getAddress()%></p>
            </div>
          </div>
        </div>
        <% } else if(request.getAttribute("message") != null) { %>
          <script type="text/javascript">
            Swal.fire({
              title: "Oops",
              text: "<%=request.getAttribute("message")%>",
              icon: "error",
              confirmButtonText: "OK",
              timer: 2000, 
              timerProgressBar: true,
            });
          </script>
        <% } else if(request.getAttribute("authorizedMessage") != null) { %>
          <script type="text/javascript">
            Swal.fire({
              title: "Warning",
              text: "<%=request.getAttribute("authorizedMessage")%>",
              icon: "warning",
              confirmButtonText: "OK",
              timer: 4000, 
              timerProgressBar: true,
            });
          </script>
        <%} %>
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