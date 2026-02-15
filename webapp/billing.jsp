<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.Bill" %>
<%
    // 1. Get data from Servlet
    Bill bill = (Bill) request.getAttribute("bill");

    // 2. Safety Check
    if (bill == null) {
%>
    <div style="padding:50px; text-align:center;">
        <h2>No Active Billing Session</h2>
        <p>Please go back to <a href="BillingServlet">Manage Rooms</a> and click Billing there.</p>
    </div>
<%
        return; // STOP the page here if there is no bill data
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Billing - Ocean View</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script>
        function calculateTotal() {
            let days = document.getElementById('daysInput').value;
            let rate = document.getElementById('rateInput').value;
            let total = (days && rate) ? (parseFloat(days) * parseFloat(rate)) : 0;
            document.getElementById('totalDisplay').innerText = "LKR " + total.toLocaleString();
        }
    </script>
</head>
<body class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-dark text-white">
            <h3>Billing for <%= bill.getRoomType() %></h3>
        </div>
        <div class="card-body">
            <form action="billing" method="post">

                <div class="mb-3">
                    <label>Room Type</label>
                    <input type="text" class="form-control" value="<%= bill.getRoomType() %>" readonly>
                </div>
                <div class="mb-3">
                    <label>Days</label>
                    <input type="number" id="daysInput" name="days" value="1" class="form-control" oninput="calculateTotal()">
                </div>
                <div class="mb-3">
                    <label>Rate (LKR)</label>
                    <input type="number" id="rateInput" name="amount" value="<%= bill.getAmountPerDay() %>" class="form-control" oninput="calculateTotal()">
                </div>

                <div class="mb-4">
                                    <label class="form-label font-weight-bold">Payment Method</label>
                                    <select name="paymentMethod" class="form-select" required>
                                        <option value="" disabled selected>-- Select Method --</option>
                                        <option value="Cash">Cash</option>
                                        <option value="Card">Credit/Debit Card</option>
                                        <option value="Online">Online Transfer</option>
                                    </select>
                                </div>

                <h4 class="text-success">Total: <span id="totalDisplay">LKR <%= bill.getAmountPerDay() %></span></h4>

                <button type="submit" class="btn btn-primary w-100 mt-3">Confirm Payment</button>
            </form>
        </div>
    </div>
</body>
</html>