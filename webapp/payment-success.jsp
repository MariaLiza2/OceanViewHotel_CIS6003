<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.Bill" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<%
    Bill bill = (Bill) session.getAttribute("bill");
    String receiptNo = (String) session.getAttribute("receiptNo");

    if (bill == null) {
        response.sendRedirect("ManageRoomsServlet");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Successful</title>
    <link rel="stylesheet"
     href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">

<div class="card shadow p-4 text-center">
    <h2 class="text-success">Payment Successful!</h2>

    <p><strong>Receipt No:</strong> <%= receiptNo %></p>
    <p><strong>Room:</strong> <%= bill.getRoomType() %></p>
    <p><strong>Total Paid:</strong> LKR <%= bill.getTotal() %></p>

    <div class="mt-4">
        <a href="billing?action=download&resId=${bill.reservationId}" class="btn btn-outline-primary">
            <i class="fas fa-download"></i> Download Receipt (PDF)
        </a>
        <a href="viewReservations" class="btn btn-secondary">Back to List</a>
    </div>
<div class="mt-4">
        <a href="dashboard.jsp" class="btn btn-outline-secondary">Back to Dashboard</a>
    </div>
    <br><br>


</div>

</body>
</html>
