package com.mycompany.sinema.model;

public class Movie {

    private int movieId;
    private String title;
    private String genre;
    private int durationMinutes;
    private String language;
    private String subtitle;
    private String director;
    private String cast;
    private String synopsis;
    private String status;
    private String releaseDate; // keep as String
    private String imagePath;
    private String ytTrailer;

    // Constructors
    public Movie() {
    }

    public Movie(int movieId, String title, String genre, int durationMinutes,
            String language, String subtitle, String director, String cast,
            String synopsis, String status, String releaseDate,
            String imagePath, String ytTrailer) {
        this.movieId = movieId;
        this.title = title;
        this.genre = genre;
        this.durationMinutes = durationMinutes;
        this.language = language;
        this.subtitle = subtitle;
        this.director = director;
        this.cast = cast;
        this.synopsis = synopsis;
        this.status = status;
        this.releaseDate = releaseDate;
        this.imagePath = imagePath;
        this.ytTrailer = ytTrailer;
    }

    // Getters & Setters
    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getCast() {
        return cast;
    }

    public void setCast(String cast) {
        this.cast = cast;
    }

    public String getSynopsis() {
        return synopsis;
    }

    public void setSynopsis(String synopsis) {
        this.synopsis = synopsis;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getYtTrailer() {
        return ytTrailer;
    }

    public void setYtTrailer(String ytTrailer) {
        this.ytTrailer = ytTrailer;
    }
}
