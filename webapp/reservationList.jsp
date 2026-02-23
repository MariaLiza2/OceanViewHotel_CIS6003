<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Reservation" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<%!
    // This is a JSP Declaration block (note the ! symbol)
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

<div class="main-container">
    <h2>Guest Reservation History</h2>

    <div style="margin-bottom: 20px; background: #ecf0f1; padding: 15px; border-radius: 8px;">
        <form action="${pageContext.request.contextPath}/viewReservations" method="get" style="display: flex; gap: 10px;">
            <input type="text" name="searchName" placeholder="Enter Guest Name (e.g. Kate)..."
                   style="flex: 1; padding: 10px; border: 1px solid #bdc3c7; border-radius: 4px;">
            <button type="submit" class="btn-custom" style="background: #27ae60; border: none; cursor: pointer; color: white;">
                Search History
            </button>
            <a href="${pageContext.request.contextPath}/viewReservations" class="btn-custom" style="background: #95a5a6; text-decoration: none; color: white;">Reset</a>
        </form>
    </div>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Res. Number</th>
                <th>Guest Name</th>
                <th>Room Type</th>
                <th>Check-In</th>
                <th>Check-Out</th>
                <th>Status</th> <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Reservation> list = (List<Reservation>) request.getAttribute("reservations");
                if (list != null) {
                    for (Reservation r : list) {
                        // Logic to handle the NULLs seen in your DB
                        String displayNum = (r.getReservationNumber() == null) ? "PENDING" : r.getReservationNumber();

                        // Logic for Status Badge
                        String status = r.getStatus();
                        if (status == null) status = "PENDING";

                        String badgeClass = status.equalsIgnoreCase("PAID") ? "badge-success" : "badge-warning";
            %>
                <tr>
                    <td><%= r.getReservationId() %></td>
                    <td><%= displayNum %></td>
                    <td><%= r.getGuestName() %></td>
                    <td><%= r.getRoomType() %></td>
                    <td><%= r.getCheckIn() %></td>
                    <td><%= r.getCheckOut() %></td>

                    <td>
                        <span class="badge <%= badgeClass %>"><%= status %></span>
                    </td>

                    <td>
                        <% if (!"PAID".equalsIgnoreCase(status)) { %>
                            <a href="billing?id=<%= r.getReservationId() %>&type=<%= r.getRoomType() %>&resNum=<%= displayNum %>"
                               class="btn btn-sm btn-primary">Billing</a>
                        <% } else { %>
                            <span class="text-success">Completed</span>
                        <% } %>
                    </td>
                </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
    <br>
    <div class="mt-4">
            <a href="dashboard.jsp" class="btn btn-outline-secondary">Back to Dashboard</a>
        </div>
</div>
</body>
</html>