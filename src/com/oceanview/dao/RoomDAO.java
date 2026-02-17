package com.oceanview.dao;

import com.oceanview.model.Room;
import com.oceanview.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    // 1. Get all rooms from database
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
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Add a new room
    public static boolean addRoom(String type, double rate) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO rooms (room_type, rate_per_day, is_available) VALUES (?, ?, ?)"
            );
            ps.setString(1, type);
            ps.setDouble(2, rate);
            ps.setBoolean(3, true); // Default to available

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    } // <-- Fixed closing brace for addRoom

    // 3. Delete a room
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

    // 4. Update an existing room
    public static void updateRoom(int id, String type, double rate) {
        String sql = "UPDATE rooms SET room_type = ?, rate_per_day = ? WHERE room_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setDouble(2, rate);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}