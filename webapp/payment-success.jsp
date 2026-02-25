<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.Bill" %>
<%
    Bill bill = (Bill) session.getAttribute("bill");
    String receiptNo = (String) session.getAttribute("receiptNo");

    if (bill == null) {
        response.sendRedirect("ManageRoomsServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transaction Complete | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;
            --primary-sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --accent-sand: #D4A373;
            --white: #ffffff;
            --success-green: #9DBF9E;
        }

        body {
            background-color: var(--bg-sage-light);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }

        .success-card {
            background: var(--white);
            max-width: 500px;
            width: 100%;
            padding: 50px 40px;
            border-radius: 4px;
            box-shadow: 0 15px 40px rgba(94, 107, 90, 0.1);
            text-align: center;
            border-top: 6px solid var(--success-green);
        }

        .icon-circle {
            width: 80px;
            height: 80px;
            background-color: var(--bg-sage-light);
            color: var(--success-green);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 25px;
        }

        .success-title {
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 300;
            color: var(--deep-sage);
            margin-bottom: 30px;
        }

        .receipt-details {
            background-color: #fafafa;
            border: 1px dashed #d1d1d1;
            padding: 25px;
            margin-bottom: 30px;
            text-align: left;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 0.9rem;
        }

        .detail-label {
            color: var(--primary-sage);
            text-transform: uppercase;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 1px;
        }

        .btn-download {
            background-color: var(--deep-sage);
            color: white;
            border: none;
            padding: 12px 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            width: 100%;
            margin-bottom: 15px;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-download:hover {
            background-color: var(--primary-sage);
            color: white;
        }

        .nav-links {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 10px;
        }

        .nav-link-item {
            color: var(--primary-sage);
            text-decoration: none;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            border-bottom: 1px solid transparent;
            transition: 0.3s;
        }

        .nav-link-item:hover {
            color: var(--accent-sand);
            border-bottom: 1px solid var(--accent-sand);
        }
    </style>
</head>
<body>

<div class="success-card">
    <div class="icon-circle">
        <i class="fa-solid fa-circle-check"></i>
    </div>

    <h2 class="success-title">Payment Received</h2>

    <div class="receipt-details">
        <div class="detail-row">
            <span class="detail-label">Receipt Number</span>
            <span class="fw-bold"><%= receiptNo %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Accommodation</span>
            <span><%= bill.getRoomType() %></span>
        </div>
        <hr class="opacity-10">
        <div class="detail-row mt-2">
            <span class="detail-label">Total Amount</span>
            <span class="fw-bold text-dark" style="font-size: 1.1rem;">LKR <%= bill.getTotal() %></span>
        </div>
    </div>

    <a href="billing?action=download&resId=${bill.reservationId}" class="btn-download">
        <i class="fa-solid fa-file-pdf me-2"></i> Download PDF Receipt
    </a>

    <div class="nav-links">
        <a href="viewReservations" class="nav-link-item">Reservations</a>
        <span class="text-muted opacity-25">|</span>
        <a href="dashboard.jsp" class="nav-link-item">Dashboard</a>
    </div>
</div>

</body>
</html>