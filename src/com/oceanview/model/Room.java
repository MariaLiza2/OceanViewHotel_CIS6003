package com.oceanview.model;

public class Room {
    private int roomId;
    private String type;
    private double rate;
    private boolean available;
    private String description;

    // 1. Default Constructor
    // Required for RoomDAO and frameworks like Jackson/Gson
    public Room() {
    }

    // 2. Constructor for DataStore (type, available)
    // This fixes the red lines in your DataStore.java
    public Room(String type, boolean available) {
        this.type = type;
        this.available = available;
    }

    // 3. Full Constructor (type, rate, available)
    // Useful for adding rooms with specific prices manually
    public Room(String type, double rate, boolean available) {
        this.type = type;
        this.rate = rate;
        this.available = available;
    }

    // --- Getters and Setters ---

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}