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

        // FIX 1: Check for download action BEFORE checking for IDs
        // This prevents the redirect to 'viewReservations' when downloading
        String action = request.getParameter("action");
        if ("download".equals(action)) {
            generatePDF(request, response);
            return; // Stops here, successfully delivering the PDF
        }

        // --- Standard Billing Page Logic ---
        String resId = request.getParameter("id");
        if (resId == null) resId = request.getParameter("resId");

        String type = request.getParameter("type");
        String resNum = request.getParameter("resNum");

        // Redirect only if we aren't downloading AND have no ID
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

        try {
            // Step 2: Data Parsing
            int resId = Integer.parseInt(resIdStr);
            int days = Integer.parseInt(daysStr);
            double amount = Double.parseDouble(amountStr);
            double total = (double) days * amount;

            // Handle potential NULL reservation numbers safely
            String safeResNum = (resNum == null || resNum.equals("NULL")) ? "OVH-" + resId : resNum;
            String receiptNo = "OVH-REC-" + String.format("%03d", resId);

            // Step 3: Database Logic
            try (Connection conn = com.oceanview.util.DBConnection.getConnection()) {

                // A. Save to Payments (Matches your successful screenshot image_9f2832.png)
                String sql = "INSERT INTO Payments (reservation_id, reservation_number, room_type, total_amount, payment_method, payment_date) VALUES (?, ?, ?, ?, ?, GETDATE())";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, resId);
                    ps.setString(2, safeResNum);
                    ps.setString(3, roomType);
                    ps.setDouble(4, total);
                    ps.setString(5, paymentMethod);
                    ps.executeUpdate();
                }

                // B. Update Status (Matches your screenshot image_9f27d8.png)
                reservationDAO.updatePaymentStatus(resId);
            }

            // Step 4: Session for PDF
            Bill bill = new Bill();
            bill.setRoomType(roomType);
            bill.setDays(days);
            bill.setAmountPerDay(amount);
            bill.setTotal(total);

            HttpSession session = request.getSession();
            session.setAttribute("bill", bill);
            session.setAttribute("resNum", safeResNum);
            session.setAttribute("receiptNo", receiptNo);

            // Step 5: SUCCESS!
            request.getRequestDispatcher("payment-success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // This will print the EXACT error in your console
            response.sendRedirect("viewReservations?error=paymentFailed");
        }
    }
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

            // Info
            com.itextpdf.text.pdf.PdfPTable infoTable = new com.itextpdf.text.pdf.PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.addCell(getNoBorderCell("RECEIPT #: " + receiptNo));
            infoTable.addCell(getNoBorderCell("DATE: " + new java.util.Date().toString()));
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