package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Room;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;


    @WebServlet("/ManageRoomsServlet")
    public class ManageRoomsServlet extends HttpServlet {

        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            List<Room> rooms = RoomDAO.getAllRooms();
            request.setAttribute("rooms", rooms);

            request.getRequestDispatcher("manage-rooms.jsp").forward(request, response);
        }
    }


