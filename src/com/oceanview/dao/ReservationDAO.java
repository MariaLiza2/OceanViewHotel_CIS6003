package com.oceanview.dao;

import com.oceanview.model.Reservation;
import java.util.List;

public interface ReservationDAO {
    boolean addReservation(Reservation r);
    boolean updateReservation(Reservation r);
    boolean deleteReservation(int id);
    List<Reservation> getAllReservations();
    List<Reservation> searchReservationsByName(String name);
    boolean updatePaymentStatus(int reservationId); // Keep this for your PAID logic
    Reservation getReservationById(int id);
}