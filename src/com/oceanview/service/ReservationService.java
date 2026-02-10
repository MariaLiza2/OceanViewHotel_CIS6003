package com.oceanview.service;

import com.oceanview.model.Reservation;
import com.oceanview.util.DataStore;

import java.util.List;

public class ReservationService {


    public static ReservationService getInstance() {
        return null;
    }

    // Add reservation (simple method)
    public void Reservation(Reservation r) {
        DataStore.getInstance().getReservations().add(r);
    }

    // Save reservation with status (boolean)
    public boolean saveReservation(Reservation r) {
        DataStore.getInstance().getReservations().add(r);
        return true; // indicate success
    }

    // Get all reservations (using Generics + Collections)
    public List<Reservation> getReservations() {
        return DataStore.getInstance().getReservations();
    }

    public void addReservation(Reservation r) {
    }
}
