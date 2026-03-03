package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RoomDAOImpl extends RoomDAO {


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
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 2500.0;
    }
}