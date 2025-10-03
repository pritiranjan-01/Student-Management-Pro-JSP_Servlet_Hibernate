<img width="1910" height="922" alt="Homepage1" src="https://github.com/user-attachments/assets/e3db7fb8-9ef0-4122-ae3b-247744003c49" /># StudentManagementPro

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
   Steps
    ```sh
     create database studentmgmt;
    
   DB Config Location (Goto /StudentManagementPro/src/main/resources/META-INF/persistence.xml)
   <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/studentmgmt" />
   <property name="jakarta.persistence.jdbc.user" value="<YOUR USERNAME>" />
   <property name="jakarta.persistence.jdbc.password" value="<YOUR_PASSWORD>" />
    ```
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

## Screenshots

<details>
  <summary>Login Page</summary>
  
  ![Dashboard Page]<img width="1910" height="922" alt="Homepage1" src="https://github.com/user-attachments/assets/f626c0a7-3be2-430e-b6b3-9187bceb0340" />

  ![Super Admin Dashboard]<img width="1910" height="922" alt="SuperAdminDashboard" src="https://github.com/user-attachments/assets/c4b3c7fc-3397-4595-9f8a-fefac931ff48" />

</details>


## License
This project is licensed under the MIT License.

---
Feel free to contribute or raise issues to help improve StudentManagementPro!
