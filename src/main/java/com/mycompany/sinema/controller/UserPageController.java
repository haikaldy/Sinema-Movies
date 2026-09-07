package com.mycompany.sinema.controller;

import com.mycompany.sinema.model.Movie;
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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/user_page")
public class UserPageController extends HttpServlet {

    private static final String DB_URL = "jdbc:mariadb://localhost:3306/sinema";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection conn = null;
        PreparedStatement psNow = null;
        PreparedStatement psSoon = null;
        ResultSet rsNow = null;
        ResultSet rsSoon = null;

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // 1. FETCH "NOW SHOWING" MOVIES
            List<Movie> nowShowingMovies = new ArrayList<>();
            psNow = conn.prepareStatement(
                    "SELECT movie_id, title, genre, duration_minutes, language, subtitle, director, cast, status, release_date, image_path, yt_trailer, synopsis FROM movies WHERE status=? ORDER BY movie_id DESC");
            psNow.setString(1, "Now Showing");
            rsNow = psNow.executeQuery();

            while (rsNow.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rsNow.getInt("movie_id"));
                movie.setTitle(rsNow.getString("title"));
                movie.setGenre(rsNow.getString("genre"));
                movie.setDurationMinutes(rsNow.getInt("duration_minutes"));
                movie.setLanguage(rsNow.getString("language"));
                movie.setSubtitle(rsNow.getString("subtitle"));
                movie.setDirector(rsNow.getString("director"));
                movie.setCast(rsNow.getString("cast"));
                movie.setStatus(rsNow.getString("status"));
                movie.setReleaseDate(rsNow.getString("release_date"));
                movie.setImagePath(rsNow.getString("image_path"));
                movie.setYtTrailer(rsNow.getString("yt_trailer"));
                movie.setSynopsis(rsNow.getString("synopsis"));

                nowShowingMovies.add(movie);
            }

            // 2. FETCH "COMING SOON" MOVIES
            List<Movie> comingSoonMovies = new ArrayList<>();
            psSoon = conn.prepareStatement(
                    "SELECT movie_id, title, genre, duration_minutes, language, subtitle, director, cast, status, release_date, image_path, yt_trailer, synopsis FROM movies WHERE status=? ORDER BY movie_id DESC");
            psSoon.setString(1, "Coming Soon");
            rsSoon = psSoon.executeQuery();

            while (rsSoon.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rsSoon.getInt("movie_id"));
                movie.setTitle(rsSoon.getString("title"));
                movie.setGenre(rsSoon.getString("genre"));
                movie.setDurationMinutes(rsSoon.getInt("duration_minutes"));
                movie.setLanguage(rsSoon.getString("language"));
                movie.setSubtitle(rsSoon.getString("subtitle"));
                movie.setDirector(rsSoon.getString("director"));
                movie.setCast(rsSoon.getString("cast"));
                movie.setStatus(rsSoon.getString("status"));
                movie.setReleaseDate(rsSoon.getString("release_date"));
                movie.setImagePath(rsSoon.getString("image_path"));
                movie.setYtTrailer(rsSoon.getString("yt_trailer"));
                movie.setSynopsis(rsSoon.getString("synopsis"));

                comingSoonMovies.add(movie);
            }

            // 3. SET AS REQUEST ATTRIBUTES
            request.setAttribute("nowShowingMovies", nowShowingMovies);
            request.setAttribute("comingSoonMovies", comingSoonMovies);

            // 4. FORWARD TO JSP
            request.getRequestDispatcher("/user/user_page.jsp").forward(request, response);

        } catch (ServletException | IOException | ClassNotFoundException | SQLException e) {
            e.printStackTrace(); // ADDED FOR DEBUGGING
            response.getWriter().println("ERROR in UserPageController: " + e.getMessage());
        } finally {
            try {
                if (rsNow != null)
                    rsNow.close();
            } catch (SQLException ignore) {
            }
            try {
                if (rsSoon != null)
                    rsSoon.close();
            } catch (SQLException ignore) {
            }
            try {
                if (psNow != null)
                    psNow.close();
            } catch (SQLException ignore) {
            }
            try {
                if (psSoon != null)
                    psSoon.close();
            } catch (SQLException ignore) {
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (SQLException ignore) {
            }
        }
    }
}