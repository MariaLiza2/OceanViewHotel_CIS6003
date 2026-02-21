<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.Guest" %>
<%@ page import="com.oceanview.dao.GuestDAO" %>

<!DOCTYPE html>
<html>
<head>
    <title>Guest Directory - OceanView</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f8f9fa; padding: 30px; }
        .container { max-width: 1000px; margin: auto; background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .header-row { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #3498db; padding-bottom: 15px; margin-bottom: 20px; }
        h2 { margin: 0; color: #2c3e50; }

        /* Table Styling */
        .guest-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .guest-table th { background-color: #3498db; color: white; padding: 12px; text-align: left; }
        .guest-table td { padding: 12px; border-bottom: 1px solid #eee; color: #555; }
        .guest-table tr:hover { background-color: #f1f7fd; }

        .badge-id { background: #34495e; color: white; padding: 4px 8px; border-radius: 4px; font-size: 0.85rem; }
        .btn-back { text-decoration: none; color: #3498db; font-weight: bold; }
        .empty-msg { text-align: center; padding: 40px; color: #999; }
    </style>
</head>
<body>

<div class="container">
    <div class="header-row">
        <h2>Registered Guest Directory</h2>
        <a href="admin-dashboard.jsp" class="btn-back">&larr; Dashboard</a>
    </div>

    <table class="guest-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Guest Name</th>
                <th>Contact Number</th>
                <th>Residential Address</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Guest> guests = GuestDAO.getAllGuests();
                if (guests != null && !guests.isEmpty()) {
                    for (Guest g : guests) {
            %>
                <tr>
                    <td><span class="badge-id">G-<%= g.getId() %></span></td>
                    <td><strong><%= g.getName() %></strong></td>
                    <td><%= g.getContact() %></td>
                    <td><%= g.getAddress() %></td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="4" class="empty-msg">No registered guests found in the directory.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>
<div class="mt-3">
        <a href="dashboard.jsp" class="btn btn-link text-decoration-none">← Back to Dashboard</a>
    </div>
</body>
</html>