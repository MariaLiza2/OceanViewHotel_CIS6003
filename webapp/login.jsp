<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <title>Staff Portal | Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;
            --primary-sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --accent-sand: #D4A373;
            --white: #ffffff;
            --error-coral: #D48C8C;
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
            border-radius: 4px; /* Minimalist sharp corners */
            box-shadow: 0 15px 35px rgba(94, 107, 90, 0.08);
            max-width: 400px;
            width: 100%;
            text-align: center;
            border: 1px solid rgba(138, 154, 132, 0.1);
        }

        .login-card h2 {
            font-weight: 300;
            letter-spacing: 4px;
            text-transform: uppercase;
            margin-bottom: 30px;
            color: var(--deep-sage);
            font-size: 1.4rem;
        }

        .form-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 600;
            color: var(--primary-sage);
            display: block;
            text-align: left;
            margin-bottom: 8px;
        }

        .form-control {
            border: 1px solid #e1e1e1;
            border-radius: 0;
            padding: 12px;
            margin-bottom: 20px;
            transition: 0.3s;
        }

        .form-control:focus {
            box-shadow: none;
            border-color: var(--accent-sand);
            background-color: #fafafa;
        }

        .btn-login {
            background-color: var(--primary-sage);
            color: white;
            border: none;
            padding: 14px;
            width: 100%;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 600;
            transition: 0.3s;
            margin-top: 10px;
        }

        .btn-login:hover {
            background-color: var(--deep-sage);
            color: white;
            transform: translateY(-2px);
        }

        hr {
            margin: 30px 0;
            opacity: 0.1;
        }

        .register-link {
            color: var(--deep-sage);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--accent-sand);
            transition: 0.3s;
        }

        .register-link:hover {
            color: var(--accent-sand);
        }

        .error-msg {
            background-color: #fff5f5;
            color: var(--error-coral);
            padding: 10px;
            font-size: 0.85rem;
            margin-top: 20px;
            border-left: 3px solid var(--error-coral);
            text-align: left;
        }

        .brand-logo {
            color: var(--accent-sand);
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="login-card">

<div style="text-align: center; padding-top: 40px; margin-bottom: 40px; font-family: 'Segoe UI', Arial, sans-serif;">

    <h3 style="color: #4A5D45; font-weight: 800; letter-spacing: 5px; text-transform: uppercase; margin: 0 0 10px 0;">
        Ocean View Hotel
    </h3>

    <h5 style="color: #6c757d; font-weight: 300; font-size: 1.3rem; letter-spacing: 2px; margin: 0;">
        No 261, Church Street, Galle.
    </h5>

    <div style="display: flex; align-items: center; justify-content: center; margin-top: 25px;">
        <div style="height: 1px; width: 80px; background-color: #C2956E; opacity: 0.6;"></div>
        <span style="margin: 0 20px; color: #C2956E; font-size: 1.5rem; line-height: 1;">🦀</span>
        <div style="height: 1px; width: 80px; background-color: #C2956E; opacity: 0.6;"></div>
    </div>
</div>
    <h4>Staff Access</h4>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <input type="text" id="username" name="username" class="form-control" placeholder="Enter ID" required>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
        </div>

        <button type="submit" class="btn-login">Sign In</button>
    </form>

    <hr>

    <div class="mb-2">
        <a href="register.jsp" class="register-link">Create Account</a>
    </div>

    <%-- Error message --%>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error-msg">
            <i class="fa-solid fa-circle-exclamation me-2"></i>
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
</div>

</body>
</html>