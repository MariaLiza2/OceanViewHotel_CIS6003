<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.Bill" %>
<%
    Bill bill = (Bill) request.getAttribute("bill");
    if (bill == null) {
        response.sendRedirect("viewReservations");
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
            // FIX: Matching IDs with the input elements below to stop the console error
            const daysElem = document.getElementById('daysInput');
            const rateElem = document.getElementById('rateInput');
            const totalDisplay = document.getElementById('totalDisplay');
            const hiddenTotal = document.getElementById('totalAmountHidden');

            if (daysElem && rateElem && totalDisplay && hiddenTotal) {
                let days = parseFloat(daysElem.value) || 0;
                let rate = parseFloat(rateElem.value) || 0;
                let total = days * rate;

                // Updates the visual LKR 0.00 to the correct amount
                totalDisplay.innerText = "LKR " + total.toLocaleString();

                // Updates the hidden field so BillingServlet gets the data
                hiddenTotal.value = total.toFixed(2);
            }
        }
        window.onload = calculateTotal;
    </script>
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <form action="billing" method="post">
                    <input type="hidden" name="reservationId" value="<%= bill.getReservationId() %>">
                    <input type="hidden" name="resNum" value="${resNum}">
                    <input type="hidden" name="roomType" value="<%= bill.getRoomType() %>">
                    <input type="hidden" name="totalAmount" id="totalAmountHidden" value="${bill.total}">

                    <div class="card shadow border-0">
                       <div class="card-header bg-dark text-white p-3 text-center">
                           <h4 class="mb-0">Invoice Generation</h4>
                           <small>Reservation: ${resNum != null ? resNum : "N/A"}</small>
                       </div>
                        <div class="card-body p-4">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Room Category</label>
                                <input type="text" class="form-control bg-light" value="<%= bill.getRoomType() %>" readonly>
                            </div>

                            <div class="row">
                               <div class="mb-3 col-6">
                                   <label>Stay Duration (Days)</label>
                                   <input type="text" id="daysInput" name="days" value="${bill.days}" class="form-control" readonly>
                               </div>

                               <div class="mb-3 col-6">
                                   <label>Daily Rate (LKR)</label>
                                   <input type="text" id="rateInput" name="amount" value="${bill.amountPerDay}" class="form-control" readonly>
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
                                <span class="text-muted small d-block">Grand Total</span>
                                <h2 id="totalDisplay" class="text-success fw-bold">LKR ${bill.total}</h2>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">Confirm & Generate Receipt</button>
                            <a href="viewReservations" class="btn btn-link w-100 text-muted mt-2">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>