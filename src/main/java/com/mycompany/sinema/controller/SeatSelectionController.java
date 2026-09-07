package com.mycompany.sinema.controller;

import com.mycompany.sinema.util.DBConnection;
import com.mycompany.sinema.model.ShowtimeInfo;
import com.mycompany.sinema.model.Seat;
import com.mycompany.sinema.DAO.ShowtimeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/SeatSelectionController")
public class SeatSelectionController extends HttpServlet {

    // ✅ SHOW SEATS PAGE
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String showtimeParam = request.getParameter("showtime_id");
        int showtimeId;

        try {
            showtimeId = Integer.parseInt(showtimeParam);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid showtime_id.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 1) Load seats
        String sql = "SELECT seat_id, seat_number, status, booking_id " +
                "FROM seats WHERE showtime_id = ? ORDER BY seat_number";

        List<Seat> seatList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, showtimeId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Seat seat = new Seat();
                    seat.setSeatId(rs.getInt("seat_id"));
                    seat.setSeatNumber(rs.getString("seat_number"));
                    seat.setStatus(rs.getString("status"));
                    seat.setBooking_id(rs.getInt("booking_id"));
                    seatList.add(seat);
                }
            }

            // 2) Load showtime info (movie title/time/price)
            ShowtimeInfo info = ShowtimeDAO.getShowtimeInfoById(showtimeId);

            request.setAttribute("seats", seatList);
            request.setAttribute("showtime_id", showtimeId);

            // These will be used in seat_selection.jsp header/UI
            request.setAttribute("movieTitle", info.getMovieTitle());
            request.setAttribute("showDate", info.getShowDate());
            request.setAttribute("showTime", info.getShowTime());
            request.setAttribute("ticketPrice", info.getTicketPrice());
            request.setAttribute("hall", info.getHall());

            request.getRequestDispatcher("/user/seat_selection.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Seat Selection error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    // USER CONFIRMS SEATS (FORM SUBMIT)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String showtimeParam = request.getParameter("showtime_id");
        int showtimeId;

        try {
            showtimeId = Integer.parseInt(showtimeParam);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid showtime_id.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        String[] seats = request.getParameterValues("seat"); // checkbox name="seat"
        int ticketQty = (seats == null) ? 0 : seats.length;

        if (ticketQty == 0) {
            // Optional: stop user if they didn't pick anything
            request.setAttribute("error", "Please select at least 1 seat.");
            response.sendRedirect("SeatSelectionController?showtime_id=" + showtimeId);
            return;
        }

        try {
            // ✅ Always get trusted info from DB
            ShowtimeInfo info = ShowtimeDAO.getShowtimeInfoById(showtimeId);

            double ticketPrice = info.getTicketPrice();
            double ticketTotalValue = ticketPrice * ticketQty;

            HttpSession session = request.getSession();

            session.setAttribute("showtime_id", showtimeId);
            session.setAttribute("movieTitle", info.getMovieTitle());
            session.setAttribute("showDate", info.getShowDate());
            session.setAttribute("showTime", info.getShowTime());
            session.setAttribute("hall", info.getHall());

            session.setAttribute("ticketQty", ticketQty);
            session.setAttribute("ticketPrice", ticketPrice);
            session.setAttribute("ticketTotalValue", ticketTotalValue);

            session.setAttribute("selectedSeats", String.join(",", seats));

            // go snack
            response.sendRedirect(request.getContextPath() + "/SnackSelectionControllerV2");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Seat confirm error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
