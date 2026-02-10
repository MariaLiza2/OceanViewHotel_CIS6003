package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAOImpl implements ReservationDAO {

    // Implementation of the addReservation method defined in the interface
    @Override
    public boolean addReservation(Reservation r) {
        String sql = "INSERT INTO Reservations " +
                "(guest_name, address, contact_number, room_type, check_in, check_out) " +
                "VALUES (?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // Safety check for null connection
            if (con == null) return false;

            ps.setString(1, r.getGuestName());
            ps.setString(2, r.getAddress());
            ps.setString(3, r.getContactNumber());
            ps.setString(4, r.getRoomType());

            // Converting java.util.Date to java.sql.Date
            ps.setDate(5, new java.sql.Date(r.getCheckIn().getTime()));
            ps.setDate(6, new java.sql.Date(r.getCheckOut().getTime()));

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // This satisfies the second method in your interface
    @Override
    public boolean Reservation(Reservation reservation) {
        return addReservation(reservation);
    }

    @Override
    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM Reservations";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            if (con == null) return list;

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationId(rs.getInt("reservation_id"));
                r.setGuestName(rs.getString("guest_name"));
                // Note: Ensure your address and contact columns are handled if needed
                r.setRoomType(rs.getString("room_type"));
                r.setCheckIn(rs.getDate("check_in"));
                r.setCheckOut(rs.getDate("check_out"));

                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}