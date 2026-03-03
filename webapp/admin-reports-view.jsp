<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reports Center | Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --sage: #8A9A84; --sand: #D4A373; --cream: #F2F4F0; --dark-olive: #4A5D45; }
        body { background-color: var(--cream); padding: 50px; }
        .report-card { background: white; border-radius: 15px; border: none; transition: transform 0.2s; }
        .card-res { border-top: 5px solid var(--sage); }
        .card-pay { border-top: 5px solid var(--sand); }
        .btn-sage { background-color: var(--sage); color: white; }
        .btn-sand { background-color: var(--sand); color: white; }
    </style>
</head>
<body>
    <div class="container bg-white p-5 shadow-sm rounded">
        <h2 class="text-center text-uppercase mb-5" style="color: var(--dark-olive)">Hotel Reports Center</h2>
        <div class="row g-4">
            <div class="col-md-6 border-end">
                <div class="p-3 card-res">
                    <h4><i class="fa-solid fa-calendar-check"></i> Reservations</h4>
                    <form action="adminreports" method="get" class="mt-3">
                        <input type="hidden" name="type" value="reservations">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Select Date:</label>
                            <input type="date" name="reportDate" class="form-control" required>
                        </div>
                        <button type="submit" name="action" value="download" class="btn btn-sage w-100 mb-2">Download PDF</button>
                        <button type="submit" name="action" value="view" class="btn btn-outline-secondary w-100">View on Screen</button>
                    </form>
                </div>
            </div>
            <div class="col-md-6">
                <div class="p-3 card-pay">
                    <h4><i class="fa-solid fa-credit-card"></i> Payments</h4>
                    <form action="adminreports" method="get" class="mt-3">
                        <input type="hidden" name="type" value="payments">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Select Date:</label>
                            <input type="date" name="reportDate" class="form-control" required>
                        </div>
                        <button type="submit" name="action" value="download" class="btn btn-sand w-100 mb-2">Download PDF</button>
                        <button type="submit" name="action" value="view" class="btn btn-outline-secondary w-100">View on Screen</button>
                    </form>
                </div>
                <div class="mt-5">
                        <a href="admin-dashboard.jsp" class="back-link">
                            <i class="fa-solid fa-arrow-left me-2"></i>Exit to Admin Center
                        </a>
                    </div>
            </div>
        </div>
    </div>
</body>
</html>