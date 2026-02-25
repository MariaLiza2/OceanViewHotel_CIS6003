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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout & Billing | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;
            --primary-sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --accent-sand: #D4A373;
            --white: #ffffff;
        }

        body {
            background-color: var(--bg-sage-light);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
            padding: 50px 0;
        }

        .billing-card {
            background: var(--white);
            border-radius: 4px; /* Minimalist sharp corners */
            box-shadow: 0 10px 30px rgba(94, 107, 90, 0.05);
            border: 1px solid rgba(138, 154, 132, 0.1);
            overflow: hidden;
        }

        .card-header-sage {
            background-color: var(--deep-sage);
            color: var(--white);
            padding: 30px;
            text-align: center;
            border-bottom: 4px solid var(--accent-sand);
        }

        .card-header-sage h4 {
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 300;
            margin: 0;
        }

        .form-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            color: var(--primary-sage);
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border: 1px solid #e1e1e1;
            border-radius: 0;
            padding: 12px;
            color: var(--deep-sage);
            transition: 0.3s;
        }

        .form-control[readonly] {
            background-color: var(--bg-sage-light) !important;
            border-color: transparent;
        }

        .total-box {
            background-color: var(--bg-sage-light);
            border-left: 4px solid var(--accent-sand);
            padding: 25px;
            text-align: center;
        }

        .total-amount {
            color: var(--deep-sage);
            font-weight: 700;
            margin: 0;
        }

        .btn-checkout {
            background-color: var(--primary-sage);
            color: white;
            border: none;
            padding: 15px;
            width: 100%;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-checkout:hover {
            background-color: var(--deep-sage);
            color: white;
        }

        .cancel-link {
            display: inline-block;
            margin-top: 15px;
            color: var(--deep-sage);
            text-decoration: none;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.7;
        }

        .cancel-link:hover { opacity: 1; color: #F66E6A; }
    </style>

    <script>
        function calculateTotal() {
            const daysElem = document.getElementById('daysInput');
            const rateElem = document.getElementById('rateInput');
            const totalDisplay = document.getElementById('totalDisplay');
            const hiddenTotal = document.getElementById('totalAmountHidden');

            if (daysElem && rateElem && totalDisplay && hiddenTotal) {
                let days = parseFloat(daysElem.value) || 0;
                let rate = parseFloat(rateElem.value) || 0;
                let total = days * rate;

                totalDisplay.innerText = "LKR " + total.toLocaleString();
                hiddenTotal.value = total.toFixed(2);
            }
        }
        window.onload = calculateTotal;
    </script>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <form action="billing" method="post">
                <input type="hidden" name="reservationId" value="<%= bill.getReservationId() %>">
                <input type="hidden" name="resNum" value="${resNum}">
                <input type="hidden" name="roomType" value="<%= bill.getRoomType() %>">
                <input type="hidden" name="totalAmount" id="totalAmountHidden" value="${bill.total}">

                <div class="billing-card">
                    <div class="card-header-sage">
                        <h4>Invoice Entry</h4>
                        <small class="opacity-75">ID: ${resNum != null ? resNum : "N/A"}</small>
                    </div>

                    <div class="card-body p-4">
                        <div class="mb-4">
                            <label class="form-label">Selected Accommodation</label>
                            <input type="text" class="form-control" value="<%= bill.getRoomType() %>" readonly>
                        </div>

                        <div class="row mb-4">
                            <div class="col-6">
                                <label class="form-label">Duration</label>
                                <div class="input-group">
                                    <input type="text" id="daysInput" name="days" value="${bill.days}" class="form-control text-center" readonly>
                                    <span class="input-group-text bg-white border-0 small text-muted">Days</span>
                                </div>
                            </div>

                            <div class="col-6">
                                <label class="form-label">Rate</label>
                                <input type="text" id="rateInput" name="amount" value="${bill.amountPerDay}" class="form-control text-center" readonly>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Payment Method</label>
                            <select name="paymentMethod" class="form-select" required>
                                <option value="Cash">Cash Payment</option>
                                <option value="Card">Credit / Debit Card</option>
                                <option value="Online">Online Bank Transfer</option>
                            </select>
                        </div>

                        <div class="total-box mb-4">
                            <span class="form-label d-block mb-1">Final Settlement</span>
                            <h2 id="totalDisplay" class="total-amount">LKR ${bill.total}</h2>
                        </div>

                        <button type="submit" class="btn-checkout">
                            <i class="fa-solid fa-receipt me-2"></i> Confirm & Generate
                        </button>

                        <div class="text-center">
                            <a href="viewReservations" class="cancel-link">Discard and return</a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<footer class="text-center mt-5 opacity-50">
    <small>OCEAN VIEW HOTEL | SECURE BILLING PORTAL</small>
</footer>

</body>
</html>