package com.mycompany.sinema.DAO;

import com.mycompany.sinema.model.Booking;
import com.mycompany.sinema.util.DBConnection;
import com.mycompany.sinema.model.ReportRow;
import java.util.regex.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // 1) We split SQL into 3 parts so we can safely add WHERE before GROUP BY.
    private static final String SELECT_FROM = "SELECT " +
            "  b.booking_id, b.user_id, b.showtime_id, b.total_price, " +
            "  b.columnstatus AS status, b.booked_at AS created_at, " +
            "  u.username AS customer_name, u.email AS customer_email, " +
            "  st.show_date, st.show_time, " +
            "  m.title AS movie_title, " +
            "  COALESCE(GROUP_CONCAT(se.seat_number ORDER BY se.seat_number SEPARATOR ','), '') AS seat_numbers " +
            "FROM bookings b " +
            "JOIN users u ON b.user_id = u.user_id " +
            "JOIN showtimes st ON b.showtime_id = st.showtime_id " +
            "JOIN movies m ON st.movie_id = m.movie_id " +
            "LEFT JOIN seats se ON se.booking_id = b.booking_id ";

    private static final String GROUP_BY = " GROUP BY " +
            "  b.booking_id, b.user_id, b.showtime_id, b.total_price, b.columnstatus, b.booked_at, " +
            "  u.username, u.email, st.show_date, st.show_time, m.title ";

    private static final String ORDER_BY = " ORDER BY b.booking_id DESC ";

    public List<Booking> getAllBookingsForAdmin() throws Exception {
        String sql = SELECT_FROM + GROUP_BY + ORDER_BY;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            return mapRows(rs);
        }
    }

    public List<Booking> searchBookings(String keyword, Date showDate, String status) throws Exception {

        StringBuilder sb = new StringBuilder(SELECT_FROM);
        List<Object> params = new ArrayList<>();

        sb.append(" WHERE 1=1 ");

        // keyword filter
        if (keyword != null && !keyword.trim().isEmpty()) {
            sb.append(" AND (b.booking_id LIKE ? OR u.username LIKE ? OR u.email LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
            params.add(k);
        }

        // date filter
        if (showDate != null) {
            sb.append(" AND st.show_date = ? ");
            params.add(showDate);
        }

        // status filter
        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("All")) {
            sb.append(" AND b.columnstatus = ? ");
            params.add(status.trim());
        }

        sb.append(GROUP_BY).append(ORDER_BY);

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                return mapRows(rs);
            }
        }
    }

    public List<ReportRow> getReportRows() throws Exception {

        String sql = "SELECT " +
                "  DATE(b.booked_at) AS tx_date, " +
                "  b.booking_id, " +
                "  COUNT(s.seat_id) AS ticket_qty, " +
                "  b.snacks, " +
                "  COALESCE(NULLIF(b.total, 0), b.total_price) AS revenue " +
                "FROM bookings b " +
                "LEFT JOIN seats s ON s.booking_id = b.booking_id " +
                "GROUP BY DATE(b.booked_at), b.booking_id, b.snacks, b.total, b.total_price " +
                "ORDER BY tx_date DESC, b.booking_id DESC";

        List<ReportRow> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ReportRow r = new ReportRow();

                r.setDate(rs.getDate("tx_date"));
                r.setBookingId(rs.getString("booking_id"));
                r.setTicketQty(rs.getInt("ticket_qty"));

                String snacks = rs.getString("snacks");
                r.setSnackQty(parseSnackQty(snacks));

                r.setRevenue(rs.getDouble("revenue"));

                list.add(r);
            }
        }

        return list;
    }

    private int parseSnackQty(String snacks) {
        if (snacks == null)
            return 0;

        snacks = snacks.trim();
        if (snacks.isEmpty())
            return 0;

        int total = 0;
        Pattern p = Pattern.compile("x\\s*(\\d+)", Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(snacks);

        while (m.find()) {
            total += Integer.parseInt(m.group(1));
        }

        return total;
    }

    private List<Booking> mapRows(ResultSet rs) throws SQLException {
        List<Booking> list = new ArrayList<>();

        while (rs.next()) {
            Booking b = new Booking();

            b.setBookingId(rs.getString("booking_id"));
            b.setUserId(rs.getInt("user_id"));
            b.setShowtimeId(rs.getInt("showtime_id"));

            b.setMovieTitle(rs.getString("movie_title"));
            b.setShowDate(rs.getDate("show_date"));
            b.setShowTime(rs.getTime("show_time"));

            // Booking.java stores into totalAmount
            b.setTotalAmount(rs.getDouble("total_price"));

            b.setStatus(rs.getString("status"));
            b.setCreatedAt(rs.getTimestamp("created_at"));

            b.setCustomerName(rs.getString("customer_name"));
            b.setCustomerEmail(rs.getString("customer_email"));

            b.setSeatNumbers(rs.getString("seat_numbers"));

            list.add(b);
        }

        return list;
    }
}
