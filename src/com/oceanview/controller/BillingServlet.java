package com.oceanview.controller;

import com.oceanview.model.Bill;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    // ===============================
    // STEP 1: Show Billing Page
    // ===============================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // If download action → generate PDF
        if ("download".equals(action)) {
            generatePDF(request, response);
            return;
        }

        String resId = request.getParameter("resId");
        String type = request.getParameter("type");
        String resNum = request.getParameter("resNum");

        // 1. Safety check
        if (resId == null || type == null) {
            response.sendRedirect("viewReservations");
            return;
        }

        // 2. Determine price based on room type
        double rate = 2500.0; // Default
        if ("Double".equalsIgnoreCase(type)) rate = 4500.0;
        else if ("Luxury".equalsIgnoreCase(type)) rate = 8500.0;

        // 3. Create the Bill object with the guest's specific data
        Bill bill = new Bill();
        bill.setReservationId(Integer.parseInt(resId));
        bill.setRoomType(type);
        bill.setAmountPerDay(rate);

        // 4. Send this "pre-filled" bill to the billing page
        request.setAttribute("bill", bill);
        HttpSession session = request.getSession();
        session.setAttribute("resNum", resNum);
        request.getRequestDispatcher("billing.jsp").forward(request, response);
    }

    // ===============================
    // STEP 2: After Payment Click
    // ===============================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String daysStr = request.getParameter("days");
        String amountStr = request.getParameter("amount");
        String roomType = request.getParameter("roomType");
        String resIdStr = request.getParameter("reservationId");
        String resNum = request.getParameter("resNum"); // Formatted number (OVH-001)
        String totalStr = request.getParameter("totalAmount");
        String paymentMethod = request.getParameter("paymentMethod");

        long days = Long.parseLong(daysStr);
        double amount = Double.parseDouble(amountStr);
        double total = days * amount;

        String resId = request.getParameter("reservationId");
        String receiptNo = "OVH-REC-" + String.format("%03d", Integer.parseInt(resIdStr));

// 3. Save to Database (Connecting to oceanview_db)
        try (Connection conn = com.oceanview.util.DBConnection.getConnection()) {
            // Matches your SSMS column structure
            String sql = "INSERT INTO Payments (reservation_id, reservation_number, room_type, total_amount, payment_method, payment_date) VALUES (?, ?, ?, ?, ?, GETDATE())";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, resId);
                ps.setString(2, resNum);
                ps.setString(3, roomType);
                ps.setDouble(4, total);
                ps.setString(5, paymentMethod);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    System.out.println("Payment saved for " + resNum);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
           }
        Bill bill = new Bill();
        bill.setRoomType(roomType);
        int daysValue = Integer.parseInt(request.getParameter("days"));
        bill.setDays(daysValue);
        bill.setAmountPerDay(amount);
        bill.setTotal(total);

        // Save receipt number in session
        HttpSession session = request.getSession();
        session.setAttribute("receiptNo", receiptNo);
        session.setAttribute("bill", bill);

        // Forward to success page
        request.getRequestDispatcher("payment-success.jsp")
                .forward(request, response);
    }

    // ===============================
    // STEP 3: PDF Generator Method
    // ===============================
    private void generatePDF(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        // Retrieving the bill and the formatted reservation number from session
        Bill bill = (Bill) session.getAttribute("bill");
        String resNum = (String) session.getAttribute("resNum"); // This is the OVH-001 format
        String receiptNo = (String) session.getAttribute("receiptNo");

        // Redirect if no data is found to prevent empty PDF errors
        if (bill == null) {
            response.sendRedirect("viewReservations");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=Receipt_" + (resNum != null ? resNum : receiptNo) + ".pdf");

        try {
            com.itextpdf.text.Document document = new com.itextpdf.text.Document();
            com.itextpdf.text.pdf.PdfWriter.getInstance(document, response.getOutputStream());

            document.open();

            // Adding Header Info
            document.add(new com.itextpdf.text.Paragraph("Ocean View Hotel - Official Receipt"));
            document.add(new com.itextpdf.text.Paragraph("-----------------------------------------"));
            document.add(new com.itextpdf.text.Paragraph(" "));

            // Displaying the Reservation Number (OVH format)
            document.add(new com.itextpdf.text.Paragraph("Reservation Number: " + (resNum != null ? resNum : "N/A")));
            document.add(new com.itextpdf.text.Paragraph("Receipt Reference: " + receiptNo));
            document.add(new com.itextpdf.text.Paragraph(" "));

            // Billing Details
            document.add(new com.itextpdf.text.Paragraph("Room Category: " + bill.getRoomType()));
            document.add(new com.itextpdf.text.Paragraph("Stay Duration: " + bill.getDays() + " Day(s)"));
            document.add(new com.itextpdf.text.Paragraph("Daily Rate: LKR " + bill.getAmountPerDay()));
            document.add(new com.itextpdf.text.Paragraph(" "));

            // Final Total
            com.itextpdf.text.Paragraph total = new com.itextpdf.text.Paragraph("TOTAL PAID: LKR " + bill.getTotal());
            total.setAlignment(com.itextpdf.text.Element.ALIGN_LEFT);
            document.add(total);

            document.add(new com.itextpdf.text.Paragraph(" "));
            document.add(new com.itextpdf.text.Paragraph("Thank you for choosing Ocean View Hotel!"));

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
            // Fallback if PDF generation fails
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not generate PDF");
        }
    }
}