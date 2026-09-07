
package com.mycompany.sinema.DAO;

import com.mycompany.sinema.model.Showtime;
import com.mycompany.sinema.model.ShowtimeInfo;
import com.mycompany.sinema.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShowtimeDAO {

    public static ShowtimeInfo getShowtimeInfoById(int showtimeId) throws SQLException {
        String sql = "SELECT s.showtime_id, s.movie_id, m.title AS movie_title, " +
                "       s.show_date, s.show_time, s.price, s.hall " +
                "FROM showtimes s " +
                "JOIN movies m ON s.movie_id = m.movie_id " +
                "WHERE s.showtime_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, showtimeId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ShowtimeInfo info = new ShowtimeInfo();
                    info.setShowtimeId(rs.getInt("showtime_id"));
                    info.setMovieId(rs.getInt("movie_id"));
                    info.setMovieTitle(rs.getString("movie_title"));
                    info.setShowDate(rs.getDate("show_date"));
                    info.setShowTime(rs.getTime("show_time"));
                    info.setTicketPrice(rs.getDouble("price"));
                    info.setHall(rs.getString("hall"));
                    return info;
                }
            }
        }
        return null; // not found
    }

    public static List<Showtime> getAllShowtimes() throws SQLException {
        String sql = "SELECT showtime_id, movie_id, show_date, show_time, price, hall FROM showtimes ORDER BY show_date, show_time";
        List<Showtime> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Showtime st = new Showtime();
                st.setShowtimeId(rs.getInt("showtime_id"));
                st.setMovieId(rs.getInt("movie_id"));
                st.setShowDate(rs.getDate("show_date"));
                st.setShowTime(rs.getTime("show_time"));
                st.setPrice(rs.getDouble("price"));
                st.setHall(rs.getString("hall"));
                list.add(st);
            }
        }
        return list;
    }

    public static Showtime getShowtimeById(int showtimeId) throws SQLException {
        String sql = "SELECT showtime_id, movie_id, show_date, show_time, price, hall FROM showtimes WHERE showtime_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, showtimeId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Showtime st = new Showtime();
                    st.setShowtimeId(rs.getInt("showtime_id"));
                    st.setMovieId(rs.getInt("movie_id"));
                    st.setShowDate(rs.getDate("show_date"));
                    st.setShowTime(rs.getTime("show_time"));
                    st.setPrice(rs.getDouble("price"));
                    st.setHall(rs.getString("hall"));
                    return st;
                }
            }
        }
        return null;
    }

    public static boolean insertShowtime(Showtime st) throws SQLException {
        String sql = "INSERT INTO showtimes (movie_id, show_date, show_time, price, hall) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, st.getMovieId());
            ps.setDate(2, st.getShowDate());
            ps.setTime(3, st.getShowTime());
            ps.setDouble(4, st.getPrice());
            ps.setString(5, st.getHall());

            return ps.executeUpdate() > 0;
        }
    }

    public static boolean updateShowtime(Showtime st) throws SQLException {
        String sql = "UPDATE showtimes " +
                "SET movie_id=?, show_date=?, show_time=?, price=?, hall=? " +
                "WHERE showtime_id=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, st.getMovieId());
            ps.setDate(2, st.getShowDate());
            ps.setTime(3, st.getShowTime());
            ps.setDouble(4, st.getPrice());
            ps.setString(5, st.getHall());
            ps.setInt(6, st.getShowtimeId());

            return ps.executeUpdate() > 0;
        }
    }

    public static boolean deleteShowtime(int showtimeId) throws SQLException {
        String sql = "DELETE FROM showtimes WHERE showtime_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, showtimeId);
            return ps.executeUpdate() > 0;
        }
    }

    public static boolean hasBookings(int showtimeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE showtime_id=?";
        try (Connection c = DBConnection.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

}
