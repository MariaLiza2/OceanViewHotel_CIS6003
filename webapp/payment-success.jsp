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

    <a href="billing?action=download" class="btn btn-success mt-3">
        Download Receipt
    </a>

    <br><br>

    <a href="ManageRoomsServlet" class="btn btn-primary">
        Back to Rooms
    </a>
</div>

</body>
</html>
