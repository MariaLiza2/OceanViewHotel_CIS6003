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
                String desc = request.getParameter("description"); // New
                String statusStr = request.getParameter("isAvailable"); // New dropdown value

                if (type != null && rateStr != null && desc != null) {
                    double rate = Double.parseDouble(rateStr);
                    boolean isAvailable = Boolean.parseBoolean(statusStr);

                    RoomDAO.addRoom(type, rate, desc, isAvailable);
                }

            } else if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    RoomDAO.deleteRoom(id);
                }

            } else if ("update".equals(action)) {
                String idStr = request.getParameter("roomId");
                String type = request.getParameter("roomType");
                String rateStr = request.getParameter("rate");
                String desc = request.getParameter("description"); // New
                String statusStr = request.getParameter("isAvailable"); // New

                if (idStr != null && type != null && rateStr != null) {
                    int id = Integer.parseInt(idStr);
                    double rate = Double.parseDouble(rateStr);
                    boolean isAvailable = Boolean.parseBoolean(statusStr);

                    RoomDAO.updateRoom(id, type, rate, desc, isAvailable);
                }

            } else if ("toggle".equals(action)) {
                String idStr = request.getParameter("id");
                String currentStatusStr = request.getParameter("currentStatus");

                if (idStr != null && currentStatusStr != null) {
                    int id = Integer.parseInt(idStr);
                    boolean newStatus = !Boolean.parseBoolean(currentStatusStr);
                    RoomDAO.toggleRoomStatus(id, newStatus);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        if (action != null) {
            response.sendRedirect("ManageRoomsServlet");
        } else {
            List<Room> rooms = RoomDAO.getAllRooms();
            request.setAttribute("rooms", rooms);
            request.getRequestDispatcher("manage-rooms.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}