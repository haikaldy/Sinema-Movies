package com.mycompany.sinema.model;

import java.sql.Date;
import java.sql.Time;

public class Showtime {

    private int showtime_Id;
    private int movie_id;
    private Date show_date;
    private Time show_time;
    private double price;
    private String hall;

    // EMPTY constructor (so `new Showtime()` works)
    public Showtime() {
    }

    // constructor
    public Showtime(int showtime_Id, Date show_date, Time show_time, int movie_id, double price, String hall) {
        this.showtime_Id = showtime_Id;
        this.show_date = show_date;
        this.show_time = show_time;
        this.movie_id = movie_id;
        this.price = price;
        this.hall = hall;
    }

    // Getters & Setters
    public int getShowtimeId() {
        return showtime_Id;
    }

    public void setShowtimeId(int showtime_Id) {
        this.showtime_Id = showtime_Id;
    }

    public Date getShowDate() {
        return show_date;
    }

    public void setShowDate(Date show_date) {
        this.show_date = show_date;
    }

    public Time getShowTime() {
        return show_time;
    }

    public void setShowTime(Time show_time) {
        this.show_time = show_time;
    }

    public int getMovieId() {
        return movie_id;
    }

    public void setMovieId(int movie_id) {
        this.movie_id = movie_id;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getHall() {
        return hall;
    }

    public void setHall(String hall) {
        this.hall = hall;
    }

}
