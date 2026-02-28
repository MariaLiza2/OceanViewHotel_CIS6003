package com.oceanview.controller;

import com.oceanview.util.DBConnection;
import com.oceanview.model.Reservation;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

@WebServlet("/adminreports")
public class AdminReportServlet extends HttpServlet {

    // Define the Sage Green color for branding
    private static final BaseColor SAGE_GREEN = new BaseColor(74, 93, 69);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reportType = request.getParameter("type");
        String action = request.getParameter("action");
        String reportDate = request.getParameter("reportDate");

        try {
            if ("download".equals(action)) {
                if ("reservations".equals(reportType)) {
                    generateReservationPDF(request, response, reportDate);
                } else if ("payments".equals(reportType)) {
                    generatePaymentPDF(request, response, reportDate);
                }
            } else if ("view".equals(action)) {
                request.setAttribute("selectedDate", reportDate);
                if ("reservations".equals(reportType)) {
                    request.setAttribute("resList", fetchReservationsFromDB(reportDate));
                    request.getRequestDispatcher("/admin-res-list.jsp").forward(request, response);
                } else if ("payments".equals(reportType)) {
                    request.setAttribute("payList", fetchPaymentsFromDB(reportDate));
                    request.getRequestDispatcher("/admin-pay-list.jsp").forward(request, response);
                }
            } else {
                // Default view (Dashboard)
                request.getRequestDispatcher("/admin-reports-view.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-reports-view.jsp?msg=error");
        }
    }

    private void generatePaymentPDF(HttpServletRequest request, HttpServletResponse response, String date) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Payment_Report_" + date + ".pdf");

        try (javax.servlet.ServletOutputStream out = response.getOutputStream();
             Connection con = DBConnection.getConnection()) {

            Document document = new Document();
            PdfWriter.getInstance(document, out);
            document.open();

            Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, SAGE_GREEN);
            document.add(new Paragraph("OCEAN VIEW HOTEL - PAYMENT SETTLEMENT", titleFont));
            document.add(new Paragraph("Transaction Date: " + date));
            document.add(new Paragraph(" "));

            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(100);

            // Header Cells
            String[] headers = {"Res ID", "Method", "Time", "Amount (LKR)"};
            for (String h : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(h, FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
                cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                table.addCell(cell);
            }

            // Updated SQL to use total_amount as per your database schema
            String sql = "SELECT reservation_id, payment_method, payment_date, total_amount FROM Payments WHERE CAST(payment_date AS DATE) = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, date);
                ResultSet rs = ps.executeQuery();
                double total = 0;

                while (rs.next()) {
                    table.addCell(String.valueOf(rs.getInt("reservation_id")));
                    table.addCell(rs.getString("payment_method"));
                    table.addCell(rs.getTimestamp("payment_date").toString());

                    double amt = rs.getDouble("total_amount");
                    // CHANGE: Replaced $ with LKR and added comma formatting
                    table.addCell("LKR " + String.format("%,.2f", amt));
                    total += amt;
                }

                document.add(table);
                document.add(new Paragraph(" "));
                // CHANGE: Replaced $ with LKR here too
                document.add(new Paragraph("TOTAL REVENUE: LKR " + String.format("%,.2f", total), titleFont));
            }
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // --- PDF GENERATION: RESERVATIONS ---
    private void generateReservationPDF(HttpServletRequest request, HttpServletResponse response, String date) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Reservation_Report_" + date + ".pdf");

        try (javax.servlet.ServletOutputStream out = response.getOutputStream();
             Connection con = DBConnection.getConnection()) {

            Document document = new Document();
            PdfWriter.getInstance(document, out);
            document.open();

            Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, SAGE_GREEN);
            document.add(new Paragraph("OCEAN VIEW HOTEL - RESERVATIONS", titleFont));
            document.add(new Paragraph("Booking Date: " + date));
            document.add(new Paragraph(" "));

            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);

            // Table Headers
            String[] headers = {"Guest", "Room", "In", "Out", "Status"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
                cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                table.addCell(cell);
            }

            String sql = "SELECT guest_name, room_type, check_in, check_out, status FROM Reservations WHERE CAST(booking_date AS DATE) = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, date);
                ResultSet rs = ps.executeQuery();
                boolean hasData = false;

                while (rs.next()) {
                    hasData = true;
                    table.addCell(rs.getString(1));
                    table.addCell(rs.getString(2));
                    table.addCell(rs.getDate(3).toString());
                    table.addCell(rs.getDate(4).toString());
                    table.addCell(rs.getString(5));
                }

                if (!hasData) {
                    PdfPCell emptyCell = new PdfPCell(new Phrase("No reservations found for this date."));
                    emptyCell.setColspan(5);
                    emptyCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(emptyCell);
                }
                document.add(table);
            }
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- DATABASE HELPERS ---
    private List<Reservation> fetchReservationsFromDB(String date) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM Reservations WHERE CAST(booking_date AS DATE) = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationId(rs.getInt("reservation_id"));
                r.setGuestName(rs.getString("guest_name"));
                r.setRoomType(rs.getString("room_type"));
                r.setCheckIn(rs.getDate("check_in"));
                r.setCheckOut(rs.getDate("check_out"));
                r.setStatus(rs.getString("status"));
                list.add(r);
            }
        }
        return list;
    }

    private List<Map<String, Object>> fetchPaymentsFromDB(String date) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        // Note: I am selecting total_amount here
        String sql = "SELECT reservation_id, total_amount, payment_method, payment_date FROM Payments WHERE CAST(payment_date AS DATE) = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("resId", rs.getInt("reservation_id"));
                map.put("amount", rs.getDouble("total_amount")); // FIXED COLUMN NAME
                map.put("method", rs.getString("payment_method"));
                map.put("date", rs.getTimestamp("payment_date"));
                list.add(map);
            }
        }
        return list;
    }
}