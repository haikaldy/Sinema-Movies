<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.sinema.model.Movie" %>
<%
  List<Movie> nowMovies  = (List<Movie>) request.getAttribute("nowMovies");
  List<Movie> soonMovies = (List<Movie>) request.getAttribute("soonMovies");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Update Movies</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
:root{
  --bg:#0b0b0f;
  --panel:#111118;
  --line:rgba(255,255,255,.12);
  --text:#f5f5f5;
  --muted:#bdbdbd;
  --accent:#e50914;
  --accent2:#7c4dff;
}

body{
  min-height:100vh;
  background:
    radial-gradient(900px 450px at 20% 15%, rgba(229,9,20,.18), transparent 60%),
    radial-gradient(900px 450px at 85% 25%, rgba(124,77,255,.14), transparent 60%),
    linear-gradient(180deg, #08080b, var(--bg));
  color:var(--text);
  overflow-x:hidden;
}
a{ text-decoration:none; }

/* ===== Sidebar ===== */
.sidebar{
  width:270px;
  min-height:100vh;
  position:fixed;
  left:0; top:0;
  background: linear-gradient(180deg, rgba(255,255,255,.03), transparent 40%), var(--panel);
  border-right:1px solid var(--line);
  padding:22px 16px;
}
.content{
  margin-left:270px;
  padding:26px 26px 46px;
}
.brand{
  display:flex;
  align-items:center;
  gap:10px;
  padding:10px 10px 18px;
  border-bottom:1px solid var(--line);
  margin-bottom:16px;
}
.brand .logo{
  width:48px;
  height:48px;
  border-radius:14px;
  display:flex;
  align-items:center;
  justify-content:center;
  background: rgba(124,77,255,.08);
  border:1px solid rgba(124,77,255,.22);
  overflow:hidden;
}
.brand .logo img{
  width:100%;
  height:100%;
  object-fit:cover;
  display:block;
}
.brand .title{ font-weight:900; letter-spacing:1px; margin:0; }
.brand small{ color:var(--muted); font-size:12px; display:block; margin-top:-2px; }

.nav-itemx{
  display:flex;
  align-items:center;
  gap:10px;
  padding:12px 12px;
  border-radius:12px;
  color:#ddd;
  margin-bottom:8px;
  transition:.2s ease;
  border:1px solid transparent;
}
.nav-itemx i{ font-size:18px; }
.nav-itemx:hover{
  background: rgba(229,9,20,.10);
  border-color: rgba(229,9,20,.25);
  color:#fff;
}
.nav-itemx.active{
  background: linear-gradient(90deg, rgba(229,9,20,.25), rgba(124,77,255,.15));
  border-color: rgba(229,9,20,.35);
  color:#fff;
  box-shadow: 0 10px 25px rgba(0,0,0,.35);
}
.sidebar .bottom{
  position:absolute;
  left:16px; right:16px;
  bottom:16px;
  padding-top:12px;
  border-top:1px solid var(--line);
}

/* ===== TOPBAR ===== */
.topbar{
  display:flex; align-items:center; justify-content:space-between;
  gap:12px; padding:14px 16px;
  border:1px solid var(--line);
  background: rgba(0,0,0,.35);
  border-radius:16px;
  backdrop-filter: blur(10px);
}

/* ===== Header ===== */
.page-title{ font-size:44px; font-weight:900; margin:18px 0 6px; }
.page-sub{ color:var(--muted); margin-bottom:18px; }

/* ===== Tabs (underline) ===== */
.nav-tabs{
  border-bottom:1px solid rgba(255,255,255,.18);
}
.nav-tabs .nav-link{
  background: transparent;
  border: none;
  color: #9a9a9a !important;
  font-size: 1.05rem;
  font-weight: 800;
  padding: 15px 18px;
  text-transform: uppercase;
  letter-spacing: .6px;
}
.nav-tabs .nav-link.active{
  color: #fff !important;
  border-bottom: 3px solid var(--accent);
  background: transparent;
}

/* ===== Movie Cards (same like user_page) ===== */
.movie-card{
  background-color: transparent;
  border: none;
  transition: transform .25s ease;
  cursor: pointer;
  position: relative;
  margin-bottom: 22px;
}
.movie-card:hover{ transform: translateY(-5px); }

.poster-container{
  position: relative;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 6px 18px rgba(0,0,0,.55);
  aspect-ratio: 2/3;
  background-color: rgba(255,255,255,.06);
  border:1px solid rgba(255,255,255,.10);
}
.poster-img{
  width: 100%;
  height: 100%;
  object-fit: cover;
  display:block;
}

.poster-overlay{
  position:absolute;
  inset:0;
  background: rgba(0,0,0,.45);
  display:flex;
  align-items:flex-end;
  justify-content:center;
  padding-bottom: 18px;
  opacity:0;
  transition: opacity .25s ease;
}
.poster-container:hover .poster-overlay{ opacity:1; }

.edit-btn{
  background-color: #ffffff;
  color: var(--accent);
  font-weight: 900;
  text-decoration:none;
  padding: 10px 26px;
  border-radius: 999px;
  box-shadow: 0 6px 14px rgba(0,0,0,.55);
  transform: translateY(18px);
  transition: transform .25s ease, background-color .2s ease, color .2s ease;
  border:0;
}
.poster-container:hover .edit-btn{ transform: translateY(0); }
.edit-btn:hover{
  background-color: var(--accent);
  color: #ffffff;
  transform: translateY(-2px);
  box-shadow: 0 10px 22px rgba(229,9,20,.35);
}

.movie-title{
  margin-top: 12px;
  font-size: 1rem;
  font-weight: 900;
  text-align: center;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.movie-meta{
  text-align:center;
  color: var(--muted);
  font-size: .85rem;
  margin-top: 4px;
}

/* Hidden movies */
.hidden-now, .hidden-soon{ display:none; }

/* Expand button */
.expand-btn-container{
  text-align:center;
  margin-top: 6px;
  margin-bottom: 12px;
}
.btn-expand{
  background-color: var(--accent);
  color: white;
  width: 52px;
  height: 52px;
  border-radius: 50%;
  border: none;
  font-size: 1.2rem;
  box-shadow: 0 0 16px rgba(229,9,20,.45);
  transition: all .25s ease;
  display:inline-flex;
  align-items:center;
  justify-content:center;
}
.btn-expand:hover{
  transform: scale(1.08);
  filter: brightness(1.08);
}

/* ===== Modal styling ===== */
.modal-content{
  background:#111118;
  border:1px solid rgba(255,255,255,.12);
  color:#fff;
}
.form-control, .form-select{
  background: rgba(255,255,255,.04) !important;
  border:1px solid var(--line) !important;
  color: var(--text) !important;
}

.form-select option{
  background-color:#111118;
  color:#ffffff;
}

.form-control::placeholder{ color: rgba(255,255,255,.35); }
.form-control:focus, .form-select:focus{
  border-color: rgba(229,9,20,.35) !important;
  box-shadow: 0 0 0 .2rem rgba(229,9,20,.12) !important;
}
.btn-accent{
  background: linear-gradient(90deg, rgba(229,9,20,.95), rgba(124,77,255,.75));
  border:0;
  color:#fff;
}
.btn-accent:hover{ filter: brightness(1.05); }

@media(max-width:992px){
  .sidebar{ position:relative; width:100%; min-height:auto; }
  .content{ margin-left:0; }
  .sidebar .bottom{ position:static; margin-top:14px; }
}

input[type="date"]::-webkit-calendar-picker-indicator{
  filter: invert(1);
  opacity: .85;
  cursor: pointer;
}
</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
  <div class="brand">
    <div class="logo">
      <img src="<%= request.getContextPath() %>/images/logo2.png" alt="Cinema Logo">
    </div>
    <div>
      <p class="title mb-0">SINEMA</p>
      <small>Admin Panel</small>
    </div>
  </div>

  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/dashboard">
    <i class="bi bi-grid-1x2-fill"></i> Dashboard
  </a>
    
  <a class="nav-itemx active" href="<%= request.getContextPath() %>/admin/movies">
    <i class="bi bi-camera-reels"></i> Movies
  </a>
    
  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/showtimes">
    <i class="bi bi-clock-history"></i> Showtimes
  </a>
    
  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/bookings">
    <i class="bi bi-ticket-perforated"></i> Bookings
  </a>
    
  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/report">
    <i class="bi bi-graph-up-arrow"></i> Report
  </a>

  <div class="bottom">
    <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/admin_login.jsp">
      <i class="bi bi-box-arrow-right"></i> Logout
    </a>
  </div>
</div>


<!-- CONTENT -->
<div class="content">

  <div class="topbar">
    <div>
      <div class="text-secondary small">Admin / movies</div>
      <div class="fw-bold">Manage movies</div>
    </div>
    <div class="d-flex gap-2">
      <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/admin/admin_page.jsp">
        <i class="bi bi-house"></i> Dashboard
      </a>
    </div>
  </div>

  <div class="page-title">Manage Movies</div>
  <div class="page-sub">Add and edit movies.</div>

  <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
    <ul class="nav nav-tabs" id="movieTabs" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active" id="now-tab" data-bs-toggle="tab" data-bs-target="#now" type="button" role="tab">
          NOW SHOWING
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="soon-tab" data-bs-toggle="tab" data-bs-target="#soon" type="button" role="tab">
          COMING SOON
        </button>
      </li>
    </ul>

    <button class="btn btn-accent" data-bs-toggle="modal" data-bs-target="#addMovieModal">
      <i class="bi bi-plus-circle me-1"></i> Add Movie
    </button>
  </div>

  <div class="tab-content pt-4">

    <!-- NOW SHOWING -->
    <div class="tab-pane fade show active" id="now" role="tabpanel" aria-labelledby="now-tab">

<%
  int nowCount = 0;
  boolean hasMoreNow = false;
%>

<div class="row row-cols-2 row-cols-md-3 row-cols-lg-6 g-4">
<%
  if(nowMovies != null){
    for(Movie m : nowMovies){
      nowCount++;
      if(nowCount == 7) hasMoreNow = true;

      String hiddenClass = (nowCount > 6) ? " hidden-now" : "";
      String img = m.getImagePath();
%>

  <div class="col<%= hiddenClass %>">
    <div class="movie-card">
      <div class="poster-container">
        <img src="<%= request.getContextPath() + (img==null || img.isBlank() ? "/images/default.jpg" : img) %>"
             class="poster-img" alt="Movie">
        <div class="poster-overlay">
          <button
            type="button"
            class="edit-btn btnEditMovie"
            data-bs-toggle="modal"
            data-bs-target="#editMovieModal"

            data-id="<%= m.getMovieId() %>"
            data-title="<%= m.getTitle() %>"
            data-genre="<%= m.getGenre() %>"
            data-duration="<%= m.getDurationMinutes() %>"
            data-language="<%= m.getLanguage() %>"
            data-subtitles="<%= m.getSubtitle() %>"
            data-director="<%= m.getDirector() %>"
            data-cast="<%= m.getCast() %>"
            data-synopsis="<%= m.getSynopsis() %>"
            data-status="<%= m.getStatus() %>"
            data-releasedate="<%= m.getReleaseDate() %>"
            data-imagepath="<%= m.getImagePath() %>"
            data-trailer="<%= m.getYtTrailer() %>"
          >
            <i class="bi bi-pencil-square me-1"></i> Edit
          </button>
        </div>
      </div>

      <div class="movie-title"><%= m.getTitle() %></div>
      <div class="movie-meta"><%= m.getDurationMinutes() %> mins • <%= m.getLanguage() %></div>
    </div>
  </div>

<%
    }
  }
%>
</div>

<% if(hasMoreNow){ %>
  <div class="expand-btn-container">
    <button class="btn-expand" type="button" onclick="toggleSection('hidden-now','iconNow')">
      <i class="bi bi-chevron-down" id="iconNow"></i>
    </button>
  </div>
<% } %>

</div>


    <!-- COMING SOON -->
    <div class="tab-pane fade" id="soon" role="tabpanel" aria-labelledby="soon-tab">

    <%
      int soonCount = 0;
      boolean hasMoreSoon = false;
    %>

    <div class="row row-cols-2 row-cols-md-3 row-cols-lg-6 g-4">
    <%
      if(soonMovies != null){
        for(Movie m : soonMovies){
          soonCount++;
          if(soonCount == 7) hasMoreSoon = true;

          String hiddenClass = (soonCount > 6) ? " hidden-soon" : "";
          String img = m.getImagePath();
    %>

      <div class="col<%= hiddenClass %>">
        <div class="movie-card">
          <div class="poster-container">
            <img src="<%= request.getContextPath() + (img==null || img.isBlank() ? "/images/default.jpg" : img) %>"
                 class="poster-img" alt="Movie">
            <div class="poster-overlay">
              <button
                type="button"
                class="edit-btn btnEditMovie"
                data-bs-toggle="modal"
                data-bs-target="#editMovieModal"

                data-id="<%= m.getMovieId() %>"
                data-title="<%= m.getTitle() %>"
                data-genre="<%= m.getGenre() %>"
                data-duration="<%= m.getDurationMinutes() %>"
                data-language="<%= m.getLanguage() %>"
                data-subtitles="<%= m.getSubtitle() %>"
                data-director="<%= m.getDirector() %>"
                data-cast="<%= m.getCast() %>"
                data-synopsis="<%= m.getSynopsis() %>"
                data-status="<%= m.getStatus() %>"
                data-releasedate="<%= m.getReleaseDate() %>"
                data-imagepath="<%= m.getImagePath() %>"
                data-trailer="<%= m.getYtTrailer() %>"
              >
                <i class="bi bi-pencil-square me-1"></i> Edit
              </button>
            </div>
          </div>

          <div class="movie-title"><%= m.getTitle() %></div>
          <div class="movie-meta"><%= m.getDurationMinutes() %> mins • <%= m.getLanguage() %></div>
        </div>
      </div>

    <%
        }
      }
    %>
    </div>

    <% if(hasMoreSoon){ %>
      <div class="expand-btn-container">
        <button class="btn-expand" type="button" onclick="toggleSection('hidden-soon','iconSoon')">
          <i class="bi bi-chevron-down" id="iconSoon"></i>
        </button>
      </div>
    <% } %>

</div>
</div>
</div>


<!-- ADD MOVIE MODAL -->
<div class="modal fade" id="addMovieModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header" style="border-color: rgba(255,255,255,.10);">
        <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Add Movie</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>

      <form action="<%=request.getContextPath()%>/admin/movies" method="post">
        <div class="modal-body">

          <!-- (optional) action param if your servlet uses it -->
          <input type="hidden" name="action" value="add">

          <div class="row g-3">
            <div class="col-md-8">
              <label class="form-label">Title</label>
              <input class="form-control" name="title" required>
            </div>

            <div class="col-md-8">
              <label class="form-label">Genre</label>
              <input class="form-control" name="genre" required>
            </div>

            <div class="col-md-4">
              <label class="form-label">Duration (minutes)</label>
              <input class="form-control" type="number" name="duration" placeholder="190" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Language</label>
              <input class="form-control" name="language" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Subtitles</label>
              <input class="form-control" name="subtitles" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Director</label>
              <input class="form-control" name="director" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Cast</label>
              <input class="form-control" name="cast" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Status</label>
              <select class="form-select" name="status" required>
                <option>Now Showing</option>
                <option>Coming Soon</option>
              </select>
            </div>

            <div class="col-md-6">
              <label class="form-label">Release Date</label>
              <input type="date" class="form-control" name="releaseDate" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Image Path</label>
              <input class="form-control" name="imagePath" placeholder="/images/movie1.jpg" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Trailer (YouTube ID optional)</label>
              <input class="form-control" name="trailer">
            </div>

            <div class="col-12">
              <label class="form-label">Synopsis</label>
              <textarea class="form-control" name="synopsis" rows="4" required></textarea>
            </div>
          </div>

        </div>

        <div class="modal-footer" style="border-color: rgba(255,255,255,.10);">
          <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-accent" name="action" value="add">Save</button>
        </div>
      </form>
    </div>
  </div>
</div>

        
<!-- EDIT MOVIE MODAL (FULL DETAILS + AUTO FILL) -->
<div class="modal fade" id="editMovieModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header" style="border-color: rgba(255,255,255,.10);">
        <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Edit Movie</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>

      <form action="<%=request.getContextPath()%>/admin/movies" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" id="editId" name="movieId">

        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-8">
              <label class="form-label">Title</label>
              <input class="form-control" id="editTitle" name="title" required>
            </div>

            <div class="col-md-8">
              <label class="form-label">Genre</label>
              <input class="form-control" id="editGenre" name="genre" required>
            </div>

            <div class="col-md-4">
              <label class="form-label">Duration</label>
              <input class="form-control" id="editDuration" name="duration" type="number" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Language</label>
              <input class="form-control" id="editLanguage" name="language" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Subtitles</label>
              <input class="form-control" id="editSubtitles" name="subtitles" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Director</label>
              <input class="form-control" id="editDirector" name="director" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Cast</label>
              <input class="form-control" id="editCast" name="cast" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Status</label>
              <select class="form-select" id="editStatus" name="status" required>
                <option>Now Showing</option>
                <option>Coming Soon</option>
              </select>
            </div>

            <div class="col-md-6">
              <label class="form-label">Release Date</label>
              <input type="date" class="form-control" id="editReleaseDate" name="releaseDate" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Image Path</label>
              <input class="form-control" id="editImagePath" name="imagePath" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Trailer (YouTube ID optional)</label>
              <input class="form-control" id="editTrailer" name="trailer">
            </div>

            <div class="col-12">
              <label class="form-label">Synopsis</label>
              <textarea class="form-control" id="editSynopsis" name="synopsis" rows="4" required></textarea>
            </div>
          </div>
        </div>

        <div class="modal-footer" style="border-color: rgba(255,255,255,.10);">
          <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-accent">Save Changes</button>

          <button type="button" class="btn btn-outline-danger" onclick="openDeleteConfirm()">
            <i class="bi bi-trash"></i> Delete
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- DELETE CONFIRM MODAL -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title text-danger"><i class="bi bi-trash me-2"></i>Confirm Delete</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        Delete movie: <b id="delMovieLabel"></b> ?
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancel</button>

        <form action="<%=request.getContextPath()%>/admin/movies" method="post" class="m-0">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="movieId" id="delMovieId">
          <button type="submit" class="btn btn-outline-danger">
            <i class="bi bi-trash"></i> Delete
          </button>
        </form>
      </div>
    </div>
  </div>
</div>

          <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
          
<script>
function fillEdit(id, title, genre, duration, language, subtitles, director, cast, synopsis, status, releaseDate, imagePath, trailer){
  document.getElementById("editId").value = id || "";
  document.getElementById("editTitle").value = title || "";
  document.getElementById("editGenre").value = genre || "";
  document.getElementById("editDuration").value = duration || "";
  document.getElementById("editLanguage").value = language || "";
  document.getElementById("editSubtitles").value = subtitles || "";
  document.getElementById("editDirector").value = director || "";
  document.getElementById("editCast").value = cast || "";
  document.getElementById("editSynopsis").value = synopsis || "";
  document.getElementById("editStatus").value = status || "Now Showing";
  document.getElementById("editReleaseDate").value = releaseDate || "";
  document.getElementById("editImagePath").value = imagePath || "";
  document.getElementById("editTrailer").value = trailer || "";
}

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".btnEditMovie").forEach(btn => {
    btn.addEventListener("click", () => {
      fillEdit(
        btn.dataset.id,
        btn.dataset.title,
        btn.dataset.genre,
        btn.dataset.duration,
        btn.dataset.language,
        btn.dataset.subtitles,
        btn.dataset.director,
        btn.dataset.cast,
        btn.dataset.synopsis,
        btn.dataset.status,
        btn.dataset.releasedate,
        btn.dataset.imagepath,
        btn.dataset.trailer
      );
    });
  });
});

function deleteMovieUI(){
  const id = document.getElementById("editId").value;
  if(confirm("Delete movie #" + id + "?")){
    alert("UI only: connect to delete servlet later.");
  }
}

function toggleSection(hiddenClass, iconId){
  const hiddenItems = document.querySelectorAll("." + hiddenClass);
  if(hiddenItems.length === 0) return;

  const icon = document.getElementById(iconId);
  const isExpanded = hiddenItems[0].style.display === "block";
 
  if(isExpanded){
    hiddenItems.forEach(x => x.style.display = "none");
    if(icon) icon.className = "bi bi-chevron-down";
  }else{
    hiddenItems.forEach(x => x.style.display = "block");
    if(icon) icon.className = "bi bi-chevron-up";
  }
}

function prepareDelete(){
  const id = document.getElementById("editId").value;
  const title = document.getElementById("editTitle").value;

  document.getElementById("delMovieId").value = id || "";
  document.getElementById("delMovieLabel").innerText =
    title ? (title + " (#" + id + ")") : ("#" + id);
}

document.getElementById("deleteConfirmModal").addEventListener("show.bs.modal", function () {
  const id = document.getElementById("editId").value;
  const title = document.getElementById("editTitle").value;

  document.getElementById("delMovieId").value = id || "";
  document.getElementById("delMovieLabel").innerText =
    title ? (title + " (#" + id + ")") : ("#" + id);
});

function openDeleteConfirm(){
  prepareDelete();
  const editEl = document.getElementById("editMovieModal");
  const delEl  = document.getElementById("deleteConfirmModal");

  if(!editEl || !delEl){
    console.log("Missing modal element:", {editEl, delEl});
    return;
  }

  const editModal = bootstrap.Modal.getOrCreateInstance(editEl);

  editEl.addEventListener("hidden.bs.modal", function handler(){
    editEl.removeEventListener("hidden.bs.modal", handler);
    bootstrap.Modal.getOrCreateInstance(delEl).show();
  });

  editModal.hide();
}
</script>



</body>
</html>

 