package com.mycompany.sinema.controller;

import com.mycompany.sinema.model.Snack;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/SnackSelectionControllerV2")
public class SnackSelectionController extends HttpServlet {

    // SHOW SNACK PAGE
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("showtime_id") == null) {
            // no booking session -> kick back
            response.sendRedirect(request.getContextPath() + "/user_page.jsp");
            return;
        }

        // Read trusted booking info from SESSION (set by
        // SeatSelectionController.doPost)
        int showtime_id = (int) session.getAttribute("showtime_id");
        String movieTitle = (String) session.getAttribute("movieTitle");
        Object showDate = session.getAttribute("showDate");
        Object showTime = session.getAttribute("showTime");
        String hall = (String) session.getAttribute("hall");

        int ticketQty = (int) session.getAttribute("ticketQty");
        double ticketPrice = (double) session.getAttribute("ticketPrice");
        double ticketTotalValue = (double) session.getAttribute("ticketTotalValue");
        String selectedSeats = (String) session.getAttribute("selectedSeats");

        // Pass to JSP
        request.setAttribute("showtime_id", showtime_id);
        request.setAttribute("movieTitle", movieTitle);
        request.setAttribute("showDate", showDate);
        request.setAttribute("showTime", showTime);
        request.setAttribute("hall", hall);

        request.setAttribute("ticketQty", ticketQty);
        request.setAttribute("ticketPrice", ticketPrice);
        request.setAttribute("ticketTotalValue", ticketTotalValue);
        request.setAttribute("selectedSeats", selectedSeats);

        // Load snacks from DB
        List<Snack> snackList = new ArrayList<>();
        String sql = "SELECT snack_id, snack_name, detail, price, image_path FROM snacks";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Snack s = new Snack();
                s.setSnackId(rs.getInt("snack_id"));
                s.setSnackName(rs.getString("snack_name"));
                s.setDetail(rs.getString("detail"));
                s.setPrice(rs.getDouble("price"));
                s.setImagePath(rs.getString("image_path"));
                snackList.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading snacks: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("snacks", snackList);
        request.getRequestDispatcher("/user/food_selection.jsp").forward(request, response);
    }

    // USER CLICKS CHECKOUT FROM FOOD PAGE
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("ticketTotalValue") == null) {
            response.sendRedirect(request.getContextPath() + "/user_page.jsp");
            return;
        }

        // 1) Get ticket total from session
        double ticketTotal = 0.0;
        try {
            ticketTotal = (double) session.getAttribute("ticketTotalValue");
        } catch (Exception ignore) {
        }

        // 2) Read snacks data from request
        // These MUST come from hidden inputs in food_selection.jsp
        String snackSummary = request.getParameter("snackSummary"); // e.g. "Popcorn x1, Coke x2"
        String snackTotalStr = request.getParameter("snackTotalValue");

        if (snackSummary == null)
            snackSummary = "";
        double snackTotalValue = 0.0;

        try {
            if (snackTotalStr != null && !snackTotalStr.isBlank()) {
                snackTotalValue = Double.parseDouble(snackTotalStr);
            }
        } catch (Exception ignore) {
            snackTotalValue = 0.0;
        }

        // 3) Compute grand total
        double grandTotalValue = ticketTotal + snackTotalValue;

        // 4) Save into session for checkout page
        session.setAttribute("snackSummary", snackSummary);
        session.setAttribute("snackTotalValue", snackTotalValue);
        session.setAttribute("grandTotalValue", grandTotalValue);

        // 5) Redirect to checkout controller/page
        response.sendRedirect(request.getContextPath() + "/CheckoutController");
    }
}
