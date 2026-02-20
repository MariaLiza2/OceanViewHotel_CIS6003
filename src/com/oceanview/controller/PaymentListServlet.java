package com.oceanview.controller;

import com.oceanview.model.Payment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


    @WebServlet("/viewPayments")
    public class PaymentListServlet extends HttpServlet {
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            List<Payment> paymentList = new ArrayList<>();
            // Get the search input from the JSP
            String searchQuery = request.getParameter("searchQuery");

            try (Connection conn = com.oceanview.util.DBConnection.getConnection()) {
                String sql;
                PreparedStatement ps;

                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    // Search mode: Filter by reservation_number
                    sql = "SELECT * FROM Payments WHERE reservation_number LIKE ? ORDER BY payment_date DESC";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchQuery.trim() + "%");
                } else {
                    // Normal mode: Show all payments
                    sql = "SELECT * FROM Payments ORDER BY payment_date DESC";
                    ps = conn.prepareStatement(sql);
                }

                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Payment p = new Payment();
                    p.setReservationId(rs.getInt("reservation_id"));
                    p.setReservationNumber(rs.getString("reservation_number"));
                    p.setRoomType(rs.getString("room_type"));
                    p.setTotalAmount(rs.getDouble("total_amount"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setPaymentDate(rs.getTimestamp("payment_date"));
                    paymentList.add(p);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            request.setAttribute("payments", paymentList);
            request.getRequestDispatcher("payment-list.jsp").forward(request, response);
        }}
