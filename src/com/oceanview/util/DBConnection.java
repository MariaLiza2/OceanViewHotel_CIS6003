package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Update these details based on your SQL Server Instance
    // If you have a named instance (like SQLEXPRESS), use: localhost\\SQLEXPRESS
    private static final String URL = "jdbc:sqlserver://localhost:1433;"
            + "databaseName=oceanview_db;"
            + "integratedSecurity=true;"
            + "encrypt=false;" // Required for SQL Server 2014 compatibility
            + "trustServerCertificate=true;";

    public static Connection getConnection() {
        Connection con = null;
        try {
            // Load the Microsoft SQL Server Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Attempt to establish the connection
            con = DriverManager.getConnection(URL);

            if (con != null) {
                System.out.println("Successfully connected to oceanview_db!");
            }

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found. Make sure the MSSQL JDBC Jar is in your build path.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Failed to connect to SQL Server. Check your URL and DLL files.");
            e.printStackTrace();
        }
        return con;
    }
}