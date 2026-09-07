package com.mycompany.sinema.controller;

import com.mycompany.sinema.model.Showtime;
import com.mycompany.sinema.model.Movie;
import com.mycompany.sinema.DAO.MovieDAO;
import com.mycompany.sinema.DAO.ShowtimeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.*;

@WebServlet("/admin/showtimes")
public class ShowtimesController extends HttpServlet {

  private MovieDAO movieDAO;

  @Override
  public void init() {
    movieDAO = new MovieDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    try {
      String action = request.getParameter("action");
      if ("delete".equalsIgnoreCase(action)) {
        int id = Integer.parseInt(request.getParameter("showtimeId"));
        ShowtimeDAO.deleteShowtime(id);
        response.sendRedirect(request.getContextPath() + "/admin/showtimes");
        return;
      }

      // ... your existing code that loads movies + showtimes ...
      List<Movie> now = movieDAO.findByStatus("Now Showing");
      List<Movie> soon = movieDAO.findByStatus("Coming Soon");

      List<Movie> allMovies = new ArrayList<>();
      if (now != null)
        allMovies.addAll(now);
      if (soon != null)
        allMovies.addAll(soon);

      Map<Integer, String> movieTitleMap = new HashMap<>();
      for (Movie m : allMovies) {
        movieTitleMap.put(m.getMovieId(), m.getTitle());
      }

      List<Showtime> showtimes = ShowtimeDAO.getAllShowtimes();

      request.setAttribute("movies", allMovies);
      request.setAttribute("showtimes", showtimes);
      request.setAttribute("movieTitleMap", movieTitleMap);

      request.getRequestDispatcher("/admin/manage_showtime.jsp").forward(request, response);

    } catch (Exception e) {
      throw new ServletException("Failed to load showtimes page", e);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws IOException, ServletException {

    String action = request.getParameter("action");

    try {
      if ("update_multi".equalsIgnoreCase(action)) {

        int movieId = Integer.parseInt(request.getParameter("movieId"));

        String[] slotIds = request.getParameterValues("slotId");
        String[] slotDates = request.getParameterValues("slotDate");
        String[] slotTimes = request.getParameterValues("slotTime");
        String[] slotHalls = request.getParameterValues("slotHall");
        String[] slotPrices = request.getParameterValues("slotPrice");

        if (slotDates != null) {
          for (int i = 0; i < slotDates.length; i++) {

            Showtime st = new Showtime();
            st.setMovieId(movieId);
            st.setShowDate(Date.valueOf(slotDates[i]));
            st.setShowTime(Time.valueOf(slotTimes[i] + ":00"));
            st.setHall(slotHalls[i]);
            st.setPrice(Double.parseDouble(slotPrices[i]));

            // if slotId exists => UPDATE, else INSERT
            String sid = (slotIds != null && slotIds.length > i) ? slotIds[i] : null;

            if (sid != null && !sid.isBlank()) {
              st.setShowtimeId(Integer.parseInt(sid));
              ShowtimeDAO.updateShowtime(st);
            } else {
              ShowtimeDAO.insertShowtime(st);
            }
          }
        }
      } else if ("update".equalsIgnoreCase(action)) {

        Showtime st = new Showtime();
        st.setShowtimeId(Integer.parseInt(request.getParameter("showtimeId")));
        st.setMovieId(Integer.parseInt(request.getParameter("movieId")));
        st.setShowDate(Date.valueOf(request.getParameter("showDate")));
        st.setShowTime(Time.valueOf(request.getParameter("showTime") + ":00"));
        st.setPrice(Double.parseDouble(request.getParameter("price")));
        st.setHall(request.getParameter("hall"));

        ShowtimeDAO.updateShowtime(st);

      } else if ("delete".equalsIgnoreCase(action)) {
        int id = Integer.parseInt(request.getParameter("showtimeId"));

        if (ShowtimeDAO.hasBookings(id)) {
          request.getSession().setAttribute("flashError",
              "Cannot delete showtime because there are bookings linked to it.");
        } else {
          ShowtimeDAO.deleteShowtime(id);
        }
      }

      response.sendRedirect(request.getContextPath() + "/admin/showtimes");

    } catch (Exception e) {
      throw new ServletException(e);
    }
  }
}
