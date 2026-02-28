<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Report | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --sage: #8A9A84; --sand: #D4A373; --cream: #F2F4F0; }
        body { background-color: var(--cream); padding-top: 50px; }
        .report-container { background: white; border-radius: 15px; padding: 40px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .table thead { background-color: var(--sage); color: white; }
        .total-row { background-color: #f8f9fa; font-weight: bold; font-size: 1.2rem; }
        @media print { .no-print { display: none; } }
    </style>
</head>
<body>
    <div class="container report-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 style="color: var(--sage);">Payment Settlement</h2>
                <p class="text-muted">Transaction Date: ${selectedDate}</p>
            </div>
            <div class="no-print">
                <button onclick="window.print()" class="btn btn-outline-dark"><i class="fa fa-print"></i> Print</button>
                <a href="adminreports?type=payments&action=download&reportDate=${selectedDate}" class="btn btn-success">
                    <i class="fa-solid fa-file-pdf"></i> Download PDF
                </a>
                <a href="adminreports" class="btn btn-secondary">Back</a>
            </div>
        </div>

        <table class="table table-striped">
            <%-- Change the Table Head --%>
            <thead>
                <tr>
                    <th>Payment ID</th>
                    <th>Reservation ID</th>
                    <th>Method</th>
                    <th>Time</th>
                    <th class="text-end">Amount (LKR)</th>
                </tr>
            </thead>

            <%-- Change the Table Body Loop --%>
            <tbody>
                <%
                    List<Map<String, Object>> payList = (List<Map<String, Object>>) request.getAttribute("payList");
                    double totalRevenue = 0;
                    if (payList != null && !payList.isEmpty()) {
                        for (Map<String, Object> p : payList) {
                            // Ensure you use 'amount' which we mapped from 'total_amount' in the servlet
                            double amt = (Double) p.get("amount");
                            totalRevenue += amt;
                %>
                <tr>
                    <td>#<%= p.get("id") %></td>
                    <td>#<%= p.get("resId") %></td>
                    <td><%= p.get("method") %></td>
                    <td><%= p.get("date") %></td>
                    <td class="text-end">LKR <%= String.format("%,.2f", amt) %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="5" class="text-center text-muted">No transactions recorded for this date.</td></tr>
                <% } %>
            </tbody>

            <%-- Change the Table Footer --%>
            <tfoot>
                <tr class="total-row">
                    <td colspan="4" class="text-end">TOTAL REVENUE</td>
                    <td class="text-end" style="color: var(--sage);">LKR <%= String.format("%,.2f", totalRevenue) %></td>
                </tr>
            </tfoot>
        </table>
    </div>
</body>
</html>