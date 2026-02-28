<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.oceanview.model.Reservation" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reservation Report | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --sage: #8A9A84; --sand: #D4A373; --cream: #F2F4F0; }
        body { background-color: var(--cream); padding-top: 50px; }
        .report-container { background: white; border-radius: 15px; padding: 40px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .table thead { background-color: var(--sage); color: white; }
        .status-badge { padding: 5px 10px; border-radius: 20px; font-size: 0.85rem; }
        @media print { .no-print { display: none; } }
    </style>
</head>
<body>
    <div class="container report-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 style="color: var(--sage);">Reservation Report</h2>
                <p class="text-muted">Date: ${selectedDate}</p>
            </div>
            <div class="no-print">
                <button onclick="window.print()" class="btn btn-outline-dark"><i class="fa fa-print"></i> Print</button>
                <a href="adminreports?type=reservations&action=download&reportDate=${selectedDate}" class="btn btn-success">
                    <i class="fa fa-file-pdf"></i> Download PDF
                </a>
                <a href="adminreports" class="btn btn-secondary">Back</a>
            </div>
        </div>

        <table class="table table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Guest Name</th>
                    <th>Room Type</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Reservation> resList = (List<Reservation>) request.getAttribute("resList");
                    if (resList != null && !resList.isEmpty()) {
                        for (Reservation r : resList) {
                %>
                <tr>
                    <td>#<%= r.getReservationId() %></td>
                    <td><%= r.getGuestName() %></td>
                    <td><%= r.getRoomType() %></td>
                    <td><%= r.getCheckIn() %></td>
                    <td><%= r.getCheckOut() %></td>
                    <td><span class="status-badge bg-light border"><%= r.getStatus() %></span></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="6" class="text-center text-muted">No reservations found for this date.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>