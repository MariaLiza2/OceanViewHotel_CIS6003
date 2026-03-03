package com.oceanview.model;
import java.sql.Timestamp;

public class Payment {
    private int reservationId;
    private String reservationNumber;
    private String guestName;
    private String roomType;
    private double totalAmount;
    private String paymentMethod;
    private java.sql.Timestamp paymentDate;

    // SETTERS
    public void setReservationId(int id) { this.reservationId = id; }
    public void setReservationNumber(String num) { this.reservationNumber = num; }
    public void setGuestName(String guestName) { this.guestName = guestName; }
    public void setRoomType(String type) { this.roomType = type; }
    public void setTotalAmount(double amount) { this.totalAmount = amount; }
    public void setPaymentMethod(String method) { this.paymentMethod = method; }
    public void setPaymentDate(java.sql.Timestamp date) { this.paymentDate = date; }

    // GETTERS

    public int getReservationId() { return reservationId; }

    public String getReservationNumber() { return reservationNumber; }
    public String getGuestName() { return guestName; }

    public String getRoomType() { return roomType; }
    public double getTotalAmount() { return totalAmount; }
    public String getPaymentMethod() { return paymentMethod; }
    public java.sql.Timestamp getPaymentDate() { return paymentDate; }
}