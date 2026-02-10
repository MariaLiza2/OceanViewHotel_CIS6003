package com.oceanview.service;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.model.Reservation;

import java.util.List;

public class ReservationServiceImpl extends ReservationService {

    private ReservationDAO dao = new ReservationDAOImpl() {
        @Override
        public boolean Reservation(Reservation reservation) {
            return false;
        }
    };

    public boolean saveReservation(Reservation reservation) {
        return dao.Reservation(reservation);
    }

    public List<Reservation> getReservations() {
        return dao.getAllReservations();
    }
}
