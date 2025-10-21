<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Create User - SuperAdmin Dashboard</title>
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
    
    .form-container {
      max-width: 700px;
      margin: 20px auto;
      background: rgba(255, 255, 255, 0.95);
      padding: 30px;
      border-radius: 20px;
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
    }
    
    .form-container h2 {
      text-align: center;
      margin-bottom: 25px;
      font-weight: 600;
    }
    
    .btn-custom {
      background: #0d6efd;
      color: white;
      border-radius: 10px;
      padding: 10px 20px;
      transition: all 0.3s ease;
      border: none;
    }
    
    .btn-custom:hover {
      background: #0b5ed7;
      transform: translateY(-2px);
    }
    
    .btn-custom:disabled {
      background: #6c757d;
      cursor: not-allowed;
      transform: none;
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
        margin: 15px;
      }
      
      .form-container h2 {
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
        border-radius: 15px;
      }
      
      .form-container h2 {
        font-size: 1.3rem;
      }
      
      .btn-custom,
      .btn-secondary {
        width: 100%;
        margin-bottom: 10px;
      }
      
      .d-flex.justify-content-between {
        flex-direction: column;
      }
    }
  </style>
</head>
<body>
  <%
    HttpSession hs = request.getSession(false);
    String role = (String) hs.getAttribute("role");
    if(role==null)  {
      request.setAttribute("logoutMessage", "Session Expired");
      RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
      dispatcher.forward(request, response);
      return;
    }
  %>

  <!-- Mobile Navbar (only visible on mobile) -->
  <nav class="mobile-navbar d-lg-none">
    <div class="navbar-content">
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
        <a href="SuperAdminDashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="CreateUser.jsp" class="active"><i class="bi bi-person-add"></i> Create User</a>
        <a href="ManageUsers.jsp"><i class="bi bi-people-fill"></i> Manage Users</a>
        <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
      </nav>

      <!-- Main Content -->
      <main class="col-lg-10 col-12 p-4 main-content">
        <h2 class="text-black mb-3">User Registration</h2>
        <hr/>

        <!-- Create User Form -->
        <div class="form-container">
          <h2><i class="bi bi-person-plus"></i> Create User</h2>
          <form action="createuser" method="post">
            
            <!-- Role -->
            <div class="mb-3">
              <label for="role" class="form-label">Role</label>
              <select class="form-select" id="role" name="role" required>
                <option value="" disabled selected>Select Role</option>
                <option value="Admin">Admin</option>
                <option value="HR">HR</option>
              </select>
            </div>
            
            <!-- Full Name -->
            <div class="mb-3">
              <label for="fullname" class="form-label">Full Name</label>
              <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Enter full name" required />
            </div>

            <!-- Username -->
            <div class="mb-3">
              <label for="username" class="form-label">Username</label>
              <input type="text" class="form-control" id="username" name="username" placeholder="Enter username (min 3 chars)" required />
              <small class="text-muted">Minimum 3 characters required</small>
            </div>

            <!-- Password -->
            <div class="mb-3">
              <label for="password" class="form-label">Password</label>
              <input type="password" class="form-control" id="password" name="password" placeholder="Enter password (min 4 chars)" required />
              <small class="text-muted">Minimum 4 characters required</small>
            </div>

            <!-- Buttons -->
            <div class="d-flex justify-content-between mt-4">
              <button type="submit" class="btn btn-custom" id="submit"><i class="bi bi-check-circle"></i> Create</button>
              <button type="reset" class="btn btn-secondary"><i class="bi bi-arrow-counterclockwise"></i> Reset</button>
            </div>
          </form>
        </div>
      </main>
    </div>
  </div>
  
  <%-- Response from Servlet --%>
  <%
    String msg = (String) request.getAttribute("message");
    String type = (String) request.getAttribute("msgType");
    if (msg != null && type != null) { 
        String icon = "info"; // default
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

    // Form validation
    const username = document.getElementById("username");
    const password = document.getElementById("password");
    const submitBtn = document.getElementById("submit");
    submitBtn.disabled = true;

    username.addEventListener("input", () => {
      validateInput(username, 3);
      toggleSubmit();
    });

    password.addEventListener("input", () => {
      validateInput(password, 4);
      toggleSubmit();
    });

    function toggleSubmit() {
      const isUsernameValid = (username.value.length) >= 3;
      const isPasswordValid = (password.value.length) >= 4;
      
      submitBtn.disabled = !(isUsernameValid && isPasswordValid);
    }

    function validateInput(inputElement, minLength) {
      if(inputElement.value.length === 0){
        inputElement.style.border = ""; 
        return false;
      } else if(inputElement.value.length >= minLength){
        inputElement.style.border = "2px solid green";
        return true;
      } else {
        inputElement.style.border = "2px solid red";
        return false;
      }
    }
  </script>
</body>
</html>