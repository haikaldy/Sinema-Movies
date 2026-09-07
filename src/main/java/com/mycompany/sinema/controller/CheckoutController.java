package com.mycompany.sinema.controller;

import com.mycompany.sinema.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/CheckoutController")
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("showtime_id") == null) {
            response.sendRedirect(request.getContextPath() + "/user_page.jsp");
            return;
        }

        request.getRequestDispatcher("/user/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("showtime_id") == null) {
            response.sendRedirect(request.getContextPath() + "/user_page.jsp");
            return;
        }

        System.out.println("DEBUG showtime_id = " + session.getAttribute("showtime_id"));
        System.out.println("DEBUG selectedSeats = " + session.getAttribute("selectedSeats"));
        System.out.println("DEBUG ticketTotalValue = " + session.getAttribute("ticketTotalValue"));
        System.out.println("DEBUG user_id = " + session.getAttribute("user_id"));

        // in session (from login)
        Integer userIdObj = (Integer) session.getAttribute("user_id"); // <-- change if your session name is different
        if (userIdObj == null) {
            request.setAttribute("error", "User not logged in (session user_id missing).");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        int userId = userIdObj;

        int showtime_id = (int) session.getAttribute("showtime_id");
        String selectedSeats = (String) session.getAttribute("selectedSeats");

        Double ticketTotalObj = (Double) session.getAttribute("ticketTotalValue");
        double ticketTotalValue = (ticketTotalObj != null) ? ticketTotalObj : 0.0;

        String snackSummary = (String) session.getAttribute("snackSummary");
        if (snackSummary == null)
            snackSummary = "";

        Double snackTotalObj = (Double) session.getAttribute("snackTotalValue");
        double snackTotalValue = (snackTotalObj != null) ? snackTotalObj : 0.0;

        Double grandTotalObj = (Double) session.getAttribute("grandTotalValue");
        double grandTotalValue = (grandTotalObj != null) ? grandTotalObj : (ticketTotalValue + snackTotalValue);

        // Basic validation
        if (selectedSeats == null || selectedSeats.trim().isEmpty()) {
            request.setAttribute("error", "No seats selected.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1) Insert into bookings (MATCH YOUR TABLE COLUMNS)
            String insertBookingSql = "INSERT INTO bookings " +
                    "(user_id, showtime_id, total_price, booking_date, seats, snacks, total, columnstatus, booked_at) "
                    +
                    "VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?, ?, ?, 'PAID', CURRENT_TIMESTAMP)";

            int booking_id;

            try (PreparedStatement ps = conn.prepareStatement(insertBookingSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, showtime_id);
                ps.setDouble(3, ticketTotalValue); // total_price
                ps.setString(4, selectedSeats); // seats
                ps.setString(5, snackSummary); // snacks
                ps.setDouble(6, grandTotalValue); // total (grand total)

                int rows = ps.executeUpdate();
                if (rows == 0)
                    throw new Exception("Insert into bookings failed.");

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next())
                        throw new Exception("No booking_id generated.");
                    booking_id = rs.getInt(1);
                }
            }

            // 2) Update seats table: mark seats booked + attach booking_id
            String updateSeatSql = "UPDATE seats SET status='booked', booking_id=? " +
                    "WHERE showtime_id=? AND seat_number=?";

            String[] seatArr = selectedSeats.split(",");

            try (PreparedStatement ps = conn.prepareStatement(updateSeatSql)) {
                for (String seat : seatArr) {
                    seat = seat.trim();
                    if (seat.isEmpty())
                        continue;

                    ps.setInt(1, booking_id);
                    ps.setInt(2, showtime_id);
                    ps.setString(3, seat);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // 3) Insert into booking_seat (optional but recommended)
            // booking_seat table: (booking_seat_id, booking_id, seat_id)
            String findSeatIdSql = "SELECT seat_id FROM seats WHERE showtime_id=? AND seat_number=?";
            String insertBookingSeatSql = "INSERT INTO booking_seats (booking_id, seat_id) VALUES (?, ?)";

            try (PreparedStatement psFind = conn.prepareStatement(findSeatIdSql);
                    PreparedStatement psIns = conn.prepareStatement(insertBookingSeatSql)) {

                for (String seat : seatArr) {
                    seat = seat.trim();
                    if (seat.isEmpty())
                        continue;

                    psFind.setInt(1, showtime_id);
                    psFind.setString(2, seat);

                    try (ResultSet rs = psFind.executeQuery()) {
                        if (rs.next()) {
                            int seatId = rs.getInt("seat_id");
                            psIns.setInt(1, booking_id);
                            psIns.setInt(2, seatId);
                            psIns.addBatch();
                        }
                    }
                }
                psIns.executeBatch();
            }

            conn.commit();

            // ✅ only after commit -> allow receipt
            session.setAttribute("booking_id", booking_id);

            response.sendRedirect(request.getContextPath() + "/ReceiptController");

        } catch (Exception e) {
            try {
                if (conn != null)
                    conn.rollback();
            } catch (Exception ignore) {
            }
            e.printStackTrace();

            request.setAttribute("error", "Checkout error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);

        } finally {
            try {
                if (conn != null)
                    conn.setAutoCommit(true);
            } catch (Exception ignore) {
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception ignore) {
            }
        }
    }
}
