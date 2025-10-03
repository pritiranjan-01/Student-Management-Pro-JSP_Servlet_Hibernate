# StudentManagementPro

StudentManagementPro is a Java-based web application designed for efficient management of student records and administrative tasks in educational institutions. It provides secure user authentication, authorization, and role-based access control (RBAC) with multiple user roles.

## Features

- **Student Management:** Create, update, search, and manage student records.
- **User Management:** Add and manage users with roles such as Super Admin, Admin, and HR.
- **Authentication & Authorization:** Secure login system with session management.
- **Role-Based Access Control (RBAC):** Restrict access to features based on user roles (Super Admin, Admin, HR).
- **Dashboards:** Separate dashboards for Super Admin and other users.
- **Settings:** Manage application and user settings.

## Technologies Used

- **Java** (Servlets, JSP)
- **Jakarta Servlet API**
- **Hibernate ORM**
- **MySQL** (Database)
- **Lombok** (Boilerplate code reduction)
- **JUnit** (Testing)
- **Maven** (Build and dependency management)

## Project Structure

```
StudentManagementPro/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   ├── resources/
│   │   └── webapp/
│   │       ├── CreateStudent.jsp
│   │       ├── CreateUser.jsp
│   │       ├── Login.jsp
│   │       ├── ManageStudent.jsp
│   │       ├── ManageUsers.jsp
│   │       ├── SearchSingleStudent.jsp
│   │       ├── Settings.jsp
│   │       ├── SuperAdminDashboard.jsp
│   │       ├── UpdateStudent.jsp
│   │       ├── UsersDashboard.jsp
│   │       └── WEB-INF/
│   └── test/
└── target/
```

## Getting Started

### Prerequisites
- Java 17 or above
- Maven 3.6+
- MySQL Server
- Tomcat 10+ (or compatible servlet container)

### Setup Instructions
1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/StudentManagementPro.git
   ```
2. **Configure the database:**
   - Create a MySQL database and update the connection details in the Hibernate configuration.
3. **Build the project:**
   ```sh
   mvn clean package
   ```
4. **Deploy the WAR file:**
   - Deploy `target/ServletTask.war` to your servlet container (e.g., Tomcat).
5. **Access the application:**
   - Open your browser and go to `http://localhost:8080/ServletTask/`

## User Roles
- **Super Admin:** Full access to all features and user management.
- **Admin:** Manage students and view reports.
- **HR:** Limited access for HR-related tasks.

## License
This project is licensed under the MIT License.

## Acknowledgements
- Jakarta EE
- Hibernate ORM
- MySQL
- Lombok

---
Feel free to contribute or raise issues to help improve StudentManagementPro!
