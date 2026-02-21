<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.Room" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Rooms - Admin</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f6; padding: 40px; }
        .container { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 900px; margin: auto; }
        h2 { color: #333; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #3498db; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #ddd; }
        .add-form { margin-bottom: 20px; padding: 15px; background: #e8f4fd; border-radius: 5px; }
        input { padding: 8px; margin-right: 10px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-add { background: #27ae60; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; }
        .btn-update { background: #f39c12; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; }
        .btn-delete { color: #e74c3c; text-decoration: none; font-weight: bold; margin-right: 15px; }
        .btn-edit { color: #f39c12; text-decoration: none; font-weight: bold; }
    </style>
    <script>
        // This function puts row data into the form for editing
        function prepareEdit(id, type, rate) {
            document.getElementById('formAction').value = "update";
            document.getElementById('roomIdField').value = id;
            document.getElementById('roomTypeField').value = type;
            document.getElementById('rateField').value = rate;
            document.getElementById('submitBtn').innerText = "Update Room";
            document.getElementById('submitBtn').className = "btn-update";
        }
    </script>
</head>
<body>

<div class="container">
    <h2>Room Management Panel</h2>

    <div class="add-form">
        <form action="ManageRoomsServlet" method="GET">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="roomId" id="roomIdField">

            <input type="text" name="roomType" id="roomTypeField" placeholder="Room Type" required>
            <input type="number" name="rate" id="rateField" placeholder="Rate (LKR)" required>

            <input type="text" name="description" id="descriptionField" placeholder="Description" required>

            <select name="isAvailable" id="statusField">
                <option value="true">Available</option>
                <option value="false">Booked</option>
            </select>

            <button type="submit" id="submitBtn" class="btn-add">Add Room</button>
            <a href="ManageRoomsServlet" style="font-size: 12px; color: gray; margin-left: 10px;">Clear/Reset</a>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Room Type</th>
                <th>Rate (LKR)</th>
                <th>Description</th> <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                if (rooms != null && !rooms.isEmpty()) {
                    for (Room r : rooms) {
            %>
                <tr>
                    <td><%= r.getRoomId() %></td>
                    <td><%= r.getType() %></td>
                    <td><%= r.getRate() %></td>
                    <td><%= r.getDescription() %></td> <td>
                        <a href="ManageRoomsServlet?action=toggle&id=<%= r.getRoomId() %>&currentStatus=<%= r.isAvailable() %>"
                           style="text-decoration:none; color: <%= r.isAvailable() ? "#27ae60" : "#e74c3c" %>; font-weight:bold;">
                            <%= r.isAvailable() ? "Available" : "Booked" %>
                        </a>
                    </td>
                   <td>
                       <a href="javascript:void(0)" class="btn-edit"
                          onclick="prepareEdit('<%= r.getRoomId() %>', '<%= r.getType() %>', '<%= r.getRate() %>', '<%= r.getDescription() %>', '<%= r.isAvailable() %>')">Edit</a>
                       &nbsp;|&nbsp;
                       <a href="ManageRoomsServlet?action=delete&id=<%= r.getRoomId() %>"
                          class="btn-delete" onclick="return confirm('Delete this room?')">Delete</a>
                   </td>
                </tr>
            <% } } else { %>
                <tr><td colspan="6" style="text-align:center;">No rooms found in database.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>
    <br>
    <a href="admin-dashboard.jsp" style="text-decoration: none; color: #3498db;">&larr; Back to Admin Panel</a>
</div>

</body>
</html>