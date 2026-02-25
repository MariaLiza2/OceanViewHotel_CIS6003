<%@ page import="java.util.*, com.oceanview.model.Room" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Room Availability | Ocean View Hotel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;
            --primary-sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --accent-sand: #D4A373;
            --white: #ffffff;
            --available-green: #9DBF9E; /* Muted dull green */
            --booked-red: #D48C8C;      /* Muted dull red */
        }

        body {
            background-color: var(--bg-sage-light);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
            padding: 40px 20px;
        }

        .main-container {
            max-width: 1000px;
            margin: auto;
            background: var(--white);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(94, 107, 90, 0.05);
            border: 1px solid rgba(138, 154, 132, 0.1);
        }

        .page-title {
            color: var(--deep-sage);
            font-weight: 300;
            text-transform: uppercase;
            letter-spacing: 3px;
            border-bottom: 2px solid var(--accent-sand);
            padding-bottom: 15px;
            display: inline-block;
        }

        .standard-table {
            width: 100%;
            margin-top: 30px;
            border-collapse: separate;
            border-spacing: 0 10px; /* Gives a "card" look to rows */
        }

        .standard-table th {
            background-color: transparent;
            color: var(--primary-sage);
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 1.5px;
            padding: 15px;
            border-bottom: 1px solid var(--bg-sage-light);
        }

        .standard-table td {
            background: var(--white);
            padding: 20px 15px;
            border-top: 1px solid var(--bg-sage-light);
            border-bottom: 1px solid var(--bg-sage-light);
        }

        /* Rounding the row corners */
        .standard-table td:first-child { border-left: 1px solid var(--bg-sage-light); border-radius: 8px 0 0 8px; }
        .standard-table td:last-child { border-right: 1px solid var(--bg-sage-light); border-radius: 0 8px 8px 0; }

        .badge-status {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 6px 12px;
            font-weight: 600;
        }

        .badge-available { background-color: var(--available-green); color: white; }
        .badge-booked { background-color: var(--booked-red); color: white; }

        .btn-reserve {
            background-color: var(--primary-sage);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s;
            text-decoration: none;
        }

        .btn-reserve:hover {
            background-color: var(--accent-sand);
            color: white;
            box-shadow: 0 4px 12px rgba(212, 163, 115, 0.3);
        }

        .btn-back {
            color: var(--deep-sage);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 2px solid var(--accent-sand);
            padding-bottom: 3px;
            transition: 0.3s;
        }

        .btn-back:hover {
            color: var(--accent-sand);
        }
    </style>
</head>
<body>

<div class="main-container">
    <div class="text-center mb-5">
        <h2 class="page-title">Room Availability</h2>
    </div>

    <div class="table-responsive">
        <table class="standard-table align-middle">
            <thead>
                <tr>
                    <th class="ps-4">Room Category</th>
                    <th>Daily Rate</th>
                    <th>Status</th>
                    <th class="text-center">Availability Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                    if(rooms != null && !rooms.isEmpty()){
                        for(Room r : rooms){
                %>
                <tr>
                    <td class="ps-4">
                        <div class="fw-bold" style="font-size: 1.1rem;"><%= r.getType() %></div>
                        <small class="text-muted"><i class="fa-solid fa-bed me-1"></i> Standard View</small>
                    </td>
                    <td>
                        <span class="fw-bold" style="color: var(--primary-sage)">LKR <%= r.getRate() %></span>
                        <small class="text-muted">/ night</small>
                    </td>
                    <td>
                        <% if(r.isAvailable()) { %>
                            <span class="badge rounded-pill badge-status badge-available">
                                <i class="fa-solid fa-check-circle me-1"></i> Available
                            </span>
                        <% } else { %>
                            <span class="badge rounded-pill badge-status badge-booked">
                                <i class="fa-solid fa-circle-minus me-1"></i> Booked
                            </span>
                        <% } %>
                    </td>
                    <td class="text-center">
                        <% if(r.isAvailable()) { %>
                            <a href="reservation.jsp?type=<%= r.getType() %>&rate=<%= r.getRate() %>"
                               class="btn-reserve">
                               Reserve Now
                            </a>
                        <% } else { %>
                            <span class="text-muted small fw-bold text-uppercase" style="letter-spacing: 1px;">
                                Currently Occupied
                            </span>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="4" class="text-center py-5 text-muted italic">
                        <i class="fa-solid fa-info-circle me-2"></i> No room configurations found in the system.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="mt-5 pt-3">
        <a href="dashboard.jsp" class="btn-back">
            <i class="fa-solid fa-arrow-left me-2"></i>Return to Dashboard
        </a>
    </div>
</div>

<footer class="text-center mt-5 opacity-50">
    <small>&copy; 2026 Ocean View Hotel - Inventory Module</small>
</footer>

</body>
</html>