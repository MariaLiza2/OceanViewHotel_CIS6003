<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Reservation" %>

<%!
    public double getRate(String type) {
        if ("Double".equalsIgnoreCase(type)) return 4500.0;
        if ("Luxury".equalsIgnoreCase(type)) return 8500.0;
        return 2500.0;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reservation Ledger | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;
            --primary-sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --accent-sand: #D4A373;
            --white: #ffffff;
            --status-paid: #9DBF9E;
            --status-pending: #E9C46A;
        }

        body {
            background-color: var(--bg-sage-light);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
            padding: 40px 20px;
        }

        .main-card {
            background: var(--white);
            border-radius: 4px;
            box-shadow: 0 10px 30px rgba(94, 107, 90, 0.05);
            padding: 40px;
            border: 1px solid rgba(138, 154, 132, 0.1);
        }

        .header-section {
            border-bottom: 2px solid var(--accent-sand);
            margin-bottom: 30px;
            padding-bottom: 15px;
        }

        .header-section h2 {
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 300;
            margin: 0;
        }

        /* Search Bar */
        .search-box {
            background: var(--bg-sage-light);
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 30px;
        }

        .form-control {
            border: 1px solid #d1d1d1;
            border-radius: 0;
            padding: 10px 15px;
        }

        .btn-search {
            background-color: var(--primary-sage);
            color: white;
            border: none;
            padding: 10px 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-search:hover { background-color: var(--deep-sage); color: white; }

        /* Table Styling */
        .res-table {
            width: 100%;
            border-collapse: collapse;
        }

        .res-table th {
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            color: var(--primary-sage);
            padding: 15px;
            border-bottom: 2px solid var(--bg-sage-light);
        }

        .res-table td {
            padding: 15px;
            border-bottom: 1px solid var(--bg-sage-light);
            font-size: 0.9rem;
            vertical-align: middle;
        }

        /* Status Badges */
        .badge-res {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 700;
        }

        .bg-paid { background-color: var(--status-paid); color: white; }
        .bg-pending { background-color: var(--status-pending); color: #744b00; }

        .btn-billing {
            background-color: transparent;
            color: var(--primary-sage);
            border: 1px solid var(--primary-sage);
            padding: 5px 15px;
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: 600;
            text-decoration: none;
            transition: 0.3s;
        }

        .btn-billing:hover {
            background-color: var(--primary-sage);
            color: white;
        }

        .back-link {
            text-decoration: none;
            color: var(--deep-sage);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--accent-sand);
        }
    </style>
</head>
<body>

<div class="container main-card">
    <div class="header-section d-flex justify-content-between align-items-center">
        <h2>Guest Ledger</h2>
       <div class="d-flex justify-content-between align-items-center mb-4">
                <a href="dashboard.jsp" class="btn btn-sm btn-outline-secondary">BACK TO DASHBOARD</a>
            </div>
    </div>

    <div class="search-box">
        <form action="${pageContext.request.contextPath}/viewReservations" method="get" class="row g-2">
            <div class="col-md-9">
                <input type="text" name="searchName" class="form-control"
                       placeholder="Filter by Guest Name (e.g. Kate)..."
                       value="<%= request.getParameter("searchName") != null ? request.getParameter("searchName") : "" %>">
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn-search flex-grow-1">Search</button>
                <a href="${pageContext.request.contextPath}/viewReservations" class="btn btn-outline-secondary rounded-0">Reset</a>
            </div>
        </form>
    </div>

    <div class="table-responsive">
        <table class="res-table">
            <thead>
                <tr>
                    <th>Ref ID</th>
                    <th>Guest</th>
                    <th>Room</th>
                    <th>Stay Period</th>
                    <th>Status</th>
                    <th class="text-end">Operation</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Reservation> list = (List<Reservation>) request.getAttribute("reservations");
                    if (list != null && !list.isEmpty()) {
                        for (Reservation r : list) {
                            String displayNum = r.getReservationNumber();
                            String currentStatus = r.getStatus();
                            if (currentStatus == null) currentStatus = "PENDING";

                            String badgeClass = currentStatus.equalsIgnoreCase("PAID") ? "bg-paid" : "bg-pending";
                %>
                    <tr>
                        <td class="text-muted small">#<%= displayNum %></td>
                        <td class="fw-bold"><%= r.getGuestName() %></td>
                        <td>
                            <span class="d-block"><%= r.getRoomType() %></span>
                            <small class="text-muted">LKR <%= getRate(r.getRoomType()) %> / night</small>
                        </td>
                        <td>
                            <div class="small"><i class="fa-regular fa-calendar-check me-1 text-muted"></i> <%= r.getCheckIn() %></div>
                            <div class="small"><i class="fa-regular fa-calendar-xmark me-1 text-muted"></i> <%= r.getCheckOut() %></div>
                        </td>
                        <td>
                            <span class="badge-res <%= badgeClass %>"><%= currentStatus.toUpperCase() %></span>
                        </td>

                        <td class="text-end">
                            <% if("PAID".equalsIgnoreCase(currentStatus)) { %>
                                <span class="text-muted small fw-bold"><i class="fa-solid fa-check-double me-1"></i> Completed</span>
                            <% } else { %>
                                <a href="billing?id=<%= r.getReservationId() %>&type=<%= r.getRoomType() %>&resNum=<%= displayNum %>"
                                   class="btn-billing">
                                   Process Bill
                                </a>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="6" class="text-center py-5 text-muted italic">
                            No reservations found in the current ledger.
                        </td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<footer class="text-center mt-5 opacity-50">
    <small>OCEAN VIEW HOTEL | FRONT DESK OPERATIONS 2026</small>
</footer>

</body>
</html>