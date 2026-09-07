package com.mycompany.sinema.model;

import java.math.BigDecimal;

public class DashboardStats {
    private int totalMovies;
    private int bookingsToday;
    private BigDecimal revenueThisWeek;
    private int upcomingShowtimes;

    public int getTotalMovies() {
        return totalMovies;
    }

    public void setTotalMovies(int totalMovies) {
        this.totalMovies = totalMovies;
    }

    public int getBookingsToday() {
        return bookingsToday;
    }

    public void setBookingsToday(int bookingsToday) {
        this.bookingsToday = bookingsToday;
    }

    public BigDecimal getRevenueThisWeek() {
        return revenueThisWeek;
    }

    public void setRevenueThisWeek(BigDecimal revenueThisWeek) {
        this.revenueThisWeek = revenueThisWeek;
    }

    public int getUpcomingShowtimes() {
        return upcomingShowtimes;
    }

    public void setUpcomingShowtimes(int upcomingShowtimes) {
        this.upcomingShowtimes = upcomingShowtimes;
    }
}
