package com.mycompany.sinema.controller;

import com.mycompany.sinema.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/ReceiptController")
public class ReceiptController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        // ✅ Must have booking_id saved after successful checkout
        if (session == null || session.getAttribute("booking_id") == null) {
            response.sendRedirect(request.getContextPath() + "/user_page");
            return;
        }

        int bookingId;
        try {
            bookingId = (int) session.getAttribute("booking_id");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/user_page.jsp");
            return;
        }

        String sql = "SELECT booking_id, user_id, showtime_id, total_price, booking_date, seats, snacks, total, columnstatus, booked_at "
                +
                "FROM bookings WHERE booking_id=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    request.setAttribute("error", "Receipt not found. Booking not saved.");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }

                // ===== DB fields =====
                int booking_id = rs.getInt("booking_id");
                double ticketTotal = rs.getDouble("total_price"); // ticket total (from your table)
                String seatsStr = rs.getString("seats");
                String snacksStr = rs.getString("snacks");
                double grandTotal = rs.getDouble("total"); // grand total (ticket + snacks)
                String status = rs.getString("columnstatus");

                // ===== ticket quantity = count seats =====
                int ticketQty = 0;
                if (seatsStr != null && !seatsStr.trim().isEmpty()) {
                    String[] seatArr = seatsStr.split(",");
                    for (String s : seatArr) {
                        if (!s.trim().isEmpty())
                            ticketQty++;
                    }
                }

                // ===== ticket price per seat =====
                double ticketPrice = (ticketQty > 0) ? (ticketTotal / ticketQty) : 0.0;

                // ===== snack total (derived) =====
                // snackTotal = grandTotal - ticketTotal
                double snackTotal = grandTotal - ticketTotal;
                if (snackTotal < 0)
                    snackTotal = 0.0;

                // ===== customer name from session (login) =====
                // You said you set: session.setAttribute("username", rs.getString("username"))
                String customerName = (String) session.getAttribute("username");

                // ===== Set attributes used by receipt.jsp =====
                request.setAttribute("booking_id", booking_id);
                request.setAttribute("status", status);

                request.setAttribute("customer_name", customerName != null ? customerName : "—");

                request.setAttribute("seats", seatsStr != null ? seatsStr : "—");

                request.setAttribute("ticket_qty", ticketQty);
                request.setAttribute("ticket_price", ticketPrice);

                request.setAttribute("snack_summary",
                        (snacksStr != null && !snacksStr.trim().isEmpty()) ? snacksStr : "");
                request.setAttribute("snack_total", snackTotal);

                request.setAttribute("grand_total", grandTotal);

                // Optional extra info (nice for header)
                request.setAttribute("movieTitle", session.getAttribute("movieTitle"));
                request.setAttribute("hall", session.getAttribute("hall"));
                request.setAttribute("showDate", session.getAttribute("showDate"));
                request.setAttribute("showTime", session.getAttribute("showTime"));

                request.getRequestDispatcher("/user/receipt.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Receipt error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
