<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Reservation" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<%!
    public double getRate(String type) {
        if ("Double".equalsIgnoreCase(type)) return 4500.0;
        if ("Luxury".equalsIgnoreCase(type)) return 8500.0;
        return 2500.0;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reservation History</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="main-container container mt-4">
    <h2>Guest Reservation History</h2>

    <div style="margin-bottom: 20px; background: #ecf0f1; padding: 15px; border-radius: 8px;">
        <form action="${pageContext.request.contextPath}/viewReservations" method="get" style="display: flex; gap: 10px;">
            <input type="text" name="searchName" placeholder="Enter Guest Name (e.g. Kate)..."
                   style="flex: 1; padding: 10px; border: 1px solid #bdc3c7; border-radius: 4px;">
            <button type="submit" class="btn btn-success">
                Search History
            </button>
            <a href="${pageContext.request.contextPath}/viewReservations" class="btn btn-secondary">Reset</a>
        </form>
    </div>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Res. Number</th>
                <th>Guest Name</th>
                <th>Room Type</th>
                <th>Check-In</th>
                <th>Check-Out</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Reservation> list = (List<Reservation>) request.getAttribute("reservations");
                if (list != null) {
                    for (Reservation r : list) {
                        // Use the formatted number from the DAO
                        String displayNum = r.getReservationNumber();

                        // Handle the Status
                        String currentStatus = r.getStatus();
                        if (currentStatus == null) currentStatus = "PENDING";

                        // Bootstrap 5 Badge Classes
                        String badgeClass = currentStatus.equalsIgnoreCase("PAID") ? "bg-success" : "bg-warning text-dark";
            %>
                <tr>
                    <td><%= r.getReservationId() %></td>
                    <td><strong><%= displayNum %></strong></td>
                    <td><%= r.getGuestName() %></td>
                    <td><%= r.getRoomType() %></td>
                    <td><%= r.getCheckIn() %></td>
                    <td><%= r.getCheckOut() %></td>

                    <td>
                        <span class="badge <%= badgeClass %>"><%= currentStatus.toUpperCase() %></span>
                    </td>

                    <td>
                        <% if("PAID".equalsIgnoreCase(currentStatus)) { %>
                            <span class="text-success fw-bold">✓ Completed</span>
                        <% } else { %>
                            <a href="billing?id=<%= r.getReservationId() %>&type=<%= r.getRoomType() %>&resNum=<%= displayNum %>"
                               class="btn btn-sm btn-primary">
                               Billing
                            </a>
                        <% } %>
                    </td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="8" class="text-center">No reservations found.</td>
                </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <div class="mt-4">
        <a href="dashboard.jsp" class="btn btn-outline-secondary">Back to Dashboard</a>
    </div>
</div>
</body>
</html>