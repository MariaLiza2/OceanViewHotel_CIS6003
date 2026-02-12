package com.oceanview.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Room;

@WebServlet("/ManageRoomsServlet")
public class ManageRoomsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String type = request.getParameter("roomType");
                String rateStr = request.getParameter("rate");
                if (type != null && rateStr != null) {
                    double rate = Double.parseDouble(rateStr);
                    RoomDAO.addRoom(type, rate);
                }

            } else if ("delete".equals(action)) {
                // Get the ID of the room to delete
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    RoomDAO.deleteRoom(id);
                }

            } else if ("update".equals(action)) {
                // Get data for the updated room
                String idStr = request.getParameter("roomId");
                String type = request.getParameter("roomType");
                String rateStr = request.getParameter("rate");

                if (idStr != null && type != null && rateStr != null) {
                    int id = Integer.parseInt(idStr);
                    double rate = Double.parseDouble(rateStr);
                    RoomDAO.updateRoom(id, type, rate);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // After any action (Add, Delete, or Update), refresh the list
        if (action != null) {
            response.sendRedirect("ManageRoomsServlet");
        } else {
            // Default: Load the table
            List<Room> rooms = RoomDAO.getAllRooms();
            request.setAttribute("rooms", rooms);
            request.getRequestDispatcher("manage-rooms.jsp").forward(request, response);
        }
    }
    // Even if the form accidentally sends a POST, this redirects it to our working logic
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}