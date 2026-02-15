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

    /**
     * GET method: Fetches all data and displays the History List.
     * This is triggered after a successful redirect from doPost.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Initialize DAO to fetch data
        ReservationDAO dao = new ReservationDAOImpl();

        // 2. Get search parameter (if any)
        String searchName = request.getParameter("searchName");
        List<Reservation> reservations;

        if (searchName != null && !searchName.trim().isEmpty()) {
            reservations = dao.searchReservationsByName(searchName);
        } else {
            reservations = dao.getAllReservations();
        }

        // 3. Set the list as a request attribute
        request.setAttribute("reservations", reservations);

        // 4. Forward to the history JSP page
        request.getRequestDispatcher("reservationList.jsp").forward(request, response);
    }

    /**
     * POST method: Processes the registration form and saves to DB.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Capture parameters from the registration form
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

            // 3. Parse Dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (checkInStr != null && !checkInStr.isEmpty()) {
                r.setCheckIn(sdf.parse(checkInStr));
            }
            if (checkOutStr != null && !checkOutStr.isEmpty()) {
                r.setCheckOut(sdf.parse(checkOutStr));
            }

            // 4. Call the DAO to save the record (includes reservation_number generation)
            ReservationDAO dao = new ReservationDAOImpl();
            boolean success = dao.addReservation(r);

            if (success) {
                // 5. Success: Redirect to the GET method to view the History List
                // This fulfills your requirement to go to Reservation History
                response.sendRedirect(request.getContextPath() + "/addReservation");
            } else {
                // 6. Failure: Return to form with error
                request.setAttribute("errorMessage", "Database insertion failed. Please try again.");
                request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error processing reservation: " + e.getMessage());
        }
    }
}