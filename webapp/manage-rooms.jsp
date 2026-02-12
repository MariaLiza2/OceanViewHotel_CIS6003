<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.Room" %>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
%>

<table border="1">

    <% if (rooms != null) {
        for (Room r : rooms) { %>
       <%-- Use the names that match your Room.java getters --%>
       <tr>
           <td><%= r.getType() %></td>
           <td><%= r.getRate() %></td>
           <td>
               <a href="DeleteRoomServlet?id=<%= r.getRoomId() %>">Delete</a>
           </td>
       </tr>
    <% } } %>
</table>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Rooms - Admin</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f7f6; padding: 40px; }
        .container { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 800px; margin: auto; }
        h2 { color: #333; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #3498db; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f1f1f1; }
        .btn-delete { color: #e74c3c; text-decoration: none; font-weight: bold; border: 1px solid #e74c3c; padding: 5px 10px; border-radius: 4px; }
        .btn-delete:hover { background: #e74c3c; color: white; }
        .add-form { margin-bottom: 20px; padding: 15px; background: #e8f4fd; border-radius: 5px; }
    </style>
</head>
<body>

<div class="container">
    <h2>Room Management Panel</h2>

    <div class="add-form">
        <form action="ManageRoomsServlet" method="post">
            <input type="text" name="roomType" placeholder="Room Type (e.g. Deluxe)" required>
            <input type="number" name="rate" placeholder="Rate per Night" required>
            <button type="submit" style="background: #27ae60; color: white; border: none; padding: 5px 15px; border-radius: 4px; cursor: pointer;">Add Room</button>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>Room Type</th>
                <th>Rate (LKR)</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="r" items="${rooms}">
                <tr>
                    <td>${r.type}</td>
                    <td>${r.rate}</td>
                    <td>
                        <a href="DeleteRoomServlet?id=${r.roomId}">Delete</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty rooms}">
                <tr><td colspan="3" style="text-align:center;">No rooms found in database.</td></tr>
            </c:if>
        </tbody>
    </table>
    <br>
    <a href="admin-panel.jsp" style="text-decoration: none; color: #3498db;">&larr; Back to Admin Panel</a>
</div>

</body>
</html>