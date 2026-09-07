package com.mycompany.sinema.controller;

import com.mycompany.sinema.model.Movie;
import com.mycompany.sinema.DAO.MovieDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/movies")
public class MoviesController extends HttpServlet {

    private MovieDAO movieDAO;

    @Override
    public void init() {
        movieDAO = new MovieDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Movie> nowMovies = movieDAO.findByStatus("Now Showing");
            List<Movie> soonMovies = movieDAO.findByStatus("Coming Soon");

            request.setAttribute("nowMovies", nowMovies != null ? nowMovies : new ArrayList<>());
            request.setAttribute("soonMovies", soonMovies != null ? soonMovies : new ArrayList<>());

            request.getRequestDispatcher("/admin/update_movie.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load movies list", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String action = request.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                Movie m = readMovieFromRequest(request);
                movieDAO.insert(m);

            } else if ("update".equalsIgnoreCase(action)) {
                Movie m = new Movie();
                m.setMovieId(Integer.parseInt(request.getParameter("movieId")));
                m.setTitle(request.getParameter("title"));
                m.setGenre(request.getParameter("genre"));
                m.setDurationMinutes(Integer.parseInt(request.getParameter("duration")));
                m.setLanguage(request.getParameter("language"));
                m.setSubtitle(request.getParameter("subtitles"));
                m.setDirector(request.getParameter("director"));
                m.setCast(request.getParameter("cast"));
                m.setSynopsis(request.getParameter("synopsis"));
                m.setStatus(request.getParameter("status"));
                m.setReleaseDate(request.getParameter("releaseDate"));
                m.setImagePath(request.getParameter("imagePath"));
                m.setYtTrailer(request.getParameter("trailer"));

                movieDAO.update(m);

            } else if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("movieId"));
                movieDAO.delete(id);
            }

            response.sendRedirect(request.getContextPath() + "/admin/movies");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private Movie readMovieFromRequest(HttpServletRequest request) {
        Movie m = new Movie();

        m.setTitle(request.getParameter("title"));
        m.setGenre(request.getParameter("genre"));

        // note: your JSP uses "duration" as minutes
        String duration = request.getParameter("duration");
        m.setDurationMinutes(duration == null || duration.isBlank() ? 0 : Integer.parseInt(duration));

        m.setLanguage(request.getParameter("language"));
        m.setSubtitle(request.getParameter("subtitles"));
        m.setDirector(request.getParameter("director"));
        m.setCast(request.getParameter("cast"));
        m.setSynopsis(request.getParameter("synopsis"));
        m.setStatus(request.getParameter("status"));
        m.setReleaseDate(request.getParameter("releaseDate"));
        m.setImagePath(request.getParameter("imagePath"));
        m.setYtTrailer(request.getParameter("trailer"));

        return m;
    }
}
