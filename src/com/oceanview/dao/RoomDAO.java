package com.oceanview.dao;

import com.oceanview.model.Room;
import com.oceanview.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {


    public static List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM rooms");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setType(rs.getString("room_type"));
                r.setRate(rs.getDouble("rate_per_day"));

                r.setDescription(rs.getString("description"));
                r.setAvailable(rs.getBoolean("is_available"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public static boolean addRoom(String type, double rate, String description, boolean isAvailable) {
        String sql = "INSERT INTO rooms (room_type, rate_per_day, description, is_available) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, type);
            ps.setDouble(2, rate);
            ps.setString(3, description);
            ps.setBoolean(4, isAvailable);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public static void deleteRoom(int id) {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void updateRoom(int id, String type, double rate, String description, boolean isAvailable) {
        String sql = "UPDATE rooms SET room_type = ?, rate_per_day = ?, description = ?, is_available = ? WHERE room_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, type);
            ps.setDouble(2, rate);
            ps.setString(3, description);
            ps.setBoolean(4, isAvailable);
            ps.setInt(5, id);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void toggleRoomStatus(int id, boolean status) {
        String sql = "UPDATE rooms SET is_available = ? WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    public double getRoomPriceByType(String roomType) {
        String sql = "SELECT rate_per_day FROM rooms WHERE room_type = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, roomType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("rate_per_day");
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0.0;
    }
}