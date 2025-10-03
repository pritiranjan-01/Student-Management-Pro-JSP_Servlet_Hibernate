<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light d-flex justify-content-center align-items-center vh-100">

    <div class="card shadow-lg p-4 rounded-4" style="width: 350px;">
        <h3 class="text-center mb-4">Login</h3>

        <form action="login" method="post">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" name="username" class="form-control" placeholder="Enter username" required>
            </div>

            <div class="mb-3 position-relative">
    			<label class="form-label">Password</label>
    			<input id="password" type="password" name="password" class="form-control" placeholder="Enter password" required>
   				<i id="togglePassword" class="bi bi-eye-fill position-absolute" style="top: 38px; right: 15px; cursor: pointer;"></i>
			</div>

            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>

        <!-- Display dynamic message from Servlet -->
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
            <div class="alert alert-danger mt-3 text-center">
                <%= message %>
            </div>
        <%
            }
        	String logoutMessage = (String)request.getAttribute("logoutMessage");
        	 if (logoutMessage != null) {
        %>
            <div class="alert alert-success mt-3 text-center">
                <%= logoutMessage %>
            </div>
        <%
            }
        %>
    </div>
    <script>
    const togglePassword = document.getElementById('togglePassword');
    const password = document.getElementById('password');

    togglePassword.addEventListener('click', () => {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);

        // Toggle eye icon
        togglePassword.classList.toggle('bi-eye-fill');
        togglePassword.classList.toggle('bi-eye-slash-fill');
    });
</script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
