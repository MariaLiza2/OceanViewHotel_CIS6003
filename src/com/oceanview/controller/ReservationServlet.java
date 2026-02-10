package com.oceanview.controller;

import com.oceanview.model.Reservation;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/addReservation")
public class ReservationServlet extends HttpServlet {

    // GET method to display the list of reservations
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ReservationDAO dao = new ReservationDAOImpl();
        List<Reservation> reservations = dao.getAllReservations();
        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("reservation.jsp").forward(request, response);
    }

    // POST method to handle form submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Capture parameters from the JSP form
            String name = request.getParameter("guestName");
            String address = request.getParameter("address");
            String contact = request.getParameter("contactNumber");
            String roomType = request.getParameter("roomType");
            String checkInStr = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");

            // 2. Map form data to the Reservation Model
            Reservation r = new Reservation();
            r.setGuestName(name);
            r.setAddress(address);
            r.setContactNumber(contact);
            r.setRoomType(roomType);

            // 3. Parse Dates (HTML5 date input sends yyyy-MM-dd)
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (checkInStr != null && !checkInStr.isEmpty()) {
                r.setCheckIn(sdf.parse(checkInStr));
            }
            if (checkOutStr != null && !checkOutStr.isEmpty()) {
                r.setCheckOut(sdf.parse(checkOutStr));
            }

            // 4. Call the DAO to save to SQL Server 2014
            ReservationDAO dao = new ReservationDAOImpl();
            boolean success = dao.addReservation(r);

            if (success) {

                // Redirect to the GET method to refresh the list
                response.sendRedirect(request.getContextPath() + "/rooms");
            } else {
                request.setAttribute("errorMessage", "Database insertion failed. Check console.");
                request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing reservation: " + e.getMessage());
        }
    }
}