<%@ page import="java.util.List, com.oceanview.model.Payment" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Payment History | Ocean View Hotel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .table-header { background-color: #4da3ff; color: white; }
        .page-title { color: #2c3e50; border-bottom: 3px solid #4da3ff; padding-bottom: 10px; font-weight: bold; }
        .card { border: none; border-radius: 8px; }
        .table thead th { border-top: none; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="page-title mb-4">Payment History</h2>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form action="viewPayments" method="get">
                <div class="row g-2">
                    <div class="col-md-9">
                        <input type="text" name="searchQuery" class="form-control"
                               placeholder="Enter Reservation Number (e.g. OVH-048)..."
                               value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>">
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-success flex-grow-1">Search History</button>
                        <a href="viewPayments" class="btn btn-secondary">Reset</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-header">
                    <tr>
                        <th class="ps-3">ID</th>
                        <th>Res. Number</th>
                        <th>Room Type</th>
                        <th>Amount (LKR)</th>
                        <th>Method</th>
                        <th>Payment Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Retrieve the list from the Servlet
                        List<Payment> payments = (List<Payment>) request.getAttribute("payments");

                        if (payments != null && !payments.isEmpty()) {
                            for (Payment p : payments) {
                    %>
                        <tr>
                            <td class="ps-3 text-muted"><%= p.getReservationId() %></td>
                            <td class="text-primary fw-bold"><%= p.getReservationNumber() %></td> <td><%= p.getRoomType() %></td>
                            <td><%= p.getTotalAmount() %></td>
                            <td><span class="badge rounded-pill bg-info text-dark"><%= p.getPaymentMethod() %></span></td>
                            <td class="text-muted small"><%= p.getPaymentDate() %></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                No payment records found in the database.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="mt-4">
        <a href="dashboard.jsp" class="btn btn-outline-secondary">Back to Dashboard</a>
    </div>
</div>

</body>
</html>