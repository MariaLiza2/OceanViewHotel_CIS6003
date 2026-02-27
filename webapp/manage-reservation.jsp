<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Reservation, com.oceanview.dao.ReservationDAO, com.oceanview.dao.ReservationDAOImpl" %>

<%
    // Ensure data is present even on direct JSP access
    List<Reservation> list = (List<Reservation>) request.getAttribute("reservations");
    if (list == null) {
        ReservationDAO dao = new ReservationDAOImpl();
        list = dao.getAllReservations();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Management | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sage: #8A9A84; --deep-sage: #5E6B5A; --sand: #D4A373; --cream: #F2F4F0;
        }
        body { background-color: var(--cream); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 40px 20px; color: var(--deep-sage); }
        .main-card { background: white; border-radius: 12px; box-shadow: 0 8px 30px rgba(0,0,0,0.05); padding: 40px; border-top: 6px solid var(--sage); }
        .header-title { letter-spacing: 2px; border-bottom: 2px solid var(--sand); padding-bottom: 10px; margin-bottom: 30px; }
        .table thead th { border: none; color: var(--sage); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; }
        .btn-sage { background-color: var(--sage); color: white; border-radius: 4px; }
        .btn-sage:hover { background-color: var(--deep-sage); color: white; }
        .action-btn { width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; border-radius: 4px; margin-left: 5px; transition: 0.3s; }
        .view-btn { background: #e7f0e7; color: var(--sage); }
        .edit-btn { background: #fdf5e6; color: var(--sand); }
        .delete-btn { background: #fce8e8; color: #d9534f; }
        .action-btn:hover { transform: translateY(-2px); opacity: 0.8; }
    </style>
</head>
<body>

<div class="container main-card">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="header-title m-0">ADMIN MANAGEMENT</h2>
        <a href="dashboard.jsp" class="btn btn-sm btn-outline-secondary">BACK TO DASHBOARD</a>
    </div>

    <div class="mb-4 p-3 rounded" style="background: #f8f9fa;">
        <form action="manageReservation" method="get" class="row g-2">
            <div class="col-md-10">
                <input type="text" name="searchName" class="form-control border-0 shadow-sm" placeholder="Find guest by name...">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-sage w-100">SEARCH</button>
            </div>
        </form>
    </div>

    <table class="table">
        <thead>
            <tr>
                <th>Ref ID</th>
                <th>Guest Name</th>
                <th>Room Type</th>
                <th>Stay Dates</th>
                <th class="text-end">Actions</th>
            </tr>
        </thead>
        <tbody>
            <% if (list != null && !list.isEmpty()) {
                for (Reservation r : list) { %>
                <tr>
                    <td class="text-muted">#<%= r.getReservationNumber() %></td>
                    <td class="fw-bold"><%= r.getGuestName() %></td>
                    <td><span class="badge bg-light text-dark"><%= r.getRoomType() %></span></td>
                    <td class="small text-muted"><%= r.getCheckIn() %> — <%= r.getCheckOut() %></td>
                    <td class="text-end">
                        <a href="manageReservation?action=view&id=<%= r.getReservationId() %>" class="action-btn view-btn"><i class="fa-solid fa-eye"></i></a>
                        <a href="manageReservation?action=edit&id=<%= r.getReservationId() %>" class="action-btn edit-btn"><i class="fa-solid fa-pen"></i></a>
                        <a href="manageReservation?action=delete&id=<%= r.getReservationId() %>" class="action-btn delete-btn" onclick="return confirm('Delete this record?')"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
            <% } } else { %>
                <tr><td colspan="5" class="text-center py-5 text-muted">No records found.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>

</body>
</html>