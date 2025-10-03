# 🎓 StudentManagementPro

StudentManagementPro is a Java-based web application designed for efficient management of student records and administrative tasks in educational institutions. It provides secure user authentication, authorization, and role-based access control (RBAC) with multiple user roles.

## ✨ Features

- 👨‍🎓 **Student Management:** Create, update, search, and manage student records.
- 👥 **User Management:** Add and manage users with roles such as Super Admin, Admin, and HR.
- 🔐 **Authentication & Authorization:** Secure login system with role based access management.
- 🛡️ **Role-Based Access Control (RBAC):** Restrict access to features based on user roles (Super Admin, Admin, HR).
- 📊 **Dashboards:** Separate dashboards for Super Admin and other users.
- ⚙️ **Settings:** Manage password change.

## 🛠️ Technologies Used

- **Java** (Servlets, JSP)
- **Jakarta Servlet API**
- **Hibernate ORM**
- **MySQL** (Database)
- **Lombok** (Boilerplate code reduction)
- **Maven** (Build and dependency management)

## 📂 Project Structure

```
StudentManagementPro/
├── pom.xml
├── README.md
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── prm/
│   │   │           ├── container/
│   │   │           │   ├── ChangePasswordServlet.java
│   │   │           │   ├── DeleteStudentServlet.java
│   │   │           │   ├── DeleteUserServlet.java
│   │   │           │   ├── ExceptionHandlerServlet.java
│   │   │           │   ├── FetchAllStudents.java
│   │   │           │   ├── FetchSingleStudent.java
│   │   │           │   ├── LogoutServlet.java
│   │   │           │   ├── SaveStudentServlet.java
│   │   │           │   ├── UpdateStudent.java
│   │   │           │   ├── UpdateUser.java
│   │   │           │   ├── UserLoginServlet.java
│   │   │           │   └── UserRegistrationServlet.java
│   │   │           ├── dao/
│   │   │           │   ├── EntityProxy.java
│   │   │           │   ├── StudentDAO.java
│   │   │           │   ├── UserDAO.java
│   │   │           │   └── UserLastLoginDTO.java
│   │   │           ├── entity/
│   │   │           │   ├── AuthorizeRoleEnum.java
│   │   │           │   ├── Student.java
│   │   │           │   ├── Users.java
│   │   │           │   └── Usertype.java
│   │   │           ├── util/
│   │   │           │   ├── UserAuthenticationUtil.java
│   │   │           │   ├── UserAuthorizationValidUtil.java
│   │   │           │   └── UserResponseObject.java
│   │   │           └── weblistener/
│   │   │               └── WebInformationListener.java
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
├── test/
├── target/
├── pom.xml

```

## 🚀 Getting Started

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

## 👥 User Roles
- 🛡️ **Super Admin:** Full access to all features and can perform CRUD operation of Users(Admin & HR).
- 🏫 **Admin:** Manage students can performs CRUD operation of Students.
- 👔 **HR:** Limited access only can View and Update Students.

## 📸 Screenshots

<details>
<summary>Super Admin Operations </summary>
   ##### Home Page
     <img width="1910" height="922" alt="Homepage1" src="https://github.com/user-attachments/assets/f626c0a7-3be2-430e-b6b3-9187bceb0340" />
   ##### Dashboard
     <img width="1910" height="922" alt="SuperAdminDashboard" src="https://github.com/user-attachments/assets/c4b3c7fc-3397-4595-9f8a-fefac931ff48" />
   #### Create User
     <img width="1910" height="922" alt="sp-createuser" src="https://github.com/user-attachments/assets/628890ac-26c3-4c40-934f-12acd61c8710" />
   ##### Manage User
     <img width="1910" height="922" alt="sp-manageuser" src="https://github.com/user-attachments/assets/4422dbe4-ef4e-4bf5-addf-db7933a881e5" />
</details>
<details>
 <summary>Admin Operations </summary>
  #####Admin Dashboard
   <img width="1910" height="922" alt="AdminDashboard" src="https://github.com/user-attachments/assets/89c0fe18-7faa-4f94-a0fe-5747bf4bd08e" />
  ##### Create Student
   <img width="1920" height="1080" alt="adminCreateStudent" src="https://github.com/user-attachments/assets/7ab8bde3-05f9-4c40-bb0e-6172165e7f6d" />
  ##### Manage Student
   <img width="1910" height="922" alt="adminManageStudent" src="https://github.com/user-attachments/assets/0409109d-c610-4443-a8b5-85b2f7242b2d" />
  ##### Search Student
   <img width="1910" height="922" alt="AdminSearchStudent" src="https://github.com/user-attachments/assets/76833d13-7ef8-4817-aafd-8e437f232f21" />
  ##### Update Student
   <img width="1910" height="922" alt="adminUpdateStudent" src="https://github.com/user-attachments/assets/2aaaff6e-4de3-4fbd-9cb1-93670194907a" />
  ##### Setting
   <img width="1910" height="922" alt="AdminSetting" src="https://github.com/user-attachments/assets/0225f437-5457-40e1-b5fd-6bd56126666b" />

</details>
<details>
 <summary>HR Operations </summary>
  ##### HR Dashboard
   <img width="1910" height="922" alt="HRDashboard" src="https://github.com/user-attachments/assets/bcc47669-6f32-4b01-87ec-0a0b00e3ce95" />
  ##### Manage Student
   <img width="1910" height="922" alt="HRManageStudent" src="https://github.com/user-attachments/assets/e4cb2605-cc2c-4329-b11a-10aa20fc7c43" />
  ##### Search Student
   <img width="1910" height="922" alt="HRSearchStudent" src="https://github.com/user-attachments/assets/1684f573-8951-4fbe-80ac-03cbdeff80af" />
  ##### Update Student
   <img width="1910" height="922" alt="HRUpdateStudent" src="https://github.com/user-attachments/assets/02919b91-6049-43da-823e-d3f3735e6302" />
  ##### Setting
   <img width="1910" height="922" alt="HRSetting" src="https://github.com/user-attachments/assets/4cad8550-e142-41a3-8677-29ef90f3ec12" />
</details>

## 👨‍💻 Author

**Pritiranjan Mohanty** — [GitHub Profile](https://github.com/pritiranjan-01)


## License
This project is licensed under the MIT License. See the [LICENSE](https://github.com/pritiranjan-01/Student-Management-Pro-JSP_Servlet_Hibernate/blob/main/LICENSE) file for details.

---
Feel free to contribute or raise issues to help improve StudentManagementPro!
