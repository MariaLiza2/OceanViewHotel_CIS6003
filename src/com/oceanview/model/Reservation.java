package com.oceanview.model;

import java.util.Date;

public class Reservation {
    private int reservationId;
    private String reservationNumber;
    private String guestName;
    private String address;
    private String contactNumber;
    private String roomType;
    private Date checkIn;
    private Date checkOut;
    private String status; // Crucial for the 'PAID/PENDING' logic

    // Constructors
    public Reservation() {}

    // Getters and Setters
    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }

    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public Date getCheckIn() { return checkIn; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }

    public Date getCheckOut() { return checkOut; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    private java.sql.Timestamp bookingDate;

    public java.sql.Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(java.sql.Timestamp bookingDate) { this.bookingDate = bookingDate; }


        private String roomNumber; // Ensure this exists!
        public String getRoomNumber() { return roomNumber; }
        public void setRoomNumber(String rn) { this.roomNumber = rn; }
    }
