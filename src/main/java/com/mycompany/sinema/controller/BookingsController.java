package com.mycompany.sinema.controller;

import com.mycompany.sinema.model.Booking;
import com.mycompany.sinema.DAO.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/bookings")
public class BookingsController extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String q = request.getParameter("q"); // keyword (name/email/bookingid)
            String dateStr = request.getParameter("date"); // yyyy-mm-dd
            String status = request.getParameter("status"); // Paid/Pending/All

            Date showDate = null;
            if (dateStr != null && !dateStr.isBlank()) {
                showDate = Date.valueOf(dateStr); // must be yyyy-mm-dd
            }

            List<Booking> bookings;
            boolean hasFilter = (q != null && !q.isBlank()) || showDate != null
                    || (status != null && !status.isBlank() && !status.equalsIgnoreCase("All"));

            if (hasFilter) {
                bookings = bookingDAO.searchBookings(q, showDate, status);
            } else {
                bookings = bookingDAO.getAllBookingsForAdmin();
            }

            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/admin/booking_details.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load bookings", e);
        }
    }
}
