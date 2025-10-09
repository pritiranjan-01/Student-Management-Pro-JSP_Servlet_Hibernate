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
    .sidebar a:hover,
    .sidebar a.active {
      background: #0d6efd;
      color: #fff;
      transform: translateX(5px);
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
    }
    .btn-custom:hover {
      background: #0b5ed7;
      transform: translateY(-2px);
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
        if(role==null)  {
          request.setAttribute("logoutMessage", "Session Expired");
          RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
          dispatcher.forward(request, response);
          return;
        }
      %>

      <div class="col-md-2 sidebar">
        <h4 class="text-center mb-4"><i class="bi bi-people-fill"></i> Super Admin</h4>
        <a href="SuperAdminDashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="CreateUser.jsp" class="active"><i class="bi bi-person-add"></i> Create User</a>
        <a href="ManageUsers.jsp"><i class="bi bi-people-fill"></i> Manage Users</a>
        <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
      </div>
      

      <!-- Main Content -->
      <div class="col-md-10 p-4">
        <h2 class="text-black">User Registration</h2>
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
              <input type="text" class="form-control" id="username" name="username" placeholder="Enter username" required />
            </div>

            <!-- Password -->
            <div class="mb-3">
              <label for="password" class="form-label">Password</label>
              <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required />
            </div>

            <!-- Buttons -->
            <div class="d-flex justify-content-between">
              <button type="submit" class="btn btn-custom" id="submit"><i class="bi bi-check-circle"></i> Create</button>
              <button type="reset" class="btn btn-secondary"><i class="bi bi-arrow-counterclockwise"></i> Reset</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
  
         
     <%--Response from Servlet --%>
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
      
  
  
<script type="text/javascript">
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
