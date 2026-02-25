<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Protocol | Ocean View Hotel</title>
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
            padding: 50px 20px;
        }

        .guide-container {
            max-width: 900px;
            margin: auto;
            background: var(--white);
            padding: 50px;
            border-radius: 4px;
            box-shadow: 0 15px 40px rgba(94, 107, 90, 0.08);
            border: 1px solid rgba(138, 154, 132, 0.1);
        }

        .header {
            text-align: center;
            border-bottom: 2px solid var(--accent-sand);
            margin-bottom: 40px;
            padding-bottom: 20px;
        }

        .header h1 {
            text-transform: uppercase;
            letter-spacing: 4px;
            font-weight: 300;
            margin-bottom: 10px;
        }

        .admin-box {
            background: #FAF9F6;
            border-left: 4px solid var(--accent-sand);
            padding: 30px;
            margin-bottom: 40px;
        }

        .admin-header {
            color: var(--accent-sand);
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 700;
            font-size: 0.9rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .section-title {
            text-transform: uppercase;
            letter-spacing: 2px;
            color: var(--deep-sage);
            font-size: 1.25rem;
            margin-top: 40px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
        }

        .section-title::after {
            content: "";
            flex: 1;
            height: 1px;
            background: var(--bg-sage-light);
            margin-left: 20px;
        }

        /* Timeline-style Steps */
        .step {
            position: relative;
            padding-left: 60px;
            margin-bottom: 35px;
        }

        .step-num {
            position: absolute;
            left: 0;
            top: 0;
            background: var(--primary-sage);
            color: #fff;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .field-info {
            background: var(--bg-sage-light);
            padding: 15px;
            margin-top: 15px;
            font-size: 0.85rem;
            border-radius: 4px;
            color: var(--deep-sage);
        }

        .highlight { font-weight: 700; color: var(--accent-sand); }

        .back-link {
            text-decoration: none;
            color: var(--primary-sage);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--accent-sand);
            transition: 0.3s;
        }

        .back-link:hover { color: var(--accent-sand); }
    </style>
</head>
<body>

<div class="guide-container">
    <div class="header">
        <h1>Operational Protocol</h1>
        <p class="text-muted small text-uppercase" style="letter-spacing: 2px;">Standard Operating Procedures • Ocean View Hotel</p>
    </div>

    <div class="admin-box">
        <div class="admin-header">
            <i class="fa-solid fa-shield-halved me-2"></i> Administrative Restricted Controls
        </div>
        <p class="small mb-3">System Administrators are responsible for the structural integrity of the database:</p>
        <ul class="small" style="list-style-type: square;">
            <li><strong>Inventory Audit:</strong> Monitoring and adjusting room availability status globally.</li>
            <li><strong>Record Lifecycle:</strong> Adding, updating, or purging Room/Guest records.</li>
            <li><strong>Financial Oversight:</strong> Accessing global payment history and revenue reports.</li>
        </ul>
    </div>

    <h2 class="section-title">Standard Workflow</h2>

    <div class="step">
        <div class="step-num">01</div>
        <p><strong>Availability Check:</strong> Consult the <span class="highlight">Room Management</span> panel. Ensure the room category matches the guest's requirement before proceeding.</p>
    </div>



    <div class="step">
        <div class="step-num">02</div>
        <p><strong>Guest Enrollment:</strong> Navigate to <span class="highlight">Guest Registration</span>. Create a unique profile. Ensure the address and contact data are verified against physical identification.</p>
    </div>

    <div class="step">
        <div class="step-num">03</div>
        <p><strong>Reservation Entry:</strong> Link the Guest Profile to a room.
            <div class="field-info">
                <strong>Crucial Check:</strong> Check-In and Check-Out dates must be logically ordered. The system prevents backward-dating.
            </div>
        </p>
    </div>

    <div class="step">
        <div class="step-num">04</div>
        <p><strong>RefNum Assignment:</strong> Upon saving, the system generates a <span class="highlight">Reservation Number</span> (e.g., OVH-XXX). Note this for all future billing inquiries.</p>
    </div>



    <div class="step">
        <div class="step-num">05</div>
        <p><strong>Billing Initiation:</strong> Access the <span class="highlight">Guest Ledger</span>. Locate the PENDING reservation and click <strong>Process Bill</strong>.</p>
    </div>

    <div class="step">
        <div class="step-num">06</div>
        <p><strong>Financial Settlement:</strong> Select the payment channel.
            <div class="field-info">
                <strong>Cash:</strong> Direct desk settlement.<br>
                <strong>Card:</strong> Validate via the secure terminal.<br>
                <strong>Online:</strong> Reserved for advance web bookings.
            </div>
        </p>
    </div>

    <div class="step">
        <div class="step-num">07</div>
        <p><strong>Verification:</strong> Confirm the ledger status shifts to <span class="highlight">PAID</span>. Do not issue keycards for PENDING accounts.</p>
    </div>

    <div class="step">
        <div class="step-num">08</div>
        <p><strong>Documentation:</strong> Download the PDF receipt. Provide a digital copy or a printed version to the guest to finalize the transaction.</p>
    </div>

    <div class="text-center mt-5">
        <a href="dashboard.jsp" class="back-link">
            <i class="fa-solid fa-chevron-left me-2"></i> Return to Staff Dashboard
        </a>
    </div>
</div>

<footer class="text-center mt-5 opacity-50">
    <small>VERSION 2.1 | INTERNAL DOCUMENTATION ONLY</small>
</footer>

</body>
</html>