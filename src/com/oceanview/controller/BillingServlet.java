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
        double rate = 25000.0; // Default
        if ("Double".equalsIgnoreCase(type)) rate = 45000.0;
        else if ("Luxury".equalsIgnoreCase(type)) rate = 85000.0;

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

            // 1. Header Section (Title and Business Name)
            com.itextpdf.text.Font titleFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 22, com.itextpdf.text.Font.BOLD, com.itextpdf.text.BaseColor.BLUE);
            com.itextpdf.text.Paragraph title = new com.itextpdf.text.Paragraph("RECEIPT", titleFont);
            title.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
            document.add(title);
            document.add(new com.itextpdf.text.Paragraph("Ocean View Hotel", new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 14, com.itextpdf.text.Font.BOLD)));
            document.add(new com.itextpdf.text.Paragraph("123 Beach Road, Negombo, Sri Lanka"));
            document.add(new com.itextpdf.text.Paragraph(" "));

            // 2. Info Table (Receipt # and Date)
            com.itextpdf.text.pdf.PdfPTable infoTable = new com.itextpdf.text.pdf.PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.addCell(getNoBorderCell("RECEIPT #: " + receiptNo));
            infoTable.addCell(getNoBorderCell("DATE: " + new java.util.Date().toString()));
            infoTable.addCell(getNoBorderCell("RESERVATION NO: " + (resNum != null ? resNum : "N/A"))); // Fixes N/A issue
            infoTable.addCell(getNoBorderCell(" "));
            document.add(infoTable);
            document.add(new com.itextpdf.text.Paragraph(" "));

            // 3. Billing Table (The main table from your layout)
            com.itextpdf.text.pdf.PdfPTable table = new com.itextpdf.text.pdf.PdfPTable(4);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{3f, 1.5f, 1f, 1.5f});

            // Blue Table Header
            addTableHeader(table, "DESCRIPTION");
            addTableHeader(table, "UNIT COST");
            addTableHeader(table, "QTY (DAYS)");
            addTableHeader(table, "AMOUNT");

            // Table Rows
            table.addCell("Room Category: " + bill.getRoomType());
            table.addCell("LKR " + bill.getAmountPerDay());
            table.addCell(String.valueOf(bill.getDays()));
            table.addCell("LKR " + bill.getTotal());

            document.add(table);

            // 4. Totals Section
            document.add(new com.itextpdf.text.Paragraph(" "));
            com.itextpdf.text.Paragraph totalPara = new com.itextpdf.text.Paragraph("TOTAL PAID: LKR " + bill.getTotal(),
                    new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 12, com.itextpdf.text.Font.BOLD));
            totalPara.setAlignment(com.itextpdf.text.Element.ALIGN_RIGHT);
            document.add(totalPara);

            document.add(new com.itextpdf.text.Paragraph("\nThank you for choosing Ocean View Hotel!"));
            document.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF");
        }
    }

    // Helper method for the header color
    private void addTableHeader(com.itextpdf.text.pdf.PdfPTable table, String headerTitle) {
        com.itextpdf.text.pdf.PdfPCell header = new com.itextpdf.text.pdf.PdfPCell();
        header.setBackgroundColor(com.itextpdf.text.BaseColor.LIGHT_GRAY);
        header.setPhrase(new com.itextpdf.text.Phrase(headerTitle, new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10, com.itextpdf.text.Font.BOLD)));
        table.addCell(header);
    }

    // Helper method to remove cell borders
    private com.itextpdf.text.pdf.PdfPCell getNoBorderCell(String text) {
        com.itextpdf.text.pdf.PdfPCell cell = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase(text));
        cell.setBorder(com.itextpdf.text.Rectangle.NO_BORDER);
        return cell;
    }
    }
