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
        String searchQuery = request.getParameter("searchQuery");

        try (Connection conn = com.oceanview.util.DBConnection.getConnection()) {
            StringBuilder sql = new StringBuilder();


            sql.append("SELECT p.*, r.guest_name ");
            sql.append("FROM Payments p ");
            sql.append("JOIN Reservations r ON p.reservation_id = r.reservation_id ");

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                sql.append("WHERE p.reservation_number LIKE ? ");
            }
            sql.append("ORDER BY p.payment_date DESC");

            PreparedStatement ps = conn.prepareStatement(sql.toString());

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(1, "%" + searchQuery.trim() + "%");
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

                p.setGuestName(rs.getString("guest_name"));

                paymentList.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("payments", paymentList);
        request.getRequestDispatcher("payment-list.jsp").forward(request, response);
    }
}