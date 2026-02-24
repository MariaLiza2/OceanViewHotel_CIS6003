package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAOImpl implements ReservationDAO {

    @Override
    public boolean addReservation(Reservation r) {
        String insertSql = "INSERT INTO Reservations (guest_name, address, contact_number, room_type, check_in, check_out, status) VALUES (?,?,?,?,?,?,'PENDING')";

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) return false;

            try (PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, r.getGuestName());
                ps.setString(2, r.getAddress());
                ps.setString(3, r.getContactNumber());
                ps.setString(4, r.getRoomType());
                ps.setDate(5, new java.sql.Date(r.getCheckIn().getTime()));
                ps.setDate(6, new java.sql.Date(r.getCheckOut().getTime()));

                int affectedRows = ps.executeUpdate();

                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            int newId = generatedKeys.getInt(1);
                            String resNumber = "OVH-" + String.format("%02d", newId);

                            String updateSql = "UPDATE Reservations SET reservation_number = ? WHERE reservation_id = ?";
                            try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
                                psUpdate.setString(1, resNumber);
                                psUpdate.setInt(2, newId);
                                psUpdate.executeUpdate();
                            }
                        }
                    }
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM Reservations";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Reservation r = new Reservation();
                int id = rs.getInt("reservation_id");
                r.setReservationId(id);

                // Handle 'PENDING' or 'null' in reservation_number column
                String dbResNum = rs.getString("reservation_number");
                if (dbResNum == null || dbResNum.equalsIgnoreCase("PENDING") || dbResNum.equalsIgnoreCase("null")) {
                    r.setReservationNumber("OVH-" + String.format("%02d", id));
                } else {
                    r.setReservationNumber(dbResNum);
                }

                r.setGuestName(rs.getString("guest_name"));
                r.setRoomType(rs.getString("room_type"));
                r.setCheckIn(rs.getDate("check_in"));
                r.setCheckOut(rs.getDate("check_out"));

                // CRITICAL FIX: Ensure status is never null when sent to JSP
                String status = rs.getString("status");
                r.setStatus(status != null ? status : "PENDING");

                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Reservation> searchReservationsByName(String name) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM Reservations WHERE guest_name LIKE ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Reservation r = new Reservation();
                int id = rs.getInt("reservation_id");
                r.setReservationId(id);

                String dbResNum = rs.getString("reservation_number");
                if (dbResNum == null || dbResNum.equalsIgnoreCase("PENDING") || dbResNum.equalsIgnoreCase("null")) {
                    r.setReservationNumber("OVH-" + String.format("%02d", id));
                } else {
                    r.setReservationNumber(dbResNum);
                }

                r.setGuestName(rs.getString("guest_name"));
                r.setRoomType(rs.getString("room_type"));
                r.setCheckIn(rs.getDate("check_in"));
                r.setCheckOut(rs.getDate("check_out"));

                // Ensure status is handled in search as well
                String status = rs.getString("status");
                r.setStatus(status != null ? status : "PENDING");

                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updatePaymentStatus(int reservationId) {
        // Using exactly 'reservation_id' as seen in your DB
        String sql = "UPDATE Reservations SET status = 'PAID' WHERE reservation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Returns true if the row was actually found and changed
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    @Override
    public Reservation getReservationById(int id) {
        String sql = "SELECT * FROM Reservations WHERE reservation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservation_id"));
                    r.setCheckIn(rs.getDate("check_in"));
                    r.setCheckOut(rs.getDate("check_out"));
                    r.setRoomType(rs.getString("room_type"));
                    r.setReservationNumber(rs.getString("reservation_number"));
                    return r;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}