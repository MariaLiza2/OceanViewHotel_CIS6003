<%@ page import="java.util.*, com.oceanview.model.Room" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Room Availability | Ocean View Hotel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .table-header { background-color: #4da3ff; color: white; }
        .page-title { color: #2c3e50; border-bottom: 3px solid #4da3ff; padding-bottom: 10px; font-weight: bold; }
        .badge-available { background-color: #2ecc71; color: white; }
        .badge-booked { background-color: #e74c3c; color: white; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5 p-4 bg-white shadow-sm rounded">
    <h2 class="page-title mb-4">Room Availability</h2>

    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-header">
                <tr>
                    <th class="ps-3">Room Type</th>
                    <th>Daily Rate (LKR)</th>
                    <th>Status</th>
                    <th class="text-center">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                    if(rooms != null && !rooms.isEmpty()){
                        for(Room r : rooms){
                %>
                <tr>
                    <td class="ps-3 fw-bold text-primary"><%= r.getType() %></td>
                    <td>LKR <%= r.getRate() %></td>
                    <td>
                        <% if(r.isAvailable()) { %>
                            <span class="badge rounded-pill badge-available">Available</span>
                        <% } else { %>
                            <span class="badge rounded-pill badge-booked">Booked</span>
                        <% } %>
                    </td>
                    <td class="text-center">
                        <% if(r.isAvailable()) { %>
                            <a href="reservation.jsp?type=<%= r.getType() %>&rate=<%= r.getRate() %>"
                               class="btn btn-sm btn-outline-primary px-4">
                               Make Reservation
                            </a>
                        <% } else { %>
                            <button class="btn btn-sm btn-secondary px-4" disabled>Occupied</button>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="4" class="text-center py-4 text-muted">No rooms currently in the system.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="mt-3">
        <a href="dashboard.jsp" class="btn btn-link text-decoration-none">← Back to Dashboard</a>
    </div>
</div>
</body>
</html>