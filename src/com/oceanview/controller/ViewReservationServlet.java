package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.model.Reservation;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewReservations")
public class ViewReservationServlet extends HttpServlet {


    private ReservationDAO dao = new ReservationDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("searchName");
        List<Reservation> list;


        if (query != null && !query.trim().isEmpty()) {
           list = dao.searchReservationsByName(query);
        } else {
            list = dao.getAllReservations();
        }

        request.setAttribute("reservations", list);
        request.getRequestDispatcher("/reservationList.jsp").forward(request, response);
    }
}