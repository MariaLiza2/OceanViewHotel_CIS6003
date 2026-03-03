<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Printable Staff Manual | Ocean View Hotel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --sage: #4A5D45;
            --sand: #C2956E;
        }

        body { background-color: #fdfdfd; font-family: 'Segoe UI', sans-serif; padding: 40px 10px; }

        .manual-card {
            max-width: 950px;
            margin: auto;
            background: #fff;
            padding: 50px;
            border: 1px solid #eee;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            position: relative;
        }

        .hotel-title { text-align: center; border-bottom: 2px solid var(--sand); margin-bottom: 40px; padding-bottom: 20px; }
        .hotel-title h1 { color: var(--sage); font-weight: 800; letter-spacing: 5px; text-transform: uppercase; }

        .module-header {
            color: var(--sage);
            font-weight: 700;
            text-transform: uppercase;
            border-left: 4px solid var(--sand);
            padding-left: 15px;
            margin: 35px 0 15px 0;
            background: #fcfcfc;
        }

        .instruction-list { list-style: none; padding-left: 0; }
        .instruction-list li {
            padding: 8px 0 8px 35px;
            position: relative;
            border-bottom: 1px solid #f1f1f1;
        }

        .instruction-list li::before {
            content: "\f058";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            position: absolute;
            left: 5px;
            color: var(--sand);
        }

        /* PRINT LOGIC: This hides buttons and adjusts layout for paper */
        @media print {
            body { background: white; padding: 0; }
            .manual-card { box-shadow: none; border: none; width: 100%; max-width: 100%; padding: 20px; }
            .no-print { display: none !important; }
            .module-header { border-bottom: 1px solid #ddd; background: none; }
            a { text-decoration: none; color: black; }
        }

        .print-btn {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            background-color: var(--sage);
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: 0.3s;
        }
        .print-btn:hover { background-color: #384735; transform: scale(1.05); }
    </style>
</head>
<body>

<button onclick="window.print()" class="print-btn no-print">
    <i class="fas fa-print me-2"></i> Print Manual
</button>

<div class="manual-card">
    <div class="hotel-title">
        <div style="font-size: 2.5rem; margin-bottom: 10px;">&#129408;</div>
        <h1>Ocean View Hotel</h1>
        <p class="text-muted">No 261, Church Street, Galle.</p>
    </div>

    <div class="module-header">Staff Registration & Access</div>
    <ul class="instruction-list">
        <li>Self-register your official receptionist profile through the main login gateway.</li>
        <li>Select a unique username that will be used for all financial accountability logs.</li>
        <li>Protect your password at all times to prevent unauthorized access to hotel records.</li>
    </ul>

    <div class="module-header">Guest Booking Entry</div>
    <ul class="instruction-list">
        <li>Check live room inventory to confirm availability before speaking with a guest.</li>
        <li>Input the guest's full name exactly as it appears on their legal identification.</li>
        <li>Correctly categorize the stay (Single, Double, or Suite) for accurate billing.</li>
        <li>Select the Check-In and Check-Out dates using the digital calendar tool.</li>
        <li>Record a primary contact number to ensure we can reach the guest if needed.</li>
        <li>Generate the Reservation Reference Number to lock the room in the system.</li>
        <li>Verify all details with the guest before officially saving the new booking.</li>
    </ul>

    <div class="module-header">Managing Existing Records</div>
    <ul class="instruction-list">
        <li>View the master reservation list to prepare for daily arrivals and departures.</li>
        <li>Search for guests by name or booking ID to provide quick service at the desk.</li>
        <li>Use the Edit function to extend stays or update guest preferences in the system.</li>
        <li>Check room availability before approving any requests for date extensions.</li>
        <li>Delete reservations only in cases of confirmed cancellations or entry errors.</li>
        <li>Monitor the status column to see which guests are pending or already checked in.</li>
        <li>Update guest notes during their stay to improve the personalized service experience.</li>
    </ul>

    <div class="module-header">Billing & Financials (LKR)</div>
    <ul class="instruction-list">
        <li>Verify that the stay duration matches the final bill before asking for payment.</li>
        <li>All payments must be processed using Sri Lankan Rupees (LKR) only.</li>
        <li>Confirm the system-calculated 'Total Amount' is correct based on the room rate.</li>
        <li>Ask the guest for their preferred payment channel (Cash, Card, or Online).</li>
        <li>Finalize the bill to move the reservation status from 'Pending' to 'Paid'.</li>
    </ul>

    <div class="module-header">Payment Tracking</div>
    <ul class="instruction-list">
        <li>Review the Daily Payment List at the end of your shift to audit all income.</li>
        <li>Sort payments by type to ensure the card terminal matches the system records.</li>
        <li>Total the cash received and reconcile it with the 'Total Revenue' on the screen.</li>
        <li>Report any discrepancies immediately to the shift manager for correction.</li>
    </ul>

    <div class="module-header">Administrative & Reports</div>
    <ul class="instruction-list">
        <li>Update nightly room rates globally to reflect seasonal changes or promotions.</li>
        <li>Mark rooms as 'Unavailable' in the system for maintenance or deep cleaning.</li>
        <li>Register new rooms into the database as the hotel inventory increases.</li>
        <li>Generate daily Payment Settlement reports to track the hotel's financial health.</li>
        <li>Download the PDF version of every report for physical filing and security.</li>
        <li>Select specific dates to audit historical revenue for the Galle head office.</li>
        <li>Oversee user registration to ensure only active staff have system access.</li>
        <li>Check that the LKR symbols and totals are correctly rendered on all PDFs.</li>
        <li>Manage the 'Guest Ledger' to clear out old or inactive accounts monthly.</li>
        <li>Optimize the database by purging cancelled logs to keep the system fast.</li>
    </ul>

    <div class="text-center mt-5 no-print">
        <hr>
        <a href="dashboard.jsp" class="btn btn-outline-dark px-5">Back to Dashboard</a>
    </div>
</div>

<footer class="text-center mt-4 mb-5 text-muted small">
    &copy; 2026 Ocean View Hotel - Galle Branch | Official Staff Document 🦀
</footer>

</body>
</html>