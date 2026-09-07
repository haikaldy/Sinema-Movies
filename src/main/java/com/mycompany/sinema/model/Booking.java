package com.mycompany.sinema.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Booking implements Serializable {
    private static final long serialVersionUID = 1L;

    // ===== core booking fields =====
    private String bookingId; // S001 etc (String) - change to int if your DB uses int
    private int userId;
    private int showtimeId;
    private int movieId;

    private double totalAmount;
    private String status; // Paid / Pending / Cancelled etc
    private Timestamp createdAt;

    // ===== display fields (from JOIN) =====
    private String customerName;
    private String customerEmail;

    private String movieTitle;
    private Date showDate;
    private Time showTime;

    private String seatNumbers; // "A1,A2" easy for UI

    public Booking() {
    }

    // ===== getters/setters =====
    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public Date getShowDate() {
        return showDate;
    }

    public void setShowDate(Date showDate) {
        this.showDate = showDate;
    }

    public Time getShowTime() {
        return showTime;
    }

    public void setShowTime(Time showTime) {
        this.showTime = showTime;
    }

    public String getSeatNumbers() {
        return seatNumbers;
    }

    public void setSeatNumbers(String seatNumbers) {
        this.seatNumbers = seatNumbers;
    }

    public double getTotalPrice() {
        return totalAmount;
    }

    @Override
    public String toString() {
        return "Booking{bookingId=" + bookingId + ", userId=" + userId +
                ", showtimeId=" + showtimeId + ", totalAmount=" + totalAmount +
                ", status='" + status + "'}";
    }
}
