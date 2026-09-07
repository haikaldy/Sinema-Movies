package com.mycompany.sinema.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/addMovie")
public class UpdateMovieController extends HttpServlet {

    private static final String URL = "jdbc:mariadb://localhost:3306/sinema";
    private static final String USER = "root";
    private static final String PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "add";

        try {
            Class.forName("org.mariadb.jdbc.Driver");

            switch (action) {
                case "add":
                    addMovie(request);
                    break;
                case "update":
                    updateMovie(request);
                    break;
                case "delete":
                    deleteMovie(request);
                    break;
                default:
                    break;
            }

            // after admin edits, go back to admin page
            response.sendRedirect(request.getContextPath() + "/admin/update_movie.jsp");

        } catch (Exception e) {
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }

    private void addMovie(HttpServletRequest request) throws Exception {
        String sql = "INSERT INTO movies(title, genre, duration_minutes, language,"
                + "subtitle, director, `cast`, status, release_date, image_path, yt_trailer, synopsis)"
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
                PreparedStatement ps = conn.prepareStatement(sql)) {

            fillMovieParams(ps, request, false);
            ps.executeUpdate();
        }
    }

    private void updateMovie(HttpServletRequest request) throws Exception {
        String movieIdStr = request.getParameter("movieId");
        int movieId = Integer.parseInt(movieIdStr);

        String sql = "UPDATE movies SET title=?, genre=?, duration_minutes=?,"
                + "language=?, subtitle=?, director=?, `cast`=?, status=?,"
                + "release_date=?, image_path=?, yt_trailer=?, synopsis=?"
                + "WHERE movie_id=?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
                PreparedStatement ps = conn.prepareStatement(sql)) {

            fillMovieParams(ps, request, true);
            ps.setInt(13, movieId);
            ps.executeUpdate();
        }
    }

    private void deleteMovie(HttpServletRequest request) throws Exception {
        String movieIdStr = request.getParameter("movieId");
        int movieId = Integer.parseInt(movieIdStr);

        String sql = "DELETE FROM movies WHERE movie_id=?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);
            ps.executeUpdate();
        }
    }

    private void fillMovieParams(PreparedStatement ps, HttpServletRequest request, boolean isUpdate) throws Exception {
        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String duration = request.getParameter("duration");
        String language = request.getParameter("language");
        String subtitles = request.getParameter("subtitles");
        String director = request.getParameter("director");
        String cast = request.getParameter("cast");
        String status = request.getParameter("status");
        String releaseDate = request.getParameter("releaseDate");
        String imagePath = request.getParameter("imagePath");
        String trailer = request.getParameter("trailer");
        String synopsis = request.getParameter("synopsis");

        int durationMinutes = Integer.parseInt(duration); // make sure your JSP sends minutes (number)

        ps.setString(1, title);
        ps.setString(2, genre);
        ps.setInt(3, durationMinutes);
        ps.setString(4, language);
        ps.setString(5, subtitles);
        ps.setString(6, director);
        ps.setString(7, cast);
        ps.setString(8, status);
        ps.setString(9, releaseDate);
        ps.setString(10, imagePath);
        ps.setString(11, trailer);
        ps.setString(12, synopsis);
    }
}
