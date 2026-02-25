<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.Room" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Rooms | Ocean View Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-sage-light: #F2F4F0;
            --primary-sage: #8A9A84;
            --deep-sage: #5E6B5A;
            --accent-sand: #D4A373;
            --white: #ffffff;
            --available-green: #9DBF9E;
            --booked-red: #D48C8C;
        }

        body {
            background-color: var(--bg-sage-light);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            color: var(--deep-sage);
            padding: 40px 20px;
        }

        .admin-container {
            max-width: 1100px;
            margin: auto;
            background: var(--white);
            padding: 40px;
            border-radius: 4px;
            box-shadow: 0 10px 30px rgba(94, 107, 90, 0.05);
        }

        .header-title {
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 300;
            border-bottom: 2px solid var(--accent-sand);
            padding-bottom: 15px;
            margin-bottom: 30px;
        }

        /* Form Styling */
        .management-form-box {
            background-color: var(--bg-sage-light);
            padding: 25px;
            border-radius: 4px;
            margin-bottom: 40px;
        }

        .form-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 700;
            color: var(--primary-sage);
        }

        .form-control, .form-select {
            border: 1px solid #d1d1d1;
            border-radius: 0;
            padding: 10px;
            font-size: 0.9rem;
        }

        .btn-submit-action {
            background-color: var(--primary-sage);
            color: white;
            border: none;
            padding: 10px 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-submit-action:hover { background-color: var(--deep-sage); color: white; }
        .btn-update-mode { background-color: var(--accent-sand); color: white; }

        /* Table Styling */
        .admin-table {
            width: 100%;
            border-collapse: collapse;
        }

        .admin-table th {
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            color: var(--primary-sage);
            padding: 15px;
            border-bottom: 2px solid var(--bg-sage-light);
        }

        .admin-table td {
            padding: 15px;
            border-bottom: 1px solid var(--bg-sage-light);
            font-size: 0.9rem;
            vertical-align: middle;
        }

        .status-toggle {
            text-decoration: none;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        .btn-action-icon {
            text-decoration: none;
            margin: 0 5px;
            font-size: 1.1rem;
            transition: 0.2s;
        }
        .text-edit { color: var(--accent-sand); }
        .text-delete { color: #D48C8C; }

        .back-link {
            text-decoration: none;
            color: var(--primary-sage);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 1px;
        }
    </style>

    <script>
        function prepareEdit(id, type, rate, desc, status) {
            document.getElementById('formAction').value = "update";
            document.getElementById('roomIdField').value = id;
            document.getElementById('roomTypeField').value = type;
            document.getElementById('rateField').value = rate;
            document.getElementById('descriptionField').value = desc;
            document.getElementById('statusField').value = status;

            const btn = document.getElementById('submitBtn');
            btn.innerText = "Update Room Configuration";
            btn.classList.add("btn-update-mode");
        }
    </script>
</head>
<body>

<div class="admin-container">
    <h2 class="header-title">Room Inventory Management</h2>

    <div class="management-form-box">
        <form action="ManageRoomsServlet" method="GET" class="row g-3">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="roomId" id="roomIdField">

            <div class="col-md-3">
                <label class="form-label">Category</label>
                <input type="text" name="roomType" id="roomTypeField" class="form-control" placeholder="e.g. Deluxe Suite" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">Rate (LKR)</label>
                <input type="number" name="rate" id="rateField" class="form-control" placeholder="0.00" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Brief Description</label>
                <input type="text" name="description" id="descriptionField" class="form-control" placeholder="View, Bed count..." required>
            </div>
            <div class="col-md-3">
                <label class="form-label">Initial Status</label>
                <select name="isAvailable" id="statusField" class="form-select">
                    <option value="true">Available</option>
                    <option value="false">Occupied / Booked</option>
                </select>
            </div>
            <div class="col-12 text-end">
                <a href="ManageRoomsServlet" class="btn btn-link text-muted me-3 text-decoration-none small">Reset Form</a>
                <button type="submit" id="submitBtn" class="btn-submit-action">Add Room to Inventory</button>
            </div>
        </form>
    </div>

    <div class="table-responsive">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Category</th>
                    <th>Daily Rate</th>
                    <th>Details</th>
                    <th>Status Toggle</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                    if (rooms != null && !rooms.isEmpty()) {
                        for (Room r : rooms) {
                %>
                    <tr>
                        <td class="fw-bold">#<%= r.getRoomId() %></td>
                        <td><%= r.getType() %></td>
                        <td class="text-primary fw-bold">LKR <%= r.getRate() %></td>
                        <td class="text-muted small"><%= r.getDescription() %></td>
                        <td>
                            <a href="ManageRoomsServlet?action=toggle&id=<%= r.getRoomId() %>&currentStatus=<%= r.isAvailable() %>"
                               class="status-toggle"
                               style="background-color: <%= r.isAvailable() ? "var(--available-green)" : "var(--booked-red)" %>; color: white;">
                                <%= r.isAvailable() ? "Available" : "Booked" %>
                            </a>
                        </td>
                       <td class="text-end">
                           <a href="javascript:void(0)" class="btn-action-icon text-edit" title="Edit"
                              onclick="prepareEdit('<%= r.getRoomId() %>', '<%= r.getType() %>', '<%= r.getRate() %>', '<%= r.getDescription() %>', '<%= r.isAvailable() %>')">
                              <i class="fa-solid fa-pen-to-square"></i>
                           </a>
                           <a href="ManageRoomsServlet?action=delete&id=<%= r.getRoomId() %>"
                              class="btn-action-icon text-delete" title="Delete"
                              onclick="return confirm('Permanently remove this room?')">
                              <i class="fa-solid fa-trash-can"></i>
                           </a>
                       </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="6" class="text-center py-5 text-muted">No room data found. Use the form above to add rooms.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="mt-5">
        <a href="admin-dashboard.jsp" class="back-link">
            <i class="fa-solid fa-arrow-left me-2"></i>Exit to Admin Center
        </a>
    </div>
</div>

</body>
</html>