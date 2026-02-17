package com.oceanview.util;

import com.oceanview.model.*;
import java.util.*;

public class DataStore {

    private static DataStore instance;

    private List<Reservation> reservations = new ArrayList<>();
    private List<Room> rooms = new ArrayList<>();

    private DataStore() {

        rooms.add(new Room("Deluxe", 35000.0, true));
        rooms.add(new Room("Single", 15000.0, true));
        rooms.add(new Room("Double", 22000.0, true));
        rooms.add(new Room("Suite", 40000.0, false));
    }


    public static DataStore getInstance() {
        if (instance == null) instance = new DataStore();
        return instance;
    }

    public List<Reservation> getReservations() { return reservations; }
    public List<Room> getRooms() { return rooms; }
}
