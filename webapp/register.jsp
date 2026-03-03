<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Staff Registration | Ocean View</title>
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
        }

        .register-card {
            background: var(--white);
            border: 1px solid rgba(138, 154, 132, 0.15);
            border-radius: 4px; /* Sharp corners for professional look */
            box-shadow: 0 15px 35px rgba(94, 107, 90, 0.08);
            padding: 40px;
        }

        .brand-icon {
            color: var(--accent-sand);
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .header-title {
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 300;
            color: var(--deep-sage);
        }

        .form-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 600;
            color: var(--primary-sage);
            margin-bottom: 8px;
        }

        .input-group-text {
            background-color: var(--bg-sage-light);
            border: 1px solid #e1e1e1;
            border-radius: 0;
            color: var(--primary-sage);
        }

        .form-control, .form-select {
            border: 1px solid #e1e1e1;
            border-radius: 0;
            padding: 12px;
            transition: all 0.3s;
            color: var(--deep-sage);
        }

        .form-control:focus, .form-select:focus {
            box-shadow: none;
            border-color: var(--accent-sand);
            background-color: #fafafa;
        }

        .btn-register {
            background-color: var(--primary-sage);
            color: white;
            border: none;
            padding: 14px;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 600;
            transition: 0.3s;
            margin-top: 10px;
        }

        .btn-register:hover {
            background-color: var(--deep-sage);
            color: white;
            transform: translateY(-2px);
        }

        .login-link {
            color: var(--deep-sage);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--accent-sand);
            transition: 0.3s;
        }

        .login-link:hover {
            color: var(--accent-sand);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card register-card">
                <div class="card-body">
                    <div class="text-center mb-4">
                        <div class="brand-icon">
                            <i class="fa-solid fa-user-plus"></i>
                        </div>
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
                        <h2 class="header-title">Create Account</h2>
                        <p class="text-muted small">Access the OceanView Management System</p>
                    </div>

                    <form action="register" method="post">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                <input type="text" name="username" class="form-control" placeholder="Select a system ID" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-key"></i></span>
                                <input type="password" name="password" class="form-control" placeholder="Create a secure password" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Access Level</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-shield-halved"></i></span>
                                <select name="role" class="form-select">
                                    <option value="Staff">Staff / Receptionist</option>
                                    <option value="Admin">System Administrator</option>
                                </select>
                            </div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn-register">Confirm Registration</button>
                        </div>
                    </form>

                    <div class="text-center mt-4 pt-2">
                        <p class="mb-0 small text-muted">Authorized personnel only.</p>
                        <a href="login.jsp" class="login-link">Back to Staff Login</a>
                    </div>
                </div>
            </div>
            <div class="text-center mt-4">
                <small class="text-muted opacity-50" style="letter-spacing: 1px;">&copy; 2026 OCEAN VIEW HOTEL SYSTEMS</small>
            </div>
        </div>
    </div>
</div>

</body>
</html>