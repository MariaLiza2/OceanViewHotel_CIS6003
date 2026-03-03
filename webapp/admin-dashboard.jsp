<%@ page import="com.oceanview.model.User" %>
<%
    User admin = (User) session.getAttribute("loggedUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String displayName = "Administrator";
    try {
        displayName = admin.getUsername();
    } catch (Exception e) {
        displayName = "Admin";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <title>Admin Panel | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;
            --primary-sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --accent-sand: #D4A373;
            --white: #ffffff;
        }

        body {
            background-color: var(--bg-sage-light);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
        }

        .admin-header {
            background-color: var(--deep-sage);
            color: var(--white);
            padding: 4rem 0;
            margin-bottom: 3rem;
            border-bottom: 4px solid var(--accent-sand);
        }

        .admin-header h1 {
            font-weight: 300;
            letter-spacing: 4px;
            text-transform: uppercase;
        }

        .nav-card {
            transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1);
            text-decoration: none;
            color: var(--deep-sage);
            background: var(--white);
            padding: 3rem 2rem;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            align-items: center;
            border: 1px solid rgba(138, 154, 132, 0.15);
        }

        .nav-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(94, 107, 90, 0.1);
            border-color: var(--accent-sand);
            color: var(--accent-sand);
        }

        .icon-circle {
            width: 80px;
            height: 80px;
            background: var(--bg-sage-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 1.5rem;
            color: var(--primary-sage);
            transition: 0.3s;
        }

        .nav-card:hover .icon-circle {
            background-color: var(--primary-sage);
            color: var(--white);
        }

        .btn-logout-panel {
            color: var(--white);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.8;
            transition: 0.3s;
        }

        .btn-logout-panel:hover {
            opacity: 1;
            color: var(--accent-sand);
        }
    </style>
</head>
<body>

<div style="text-align: center; padding: 60px 20px 40px 20px; background-color: #f8f9f7; font-family: 'Segoe UI', Arial, sans-serif;">

    <h1 style="color: #4A5D45; font-weight: 800; letter-spacing: 6px; text-transform: uppercase; margin: 0 0 10px 0; font-size: 2.8rem;">
        Ocean View Hotel
    </h1>

    <h2 style="color: #7f8c8d; font-weight: 300; font-size: 1.2rem; letter-spacing: 2px; margin: 0; text-transform: capitalize;">
        No 261, Church Street, Galle.
    </h2>

    <div style="display: flex; align-items: center; justify-content: center; margin-top: 30px;">
        <div style="height: 1px; width: 100px; background-color: #d4a373; opacity: 0.5;"></div>
        <span style="margin: 0 25px; color: #d4a373; font-size: 1.8rem; line-height: 1;">&#129408;</span>
        <div style="height: 1px; width: 100px; background-color: #d4a373; opacity: 0.5;"></div>
    </div>

    <p style="margin-top: 20px; color: #a5a5a5; font-style: italic; font-size: 0.9rem; letter-spacing: 1px;">
        Management Terminal | Welcome back, admin
    </p>
</div>

<div class="container">
    <div class="row g-4 justify-content-center">
        <div class="col-md-4">
            <a href="ManageRoomsServlet" class="nav-card shadow-sm">
                <div class="icon-circle">
                    <i class="fa-solid fa-hotel"></i>
                </div>
                <h5 class="fw-bold text-uppercase" style="letter-spacing: 1px;">Manage Rooms</h5>
                <p class="text-muted text-center small mb-0">Edit room categories and seasonal rates</p>
            </a>
        </div>

        <div class="col-md-4">
            <a href="adminreports" class="nav-card shadow-sm">
                <div class="icon-circle">
                    <i class="fa-solid fa-chart-line"></i>
                </div>
                <h5 class="fw-bold text-uppercase" style="letter-spacing: 1px;">System Reports</h5>
                <p class="text-muted text-center small mb-0">Export analytics, user logs, and financial data</p>
            </a>
        </div>

        <div class="col-md-4">
            <a href="dashboard.jsp" class="nav-card shadow-sm">
                <div class="icon-circle">
                    <i class="fa-solid fa-house-user"></i>
                </div>
                <h5 class="fw-bold text-uppercase" style="letter-spacing: 1px;">Main Dashboard</h5>
                <p class="text-muted text-center small mb-0">Return to standard front-desk operations</p>
            </a>
        </div>
    </div>
</div>

<footer class="text-center mt-5 py-4 opacity-50">
    <small style="letter-spacing: 1px;">&copy; 2026 OCEAN VIEW HOTEL | ADMIN MODULE</small>
</footer>

</body>
</html>