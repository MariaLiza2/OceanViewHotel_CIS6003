<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.Bill" %>
<%
    // Retrieve the bill object set by BillingServlet's doGet
    Bill bill = (Bill) request.getAttribute("bill");

    // Safety check: if someone tries to access this page directly without a reservation
    if (bill == null) {
        response.sendRedirect("addReservation"); // Redirect to your reservation list
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
            // Get values from the input fields
            let days = document.getElementById('daysInput').value;
            let rate = document.getElementById('rateInput').value;

            // Calculate total
            let total = (days && rate) ? (parseFloat(days) * parseFloat(rate)) : 0;

            // Update the visual display for the user
            document.getElementById('totalDisplay').innerText = "LKR " + total.toLocaleString();

            // CRITICAL: Update the hidden input field that the Servlet will actually read
            document.getElementById('totalAmountHidden').value = total;
        }

        // Run calculation once when the page loads to show initial total
        window.onload = calculateTotal;
    </script>
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <form action="billing" method="post">
                    <input type="hidden" name="reservationId" value="<%= bill.getReservationId() %>">
                    <input type="hidden" name="roomType" value="<%= bill.getRoomType() %>">
                    <input type="hidden" name="totalAmount" id="totalAmountHidden" value="">

                    <div class="card shadow border-0">
                        <div class="card-header bg-dark text-white p-3 text-center">
                            <h4 class="mb-0">Invoice Generation</h4>
                            <small>Res ID: #<%= bill.getReservationId() %></small>
                        </div>
                        <div class="card-body p-4">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Room Category</label>
                                <input type="text" class="form-control bg-light" value="<%= bill.getRoomType() %>" readonly>
                            </div>

                            <div class="row">
                                <div class="col-6 mb-3">
                                    <label class="form-label fw-bold">Stay Duration (Days)</label>
                                    <input type="number" id="daysInput" name="days" value="1" min="1"
                                           class="form-control" oninput="calculateTotal()">
                                </div>
                                <div class="col-6 mb-3">
                                    <label class="form-label fw-bold">Rate Per Day (LKR)</label>
                                    <input type="number" id="rateInput" name="amount"
                                           value="<%= bill.getAmountPerDay() %>" class="form-control" readonly>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold">Payment Method</label>
                                <select name="paymentMethod" class="form-select" required>
                                    <option value="Cash">Cash</option>
                                    <option value="Card">Credit/Debit Card</option>
                                    <option value="Online">Online Transfer</option>
                                </select>
                            </div>

                            <div class="p-3 bg-light rounded text-center mb-3">
                                <span class="text-muted d-block small">Grand Total</span>
                                <h2 class="text-success mb-0" id="totalDisplay">LKR 0.00</h2>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">Confirm & Generate Receipt</button>
                            <a href="addReservation" class="btn btn-link w-100 text-muted mt-2">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>