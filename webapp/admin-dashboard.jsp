<%@ page import="com.oceanview.model.User" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null) { response.sendRedirect("login.jsp"); return; }
%>
<html>
<head>
    <title>Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
<div class="main-container text-center">
    <h2>Admin Control Center</h2>

    <div class="card-grid">
        <a href="ManageRoomsServlet" class="nav-card">

            <h4>Manage Rooms</h4>
        </a>
        <a href="ManageUsersServlet" class="nav-card">

            <h4>Download reports</h4>
        </a>
        <a href="dashboard.jsp" class="nav-card">

            <h4>Main Dashboard</h4>
        </a>
    </div>
</div>
</body>
</html>