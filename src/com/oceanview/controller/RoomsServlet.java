package com.oceanview.controller;

import com.oceanview.util.DataStore;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/roomAvailability")

public class RoomsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("rooms", DataStore.getInstance().getRooms());
        request.getRequestDispatcher("rooms.jsp").forward(request, response);
    }
}
