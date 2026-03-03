package com.oceanview.test;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.ReservationDAOImpl;
import com.oceanview.model.Reservation;
import java.util.Date;
import java.util.List;

public class TestMain1 {
    public static void main(String[] args) {
        ReservationDAO dao = new ReservationDAOImpl();

        System.out.println("=== OCEAN VIEW: INTEGRATED MODULE TESTING ===");

        // --- 1. ROOM MANAGEMENT (Availability & Pivot Logic) ---
        String preferredRoom = "105";
        System.out.println("[Room Mgmt] Checking status for Room: " + preferredRoom);

        List<Reservation> currentReservations = dao.getAllReservations();
        boolean isTaken = false;
        for (Reservation r : currentReservations) {
            if (preferredRoom.equals(r.getRoomNumber())) {
                isTaken = true;
                break;
            }
        }

        // Logic to ensure we stay within 101-210 range
        String finalRoom = isTaken ? "106" : preferredRoom;
        System.out.println(isTaken ? " Room 105 Occupied. Pivoting to 106." : " Room 105 Available.");

        // --- 2. RESERVATION CRUD (Create) ---
        Reservation testGuest = new Reservation();
        testGuest.setGuestName("Final Automation Guest");
        testGuest.setRoomType("DELUXE");
        testGuest.setCheckIn(new Date());
        testGuest.setCheckOut(new Date());
        testGuest.setRoomNumber(finalRoom);

        boolean createRes = dao.addReservation(testGuest);

        if (createRes) {
            System.out.println("CRUD (CREATE): Reservation saved to SSMS.");

            // --- 3. GUEST DIRECTORY (Search & Read) ---
            System.out.println("[Directory] Searching for 'Final Automation'...");
            List<Reservation> searchResults = dao.searchReservationsByName("Final Automation");

            if (searchResults != null && !searchResults.isEmpty()) {
                Reservation activeRecord = searchResults.get(0);
                int activeId = activeRecord.getReservationId();
                System.out.println("DIRECTORY (READ): Record found. System ID: " + activeId);

                // --- 4. RESERVATION CRUD (Update) ---
                activeRecord.setRoomType("SUITE"); // Modifying data
                if (dao.updateReservation(activeRecord)) {
                    System.out.println("CRUD (UPDATE): Room Type upgraded to SUITE.");
                }

                // --- 5. RESERVATION CRUD (Delete/Cleanup) ---
                if (dao.deleteReservation(activeId)) {
                    System.out.println("CRUD (DELETE): Test data removed. Database clean.");
                }

            } else {
                System.err.println("DIRECTORY FAILED: Search returned no results.");
            }

        } else {
            System.err.println(" CREATE FAILED: SQL Insertion Error.");
        }

        System.out.println("=== ALL AUTOMATED MODULE CHECKS COMPLETE ===");
    }
}