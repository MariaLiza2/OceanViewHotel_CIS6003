<%@ page import="java.util.*, com.oceanview.model.Room" %>

<html>
<head>
    <title>Room Availability</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container">

<h2>Room Availability</h2>

<table class="table table-bordered">
<tr>
    <th>Room Type</th>
    <th>Status</th>
    <th>Action</th>
</tr>

<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    if(rooms != null){
        for(Room r : rooms){
%>
<tr>
    <td><%= r.getType() %></td>
    <td><%= r.isAvailable() ? "Available" : "Booked" %></td>
    <td>
        <% if(r.isAvailable()) { %>
            <a href="billing?type=<%= r.getType() %>&rate=<%= r.getRate() %>"
               class="btn btn-primary">
               Billing
            </a>

        <% } else { %>
            <button class="btn btn-danger" disabled>Not Available</button>
        <% } %>
    </td>
</tr>


<%
        }
    }
%>
</table>

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

</body>
</html>
