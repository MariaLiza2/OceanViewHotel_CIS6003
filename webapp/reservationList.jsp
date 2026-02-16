<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Reservation" %>

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

    <table class="standard-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Res. Number</th>
                <th>Guest Name</th>
                <th>Room Type</th>
                <th>Check In</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Reservation> list = (List<Reservation>) request.getAttribute("reservations");
                if (list != null && !list.isEmpty()) {
                    for (Reservation r : list) {
            %>
                <tr>
                    <td><%= r.getReservationId() %></td>
                    <td style="font-weight: bold; color: #2980b9;"><%= r.getReservationNumber() %></td>
                    <td><%= r.getGuestName() %></td>
                    <td><%= r.getRoomType() %></td>
                    <td><%= r.getCheckIn() %></td>
                    <td>
                        <a href="billing?resId=<%= r.getReservationId() %>&roomType=<%= r.getRoomType() %>"
                           style="background: #27ae60; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-weight: bold;">
                           Generate Bill
                        </a>
                    </td>
                </tr>
            <%
                    } // End of for loop
                } else {
            %>
                <tr><td colspan="6" style="text-align:center;">No history found for this guest.</td></tr>
            <%
                } // End of if/else
            %>
        </tbody>
    </table>
    <br>
    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn-custom"> << Back to Dashboard</a>
</div>
</body>
</html>