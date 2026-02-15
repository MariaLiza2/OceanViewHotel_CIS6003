<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<html>
<head>
    <title>Main Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
<div class="main-container text-center">
    <h2>Welcome, <%= user.getUsername() %></h2>
    <p>Logged in as: <strong><%= user.getRole() %></strong></p>

    <div class="card-grid">
        <a href="reservation.jsp" class="nav-card">

            <h4>Reservation</h4>
        </a>
        <a href="viewReservations" class="nav-card">

                    <h4>Reservation List</h4>
                </a>

    </div>
 <div class="card-grid">
        <a href="reservation.jsp" class="nav-card">

            <h4>Help</h4>
        </a>

        <a href="admin-login.jsp" class="nav-card">

            <h4>Admin Panel</h4>
        </a>
    </div>
    <div class="mt-5">
        <a href="logout" class="btn btn-danger">Logout</a>
    </div>
</div>
</body>
</html>