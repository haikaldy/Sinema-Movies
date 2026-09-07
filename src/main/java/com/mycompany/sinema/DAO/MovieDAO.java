package com.mycompany.sinema.DAO;

import com.mycompany.sinema.util.DBConnection;
import com.mycompany.sinema.model.Movie;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {

    // CREATE
    public void insert(Movie m) throws Exception {
        String sql = "INSERT INTO movies " +
                "(title, genre, duration_minutes, language, subtitle, director, `cast`, synopsis, status, image_path, yt_trailer) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getTitle());
            ps.setString(2, m.getGenre());
            ps.setInt(3, m.getDurationMinutes());
            ps.setString(4, m.getLanguage());
            ps.setString(5, m.getSubtitle());
            ps.setString(6, m.getDirector());
            ps.setString(7, m.getCast());
            ps.setString(8, m.getSynopsis());
            ps.setString(9, m.getStatus());
            ps.setString(10, m.getImagePath());
            ps.setString(11, m.getYtTrailer());

            ps.executeUpdate();
        }
    }

    // UPDATE
    public void update(Movie m) throws Exception {
        String sql = "UPDATE movies SET " +
                "title=?, genre=?, duration_minutes=?, language=?, subtitle=?, director=?, `cast`=?, synopsis=?, status=?, image_path=?, yt_trailer=? "
                +
                "WHERE movie_id=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getTitle());
            ps.setString(2, m.getGenre());
            ps.setInt(3, m.getDurationMinutes());
            ps.setString(4, m.getLanguage());
            ps.setString(5, m.getSubtitle());
            ps.setString(6, m.getDirector());
            ps.setString(7, m.getCast());
            ps.setString(8, m.getSynopsis());
            ps.setString(9, m.getStatus());
            ps.setString(10, m.getImagePath());
            ps.setString(11, m.getYtTrailer());
            ps.setInt(12, m.getMovieId());

            ps.executeUpdate();
        }
    }

    // DELETE
    public void delete(int movieId) throws Exception {
        String sql = "DELETE FROM movies WHERE movie_id=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);
            ps.executeUpdate();
        }
    }

    // READ: find by status
    public List<Movie> findByStatus(String status) throws Exception {
        String sql = "SELECT movie_id, title, genre, duration_minutes, language, subtitle, director, `cast`, synopsis, status, image_path, yt_trailer "
                +
                "FROM movies WHERE status=? ORDER BY movie_id DESC";

        List<Movie> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    // READ: find by id
    public Movie findById(int movieId) throws Exception {
        String sql = "SELECT movie_id, title, genre, duration_minutes, language, subtitle, director, `cast`, synopsis, status, image_path, yt_trailer "
                +
                "FROM movies WHERE movie_id=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        }
        return null;
    }

    // READ: find all movies
    public List<Movie> findAll() throws Exception {
        String sql = "SELECT movie_id, title, genre, duration_minutes, language, subtitle, director, `cast`, synopsis, status, image_path, yt_trailer "
                +
                "FROM movies ORDER BY movie_id DESC";

        List<Movie> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    // Helper mapper
    private Movie mapRow(ResultSet rs) throws SQLException {
        Movie m = new Movie();
        m.setMovieId(rs.getInt("movie_id"));
        m.setTitle(rs.getString("title"));
        m.setGenre(rs.getString("genre"));
        m.setDurationMinutes(rs.getInt("duration_minutes"));
        m.setLanguage(rs.getString("language"));
        m.setSubtitle(rs.getString("subtitle"));
        m.setDirector(rs.getString("director"));
        m.setCast(rs.getString("cast"));
        m.setSynopsis(rs.getString("synopsis"));
        m.setStatus(rs.getString("status"));
        m.setImagePath(rs.getString("image_path"));
        m.setYtTrailer(rs.getString("yt_trailer"));
        return m;
    }
}
