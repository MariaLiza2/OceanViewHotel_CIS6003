package com.oceanview.model;

public class Bill {

    private String roomType;
    private long days;
    private long nights;
    private double amountPerDay;
    private double total;

    // ---------- GETTERS ----------

    public String getRoomType() {
        return roomType;
    }

    public long getDays() {
        return days;
    }

    public long getNights() {
        return nights;
    }

    public double getAmountPerDay() {
        return amountPerDay;
    }

    public double getTotal() {
        return total;
    }

    // ---------- SETTERS ----------

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public void setDays(long days) {
        this.days = days;
    }

    public void setNights(long nights) {
        this.nights = nights;
    }

    public void setAmountPerDay(double amountPerDay) {
        this.amountPerDay = amountPerDay;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    // Optional helper method (auto calculate total)
    public void calculateTotal() {
        this.total = this.amountPerDay * this.days;
    }
}
