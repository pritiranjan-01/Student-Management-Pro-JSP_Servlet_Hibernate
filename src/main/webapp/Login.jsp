<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
        }
        .card {
            max-width: 400px;
            width: 100%;
        }
        .position-relative i {
            cursor: pointer;
        }
        @media (max-width: 576px) {
            h3 {
                font-size: 1.5rem;
            }
            .card {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body class="bg-light d-flex justify-content-center align-items-center p-3">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12 col-sm-10 col-md-8 col-lg-5">
                <div class="card shadow-lg p-4 rounded-4 mx-auto">
                    <h3 class="text-center mb-4">Login</h3>

                    <form action="login" method="post">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control" placeholder="Enter username" required>
                        </div>

                        <div class="mb-3 position-relative">
                            <label class="form-label">Password</label>
                            <input id="password" type="password" name="password" class="form-control" placeholder="Enter password" required>
                            <i id="togglePassword" class="bi bi-eye-fill position-absolute" style="top: 38px; right: 15px;"></i>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Login</button>
                    </form>
                    <!-- ✅ DEMO LOGIN BUTTONS — Add Here -->
			<div class="mt-4">
    					<h6 class="text-center mb-2">Demo Logins</h6>

    					<div class="d-flex flex-column gap-2">
      				    <button type="button" class="btn btn-outline-danger w-100 demo-btn"  data-user="superadmin_demo" data-pass="Super@123">
                             Login as SuperAdmin (Demo)
                        </button>

                         <button type="button" class="btn btn-outline-primary w-100 demo-btn" data-user="admin_demo" data-pass="Admin@123">
                              Login as Admin (Demo)
                         </button>

                         <button type="button" class="btn btn-outline-success w-100 demo-btn" data-user="hr_demo" data-pass="Hr@123">
                               Login as HR (Demo)
                         </button>
                   </div>
             </div>
                  <!-- END OF DEMO LOGIN SECTION -->

                    <% String message = (String) request.getAttribute("message"); if (message != null) { %>
                        <div class="alert alert-danger mt-3 text-center auto-hide">
                            <%= message %>
                        </div>
                    <% } %>

                    <% String logoutMessage = (String) request.getAttribute("logoutMessage"); if (logoutMessage != null) { %>
                        <div class="alert alert-success mt-3 text-center auto-hide">
                            <%= logoutMessage %>
                        </div>
                    <% } %>
                    
                    <script>
  						  // Demo Login Auto Fill
   						document.querySelectorAll(".demo-btn").forEach(btn => {
      						  btn.addEventListener("click", () => {
           				document.querySelector("input[name='username']").value = btn.dataset.user;
            				document.querySelector("input[name='password']").value = btn.dataset.pass;
        					});
    					});
				</script>
                    
                    <script>
    					// Hide alert after 5 seconds
    					setTimeout(() => {
        					document.querySelectorAll('.auto-hide').forEach(el => {
           				 el.style.transition = "opacity 0.5s";
           				 el.style.opacity = "0";
           				 setTimeout(() => el.remove(), 500); // remove from DOM after fade-out
       				 });
   				 }, 5000);
				</script>
                </div>
            </div>
        </div>
    </div>

    <script>
        const togglePassword = document.getElementById('togglePassword');
        const password = document.getElementById('password');

        togglePassword.addEventListener('click', () => {
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);

            togglePassword.classList.toggle('bi-eye-fill');
            togglePassword.classList.toggle('bi-eye-slash-fill');
        });
    </script>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
