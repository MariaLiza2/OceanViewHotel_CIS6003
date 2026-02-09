<%@ page import="com.oceanview.model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Dashboard</title>
</head>
<body>

<h2>Welcome, <%= user.getUsername() %></h2>
<p>Role: <%= user.getRole() %></p>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <a class="navbar-brand">Ocean View Resort</a>
  <ul class="navbar-nav">
    <li class="nav-item"><a class="nav-link" href="dashboard.jsp">Home</a></li>
    <li class="nav-item"><a class="nav-link" href="reservation.jsp">Reservation</a></li>
    <li class="nav-item"><a class="nav-link" href="../viewReservations">Reservation Details</a></li>
    <li class="nav-item"><a class="nav-link" href="../logout">Logout</a></li>
  </ul>
</nav>

<a href="logout">Logout</a>

</body>
</html>
