package com.mycompany.sinema.model;

import java.sql.Date;

public class ReportRow {
    private Date date;
    private String bookingId;
    private int ticketQty;
    private int snackQty;
    private double revenue;

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public int getTicketQty() {
        return ticketQty;
    }

    public void setTicketQty(int ticketQty) {
        this.ticketQty = ticketQty;
    }

    public int getSnackQty() {
        return snackQty;
    }

    public void setSnackQty(int snackQty) {
        this.snackQty = snackQty;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
