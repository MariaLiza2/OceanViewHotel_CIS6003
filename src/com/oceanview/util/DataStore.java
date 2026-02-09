package com.oceanview.util;

import com.oceanview.model.*;
import java.util.*;

public class DataStore {

    private static DataStore instance;

    private List<Reservation> reservations = new ArrayList<>();
    private List<Room> rooms = new ArrayList<>();

    private DataStore() {
        rooms.add(new Room("Single", true));
        rooms.add(new Room("Double", true));
        rooms.add(new Room("Suite", false));
    }

    public static DataStore getInstance() {
        if (instance == null) instance = new DataStore();
        return instance;
    }

    public List<Reservation> getReservations() { return reservations; }
    public List<Room> getRooms() { return rooms; }
}
