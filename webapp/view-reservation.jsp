<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.Reservation" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Guest Profile | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --sand: #D4A373;
            --cream: #F2F4F0;
        }
        body { background-color: var(--cream); font-family: 'Inter', sans-serif; padding: 60px 20px; }
        .profile-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            max-width: 700px;
            margin: auto;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        .profile-header {
            background: var(--sage);
            color: white;
            padding: 40px;
            text-align: center;
        }
        .profile-body { padding: 40px; }
        .info-group { margin-bottom: 25px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--sand);
            font-weight: bold;
        }
        .info-value { font-size: 1.1rem; color: var(--deep-sage); font-weight: 500; }
        .btn-back { border: 2px solid var(--sage); color: var(--sage); font-weight: 600; transition: 0.3s; }
        .btn-back:hover { background: var(--sage); color: white; }
    </style>
</head>
<body>
    <div class="profile-card">
        <% Reservation r = (Reservation) request.getAttribute("res"); %>
        <div class="profile-header">
            <i class="fa-solid fa-circle-user fa-4x mb-3"></i>
            <h2 class="m-0"><%= r.getGuestName() %></h2>
            <p class="opacity-75 mb-0">Reservation ID: #<%= r.getReservationNumber() %></p>
        </div>

        <div class="profile-body">
            <div class="row">
                <div class="col-md-6 info-group">
                    <div class="info-label">Room Category</div>
                    <div class="info-value"><%= r.getRoomType() %></div>
                </div>
                <div class="col-md-6 info-group">
                    <div class="info-label">Current Status</div>
                    <div class="info-value text-success"><%= r.getStatus() %></div>
                </div>
                <div class="col-md-6 info-group">
                    <div class="info-label">Check-In Date</div>
                    <div class="info-value"><%= r.getCheckIn() %></div>
                </div>
                <div class="col-md-6 info-group">
                    <div class="info-label">Check-Out Date</div>
                    <div class="info-value"><%= r.getCheckOut() %></div>
                </div>
            </div>

            <div class="d-flex gap-3 mt-4">
                <a href="manageReservation" class="btn btn-back flex-grow-1">BACK TO LIST</a>
                <a href="manageReservation?action=edit&id=<%= r.getReservationId() %>" class="btn btn-dark flex-grow-1">EDIT GUEST</a>
            </div>
        </div>
    </div>
</body>
</html>