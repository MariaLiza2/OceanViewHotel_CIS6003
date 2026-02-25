<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.oceanview.model.Guest, com.oceanview.dao.GuestDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Guest Directory | Ocean View Hotel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;
            --primary-sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --accent-sand: #D4A373;
            --white: #ffffff;
        }

        body {
            background-color: var(--bg-sage-light);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
            padding: 40px 20px;
        }

        .directory-container {
            max-width: 1100px;
            margin: auto;
            background: var(--white);
            padding: 40px;
            border-radius: 4px;
            box-shadow: 0 10px 30px rgba(94, 107, 90, 0.05);
            border: 1px solid rgba(138, 154, 132, 0.1);
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            border-bottom: 2px solid var(--accent-sand);
            padding-bottom: 15px;
            margin-bottom: 30px;
        }

        .header-section h2 {
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 300;
            margin: 0;
        }

        /* Table Styling */
        .directory-table {
            width: 100%;
            border-collapse: collapse;
        }

        .directory-table th {
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            color: var(--primary-sage);
            padding: 15px;
            border-bottom: 2px solid var(--bg-sage-light);
        }

        .directory-table td {
            padding: 18px 15px;
            border-bottom: 1px solid var(--bg-sage-light);
            font-size: 0.9rem;
            vertical-align: middle;
        }

        .directory-table tr:hover {
            background-color: #fafafa;
        }

        .badge-guest-id {
            background-color: var(--bg-sage-light);
            color: var(--deep-sage);
            font-size: 0.7rem;
            font-weight: 700;
            padding: 5px 10px;
            border-radius: 2px;
            border: 1px solid rgba(138, 154, 132, 0.2);
        }

        .back-link {
            text-decoration: none;
            color: var(--primary-sage);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 1px;
            transition: 0.3s;
        }

        .back-link:hover {
            color: var(--accent-sand);
        }

        .contact-info {
            color: var(--deep-sage);
            font-weight: 500;
        }
    </style>
</head>
<body>

<div class="directory-container">
    <div class="header-section">
        <div>
            <h2>Guest Directory</h2>
            <small class="text-muted text-uppercase" style="letter-spacing: 1px;">Master Records - Authorized Access Only</small>
        </div>
        <a href="dashboard.jsp" class="back-link">
            <i class="fa-solid fa-arrow-left me-2"></i>Dashboard
        </a>
    </div>

    <div class="table-responsive">
        <table class="directory-table">
            <thead>
                <tr>
                    <th>System ID</th>
                    <th>Full Name</th>
                    <th>Contact Information</th>
                    <th>Permanent Address</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Guest> guests = GuestDAO.getAllGuests();
                    if (guests != null && !guests.isEmpty()) {
                        for (Guest g : guests) {
                %>
                    <tr>
                        <td><span class="badge-guest-id">G-<%= g.getId() %></span></td>
                        <td><strong style="color: var(--deep-sage);"><%= g.getName() %></strong></td>
                        <td class="contact-info">
                            <i class="fa-solid fa-phone-flip me-2 opacity-50" style="font-size: 0.8rem;"></i>
                            <%= g.getContact() %>
                        </td>
                        <td class="text-muted small">
                            <i class="fa-solid fa-location-dot me-2 opacity-50"></i>
                            <%= g.getAddress() %>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="4" class="text-center py-5 text-muted italic">
                            <i class="fa-solid fa-circle-info me-2"></i> No registered guest profiles found in the database.
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<footer class="text-center mt-5 opacity-50">
    <small>OCEAN VIEW HOTEL | CRM MODULE &copy; 2026</small>
</footer>

</body>
</html>