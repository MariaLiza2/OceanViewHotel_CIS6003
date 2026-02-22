<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View - Guest Registration</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0">Guest Registration Form</h3>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/addReservation" method="post">


                        <div class="mb-3">
                            <label class="form-label">Guest Full Name</label>
                            <input type="text" name="guestName" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Address</label>
                            <textarea name="address" class="form-control" rows="2" required></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Contact Number</label>
                            <input type="text" name="contactNumber" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Room Type</label>
                            <select name="roomType" class="form-select">
                                <option value="Single">Single</option>
                                <option value="Double">Double</option>
                                <option value="Suite">Suite</option>
                                <option value="Deluxe">Deluxe</option>
                            </select>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Check-In Date</label>
                                <input type="date" name="checkIn" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Check-Out Date</label>
                                <input type="date" name="checkOut" class="form-control" required>
                            </div>
                        </div>

                       <form action="${pageContext.request.contextPath}/addReservation" method="post">
                           <button type="submit" class="btn-custom">Confirm Reservation</button>
                       </form>
<div class="mt-4">
        <a href="dashboard.jsp" class="btn btn-outline-secondary">Back to Dashboard</a>
    </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>