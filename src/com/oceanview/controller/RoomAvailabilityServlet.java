package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.service.ReservationService;
import com.oceanview.service.ReservationServiceImpl;
import com.oceanview.service.RoomService;
import com.oceanview.util.DataStore;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/rooms")
public class RoomAvailabilityServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CHANGE THIS: Instead of DataStore, use the DAO to get real DB data
        List<Room> rooms = RoomDAO.getAllRooms();

        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("rooms.jsp").forward(request, response);
    }
}

