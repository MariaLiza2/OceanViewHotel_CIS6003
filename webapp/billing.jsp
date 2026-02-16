<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.Bill" %>
<%
    Bill bill = (Bill) request.getAttribute("bill");
    if (bill == null) {
        response.sendRedirect("addReservation");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Billing - Ocean View Hotel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script>
        function calculateTotal() {
            let days = document.getElementById('daysInput').value;
            let rate = document.getElementById('rateInput').value;
            let total = (days && rate) ? (parseFloat(days) * parseFloat(rate)) : 0;

            // Display total to user
            document.getElementById('totalDisplay').innerText = "LKR " + total.toLocaleString();

            // Set value for the Hidden Input so the Servlet can read it
            document.getElementById('totalAmountHidden').value = total;
        }
        window.onload = calculateTotal;
    </script>
</head>
<body class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <form action="billing" method="post">
                <input type="hidden" name="reservationId" value="<%= bill.getReservationId() %>">
                <input type="hidden" name="roomType" value="<%= bill.getRoomType() %>">
                <input type="hidden" name="totalAmount" id="totalAmountHidden" value="<%= bill.getAmountPerDay() %>">

                <div class="card shadow">
                    <div class="card-header bg-dark text-white text-center">
                        <h3 class="mb-0">Generate Bill</h3>
                    </div>
                    <div class="card-body p-4">
                        <div class="mb-3">
                            <label class="fw-bold">Room Category</label>
                            <input type="text" class="form-control bg-light" value="<%= bill.getRoomType() %>" readonly>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="fw-bold">Days</label>
                                <input type="number" id="daysInput" name="days" value="1" min="1" class="form-control" oninput="calculateTotal()">
                            </div>
                            <div class="col-6 mb-3">
                                <label class="fw-bold">Rate (LKR)</label>
                                <input type="number" id="rateInput" name="amount" value="<%= bill.getAmountPerDay() %>" class="form-control" oninput="calculateTotal()">
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="fw-bold">Payment Method</label>
                            <select name="paymentMethod" class="form-select" required>
                                <option value="Cash">Cash</option>
                                <option value="Card">Credit/Debit Card</option>
                                <option value="Online">Online Transfer</option>
                            </select>
                        </div>
                        <div class="alert alert-secondary text-center">
                            <h4 class="mb-0">Total: <span id="totalDisplay" class="text-success">LKR 0</span></h4>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold">Confirm Payment</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
</html>