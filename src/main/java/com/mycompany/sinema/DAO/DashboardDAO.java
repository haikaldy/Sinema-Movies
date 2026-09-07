package com.mycompany.sinema.DAO;

import com.mycompany.sinema.util.DBConnection;
import com.mycompany.sinema.model.DashboardStats;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO {

    public DashboardStats getStats() {
        DashboardStats s = new DashboardStats();

        // 1) Total movies
        s.setTotalMovies(getInt("SELECT COUNT(*) FROM movies"));

        // 2) Bookings today
        s.setBookingsToday(getInt(
                "SELECT COUNT(*) FROM bookings WHERE columnstatus='PAID'"));

        // 3) Revenue this week (sum total_price, paid only)
        s.setRevenueThisWeek(getBigDecimal(
                "SELECT COALESCE(SUM(COALESCE(NULLIF(total, 0), total_price)), 0) " +
                        "FROM bookings WHERE columnstatus='PAID'"));

        // 4) Upcoming showtimes
        s.setUpcomingShowtimes(getInt(
                "SELECT COUNT(*) FROM showtimes"));

        return s;
    }

    private int getInt(String sql) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next())
                return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private BigDecimal getBigDecimal(String sql) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next())
                return rs.getBigDecimal(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}
