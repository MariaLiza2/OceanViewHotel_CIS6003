package com.oceanview.model;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/admin/reports")
    public class AdminReportServlet extends HttpServlet {

        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String reportType = request.getParameter("type"); // "reservations" or "payments"
            String action = request.getParameter("action"); // "view" or "download"

            if ("reservations".equals(reportType)) {
                // Logic to fetch filtered reservations
                if ("download".equals(action)) {
                    generateReservationPDF(request, response);
                } else {
                    request.getRequestDispatcher("admin-res-list.jsp").forward(request, response);
                }
            }
            else if ("payments".equals(reportType)) {
                // Logic to fetch filtered payments
                if ("download".equals(action)) {
                    generatePaymentPDF(request, response);
                } else {
                    request.getRequestDispatcher("admin-pay-list.jsp").forward(request, response);
                }
            }
        }

        private void generatePaymentPDF(HttpServletRequest request, HttpServletResponse response) {

        }

        private void generateReservationPDF(HttpServletRequest request, HttpServletResponse response) {
        }
    }

