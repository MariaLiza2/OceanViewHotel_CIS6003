package com.oceanview.controller;

import com.oceanview.model.Bill;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    private ReservationDAO reservationDAO = new ReservationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("download".equals(action)) {
            generatePDF(request, response);
            return;
        }

        String resId = request.getParameter("id");
        if (resId == null) resId = request.getParameter("resId");

        String type = request.getParameter("type");
        String resNum = request.getParameter("resNum");

        if (resId == null) {
            response.sendRedirect("viewReservations");
            return;
        }

        double rate = 2500.0;
        if ("Double".equalsIgnoreCase(type)) rate = 4500.0;
        else if ("Luxury".equalsIgnoreCase(type)) rate = 8500.0;

        Bill bill = new Bill();
        bill.setReservationId(Integer.parseInt(resId));
        bill.setRoomType(type != null ? type : "Standard");
        bill.setAmountPerDay(rate);

        request.setAttribute("bill", bill);
        HttpSession session = request.getSession();
        session.setAttribute("resNum", resNum);

        request.getRequestDispatcher("billing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Step 1: Capture parameters
        String resIdStr = request.getParameter("reservationId");
        String resNum = request.getParameter("resNum");
        String roomType = request.getParameter("roomType");
        String daysStr = request.getParameter("days");
        String amountStr = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");

        // DEBUG: Check if we are actually getting an ID
        System.out.println("DEBUG: Attempting payment for ResID: " + resIdStr);

        try {
            int resId = Integer.parseInt(resIdStr);
            int days = Integer.parseInt(daysStr);
            double amount = Double.parseDouble(amountStr);
            double total = (double) days * amount;

            String formattedResNum = (resNum == null || resNum.equalsIgnoreCase("PENDING") || resNum.equalsIgnoreCase("null"))
                    ? "OVH-" + String.format("%02d", resId) : resNum;
            String receiptNo = "OVH-REC-" + String.format("%03d", resId);

            // Step 2: Database Operations
            try (Connection conn = com.oceanview.util.DBConnection.getConnection()) {

                // Set AutoCommit to false to ensure BOTH updates happen or NEITHER happens
                conn.setAutoCommit(false);

                try {
                    // A. Insert into Payments
                    String sql = "INSERT INTO Payments (reservation_id, reservation_number, room_type, total_amount, payment_method, payment_date) VALUES (?, ?, ?, ?, ?, GETDATE())";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, resId);
                        ps.setString(2, formattedResNum);
                        ps.setString(3, roomType);
                        ps.setDouble(4, total);
                        ps.setString(5, paymentMethod);
                        ps.executeUpdate();
                    }

                    // B. Update Reservation Status
                    boolean daoUpdated = reservationDAO.updatePaymentStatus(resId);

                    if (daoUpdated) {
                        conn.commit(); // Save both changes
                        System.out.println("DEBUG: Payment saved and Reservation status updated.");
                    } else {
                        conn.rollback(); // Cancel payment if status update fails
                        System.out.println("DEBUG: Status update FAILED. Transaction rolled back.");
                        throw new Exception("Reservation status update failed.");
                    }

                } catch (Exception innerE) {
                    conn.rollback();
                    throw innerE;
                }
            }

            // Step 3: Session Setup
            Bill bill = new Bill();
            bill.setRoomType(roomType);
            bill.setDays(days);
            bill.setAmountPerDay(amount);
            bill.setTotal(total);

            HttpSession session = request.getSession();
            session.setAttribute("bill", bill);
            session.setAttribute("resNum", formattedResNum);
            session.setAttribute("receiptNo", receiptNo);

            request.getRequestDispatcher("payment-success.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("CRITICAL ERROR: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("viewReservations?error=paymentFailed");
        }
    }

    // ... generatePDF and helper methods remain the same ...
    private void generatePDF(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Bill bill = (Bill) session.getAttribute("bill");
        String resNum = (String) session.getAttribute("resNum");
        String receiptNo = (String) session.getAttribute("receiptNo");

        if (bill == null) {
            response.sendRedirect("viewReservations");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Receipt_" + (resNum != null ? resNum : "Receipt") + ".pdf");

        try {
            com.itextpdf.text.Document document = new com.itextpdf.text.Document();
            com.itextpdf.text.pdf.PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Header
            com.itextpdf.text.Font titleFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 22, com.itextpdf.text.Font.BOLD, com.itextpdf.text.BaseColor.BLUE);
            com.itextpdf.text.Paragraph title = new com.itextpdf.text.Paragraph("RECEIPT", titleFont);
            title.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
            document.add(title);
            document.add(new com.itextpdf.text.Paragraph("Ocean View Hotel", new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 14, com.itextpdf.text.Font.BOLD)));
            document.add(new com.itextpdf.text.Paragraph(" "));

            // Info Table
            com.itextpdf.text.pdf.PdfPTable infoTable = new com.itextpdf.text.pdf.PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.addCell(getNoBorderCell("RECEIPT #: " + receiptNo));
            infoTable.addCell(getNoBorderCell("DATE: " + new java.util.Date().toString()));
            // This line now uses the resNum from the session
            infoTable.addCell(getNoBorderCell("RESERVATION NO: " + (resNum != null ? resNum : "N/A")));
            document.add(infoTable);
            document.add(new com.itextpdf.text.Paragraph(" "));

            // Details Table
            com.itextpdf.text.pdf.PdfPTable table = new com.itextpdf.text.pdf.PdfPTable(4);
            table.setWidthPercentage(100);
            addTableHeader(table, "DESCRIPTION");
            addTableHeader(table, "UNIT COST");
            addTableHeader(table, "QTY (DAYS)");
            addTableHeader(table, "AMOUNT");

            table.addCell(bill.getRoomType());
            table.addCell("LKR " + bill.getAmountPerDay());
            table.addCell(String.valueOf(bill.getDays()));
            table.addCell("LKR " + bill.getTotal());

            document.add(table);
            document.add(new com.itextpdf.text.Paragraph(" "));

            com.itextpdf.text.Paragraph totalPara = new com.itextpdf.text.Paragraph("TOTAL PAID: LKR " + bill.getTotal(),
                    new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 12, com.itextpdf.text.Font.BOLD));
            totalPara.setAlignment(com.itextpdf.text.Element.ALIGN_RIGHT);
            document.add(totalPara);

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void addTableHeader(com.itextpdf.text.pdf.PdfPTable table, String headerTitle) {
        com.itextpdf.text.pdf.PdfPCell header = new com.itextpdf.text.pdf.PdfPCell();
        header.setBackgroundColor(com.itextpdf.text.BaseColor.LIGHT_GRAY);
        header.setPhrase(new com.itextpdf.text.Phrase(headerTitle, new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10, com.itextpdf.text.Font.BOLD)));
        table.addCell(header);
    }

    private com.itextpdf.text.pdf.PdfPCell getNoBorderCell(String text) {
        com.itextpdf.text.pdf.PdfPCell cell = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase(text));
        cell.setBorder(com.itextpdf.text.Rectangle.NO_BORDER);
        return cell;
    }
}