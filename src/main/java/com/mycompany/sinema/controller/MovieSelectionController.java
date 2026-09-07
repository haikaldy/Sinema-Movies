package com.mycompany.sinema.controller;

import com.mycompany.sinema.model.Showtime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/movie_selection")
public class MovieSelectionController extends HttpServlet {

    private static final String DB_URL = "jdbc:mariadb://localhost:3306/sinema";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieIdParam = request.getParameter("movie_id");
        if (movieIdParam == null || movieIdParam.isBlank()) {
            request.setAttribute("error", "movie_id missing");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        int movie_id;
        try {
            movie_id = Integer.parseInt(movieIdParam);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid movie_id");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // 1) Load showtimes
        List<Showtime> showtimes = new ArrayList<>();
        String showtimeSql = "SELECT showtime_id, movie_id, show_date, show_time, price, hall " +
                "FROM showtimes WHERE movie_id=? ORDER BY show_date, show_time";

        // 2) Load movie details (title/poster/rating/etc)
        // ⚠️ CHANGE column names if your table is different
        String movieSql = "SELECT title, genre, duration_minutes, language, subtitle, director, cast, status, image_path, yt_trailer, synopsis FROM movies WHERE movie_id=?";

        try {
            Class.forName("org.mariadb.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                // movie details
                try (PreparedStatement ps = conn.prepareStatement(movieSql)) {
                    ps.setInt(1, movie_id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            request.setAttribute("title", rs.getString("title"));
                            request.setAttribute("genre", rs.getString("genre"));
                            request.setAttribute("duration_minutes", rs.getInt("duration_minutes"));
                            request.setAttribute("language", rs.getString("language")); // e.g. "2 hr 15 mins"
                            request.setAttribute("subtitle", rs.getString("subtitle"));
                            request.setAttribute("director", rs.getString("director")); // e.g. "/images/xxx.jpg" or
                                                                                        // "xxx.jpg"
                            request.setAttribute("cast", rs.getString("cast")); // youtube id (optional)
                            request.setAttribute("status", rs.getString("status"));
                            request.setAttribute("image_path", rs.getString("image_path"));
                            request.setAttribute("yt_trailer", rs.getString("yt_trailer"));
                            request.setAttribute("synopsis", rs.getString("synopsis"));
                        } else {

                            request.setAttribute("error", "Movie not found for movie_id=" + movie_id);
                            request.getRequestDispatcher("/error.jsp").forward(request, response);
                            return;
                        }
                    }
                }

                // showtimes list
                try (PreparedStatement ps = conn.prepareStatement(showtimeSql)) {
                    ps.setInt(1, movie_id);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Showtime st = new Showtime();
                            st.setShowtimeId(rs.getInt("showtime_id"));
                            st.setMovieId(rs.getInt("movie_id"));
                            st.setShowDate(rs.getDate("show_date"));
                            st.setShowTime(rs.getTime("show_time"));
                            st.setPrice(rs.getDouble("price"));
                            st.setHall(rs.getString("hall"));
                            showtimes.add(st);
                        }
                    }
                }
            }

            request.setAttribute("movie_id", movie_id);
            request.setAttribute("showtimes", showtimes);
            request.getRequestDispatcher("/user/movie_selection.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
