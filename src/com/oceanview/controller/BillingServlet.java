package com.oceanview.controller;

import com.oceanview.model.Bill;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String rateStr = request.getParameter("rate");

        if (rateStr == null || rateStr.trim().isEmpty()) {
            response.sendRedirect("ManageRoomsServlet");
            return;
        }

        double rate = Double.parseDouble(rateStr);

        Bill bill = new Bill();
        bill.setRoomType(type);
        bill.setAmountPerDay(rate);
        bill.setDays(1);

        request.setAttribute("bill", bill);
        request.getRequestDispatcher("billing.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form values
        String daysStr = request.getParameter("days");
        String amountStr = request.getParameter("amount");

        long days = 1;
        double amount = 0;

        if (daysStr != null) {
            days = Long.parseLong(daysStr);
        }

        if (amountStr != null) {
            amount = Double.parseDouble(amountStr);
        }

        // Calculate total
        double total = days * amount;

        // Create Bill object
        Bill bill = new Bill();
        bill.setDays(days);
        bill.setAmountPerDay(amount);
        bill.setTotal(total);

        // Send result to confirmation page
        request.setAttribute("bill", bill);

        request.getRequestDispatcher("payment-success.jsp")
                .forward(request, response);
    }

}
