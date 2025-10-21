<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.prm.entity.AuthorizeRoleEnum"%>
<%@page import="com.prm.util.UserAuthenticationUtil"%>
<%@page import="com.prm.util.UserAuthorizationValidUtil"%>
<%@page import="com.prm.dao.UserDAO"%>
<%@page import="com.prm.util.UserResponseObject"%>
<%@page import="com.prm.entity.Users"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Users - SuperAdmin Dashboard</title>
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
      margin-bottom: 20px;
      font-weight: bold;
      color: #0d6efd;
    }
    
    .table-responsive {
      background: white;
      border-radius: 15px;
      padding: 20px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    
    .table thead th {
      background-color: #0d6efd;
      color: white;
      text-align: center;
      white-space: nowrap;
    }
    
    .table td {
      vertical-align: middle;
      text-align: center;
    }
    
    .action-links a, 
    .action-links button {
      margin: 2px;
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
      
      .table thead th {
        font-size: 0.85rem;
        padding: 8px 4px;
      }
      
      .table td {
        font-size: 0.85rem;
        padding: 8px 4px;
      }
      
      h1 {
        font-size: 1.5rem;
      }
    }
    
    /* Small Mobile Adjustments */
    @media (max-width: 576px) {
      .sidebar {
        width: 100%;
      }
      
      h1 {
        font-size: 1.3rem;
      }
      
      .table thead th,
      .table td {
        font-size: 0.75rem;
        padding: 6px 2px;
      }
      
      .btn-sm {
        font-size: 0.7rem;
        padding: 4px 8px;
      }
      
      #searchInput {
        width: 100% !important;
      }
    }
  </style>
</head>
<body>
  <%-- Global Variables --%>
  <%! 
    private final UserDAO userDao = UserDAO.getUserDAO();
    private final UserAuthenticationUtil authenticateUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
    private final UserAuthorizationValidUtil authorizeutil = UserAuthorizationValidUtil.getAuthorizationValidUtil();
  %>

  <%-- Session Check --%>
  <%
    HttpSession var = request.getSession(false);
    String role = (String)var.getAttribute("role");
    if(role==null)  {
      request.setAttribute("logoutMessage", "Session Expired");
      RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
      dispatcher.forward(request, response);
      return;
    }
  %>

  <%-- Http Method Impl --%>
  <%
  if (!authenticateUtil.getCookieAuthenticate(request, response)) {
     RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
     request.setAttribute("message", "Session Expired\\nUser not Logged In so forward to User Login Page");
     request.setAttribute("msgType", "error");
     dispatcher.forward(request, response);    
     return;
  }

  UserResponseObject authorizedUser = authorizeutil.getRoleAuthorizationCheckByCookies(request, response, AuthorizeRoleEnum.FETCHUSER);

  if(!authorizedUser.getStatus()) {
    RequestDispatcher dispatcher = request.getRequestDispatcher("ManageUser.jsp");
    request.setAttribute("message", authorizedUser.getMessage());
    request.setAttribute("msgType", "warning");  
    dispatcher.forward(request, response);
    return;
  }

  List<Users> allUsers = userDao.getAllUsers();
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
        <a href="CreateUser.jsp"><i class="bi bi-person-plus"></i> Create User</a>
        <a href="ManageUsers.jsp" class="active"><i class="bi bi-people"></i> Manage Users</a>
        <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
      </nav>

      <!-- Main Content -->
      <main class="col-lg-10 col-12 p-4 main-content">
        <h1>All User Records</h1>
        
        <div class="mb-3">
          <input type="text" id="searchInput" class="form-control w-lg-25 w-100" placeholder="Search users...">
        </div>
        
        <div class="table-responsive">
          <table class="table table-bordered table-striped">
            <thead>
              <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Username</th>
                <th>Password</th>
                <th>Role</th>
                <th>Last Login</th>
                <th colspan="2">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                if (allUsers.size()==1) {
              %>
               <tr>
                 <td colspan="8" class="text-center text-danger">No users found.</td>
               </tr>
              <%
                } else {
                  for(Users u : allUsers) {
                      if(u.getUserrole().name().equalsIgnoreCase("SuperAdmin")){
                          continue;
                      }
              %>
              <tr>
                <td><%=u.getId()%></td>
                <td><%=u.getFullName()%></td>
                <td><%=u.getUsername()%></td>
                <td><%=u.getPassword()%></td>
                <td><%=u.getUserrole()%></td> 
                <td>
                  <%= u.getLastLogin() != null 
                         ? u.getLastLogin().format(DateTimeFormatter.ofPattern("yyyy-dd-MM HH:mm:ss")) 
                         : "null" 
                   %>
                </td>
                <td class="action-links">
                  <button type="button" class="btn btn-warning btn-sm"
                          onclick="openUpdateModal(
                            '<%=u.getId()%>',
                            '<%=u.getFullName()%>',
                            '<%=u.getUsername()%>',
                            '<%=u.getPassword()%>',
                            '<%=u.getUserrole()%>'
                          )">
                    Update
                  </button>
                </td>
                <td class="action-links">
                  <a href="deleteuser?id=<%= u.getId()%>" class="btn btn-danger btn-sm delete-btn">Delete</a>
                </td>
              </tr>
              <%
                  }
                }
              %>
            </tbody>
          </table>
        </div>
      </main>
    </div>
  </div>

  <!-- Update Modal -->
  <div class="modal fade" id="updateUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <form id="updateForm" action="updateuser" method="post">
          <div class="modal-header">
            <h5 class="modal-title">Update User</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body row g-3">
            <input type="hidden" name="id" id="modalUserId">

            <div class="col-md-6">
              <label class="form-label">Full Name</label>
              <input type="text" name="fullname" id="modalFullName" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Username</label>
              <input type="text" name="username" id="modalUsername" class="form-control" required>
              <small class="text-muted">Minimum 3 characters</small>
            </div>
            <div class="col-md-6">
              <label class="form-label">Password</label>
              <input type="text" name="password" id="modalPassword" class="form-control" required>
              <small class="text-muted">Minimum 4 characters</small>
            </div>
            <div class="col-md-6">
              <label class="form-label">Role</label>
              <select name="userrole" id="modalUserRole" class="form-select">
                <option value="ADMIN">Admin</option>
                <option value="HR">HR</option>
              </select>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-primary" id="submit">Update</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- JS -->
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

    // Update Modal
    function openUpdateModal(id, fullname, username, password, role) {
      document.getElementById('modalUserId').value = id;
      document.getElementById('modalFullName').value = fullname;
      document.getElementById('modalUsername').value = username;
      document.getElementById('modalPassword').value = password;
      document.getElementById('modalUserRole').value = role;
      
      // Reset validation borders
      modalUsername.style.border = "";
      modalPassword.style.border = "";

      var myModal = new bootstrap.Modal(document.getElementById('updateUserModal'));
      myModal.show();
    }

    // Search functionality
    const searchInput = document.getElementById('searchInput');
    searchInput.addEventListener('keyup', function() {
        const filter = searchInput.value.toLowerCase();
        const table = document.querySelector('table tbody');
        const rows = table.getElementsByTagName('tr');

        for (let i = 0; i < rows.length; i++) {
            const cells = rows[i].getElementsByTagName('td');
            let match = false;

            for (let j = 0; j < cells.length - 2; j++) {
                if (cells[j].innerText.toLowerCase().indexOf(filter) > -1) {
                    match = true;
                    break;
                }
            }
            rows[i].style.display = match ? '' : 'none';
        }
    });

    // Delete confirmation
    const deleteBtns = document.querySelectorAll('.delete-btn');
    deleteBtns.forEach(btn => {
        btn.addEventListener('click', (event) => {
            event.preventDefault(); 
            const url = btn.href;

            Swal.fire({
                title: 'Are you sure?',
                text: "This action cannot be undone!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, delete it!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = url;
                }
            });
        });
    });

    // Validate Username & Password in Update Modal
    const updateForm = document.getElementById("updateForm");
    if(updateForm){
      const username = document.getElementById("modalUsername");
      const password = document.getElementById("modalPassword");
      const submitBtn = document.getElementById("submit");

      username.style.border = "";
      password.style.border = "";

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
    }
  </script>
</body>
</html>