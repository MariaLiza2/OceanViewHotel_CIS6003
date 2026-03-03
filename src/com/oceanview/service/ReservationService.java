package com.oceanview.service;

import com.oceanview.model.Reservation;
import com.oceanview.util.DataStore;

import java.util.List;

public class ReservationService {


    public static ReservationService getInstance() {
        return null;
    }

    public void Reservation(Reservation r) {
        DataStore.getInstance().getReservations().add(r);
    }

    public boolean saveReservation(Reservation r) {
        DataStore.getInstance().getReservations().add(r);
        return true; // indicate success
    }

    public List<Reservation> getReservations() {
        return DataStore.getInstance().getReservations();
    }

    public void addReservation(Reservation r) {
    }
}
