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
      .sidebar {
        min-height: 100vh;
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
      .card h3 {
        font-weight: 600;
      }
      .recent-activity {
        background: rgba(255, 255, 255, 0.9);
        border-radius: 15px;
        padding: 20px;
      }
      hr {
        border: none;
        height: 2px;
        background-color: black;
        border-radius: 2px;
        margin: 20px 0;
      }
      .search-form {
        margin-bottom: 30px;
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
         
         String profile="";
         if(role.equalsIgnoreCase("Admin")) profile = "bi bi-person-gear";
         else if (role.equalsIgnoreCase("HR")) profile= "bi-person-workspace";
         else if (role.equalsIgnoreCase("SuperAdmin")) profile= "bi-shield-lock";
        %>
        <div class="col-md-2 sidebar">
          <h4 class="text-center mb-4"><i class="<%=profile %>"></i> <%=role %></h4>
          <a href="UsersDashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
       <!-- Not Show Create Student Link  for HR-->
          <% if (!role.equalsIgnoreCase("HR")) { %>
  			<a href="CreateStudent.jsp"><i class="bi bi-person-plus"></i> Create Student</a>
		  <% } %>         
		  <a href="ManageStudent.jsp"><i class="bi bi-people"></i> Manage Students</a>
  		  <a href="SearchSingleStudent.jsp"  class="active"><i class="bi bi-search"></i> Search Student</a>
          <a href="UpdateStudent.jsp"><i class="bi bi-pencil-square"></i> Update Student</a>
          <a href="Settings.jsp"><i class="bi bi-gear"></i> Settings</a>
          <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
          <h2 class="text-black">Search Student 👨‍🎓</h2>
          <hr />

          <!-- Search Form -->
          <div class="card p-4 mb-4">
            <form class="search-form" method="get" action="fetchsinglestudent">
              <input type="hidden" value="SearchSingleStudent.jsp" name ="redirectURL">
              <div class="row">
                <div class="col-md-8">
                  <input type="text" name="studentid" class="form-control" placeholder="Enter Student ID" required />
                </div>
                <div class="col-md-4">
                  <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i> Search</button>
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
            <p><strong>ID:</strong> <%=s.getId()%></p>
            <p><strong>Name:</strong> <%=s.getName()%></p>
            <p><strong>Gender:</strong> <%=s.getGender()%></p>
            <p><strong>Email:</strong> <%=s.getEmail()%></p>
            <p><strong>Mobile Number:</strong> <%=s.getMobileNumber()%></p>
            <p><strong>DoB:</strong> <%=s.getDOB()%></p>
            <p><strong>Matruculation :</strong> <%=s.getTenthMark()%></p>
            <p><strong>Intermidiate :</strong> <%=s.getTwelveMark()%></p>
            <p><strong>Graducation :</strong> <%=s.getGradMark()%></p>
            <p><strong>Address:</strong> <%=s.getAddress()%></p>
          </div>
          <% } else if(request.getAttribute("message") != null) { %>
            <script type="text/javascript">
             	Swal.fire({
  					title: "Error",
  					text: "<%=request.getAttribute("message")%>",
  					icon: "Error",
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
        </div>
      </div>
    </div>
  </body>
</html>
