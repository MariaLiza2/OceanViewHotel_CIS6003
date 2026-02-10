package com.oceanview.dao;

import com.oceanview.model.Reservation;
import java.util.List;

public interface ReservationDAO {

    boolean Reservation(Reservation reservation);

    boolean addReservation(Reservation r);

    List<Reservation> getAllReservations();
}
