<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Main Dashboard | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;   /* Light Sage Background */
            --primary-sage: #8A9A84;    /* Muted Sage Green */
            --deep-sage: #5E6B5A;       /* Darker Sage for text/borders */
            --accent-sand: #D4A373;     /* Soft Sand Accent */
            --white: #ffffff;
        }

        body {
            background-color: var(--bg-sage-light);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
        }

        .main-container {
            max-width: 1000px;
            margin: 50px auto;
            padding: 20px;
        }

        .dashboard-header {
            margin-bottom: 40px;
        }

        .dashboard-header h2 {
            font-weight: 300;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--deep-sage);
        }

        .role-badge {
            background-color: var(--primary-sage);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Responsive Grid */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .nav-card {
            background: var(--white);
            padding: 40px 20px;
            border-radius: 8px; /* Slightly soft but architectural */
            text-decoration: none;
            color: var(--deep-sage);
            transition: all 0.3s ease;
            border: 1px solid rgba(138, 154, 132, 0.2);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .nav-card i {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: var(--primary-sage);
            transition: transform 0.3s ease;
        }

        .nav-card h4 {
            font-size: 1.1rem;
            font-weight: 500;
            margin: 0;
            letter-spacing: 0.5px;
        }

        .nav-card:hover {
            background-color: var(--white);
            border-color: var(--accent-sand);
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(94, 107, 90, 0.08);
            color: var(--accent-sand);
        }

        .nav-card:hover i {
            transform: scale(1.1);
            color: var(--accent-sand);
        }

        .logout-link {
            color: var(--deep-sage);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 2px solid var(--accent-sand);
            padding-bottom: 4px;
            transition: 0.3s;
        }

        .logout-link:hover {
            color: var(--accent-sand);
            border-color: var(--deep-sage);
        }
    </style>
</head>
<body>

<div class="main-container text-center">
    <div class="dashboard-header">
        <h2>Welcome, <%= user.getUsername() %></h2>
        <span class="role-badge"><%= user.getRole() %></span>
    </div>

    <div class="card-grid">
        <a href="reservation.jsp" class="nav-card">
            <i class="fa-solid fa-calendar-plus"></i>
            <h4>Reservation</h4>
        </a>
        <a href="viewReservations" class="nav-card">
            <i class="fa-solid fa-list-check"></i>
            <h4>Reservation List</h4>
        </a>
    </div>

    <div class="card-grid">
        <a href="viewReservations" class="nav-card">
            <i class="fa-solid fa-file-invoice-dollar"></i>
            <h4>Billing / Check-out</h4>
        </a>
        <a href="viewPayments" class="nav-card">
            <i class="fa-solid fa-vault"></i>
            <h4>Payment Details</h4>
        </a>
    </div>

    <div class="card-grid">
        <a href="rooms" class="nav-card">
            <i class="fa-solid fa-door-open"></i>
            <h4>Room Availability</h4>
        </a>
        <a href="registered-guests.jsp" class="nav-card">
            <i class="fa-solid fa-users-gear"></i>
            <h4>Registered Users</h4>
        </a>
    </div>

    <div class="card-grid">
        <a href="staff-guide.jsp" class="nav-card">
            <i class="fa-solid fa-circle-info"></i>
            <h4>Help Guide</h4>
        </a>
        <a href="admin-login.jsp" class="nav-card">
            <i class="fa-solid fa-user-shield"></i>
            <h4>Admin Panel</h4>
        </a>
    </div>

    <div class="mt-5">
        <a href="logout" class="logout-link">
            <i class="fa-solid fa-power-off me-2"></i>Logout
        </a>
    </div>
</div>

</body>
</html>