package com.oceanview.model;

public class Bill {
    private int reservationId;
    private String roomType;
    private double amountPerDay;
    private int days;    // Use int for days
    private double total; // Use double for currency

    // Reservation ID
    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }

    // Room Type
    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    // Amount Per Day
    public double getAmountPerDay() { return amountPerDay; }
    public void setAmountPerDay(double amountPerDay) { this.amountPerDay = amountPerDay; }

    // Days - Fixed to return int and accept int
    public int getDays() { return days; }
    public void setDays(int days) { this.days = days; }

    // Total - Fixed to return double and accept double
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }


}