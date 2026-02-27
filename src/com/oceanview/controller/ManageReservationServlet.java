package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.model.Reservation;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageReservation") // Changed to SINGULAR to match your URL
public class ManageReservationServlet extends HttpServlet {

    private ReservationDAO reservationDAO = new ReservationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("view".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Reservation res = reservationDAO.getReservationById(id);
                request.setAttribute("res", res);
                request.getRequestDispatcher("view-reservation.jsp").forward(request, response);
            }
            else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Reservation res = reservationDAO.getReservationById(id);
                request.setAttribute("res", res);
                request.getRequestDispatcher("edit-reservation.jsp").forward(request, response);
            }
            else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                reservationDAO.deleteReservation(id);
                response.sendRedirect("manage-reservation.jsp?msg=deleted");
            }
            else {
                // Default: Fetch all and forward to JSP
                List<Reservation> list = reservationDAO.getAllReservations();
                request.setAttribute("reservations", list);
                request.getRequestDispatcher("manage-reservation.jsp").forward(request, response);
            }
        } catch (Exception e) {
            response.sendRedirect("manage-reservation.jsp?error=true");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Reservation r = new Reservation();
            r.setReservationId(id);
            r.setGuestName(request.getParameter("guestName"));
            r.setRoomType(request.getParameter("roomType"));
            r.setCheckIn(java.sql.Date.valueOf(request.getParameter("checkIn")));
            r.setCheckOut(java.sql.Date.valueOf(request.getParameter("checkOut")));

            if (reservationDAO.updateReservation(r)) {
                response.sendRedirect("manage-reservation.jsp?msg=updated");
            }
        } catch (Exception e) {
            response.sendRedirect("manage-reservation.jsp?error=update_failed");
        }
    }
}