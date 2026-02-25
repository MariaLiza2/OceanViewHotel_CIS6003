<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;
            --primary-sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --accent-sand: #D4A373;
            --white: #ffffff;
            --error-coral: #F66E6A;
        }

        body {
            background-color: var(--bg-sage-light);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        .login-card {
            background: var(--white);
            padding: 50px 40px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(94, 107, 90, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
            border: 1px solid rgba(138, 154, 132, 0.1);
        }

        .login-card h2 {
            font-weight: 300;
            letter-spacing: 3px;
            text-transform: uppercase;
            margin-bottom: 30px;
            color: var(--deep-sage);
            font-size: 1.5rem;
        }

        .form-group {
            text-align: left;
            margin-bottom: 20px;
        }

        .form-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            color: var(--primary-sage);
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            border: none;
            border-bottom: 2px solid var(--bg-sage-light);
            border-radius: 0;
            padding: 10px 5px;
            transition: all 0.3s ease;
            color: var(--deep-sage);
        }

        .form-control:focus {
            box-shadow: none;
            border-color: var(--accent-sand);
            background-color: transparent;
        }

        .btn-login {
            background-color: var(--primary-sage);
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            border-radius: 5px;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 600;
            margin-top: 20px;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            background-color: var(--deep-sage);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            color: white;
        }

        .btn-dashboard {
            display: inline-block;
            margin-top: 25px;
            color: var(--primary-sage);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--accent-sand);
            transition: 0.3s;
        }

        .btn-dashboard:hover {
            color: var(--accent-sand);
            border-color: var(--deep-sage);
        }

        .error-msg {
            color: var(--error-coral);
            font-size: 0.85rem;
            margin-top: 15px;
            font-style: italic;
        }

        .brand-icon {
            font-size: 2.5rem;
            color: var(--accent-sand);
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="brand-icon">
        <i class="fa-solid fa-user-shield"></i>
    </div>
    <h2>Admin Access</h2>

    <form action="AdminLoginServlet" method="post">
        <div class="form-group">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control" placeholder="Enter administrator ID" required>
        </div>

        <div class="form-group">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="••••••••" required>
        </div>

        <button type="submit" class="btn-login">Authorize Login</button>

        <% if (request.getAttribute("error") != null || session.getAttribute("error") != null) { %>
            <p class="error-msg">
                <i class="fa-solid fa-circle-exclamation me-1"></i>
                ${error}
            </p>
        <% } %>
    </form>

    <div class="text-center">
        <a href="dashboard.jsp" class="btn-dashboard">
            <i class="fa-solid fa-arrow-left me-2"></i>Return to Dashboard
        </a>
    </div>
</div>

</body>
</html>