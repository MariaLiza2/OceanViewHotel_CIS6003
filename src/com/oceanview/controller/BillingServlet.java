package com.oceanview.controller;

import com.oceanview.model.Bill;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    // GET: Triggered by the "Billing" button in Reservation History
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String resId = request.getParameter("resId");
        String roomType = request.getParameter("type"); // Ensure this name matches your list link

        Bill bill = new Bill();
        if(resId != null) bill.setReservationId(Integer.parseInt(resId));
        bill.setRoomType(roomType != null ? roomType : "Standard");

        // Set default rates
        double rate = 2500.0;
        if("Double".equalsIgnoreCase(roomType)) rate = 4500.0;
        else if("Luxury".equalsIgnoreCase(roomType)) rate = 8500.0;

        bill.setAmountPerDay(rate);

        request.setAttribute("bill", bill);
        request.getRequestDispatcher("billing.jsp").forward(request, response);
    }

    // POST: Triggered by "Confirm Payment" button in billing.jsp
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Retrieve parameters safely
            String resIdStr = request.getParameter("reservationId");
            String totalStr = request.getParameter("totalAmount");
            String roomType = request.getParameter("roomType");
            String daysStr = request.getParameter("days");

            // Avoid NullPointerException with a check
            if (resIdStr == null || totalStr == null) {
                throw new Exception("Missing parameters for billing.");
            }

            Bill bill = new Bill();
            bill.setReservationId(Integer.parseInt(resIdStr));
            bill.setRoomType(roomType);
            bill.setDays(Integer.parseInt(daysStr));
            bill.setTotal(Double.parseDouble(totalStr));

            // Generate a random receipt number
            String receiptNo = "OVH-" + System.currentTimeMillis() / 1000;

            // Save to Session so paymentSuccess.jsp can read it
            HttpSession session = request.getSession();
            session.setAttribute("bill", bill);
            session.setAttribute("receiptNo", receiptNo);

            // Forward to success page
            request.getRequestDispatcher("payment-success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addReservation"); // Redirect on error
        }
    }
}