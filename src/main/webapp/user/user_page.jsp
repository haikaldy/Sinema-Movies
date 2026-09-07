<%@page import="java.net.URLEncoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.sinema.model.Movie" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sinema Movies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* Your existing CSS stays the same */
        body {
            background-color: #121212;
            color: #ffffff;
            font-family: 'Segoe UI', sans-serif;
            min-height: 100vh;
        }

        .navbar {
            background-color: #000;
            border-bottom: 1px solid #333;
            padding: 10px 0;
            min-height: 70px;
        }

        .navbar-brand img {
            height: 50px;
            width: auto;
            object-fit: contain;
            vertical-align: middle;
        }
        
        .navbar-brand {
            margin-right: 20px;
        }

        .nav-link {
            color: #bbb !important;
            font-weight: 500;
        }
        
        .nav-link:hover {
            color: #fff !important;
        }

        .nav-tabs {
            border-bottom: 1px solid #333;
            margin-bottom: 30px;
        }

        .nav-tabs .nav-link {
            background: transparent;
            border: none;
            color: #888 !important;
            font-size: 1.1rem;
            font-weight: bold;
            padding: 15px 20px;
            text-transform: uppercase;
        }

        .nav-tabs .nav-link.active {
            color: #fff !important;
            border-bottom: 3px solid #eb3349;
            background-color: transparent;
        }

        .movie-card {
            background-color: transparent;
            border: none;
            transition: transform 0.3s ease;
            cursor: pointer;
            position: relative;
            margin-bottom: 30px;
        }

        .movie-card:hover {
            transform: translateY(-5px);
        }

        .poster-container {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
            aspect-ratio: 2/3;
            background-color: #222;
        }
        
        .poster-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
            display: flex;
            align-items: flex-end;
            justify-content: center;
            padding-bottom: 20px;
            opacity: 0;
            transition: opacity 0.3s ease;
            cursor: default;
        }

        .poster-container:hover .poster-overlay {
            opacity: 1;
        }

        .book-btn {
            background-color: #ffffff;
            color: #eb3349;
            font-weight: bold;
            text-decoration: none;
            padding: 10px 30px;
            border-radius: 25px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.5);
            transform: translateY(20px);
            transition: transform 0.3s ease, background-color 0.2s;
        }

        .poster-container:hover .book-btn {
            transform: translateY(0);
        }

        .book-btn:hover {
            background-color: #eb3349;
            color: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(235, 51, 73, 0.4);
            border: none;
        }

        .poster-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .movie-title {
            margin-top: 15px;
            font-size: 1rem;
            font-weight: bold;
            text-align: center;
            color: #fff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .hidden-now, .hidden-soon {
            display: none;
        }
        
        .expand-btn-container{
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 6px;
        margin-bottom: 12px;
      }

        
        .btn-expand {
            background-color: #eb3349;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            font-size: 1.2rem;
            box-shadow: 0 0 15px rgba(235, 51, 73, 0.5);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-expand:hover {
            transform: scale(1.1);
            background-color: #ff4b5c;
            color: white;
        }

        .section-title {
            text-align: center;
            font-size: 2rem;
            margin: 40px 0;
            font-weight: 300;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #000; padding: 10px 20px;">
    <div class="container-fluid">
        
        <a class="navbar-brand d-flex align-items-center" href="<%=request.getContextPath()%>/user_page">
            <img src="images/logo.png" alt="Sinema Logo" style="height: 50px; width: auto;">
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-1"></i> Hi, <%= session.getAttribute("username") %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end">
                       
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/user/login.jsp">Log Out</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    
    <h2 class="section-title">Movie Showtimes</h2>

    <ul class="nav nav-tabs justify-content-start" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="now-showing-tab" data-bs-toggle="tab" data-bs-target="#now-showing" type="button" role="tab">NOW SHOWING</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="coming-soon-tab" data-bs-toggle="tab" data-bs-target="#coming-soon" type="button" role="tab">COMING SOON</button>
        </li>
    </ul>

    <div class="tab-content pt-4" id="myTabContent">
        
        <!-- NOW SHOWING TAB -->
        <div class="tab-pane fade show active" id="now-showing" role="tabpanel">
            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-6 g-4">
                <%
                List<Movie> nowShowingMovies = (List<Movie>) request.getAttribute("nowShowingMovies");
                if (nowShowingMovies != null) {
                    int nowCount = 0;
                    boolean hasMoreNow = nowShowingMovies.size() > 6;
                    
                    for (Movie movie : nowShowingMovies) {
                        nowCount++;
                        String hiddenClass = (nowCount > 6) ? " hidden-now" : "";
                        
                        // Image handling
                        String imgPath = movie.getImagePath();
                        String imgFile = "default.jpg";
                        if (imgPath != null && !imgPath.trim().isEmpty()) {
                            String tmp = imgPath.replace("\\", "/").trim();
                            int slash = tmp.lastIndexOf('/');
                            imgFile = (slash >= 0) ? tmp.substring(slash + 1) : tmp;
                        }
                        String displayImg = (imgPath == null || imgPath.trim().isEmpty())
                                ? ("/images/" + imgFile)
                                : (imgPath.trim().startsWith("/") ? imgPath.trim() : ("/images/" + imgPath.trim()));
                %>
                
                <div class="col<%= hiddenClass %>">
                    <div class="movie-card" onclick="location.href='movie_selection?movie_id=<%= movie.getMovieId() %>'">
                        <div class="poster-container">
                            <img src="<%= request.getContextPath() + displayImg %>" class="poster-img" alt="<%= movie.getTitle() %>">
                            <div class="poster-overlay">
                                <a href="movie_selection?movie_id=<%= movie.getMovieId() %>" class="book-btn" onclick="event.stopPropagation();">Book now</a>
                            </div>
                        </div>
                        <div class="movie-title"><%= movie.getTitle() %></div>
                    </div>
                </div>
                
                <%
                    }
                    
                    if (hasMoreNow) {
                %>
                <div class="col-12 px-0" style="width:100%!important; flex:0 0 100%!important; max-width:100%!important;">
                    <div class="expand-btn-container">
                        <button class="btn-expand" type="button" onclick="toggleSection('hidden-now', 'iconNow')">
                            <i class="fas fa-chevron-down" id="iconNow"></i>
                        </button>
                    </div>
                </div>
                <%
                    }
                }
                %>
            </div>
        </div>
        
        <!-- COMING SOON TAB -->
        <div class="tab-pane fade" id="coming-soon" role="tabpanel">
            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-6 g-4">
                <%
                List<Movie> comingSoonMovies = (List<Movie>) request.getAttribute("comingSoonMovies");
                if (comingSoonMovies != null) {
                    int soonCount = 0;
                    boolean hasMoreSoon = comingSoonMovies.size() > 6;
                    
                    for (Movie movie : comingSoonMovies) {
                        soonCount++;
                        String hiddenClass = (soonCount > 6) ? " hidden-soon" : "";
                        
                        // Image handling
                        String imgPath = movie.getImagePath();
                        String imgFile = "default.jpg";
                        if (imgPath != null && !imgPath.trim().isEmpty()) {
                            String tmp = imgPath.replace("\\", "/").trim();
                            int slash = tmp.lastIndexOf('/');
                            imgFile = (slash >= 0) ? tmp.substring(slash + 1) : tmp;
                        }
                        String displayImg = (imgPath == null || imgPath.trim().isEmpty())
                                ? ("/images/" + imgFile)
                                : (imgPath.trim().startsWith("/") ? imgPath.trim() : ("/images/" + imgPath.trim()));
                %>
                
                <div class="col<%= hiddenClass %>">
                    <div class="movie-card" onclick="location.href='movie_selection?movie_id=<%= movie.getMovieId() %>'">
                        <div class="poster-container">
                            <img src="<%= request.getContextPath() + displayImg %>" class="poster-img" alt="<%= movie.getTitle() %>">
                            <div class="poster-overlay">
                                <a href="movie_selection?movie_id=<%= movie.getMovieId() %>" class="book-btn" onclick="event.stopPropagation();">More Info</a>
                            </div>
                        </div>
                        <div class="movie-title"><%= movie.getTitle() %></div>
                    </div>
                </div>
                
                <%
                    }
                    
                    if (hasMoreSoon) {
                %>
                <div class="col-12">
                    <div class="expand-btn-container">
                        <button class="btn-expand" type="button" onclick="toggleSection('hidden-soon', 'iconSoon')">
                            <i class="fas fa-chevron-down" id="iconSoon"></i>
                        </button>
                    </div>
                </div>
                <%
                    }
                }
                %>
            </div>
        </div>
        
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function toggleSection(hiddenClass, iconId) {
        const hiddenItems = document.querySelectorAll('.' + hiddenClass);
        const icon = document.getElementById(iconId);
        if (!hiddenItems || hiddenItems.length === 0 || !icon) return;

        const isExpanded = hiddenItems[0].style.display === 'block';

        if (isExpanded) {
            hiddenItems.forEach(item => item.style.display = 'none');
            icon.classList.remove('fa-chevron-up');
            icon.classList.add('fa-chevron-down');
        } else {
            hiddenItems.forEach(item => item.style.display = 'block');
            icon.classList.remove('fa-chevron-down');
            icon.classList.add('fa-chevron-up');
        }
    }
</script>
</body>
</html>