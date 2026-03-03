package com.oceanview.dao;

import com.oceanview.model.Payment;
import com.oceanview.util.DBConnection; // Adjust based on your connection utility
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();

        String sql = "SELECT p.*, r.guestName FROM payments p " +
                "JOIN reservations r ON p.reservationId = r.reservationId " +
                "ORDER BY p.paymentDate DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Payment p = new Payment();
                p.setReservationId(rs.getInt("reservationId"));
                p.setReservationNumber(rs.getString("reservationNumber"));
                p.setRoomType(rs.getString("roomType"));
                p.setTotalAmount(rs.getDouble("totalAmount"));
                p.setPaymentMethod(rs.getString("paymentMethod"));
                p.setPaymentDate(Timestamp.valueOf(rs.getString("paymentDate")));


                p.setGuestName(rs.getString("guestName"));

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}