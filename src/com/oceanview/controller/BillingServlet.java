package com.oceanview.controller;

import com.oceanview.model.Bill;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

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
        request.setAttribute("resNum", resNum);
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

        long days = Long.parseLong(daysStr);
        double amount = Double.parseDouble(amountStr);
        double total = days * amount;

        String resIdStr = request.getParameter("reservationId");
        String receiptNo = "OVH-REC-" + String.format("%03d", Integer.parseInt(resIdStr));

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
        Bill bill = (Bill) session.getAttribute("bill");
        String receiptNo = (String) session.getAttribute("receiptNo");

        if (bill == null) {
            response.sendRedirect("ManageRoomsServlet");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=Receipt_" + receiptNo + ".pdf");

        try {

            com.itextpdf.text.Document document =
                    new com.itextpdf.text.Document();

            com.itextpdf.text.pdf.PdfWriter.getInstance(
                    document, response.getOutputStream());

            document.open();

            document.add(new com.itextpdf.text.Paragraph("Ocean View Hotel"));
            document.add(new com.itextpdf.text.Paragraph(" "));
            document.add(new com.itextpdf.text.Paragraph("PAYMENT RECEIPT"));
            document.add(new com.itextpdf.text.Paragraph(" "));
            document.add(new com.itextpdf.text.Paragraph("Receipt No: " + receiptNo));
            document.add(new com.itextpdf.text.Paragraph(" "));
            document.add(new com.itextpdf.text.Paragraph("Room Type: " + bill.getRoomType()));
            document.add(new com.itextpdf.text.Paragraph("Days: " + bill.getDays()));
            document.add(new com.itextpdf.text.Paragraph("Rate: LKR " + bill.getAmountPerDay()));
            document.add(new com.itextpdf.text.Paragraph(" "));
            document.add(new com.itextpdf.text.Paragraph("TOTAL PAID: LKR " + bill.getTotal()));
            document.add(new com.itextpdf.text.Paragraph(" "));
            document.add(new com.itextpdf.text.Paragraph("Thank you for choosing Ocean View Hotel!"));

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}