package com.oceanview.dao;

import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuestDAO {

    public static List<Guest> getAllGuests() {
        List<Guest> list = new ArrayList<>();

        String sql = "SELECT * FROM guest_details ORDER BY guest_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Guest g = new Guest();
                g.setId(rs.getInt("guest_id"));
                g.setName(rs.getString("guest_name"));
                g.setContact(rs.getString("contact_number"));
                g.setAddress(rs.getString("address"));
                list.add(g);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void saveGuest(Guest guest) {
        String insertSql = "INSERT INTO guest_details (guest_name, contact_number, address) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {

            System.out.println("Saving Guest: " + guest.getName());
            System.out.println("Address Length: " + (guest.getAddress() != null ? guest.getAddress().length() : 0));

            PreparedStatement ps = con.prepareStatement(insertSql);
            ps.setString(1, guest.getName());
            ps.setString(2, guest.getContact());
            ps.setString(3, guest.getAddress());

            int rows = ps.executeUpdate();
            System.out.println("Update successful! Rows affected: " + rows);

        } catch (SQLException e) {

            System.out.println("SQL ERROR in saveGuest: " + e.getMessage());
            e.printStackTrace();
        }
    }
}