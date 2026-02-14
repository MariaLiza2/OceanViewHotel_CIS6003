package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl; // Import your implementation
import com.oceanview.model.Reservation;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewReservations")
public class ViewReservationServlet extends HttpServlet {

    // Connect to the actual implementation that talks to SQL Server
    private ReservationDAO dao = new ReservationDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the parameter from the JSP form <input name="searchName">
        String query = request.getParameter("searchName");
        List<Reservation> list;

        // 2. Decide whether to search or show all
        if (query != null && !query.trim().isEmpty()) {
            // Use the search method
            list = dao.searchReservationsByName(query);
        } else {
            // Use the default method
            list = dao.getAllReservations();
        }

        // 3. Send the list to the JSP
        request.setAttribute("reservations", list);
        request.getRequestDispatcher("/reservationList.jsp").forward(request, response);
    }
}