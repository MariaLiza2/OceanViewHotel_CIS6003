package com.oceanview.model;

public class Room {
    private int roomId;
    private String type;
    private double rate;
    private boolean available;
    private String description;

    // 1. Default Constructor
    public Room() {
    }

    // 2. Constructor for DataStore (type, available)
    public Room(String type, boolean available) {
        this.type = type;
        this.available = available;
    }

    // 3. FIXED: Constructor for DataStore (type, rate, available)
    // This removes the red lines in image_18c4ae.png
    public Room(String type, double rate, boolean available) {
        this.type = type;
        this.rate = rate;
        this.available = available;
    }

    // 4. Full Constructor including Description
    public Room(String type, double rate, boolean available, String description) {
        this.type = type;
        this.rate = rate;
        this.available = available;
        this.description = description;
    }

    // --- Getters and Setters ---

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public double getRate() { return rate; }
    public void setRate(double rate) { this.rate = rate; }

    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}