package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAOImpl implements ReservationDAO {

    @Override
    public boolean addReservation(Reservation r) {

        String nextRoom = getNextAvailableRoomNumber();
        r.setRoomNumber(nextRoom);


        String insertSql = "INSERT INTO Reservations (guest_name, address, contact_number, room_type, check_in, check_out, status, room_number) VALUES (?,?,?,?,?,?,'PENDING',?)";

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) return false;

            try (PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, r.getGuestName());
                ps.setString(2, r.getAddress());
                ps.setString(3, r.getContactNumber());
                ps.setString(4, r.getRoomType());
                ps.setDate(5, new java.sql.Date(r.getCheckIn().getTime()));
                ps.setDate(6, new java.sql.Date(r.getCheckOut().getTime()));
                ps.setString(7, r.getRoomNumber()); // Automatically calculated number (e.g., 102)

                int affectedRows = ps.executeUpdate();
                if (affectedRows > 0) {

                    return true;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }


    private String getNextAvailableRoomNumber() {
        String sql = "SELECT MAX(CAST(room_number AS INT)) as max_room FROM Reservations WHERE room_number IS NOT NULL";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int lastRoom = rs.getInt("max_room");
                if (lastRoom >= 101 && lastRoom < 210) {
                    return String.valueOf(lastRoom + 1);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return "101";
    }

    @Override
    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM Reservations ORDER BY reservation_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Reservation> searchReservationsByName(String name) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM Reservations WHERE guest_name LIKE ? ORDER BY reservation_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToReservation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Reservation getReservationById(int id) {
        String sql = "SELECT * FROM Reservations WHERE reservation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReservation(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateReservation(Reservation r) {
        String sql = "UPDATE Reservations SET guest_name=?, room_type=?, check_in=?, check_out=? WHERE reservation_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getGuestName());
            ps.setString(2, r.getRoomType());
            ps.setDate(3, new java.sql.Date(r.getCheckIn().getTime()));
            ps.setDate(4, new java.sql.Date(r.getCheckOut().getTime()));
            ps.setInt(5, r.getReservationId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteReservation(int id) {
        // SQL 1: Delete the payments first
        String deletePaymentsSql = "DELETE FROM Payments WHERE reservation_id = ?";
        // SQL 2: Then delete the reservation
        String deleteReservationSql = "DELETE FROM Reservations WHERE reservation_id = ?";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start a transaction

            // Step 1: Remove dependent payments
            try (PreparedStatement ps1 = con.prepareStatement(deletePaymentsSql)) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }

            // Step 2: Remove the reservation
            int rowsAffected = 0;
            try (PreparedStatement ps2 = con.prepareStatement(deleteReservationSql)) {
                ps2.setInt(1, id);
                rowsAffected = ps2.executeUpdate();
            }

            con.commit(); // Save changes if both succeeded
            return rowsAffected > 0;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        }

    @Override
    public boolean updatePaymentStatus(int reservationId) {
        String sql = "UPDATE Reservations SET status = 'PAID' WHERE reservation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Helper method to map a ResultSet row to a Reservation object.
     * This ensures consistency across List, Search, and View methods.
     */
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        int id = rs.getInt("reservation_id");
        r.setReservationId(id);

        // Fixes the "N/A" issue by providing a fallback if DB column is empty
        String dbResNum = rs.getString("reservation_number");
        if (dbResNum == null || dbResNum.trim().isEmpty() || dbResNum.equalsIgnoreCase("null")) {
            r.setReservationNumber("OVH-" + String.format("%02d", id));
        } else {
            r.setReservationNumber(dbResNum);
        }

        r.setGuestName(rs.getString("guest_name"));
        r.setRoomType(rs.getString("room_type"));
        r.setCheckIn(rs.getDate("check_in"));
        r.setCheckOut(rs.getDate("check_out"));
        r.setRoomNumber(rs.getString("room_number"));
        // Ensures status defaults to PENDING if null
        String status = rs.getString("status");
        r.setStatus(status != null ? status : "PENDING");

        return r;
    }
}