<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Guest Registration | Ocean View</title>
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
            padding: 50px 0;
        }

        .registration-card {
            background: var(--white);
            border-radius: 4px;
            box-shadow: 0 10px 30px rgba(94, 107, 90, 0.05);
            border: 1px solid rgba(138, 154, 132, 0.1);
            overflow: hidden;
        }

        .card-header-sage {
            background-color: var(--deep-sage);
            color: var(--white);
            padding: 30px;
            text-align: center;
            border-bottom: 4px solid var(--accent-sand);
        }

        .card-header-sage h3 {
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 300;
            margin: 0;
        }

        .form-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            color: var(--primary-sage);
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border: 1px solid #e1e1e1;
            border-radius: 0;
            padding: 12px;
            color: var(--deep-sage);
            transition: 0.3s;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: none;
            border-color: var(--accent-sand);
            background-color: #fafafa;
        }

        .btn-confirm {
            background-color: var(--primary-sage);
            color: white;
            border: none;
            padding: 15px;
            width: 100%;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 600;
            transition: 0.3s;
            margin-top: 10px;
        }

        .btn-confirm:hover {
            background-color: var(--deep-sage);
            color: white;
            transform: translateY(-2px);
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: var(--deep-sage);
            text-decoration: none;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--accent-sand);
            transition: 0.3s;
        }

        .back-link:hover {
            color: var(--accent-sand);
        }

        .input-group-text {
            background-color: var(--bg-sage-light);
            border: 1px solid #e1e1e1;
            border-radius: 0;
            color: var(--primary-sage);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="registration-card">
                <div class="card-header-sage">
                    <h3>Guest Registration</h3>
                    <p class="small mb-0 opacity-75">Ocean View Resort Management System</p>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="<%=request.getContextPath()%>/addReservation" method="post">

                        <div class="mb-4">
                            <label class="form-label">Guest Full Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                <input type="text" name="guestName" class="form-control" placeholder="Enter name as per ID" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Contact Number</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                                <input type="text" name="contactNumber" class="form-control" placeholder="+94 7X XXX XXXX" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Residential Address</label>
                            <textarea name="address" class="form-control" rows="2" placeholder="Street, City, Country" required></textarea>
                        </div>

                        <hr class="my-4 opacity-25">

                        <div class="row">
                            <div class="col-md-12 mb-4">
                                <label class="form-label">Requested Room Category</label>
                                <select name="roomType" class="form-select">
                                    <option value="Single">Single Room</option>
                                    <option value="Double">Double Room</option>
                                    <option value="Suite">Executive Suite</option>
                                    <option value="Deluxe">Deluxe Ocean View</option>
                                </select>
                            </div>

                            <div class="col-md-6 mb-4">
                                <label class="form-label">Check-In Date</label>
                                <input type="date" name="checkIn" class="form-control" required>
                            </div>

                            <div class="col-md-6 mb-4">
                                <label class="form-label">Check-Out Date</label>
                                <input type="date" name="checkOut" class="form-control" required>
                            </div>
                        </div>

                        <button type="submit" class="btn-confirm">
                            <i class="fa-solid fa-calendar-check me-2"></i> Confirm Reservation
                        </button>
                    </form>

                    <div class="text-center mt-3">
                        <a href="dashboard.jsp" class="back-link">
                            <i class="fa-solid fa-arrow-left me-1"></i> Return to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="text-center mt-5 opacity-50">
    <small>REGISTERED STAFF PORTAL &copy; 2026</small>
</footer>

</body>
</html>