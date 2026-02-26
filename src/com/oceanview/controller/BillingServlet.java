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
import java.sql.ResultSet;

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

            // Calculation Logic
            long diffInMillies = Math.abs(res.getCheckOut().getTime() - res.getCheckIn().getTime());
            long diffInDays = diffInMillies / (1000 * 60 * 60 * 24);
            if (diffInDays <= 0) diffInDays = 1;

            double rate = roomDAO.getRoomPriceByType(res.getRoomType());

            Bill bill = new Bill();
            bill.setReservationId(resId);
            bill.setRoomType(res.getRoomType());
            bill.setAmountPerDay(rate);
            bill.setDays((int) diffInDays);
            bill.setTotal(diffInDays * rate);

            request.setAttribute("bill", bill);

            HttpSession session = request.getSession();
            session.setAttribute("bill", bill);
            session.setAttribute("resNum", res.getReservationNumber());
            session.setAttribute("guestName", res.getGuestName());

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
        String totalStr = request.getParameter("totalAmount");
        String paymentMethod = request.getParameter("paymentMethod");

        try {
            if (resIdStr == null || totalStr == null || totalStr.isEmpty()) {
                throw new Exception("Missing Reservation ID or Total Amount");
            }

            int resId = Integer.parseInt(resIdStr);

            // Clean currency symbols or spaces if they exist in the input
            String cleanTotal = totalStr.replace("LKR", "").replace(",", "").trim();
            double total = Double.parseDouble(cleanTotal);
            int days = (daysStr != null && !daysStr.isEmpty()) ? Integer.parseInt(daysStr) : 1;

            // 1. DATA VALIDATION: Fetch fresh data to ensure resNum and guestName are NOT NULL
            Reservation res = reservationDAO.getReservationById(resId);
            if (res == null) throw new Exception("Reservation record not found.");

            String guestName = (res.getGuestName() != null) ? res.getGuestName() : "Guest";

            // Fix for the Unique Constraint <NULL> error:
            // If resNum is null from form, take it from database. If still null, generate a fallback.
            if (resNum == null || resNum.trim().isEmpty() || resNum.equalsIgnoreCase("null")) {
                resNum = (res.getReservationNumber() != null) ? res.getReservationNumber() : "OVH-RES-" + resId;
            }

            String receiptNo = "OVH-REC-" + String.format("%03d", resId);

            try (Connection conn = com.oceanview.util.DBConnection.getConnection()) {
                conn.setAutoCommit(false);

                // Duplicate Check to prevent crashes
                String checkSql = "SELECT COUNT(*) FROM Payments WHERE reservation_id = ?";
                try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                    checkPs.setInt(1, resId);
                    try (ResultSet rs = checkPs.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            conn.rollback();
                            response.sendRedirect("viewReservations?error=alreadyPaid");
                            return;
                        }
                    }
                }

                // Database Insert
                String sql = "INSERT INTO Payments (reservation_id, reservation_number, room_type, total_amount, payment_method, payment_date) VALUES (?, ?, ?, ?, ?, GETDATE())";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, resId);
                    ps.setString(2, resNum); // This is now guaranteed to not be NULL
                    ps.setString(3, roomType);
                    ps.setDouble(4, total);
                    ps.setString(5, paymentMethod);
                    ps.executeUpdate();

                    reservationDAO.updatePaymentStatus(resId);
                    conn.commit();
                } catch (Exception e) {
                    conn.rollback();
                    throw e;
                }
            }

            // 2. Refresh the Session for PDF generation
            HttpSession session = request.getSession();
            Bill bill = new Bill();
            bill.setReservationId(resId);
            bill.setRoomType(roomType);
            bill.setDays(days);
            bill.setTotal(total);
            bill.setAmountPerDay(total / (days > 0 ? days : 1));

            session.setAttribute("bill", bill);
            session.setAttribute("resNum", resNum);
            session.setAttribute("receiptNo", receiptNo);
            session.setAttribute("guestName", guestName);

            request.getRequestDispatcher("payment-success.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("PAYMENT ERROR: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("viewReservations?error=paymentFailed");
        }
    }

    private void generatePDF(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Bill bill = (Bill) session.getAttribute("bill");

        if (bill == null) {
            response.sendRedirect("viewReservations");
            return;
        }

        // Fresh fetch for PDF to avoid "N/A"
        String guestName = "Valued Guest";
        String resNum = "N/A";
        try {
            Reservation res = reservationDAO.getReservationById(bill.getReservationId());
            if (res != null) {
                guestName = (res.getGuestName() != null) ? res.getGuestName() : "Valued Guest";
                resNum = (res.getReservationNumber() != null) ? res.getReservationNumber() : "N/A";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String receiptNo = (String) session.getAttribute("receiptNo");
        if (receiptNo == null) receiptNo = "OVH-REC-" + String.format("%03d", bill.getReservationId());

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Receipt_" + receiptNo + ".pdf");

        try {
            com.itextpdf.text.Document document = new com.itextpdf.text.Document();
            com.itextpdf.text.pdf.PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Header
            com.itextpdf.text.Font titleFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 22, com.itextpdf.text.Font.BOLD, com.itextpdf.text.BaseColor.BLUE);
            com.itextpdf.text.Paragraph title = new com.itextpdf.text.Paragraph("PAYMENT RECEIPT", titleFont);
            title.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
            document.add(title);
            document.add(new com.itextpdf.text.Paragraph(" "));

            document.add(new com.itextpdf.text.Paragraph("Ocean View Hotel", new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 14, com.itextpdf.text.Font.BOLD)));
            document.add(new com.itextpdf.text.Paragraph("123 Beach Road, Galle, Sri Lanka", new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10)));
            document.add(new com.itextpdf.text.Paragraph(" "));

            // Info Table
            com.itextpdf.text.pdf.PdfPTable infoTable = new com.itextpdf.text.pdf.PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.addCell(getNoBorderCell("RECEIPT #: " + receiptNo));
            infoTable.addCell(getNoBorderCell("DATE: " + new java.util.Date().toString()));
            infoTable.addCell(getNoBorderCell("GUEST NAME: " + guestName));
            infoTable.addCell(getNoBorderCell("RESERVATION ID: " + bill.getReservationId()));
            infoTable.addCell(getNoBorderCell("RESERVATION NO: " + resNum));
            infoTable.addCell(getNoBorderCell("STATUS: PAID"));
            document.add(infoTable);
            document.add(new com.itextpdf.text.Paragraph(" "));

            // Invoice Items
            com.itextpdf.text.pdf.PdfPTable table = new com.itextpdf.text.pdf.PdfPTable(4);
            table.setWidthPercentage(100);
            addTableHeader(table, "DESCRIPTION");
            addTableHeader(table, "UNIT COST");
            addTableHeader(table, "QTY (DAYS)");
            addTableHeader(table, "AMOUNT");

            table.addCell(bill.getRoomType() + " Accommodation");
            table.addCell("LKR " + String.format("%.2f", bill.getAmountPerDay()));
            table.addCell(String.valueOf(bill.getDays()));
            table.addCell("LKR " + String.format("%.2f", bill.getTotal()));
            document.add(table);
            document.add(new com.itextpdf.text.Paragraph(" "));

            com.itextpdf.text.Paragraph totalPara = new com.itextpdf.text.Paragraph("GRAND TOTAL: LKR " + String.format("%.2f", bill.getTotal()),
                    new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 16, com.itextpdf.text.Font.BOLD));
            totalPara.setAlignment(com.itextpdf.text.Element.ALIGN_RIGHT);
            document.add(totalPara);

            document.close();
        } catch (Exception e) { e.printStackTrace(); }
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