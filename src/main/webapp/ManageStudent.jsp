<%@page import="com.prm.util.UserResponseObject"%>
<%@page import="com.prm.entity.AuthorizeRoleEnum"%>
<%@page import="com.prm.entity.Student"%>
<%@page import="java.util.List"%>
<%@page import="com.prm.util.UserAuthorizationValidUtil"%>
<%@page import="com.prm.util.UserAuthenticationUtil"%>
<%@page import="com.prm.dao.StudentDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Students</title>
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
    .sidebar a:hover, .sidebar a.active {
      background: #0d6efd;
      color: #fff;
      transform: translateX(5px);
    }
    h1 {
      text-align: center;
      margin-bottom: 20px;
      font-weight: bold;
      color: #0d6efd;
    }
    .table thead th {
      background-color: #0d6efd;
      color: white;
      text-align: center;
    }
    .table td {
      vertical-align: middle;
      text-align: center;
    }
    .action-links a, .action-links button {
      margin: 0 5px;
    }
  </style>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <!-- 🔹 Sidebar -->
      <%
         HttpSession var = request.getSession(false);
         String role = (String)var.getAttribute("role");
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
      <h4 class="text-center mb-4"><i class="<%=profile %>"></i>  <%=role %></h4>
      <a href=UsersDashboard.jsp><i class="bi bi-speedometer2"></i> Dashboard</a>
   <!-- Not Show Create Student Link  for HR-->
      <% if (!role.equalsIgnoreCase("HR")) { %>
  			<a href="CreateStudent.jsp"><i class="bi bi-person-plus"></i> Create Student</a>
	  <% } %>      
	  <a href="ManageStudent.jsp" class="active"><i class="bi bi-people"></i> Manage Students</a>
      <a href="SearchSingleStudent.jsp"><i class="bi bi-search"></i> Search Student</a>
      <a href="UpdateStudent.jsp"><i class="bi bi-pencil-square"></i> Update Student</a>
      <a href="Settings.jsp"><i class="bi bi-gear"></i> Settings</a>
      <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
    </div>

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
  

	<%-- Global Variables --%>
	<%!
		StudentDAO studentDAO = StudentDAO.getStudentDAO();
		UserAuthenticationUtil authenticateUtil = UserAuthenticationUtil.getUserAuthenticationUtil();
		UserAuthorizationValidUtil authorizeutil = UserAuthorizationValidUtil.getAuthorizationValidUtil();
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

	UserResponseObject authorizedUser = authorizeutil.
			getRoleAuthorizationCheckByCookies(request, response, AuthorizeRoleEnum.FETCHSTUDENT);

	if(!authorizedUser.getStatus()) {
		request.setAttribute("message", authorizedUser.getMessage());
		request.setAttribute("msgType", "warning");	
		RequestDispatcher dispatcher = request.getRequestDispatcher("ManageStudent.jsp");
		dispatcher.forward(request, response);
		return;
	}

	List<Student> allStudents = studentDAO.getAllStudent();
	%>
	
 <!-- 🔹 Main Content -->
  <div class="col-md-10 p-4">
      <h1>All Student Records</h1>
      <div class="mb-3">
  		  <input type="text" id="searchInput" class="form-control w-25" placeholder="Search students...">
	  </div>
      
      <table class="table table-bordered table-striped shadow-sm">
        <thead>
          <tr>
            <th>Student Id</th>
            <th>Name</th>
            <th>DOB</th>
            <th>Gender</th>
            <th>Mobile</th>
            <th>Email</th>
            <th>Aadhaar</th>
            <th>10th %</th>
            <th>12th %</th>
            <th>Grad %</th>
            <th>Address</th>
            <th colspan="2">Action</th>
    <%--    <%if(!role.equalsIgnoreCase("HR")) {%> <!-- If Role is HR then Dont Show Delete Button -->
            <th>Delete</th>
            <%} %>             --%>
          </tr>
        </thead>
        <tbody>
          <%
   		    if (allStudents.isEmpty()) {
  		  %>
           <tr>
               <td colspan="16" class="text-center text-danger">No students found.</td>
          </tr>
         <%
         } else {
             for(Student s : allStudents) {
          %>
          <tr>
            <td><%=s.getId() %></td>
            <td><%=s.getName() %></td>
            <td><%=s.getDOB() %></td>
            <td><%=s.getGender() %></td>
            <td><%=s.getMobileNumber() %></td>
            <td><%=s.getEmail() %></td>
            <td><%=s.getAadhaarNumber() %></td>
            <td><%=s.getTenthMark() %></td>
            <td><%=s.getTwelveMark() %></td>
            <td><%=s.getGradMark() %></td>
            <td><%=s.getAddress() %></td>
            <td class="action-links">
               <button type="button" class="btn btn-warning btn-sm"
                       onclick="openUpdateModal(
                           '<%=s.getId()%>',
                           '<%=s.getName()%>',
                           '<%=s.getDOB()%>',
                           '<%=s.getGender()%>',
                           '<%=s.getMobileNumber()%>',
                           '<%=s.getEmail()%>',
                           '<%=s.getAadhaarNumber()%>',
                           '<%=s.getTenthMark()%>',
                           '<%=s.getTwelveMark()%>',
                           '<%=s.getGradMark()%>',
                           '<%=s.getAddress()%>'
                        )">
                 Update
               </button>
            </td>
             <%if(!role.equalsIgnoreCase("HR")) { %> <!-- If Role is HR then Dont Show Delete Button -->
            <td class="action-links">
              <a href="deleteStudent?id=<%= s.getId()%>" class="btn btn-danger btn-sm delete-btn">Delete</a>
            </td>
            <%} %>
          </tr>
          <%
            } 
         } 
          %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- 🔹 Update Modal -->
<div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="updatestudent" method="post">
      <input type="hidden" value="ManageStudent.jsp" name ="redirectURL">
        <div class="modal-header">
          <h5 class="modal-title" id="updateModalLabel">Update Student</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body row g-3">
          <input type="hidden" name="id" id="modalStudentId">

          <div class="col-md-6">
            <label class="form-label">Name</label>
            <input type="text" name="name" id="modalStudentName" class="form-control" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">DOB</label>
            <input type="date" name="dob" id="modalStudentDOB" class="form-control" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">Gender</label>
            <select name="gender" id="modalStudentGender" class="form-select">
              <option value="Male">Male</option>
              <option value="Female">Female</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label">Mobile</label>
            <input type="number" name="mobileNumber" id="modalStudentMobile" class="form-control" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">Email</label>
            <input type="email" name="email" id="modalStudentEmail" class="form-control" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">Aadhaar</label>
            <input type="number" name="aadhaarNumber" id="modalStudentAadhaar" class="form-control" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">10th %</label>
            <input type="number" step="0.01" name="tenthMark" id="modalStudentTenthMark" class="form-control" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">12th %</label>
            <input type="number" step="0.01" name="twelveMark" id="modalStudentTwelveMark" class="form-control" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">Graduation %</label>
            <input type="number" step="0.01" name="gradMark" id="modalStudentGradMark" class="form-control" required>
          </div>
          <div class="col-md-12">
            <label class="form-label">Address</label>
            <input type="text" name="address" id="modalStudentAddress" class="form-control" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Update</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 🔹 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function openUpdateModal(id, name, dob, gender, mobile, email, 
					aadhaar, tenthMark, twelveMark, gradMark, address) {
    document.getElementById('modalStudentId').value = id;
    document.getElementById('modalStudentName').value = name;
    document.getElementById('modalStudentDOB').value = dob;
    document.getElementById('modalStudentGender').value = gender;
    document.getElementById('modalStudentMobile').value = mobile;
    document.getElementById('modalStudentEmail').value = email;
    document.getElementById('modalStudentAadhaar').value = aadhaar;
    document.getElementById('modalStudentTenthMark').value = tenthMark;
    document.getElementById('modalStudentTwelveMark').value = twelveMark;
    document.getElementById('modalStudentGradMark').value = gradMark;
    document.getElementById('modalStudentAddress').value = address;

    var myModal = new bootstrap.Modal(document.getElementById('updateModal'));
    myModal.show();
}

const searchInput = document.getElementById('searchInput');
searchInput.addEventListener('keyup', function() {
    const filter = searchInput.value.toLowerCase();
    const table = document.querySelector('table tbody');
    const rows = table.getElementsByTagName('tr');

    for (let i = 0; i < rows.length; i++) {
        const cells = rows[i].getElementsByTagName('td');
        let match = false;

        for (let j = 0; j < cells.length - 2; j++) { // skip Update/Delete buttons
            if (cells[j].innerText.toLowerCase().indexOf(filter) > -1) {
                match = true;
                break;
            }
        }

        rows[i].style.display = match ? '' : 'none';
    }
});


//Delete Pop up Logic
const deleteBtns = document.querySelectorAll('.delete-btn');
deleteBtns.forEach(btn => {
 btn.addEventListener('click', (event) => {
     event.preventDefault(); 
     const url = btn.href; // get the href from this button

     Swal.fire({
         title: 'Are you sure want to delete the Student?',
         text: "This action cannot be undone!",
         icon: 'warning',
         showCancelButton: true,
         confirmButtonColor: '#d33',
         cancelButtonColor: '#3085d6',
         confirmButtonText: 'Yes, delete it!',
         cancelButtonText: 'Cancel'
     }).then((result) => {
         if (result.isConfirmed) {
             window.location.href = url; // redirect to delete
         }
     });
 });
});
</script>
</body>
</html>
