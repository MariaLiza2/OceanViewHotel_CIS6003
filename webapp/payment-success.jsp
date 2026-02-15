<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.Bill" %>
<%
    Bill bill = (Bill) request.getAttribute("bill");
    // Get the payment method from the request if you passed it through the servlet
    String paymentMethod = request.getParameter("paymentMethod");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Successful - Ocean View</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">

<div class="card shadow p-4 text-center" style="max-width: 500px; margin: auto;">
    <div class="mb-3">
        <span style="font-size: 50px;">✅</span>
    </div>
    <h2 class="text-success">Payment Successful!</h2>
    <hr>

    <div class="text-start ms-4">
        <p><strong>Room Type:</strong> <%= bill.getRoomType() %></p>
        <p><strong>Days:</strong> <%= bill.getDays() %></p>
        <p><strong>Rate:</strong> LKR <%= String.format("%,.2f", bill.getAmountPerDay()) %></p>
        <p><strong>Method:</strong> <%= (paymentMethod != null) ? paymentMethod : "Confirmed" %></p>
        <h4 class="mt-3"><strong>Total Paid:</strong> LKR <%= String.format("%,.2f", bill.getTotal()) %></h4>
    </div>

    <a href="${pageContext.request.contextPath}/viewReservations" class="btn btn-primary mt-4 w-100">
        Return to Reservation List
    </a>
</div>

</body>
</html>