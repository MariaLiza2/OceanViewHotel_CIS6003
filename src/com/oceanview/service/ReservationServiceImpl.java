package com.oceanview.service;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.model.Reservation;
import java.util.List;

public class ReservationServiceImpl extends ReservationService {

    private ReservationDAO dao = new ReservationDAOImpl();

    public boolean saveReservation(Reservation reservation) {
        // Calls the real DAO method, not the ghost one
        return dao.addReservation(reservation);
    }

    public List<Reservation> getReservations() {
        return dao.getAllReservations();
    }

    public boolean processPayment(int resId) {
        return dao.updatePaymentStatus(resId);
    }
}