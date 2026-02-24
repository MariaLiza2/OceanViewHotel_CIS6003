package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomDAOImpl;
import com.oceanview.model.Bill;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    private ReservationDAO reservationDAO = new ReservationDAOImpl();
    private RoomDAO roomDAO = new RoomDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("download".equals(action)) {
            generatePDF(request, response);
            return;
        }

        String resIdStr = request.getParameter("id");
        if (resIdStr == null) resIdStr = request.getParameter("resId");

        if (resIdStr == null) {
            response.sendRedirect("viewReservations");
            return;
        }

        try {
            int resId = Integer.parseInt(resIdStr);
            Reservation res = reservationDAO.getReservationById(resId);

            if (res == null) {
                response.sendRedirect("viewReservations");
                return;
            }

            // 1. DYNAMIC DAYS CALCULATION (Calendar-based)
            long diffInMillies = Math.abs(res.getCheckOut().getTime() - res.getCheckIn().getTime());
            long diffInDays = diffInMillies / (1000 * 60 * 60 * 24);
            if (diffInDays <= 0) diffInDays = 1;

            // 2. DYNAMIC ROOM RATE (From Manage Rooms Database)
            double rate = roomDAO.getRoomPriceByType(res.getRoomType());

            Bill bill = new Bill();
            bill.setReservationId(resId);
            bill.setRoomType(res.getRoomType());
            bill.setAmountPerDay(rate);
            bill.setDays((int) diffInDays);
            bill.setTotal(diffInDays * rate);

            request.setAttribute("bill", bill);

            HttpSession session = request.getSession();
            session.setAttribute("resNum", res.getReservationNumber());

            request.getRequestDispatcher("billing.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewReservations");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String resIdStr = request.getParameter("reservationId");
        String resNum = request.getParameter("resNum");
        String roomType = request.getParameter("roomType");
        String daysStr = request.getParameter("days");
        String amountStr = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");

        try {
            int resId = Integer.parseInt(resIdStr);
            int days = Integer.parseInt(daysStr);
            double amount = Double.parseDouble(amountStr);
            double total = (double) days * amount;

            String receiptNo = "OVH-REC-" + String.format("%03d", resId);

            // Database Operations
            try (Connection conn = com.oceanview.util.DBConnection.getConnection()) {
                conn.setAutoCommit(false); // Transaction safety

                try {
                    // A. Insert Payment
                    String sql = "INSERT INTO Payments (reservation_id, reservation_number, room_type, total_amount, payment_method, payment_date) VALUES (?, ?, ?, ?, ?, GETDATE())";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, resId);
                        ps.setString(2, resNum);
                        ps.setString(3, roomType);
                        ps.setDouble(4, total);
                        ps.setString(5, paymentMethod);
                        ps.executeUpdate();
                    }

                    // B. Update Reservation Status
                    reservationDAO.updatePaymentStatus(resId);

                    conn.commit();
                } catch (Exception e) {
                    conn.rollback();
                    throw e;
                }
            }

            // Save to session for PDF
            Bill bill = new Bill();
            bill.setRoomType(roomType);
            bill.setDays(days);
            bill.setAmountPerDay(amount);
            bill.setTotal(total);

            HttpSession session = request.getSession();
            session.setAttribute("bill", bill);
            session.setAttribute("resNum", resNum);
            session.setAttribute("receiptNo", receiptNo);

            request.getRequestDispatcher("payment-success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
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

            // --- HOTEL HEADER ---
            com.itextpdf.text.Font titleFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 22, com.itextpdf.text.Font.BOLD, com.itextpdf.text.BaseColor.BLUE);
            com.itextpdf.text.Paragraph title = new com.itextpdf.text.Paragraph("RECEIPT", titleFont);
            title.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
            document.add(title);

            document.add(new com.itextpdf.text.Paragraph("Ocean View Hotel", new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 14, com.itextpdf.text.Font.BOLD)));

            // ADDED ADDRESS
            document.add(new com.itextpdf.text.Paragraph("123 Beach Road, Galle, Sri Lanka", new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10)));
            document.add(new com.itextpdf.text.Paragraph("Contact: +94 112 345 678", new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10)));
            document.add(new com.itextpdf.text.Paragraph(" "));

            // --- INFO TABLE (Receipt No, Date, Reservation No) ---
            com.itextpdf.text.pdf.PdfPTable infoTable = new com.itextpdf.text.pdf.PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.addCell(getNoBorderCell("RECEIPT #: " + receiptNo));
            infoTable.addCell(getNoBorderCell("DATE: " + new java.util.Date().toString()));

            // ENSURING RESERVATION NO. IS SHOWN
            infoTable.addCell(getNoBorderCell("RESERVATION NO: " + (resNum != null ? resNum : "N/A")));
            document.add(infoTable);
            document.add(new com.itextpdf.text.Paragraph(" "));

            // --- DETAILS TABLE ---
            com.itextpdf.text.pdf.PdfPTable table = new com.itextpdf.text.pdf.PdfPTable(4);
            table.setWidthPercentage(100);
            addTableHeader(table, "DESCRIPTION");
            addTableHeader(table, "UNIT COST");
            addTableHeader(table, "QTY (DAYS)");
            addTableHeader(table, "AMOUNT");

            table.addCell(bill.getRoomType());
            table.addCell("LKR " + String.format("%.2f", bill.getAmountPerDay()));
            table.addCell(String.valueOf(bill.getDays()));
            table.addCell("LKR " + String.format("%.2f", bill.getTotal())); //

            document.add(table);
            document.add(new com.itextpdf.text.Paragraph(" "));

            // --- GRAND TOTAL ---
            com.itextpdf.text.Paragraph totalPara = new com.itextpdf.text.Paragraph("GRAND TOTAL: LKR " + String.format("%.2f", bill.getTotal()),
                    new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 14, com.itextpdf.text.Font.BOLD));
            totalPara.setAlignment(com.itextpdf.text.Element.ALIGN_RIGHT);
            document.add(totalPara);

            document.add(new com.itextpdf.text.Paragraph(" "));
            com.itextpdf.text.Paragraph footer = new com.itextpdf.text.Paragraph("Thank you for staying with us!", new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10, com.itextpdf.text.Font.ITALIC));
            footer.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
            document.add(footer);

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