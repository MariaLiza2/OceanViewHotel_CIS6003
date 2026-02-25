package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RoomDAOImpl extends RoomDAO {

    // 6. Get room price based on type
    public double getRoomPriceByType(String roomType) {
        String sql = "SELECT rate_per_day FROM rooms WHERE room_type = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Returns the actual price managed in your database
                    return rs.getDouble("rate_per_day");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Fallback value to prevent a 0.00 total if the room type isn't found
        return 2500.0;
    }
}