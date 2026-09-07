package com.mycompany.sinema.model;

public class Seat {

    private int seat_id;
    private int showtime_id;
    private String seat_number;
    private String status;
    private int booking_id;

    public Seat(int seat_id, int showtime_id, String seat_number, String status, int booking_id) {
        this.seat_id = seat_id;
        this.showtime_id = showtime_id;
        this.seat_number = seat_number;
        this.status = status;
        this.booking_id = booking_id;
    }

    public Seat() {
    }

    public int getSeatId() {
        return seat_id;
    }

    public void setSeatId(int seat_id) {
        this.seat_id = seat_id;
    }

    public int getShowtimeId() {
        return showtime_id;
    }

    public void setShowtimeId(int showtime_id) {
        this.showtime_id = showtime_id;
    }

    public String getSeatNumber() {
        return seat_number;
    }

    public void setSeatNumber(String seat_number) {
        this.seat_number = seat_number;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;

    }

    public int getBooking_id() {
        return booking_id;
    }

    public void setBooking_id(int booking_id) {
        this.booking_id = booking_id;
    }

}
