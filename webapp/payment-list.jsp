<%@ page import="java.util.List, com.oceanview.model.Payment" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Ledger | Ocean View Hotel</title>
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

        .main-container {
            max-width: 1100px;
            margin: auto;
        }

        .page-header {
            border-bottom: 2px solid var(--accent-sand);
            margin-bottom: 30px;
            padding-bottom: 15px;
        }

        .page-header h2 {
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 300;
            margin: 0;
        }

        /* Search Section */
        .search-card {
            background: var(--white);
            border: 1px solid rgba(138, 154, 132, 0.1);
            border-radius: 4px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(94, 107, 90, 0.03);
        }

        .form-control {
            border: 1px solid #e1e1e1;
            border-radius: 0;
            padding: 12px;
        }

        .form-control:focus {
            box-shadow: none;
            border-color: var(--accent-sand);
        }

        .btn-search {
            background-color: var(--primary-sage);
            color: white;
            border: none;
            padding: 10px 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-search:hover { background-color: var(--deep-sage); color: white; }

        .btn-reset {
            background-color: transparent;
            color: var(--primary-sage);
            border: 1px solid var(--primary-sage);
            padding: 10px 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
        }

        /* Table Styling */
        .payment-table-card {
            background: var(--white);
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(94, 107, 90, 0.05);
        }

        .payment-table {
            width: 100%;
            margin-bottom: 0;
        }

        .payment-table th {
            background-color: transparent;
            color: var(--primary-sage);
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            padding: 20px 15px;
            border-bottom: 2px solid var(--bg-sage-light);
        }

        .payment-table td {
            padding: 18px 15px;
            border-bottom: 1px solid var(--bg-sage-light);
            font-size: 0.9rem;
        }

        .method-badge {
            background-color: var(--bg-sage-light);
            color: var(--deep-sage);
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 5px 12px;
            border: 1px solid rgba(138, 154, 132, 0.2);
            font-weight: 600;
        }

        .back-link {
            text-decoration: none;
            color: var(--primary-sage);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--accent-sand);
        }
    </style>
</head>
<body>

<div class="main-container">
    <div class="page-header d-flex align-items-center">
        <i class="fa-solid fa-receipt fa-2x me-3 text-muted opacity-50"></i>
        <h2>Payment Ledger</h2>
    </div>
 <div class="mt-5">
        <a href="dashboard.jsp" class="back-link">
            <i class="fa-solid fa-chevron-left me-2"></i>Exit to Dashboard
        </a>
    </div>
    <div class="search-card">
        <form action="viewPayments" method="get">
            <div class="row g-3 align-items-end">
                <div class="col-md-8">
                    <label class="small text-uppercase fw-bold mb-2 opacity-75">Filter by Reservation</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                        <input type="text" name="searchQuery" class="form-control border-start-0"
                               placeholder="Enter Reference Number (e.g. OVH-048)..."
                               value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>">
                    </div>
                </div>
                <div class="col-md-4 d-flex gap-2">
                    <button type="submit" class="btn-search flex-grow-1">Filter Records</button>
                    <a href="viewPayments" class="btn btn-reset">Clear</a>
                </div>
            </div>
        </form>
    </div>

    <div class="payment-table-card">
        <div class="table-responsive">
            <table class="payment-table table-hover align-middle">
               <thead>
                   <tr>
                       <th class="ps-4">Internal ID</th>
                       <th>Guest Name</th> <th>Res. Number</th>
                       <th>Accommodation</th>
                       <th>Settled Amount</th>
                       <th>Method</th>
                       <th class="text-end pe-4">Processing Date</th>
                   </tr>
               </thead>
               <tbody>
                   <%
                       List<Payment> payments = (List<Payment>) request.getAttribute("payments");
                       if (payments != null && !payments.isEmpty()) {
                           for (Payment p : payments) {
                   %>
                       <tr>
                           <td class="ps-4 text-muted small">#<%= p.getReservationId() %></td>
                           <td class="fw-bold"><%= p.getGuestName() != null ? p.getGuestName() : "N/A" %></td>

                           <td class="text-primary fw-bold"><%= p.getReservationNumber() %></td>
                           <td><%= p.getRoomType() %></td>
                           <td class="fw-bold" style="color: var(--primary-sage)">LKR <%= p.getTotalAmount() %></td>
                           <td><span class="badge rounded-pill method-badge"><%= p.getPaymentMethod() %></span></td>
                           <td class="text-muted small text-end pe-4"><%= p.getPaymentDate() %></td>
                       </tr>
                   <%
                           }
                       }
                   %>
               </tbody>
            </table>
        </div>
    </div>


</div>

<footer class="text-center mt-5 opacity-50">
    <small>&copy; 2026 OCEAN VIEW HOTEL | FINANCIAL AUDIT MODULE</small>
</footer>

</body>
</html>