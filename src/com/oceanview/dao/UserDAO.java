package com.oceanview.dao;

import com.oceanview.model.User;
import com.oceanview.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public User getUserByUsername(String username) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ?";

        // Get the connection first to check for null
        Connection con = DBConnection.getConnection();

        if (con == null) {
            System.err.println("CRITICAL ERROR: Could not establish a database connection. Check DBConnection.java and your DLL files.");
            return null;
        }

        // Use try-with-resources to ensure the connection and statement close properly
        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                }
            }
        } catch (Exception e) {
            System.err.println("SQL Error in getUserByUsername:");
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return user;
    }

    public User validateUser(String username, String password) {
        // Basic check for empty inputs before hitting the DB
        if (username == null || password == null) return null;

        User user = getUserByUsername(username);

        // Compare plain text passwords with trim to handle DB padding
        if (user != null && password.trim().equals(user.getPassword().trim())) {
            return user;
        }
        return null;
    }


    public boolean registerUser(User user) {

        String sql = "INSERT INTO users(username, password, role) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword()); // plain for now
            ps.setString(3, user.getRole());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}