package com.oceanview.controller;

import com.oceanview.model.Guest;
import com.oceanview.dao.GuestDAO;
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

    /**
     * GET method: Fetches all data and displays the History List.
     * This is triggered after a successful redirect from doPost.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        ReservationDAO dao = new ReservationDAOImpl();


        String searchName = request.getParameter("searchName");
        List<Reservation> reservations;

        if (searchName != null && !searchName.trim().isEmpty()) {
            reservations = dao.searchReservationsByName(searchName);
        } else {
            reservations = dao.getAllReservations();
        }


        request.setAttribute("reservations", reservations);


        request.getRequestDispatcher("reservationList.jsp").forward(request, response);
    }

    /**
     * POST method: Processes the registration form and saves to DB.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String name = request.getParameter("guestName");
            String address = request.getParameter("address");
            String contact = request.getParameter("contactNumber");
            String roomType = request.getParameter("roomType");
            String roomNumber = request.getParameter("roomNumber"); // Captured from Form
            String checkInStr = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");


            Reservation r = new Reservation();
            r.setGuestName(name);
            r.setAddress(address);
            r.setContactNumber(contact);
            r.setRoomType(roomType);
            r.setRoomNumber(roomNumber);


            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (checkInStr != null && !checkInStr.isEmpty()) {
                r.setCheckIn(sdf.parse(checkInStr));
            }
            if (checkOutStr != null && !checkOutStr.isEmpty()) {
                r.setCheckOut(sdf.parse(checkOutStr));
            }


            ReservationDAO dao = new ReservationDAOImpl();
            boolean success = dao.addReservation(r);

            if (success) {

                response.sendRedirect(request.getContextPath() + "/addReservation");
            } else {
                request.setAttribute("errorMessage", "Database insertion failed.");

                request.getRequestDispatcher("reservationList.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing: " + e.getMessage());
        }
        }}