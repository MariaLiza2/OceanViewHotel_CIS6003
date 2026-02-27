<%@ page import="com.oceanview.model.Reservation" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Guest | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #F2F4F0; padding: 60px; }
        .edit-card { background: white; border-radius: 12px; padding: 40px; max-width: 500px; margin: auto; border-top: 6px solid #D4A373; }
    </style>
</head>
<body>
    <div class="edit-card shadow">
        <h4 class="mb-4">Update Reservation</h4>
        <% Reservation r = (Reservation) request.getAttribute("res"); %>
        <form action="manageReservation" method="post">
            <input type="hidden" name="id" value="<%= r.getReservationId() %>">
            <div class="mb-3">
                <label class="form-label small fw-bold">Guest Name</label>
                <input type="text" name="guestName" class="form-control" value="<%= r.getGuestName() %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label small fw-bold">Room Type</label>
                <select name="roomType" class="form-select">
                    <option value="Single" <%= r.getRoomType().equals("Single")?"selected":"" %>>Single</option>
                    <option value="Double" <%= r.getRoomType().equals("Double")?"selected":"" %>>Double</option>
                    <option value="Deluxe" <%= r.getRoomType().equals("Deluxe")?"selected":"" %>>Deluxe</option>
                </select>
            </div>
            <div class="row">
                <div class="col mb-3"><label class="small fw-bold">Check-In</label><input type="date" name="checkIn" class="form-control" value="<%= r.getCheckIn() %>"></div>
                <div class="col mb-3"><label class="small fw-bold">Check-Out</label><input type="date" name="checkOut" class="form-control" value="<%= r.getCheckOut() %>"></div>
            </div>
            <button type="submit" class="btn btn-dark w-100 mt-3">SAVE CHANGES</button>
            <a href="manageReservation" class="btn btn-link w-100 text-muted">Cancel</a>
        </form>
    </div>
</body>
</html>