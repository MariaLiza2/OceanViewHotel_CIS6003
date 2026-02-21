<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>OceanView - Staff Operational Manual</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; color: #333; line-height: 1.6; padding: 20px; }
        .guide-container { max-width: 1000px; margin: auto; background: #fff; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .header { text-align: center; border-bottom: 2px solid #3498db; margin-bottom: 30px; padding-bottom: 10px; }
        .admin-box { background: #fff3cd; border: 1px solid #ffeeba; border-radius: 8px; padding: 20px; margin-bottom: 30px; }
        .admin-header { color: #856404; font-weight: bold; font-size: 1.2rem; margin-bottom: 10px; }
        .section-title { color: #2c3e50; border-left: 5px solid #3498db; padding-left: 15px; margin-top: 30px; margin-bottom: 15px; }
        .step { position: relative; padding-left: 50px; margin-bottom: 25px; }
        .step-num { position: absolute; left: 0; top: 0; background: #3498db; color: #fff; width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; }
        .field-info { background: #f9f9f9; border: 1px dashed #ccc; padding: 10px; margin-top: 10px; font-size: 0.95rem; }
        .highlight { font-weight: bold; color: #e67e22; }
        .btn-dashboard { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #34495e; color: #fff; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>

<div class="guide-container">
    <div class="header">
        <h1>OceanView Hotel Operational Guide</h1>
        <p>Standard Operating Procedures for Reception & Management</p>
    </div>

    <div class="admin-box">
        <div class="admin-header">🔑 Part 1: Administrative Controls (Admin Only)</div>
        <p>The following features are restricted to the System Administrator to ensure core data remains secure:</p>
        <ul>
            <li><strong>Manage Room Inventory:</strong> Access the "Manage Rooms" panel to organize the hotel's stock.</li>
            <li><strong>Add New Rooms:</strong> Create new listings by entering the category, price, and features.</li>
            <li><strong>Edit Records:</strong> Update a room's price or description if details change.</li>
            <li><strong>Delete Records:</strong> Permanently remove rooms from the system.</li>
            <li><strong>Download Reports:</strong> Generate Occupancy and Revenue reports for business analysis.</li>
        </ul>
    </div>

    <h2 class="section-title">📋 Part 2: Standard Staff Operations (12-Step Guide)</h2>



    <div class="step">
        <div class="step-num">1</div>
        <strong>Check Room Availability:</strong> Look at the main table to see which rooms are marked as <span class="highlight">Available</span>.
    </div>

    <div class="step">
        <div class="step-num">2</div>
        <strong>Toggle Room Status:</strong> If a room is dirty or occupied, click <strong>Mark as Booked</strong> to hide it from the website.
    </div>

    <div class="step">
        <div class="step-num">3</div>
        <strong>Register New Guest:</strong> Use the registration page to create a profile for first-time visitors.
    </div>

    <div class="step">
        <div class="step-num">4</div>
        <strong>Enter Account Details:</strong> Record a unique email address and a secure password for the guest.
    </div>

    <div class="step">
        <div class="step-num">5</div>
        <strong>Select Dates:</strong> Use the calendar in the reservation form to pick the <strong>Check-in</strong> and <strong>Check-out</strong> dates.
    </div>

    <div class="step">
        <div class="step-num">6</div>
        <strong>Enter Guest Details:</strong> Carefully fill the following fields:
        <div class="field-info">
            <strong>Full Name:</strong> Enter as it appears on their Passport/ID.<br>
            <strong>Phone Number:</strong> A valid mobile number for booking confirmations.<br>
            <strong>Special Requests:</strong> Note things like "Extra Bed" or "Late Arrival."
        </div>
    </div>

    <div class="step">
        <div class="step-num">7</div>
        <strong>Choose Room:</strong> Select the room from the dropdown menu based on the guest's preference.
    </div>

    <div class="step">
        <div class="step-num">8</div>
        <strong>Confirm Reservation:</strong> Review the summary and click "Add Reservation." Note the <strong>Reservation Number</strong>.
    </div>

    <div class="step">
        <div class="step-num">9</div>
        <strong>Initiate Billing:</strong> Go to the Billing section to see the "Total Amount Due". This is calculated based on the room rate.
    </div>

    <div class="step">
        <div class="step-num">10</div>
        <strong>Choose Payment Method:</strong> Select how the guest will pay:
        <div class="field-info">
            <strong>Cash:</strong> Standard desk payment.<br>
            <strong>Card:</strong> Swipe via the payment terminal.<br>
            <strong>Online:</strong> Guest pays via the website portal.
        </div>
    </div>

    <div class="step">
        <div class="step-num">11</div>
        <strong>Verify Payment:</strong> Confirm the status changes to "Paid" before issuing keys.
    </div>

    <div class="step">
        <div class="step-num">12</div>
        <strong>Download & Print Receipt:</strong> Click <strong>Download Receipt</strong> and provide a physical copy to the guest.
    </div>

    <div style="text-align: center;">
        <a href="dashboard.jsp" class="btn-dashboard">Return to Dashboard</a>
    </div>
</div>

</body>
</html>