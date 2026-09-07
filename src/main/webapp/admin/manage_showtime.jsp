<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.sinema.model.Movie" %>
<%@ page import="com.mycompany.sinema.model.Showtime" %>

<%
  List<Movie> movies = (List<Movie>) request.getAttribute("movies");
  List<Showtime> showtimes = (List<Showtime>) request.getAttribute("showtimes");

  // for showing movie title in showtimes table
     Map<Integer, Movie> movieMap = new HashMap<>();
  if (movies != null) {
    for (Movie m : movies) {
      movieMap.put(m.getMovieId(), m);
    }
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Manage Showtimes</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<%
  String flashError = (String) session.getAttribute("flashError");
  if (flashError != null) {
    session.removeAttribute("flashError");
%>
  <div class="alert alert-danger">
    <%= flashError %>
  </div>
<%
  }
%>
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

.sidebar{
  width:270px; min-height:100vh;
  position:fixed; left:0; top:0;
  background: linear-gradient(180deg, rgba(255,255,255,.03), transparent 40%), var(--panel);
  border-right:1px solid var(--line);
  padding:22px 16px;
}
.content{ margin-left:270px; padding:26px 26px 46px; }

.brand{
  display:flex; align-items:center; gap:10px;
  padding:10px 10px 18px; border-bottom:1px solid var(--line);
  margin-bottom:16px;
}
.brand .logo{
  width:48px; height:48px; border-radius:14px;
  display:flex; align-items:center; justify-content:center;
  background: rgba(124,77,255,.08);
  border:1px solid rgba(124,77,255,.22);
  overflow:hidden;
}
.brand .logo img{ width:100%; height:100%; object-fit:cover; display:block; }
.brand .title{ font-weight:900; letter-spacing:1px; margin:0; }
.brand small{ color:var(--muted); font-size:12px; display:block; margin-top:-2px; }


.nav-itemx{
  display:flex; align-items:center; gap:10px;
  padding:12px 12px; border-radius:12px;
  color:#ddd; margin-bottom:8px;
  transition:.2s ease; border:1px solid transparent;
}
.nav-itemx i{ font-size:18px; }
.nav-itemx:hover{ background: rgba(229,9,20,.10); border-color: rgba(229,9,20,.25); color:#fff; }
.nav-itemx.active{
  background: linear-gradient(90deg, rgba(229,9,20,.25), rgba(124,77,255,.15));
  border-color: rgba(229,9,20,.35); color:#fff;
  box-shadow: 0 10px 25px rgba(0,0,0,.35);
}
.sidebar .bottom{
  position:absolute; left:16px; right:16px; bottom:16px;
  padding-top:12px; border-top:1px solid var(--line);
}

.topbar{
  display:flex; align-items:center; justify-content:space-between;
  gap:12px; padding:14px 16px;
  border:1px solid var(--line);
  background: rgba(0,0,0,.35);
  border-radius:16px;
  backdrop-filter: blur(10px);
}
.page-title{ font-size:34px; font-weight:900; margin:18px 0 6px; }
.page-sub{ color:var(--muted); margin-bottom:18px; }

.cardx{
  background: rgba(255,255,255,.03);
  border:1px solid var(--line);
  border-radius:18px;
  padding:18px;
}
.form-control, .form-select{
  background: rgba(255,255,255,.04) !important;
  border:1px solid var(--line) !important;
  color: var(--text) !important;
}
.form-control:focus, .form-select:focus{
  border-color: rgba(229,9,20,.35) !important;
  box-shadow: 0 0 0 .2rem rgba(229,9,20,.12) !important;
}
.table{
  --bs-table-bg: transparent;
  --bs-table-color: var(--text);
}
.table thead th{ border-bottom:1px solid var(--line); color:#fff; }
.table td, .table th{ border-top:1px solid var(--line); }

.btn-accent{
  background: linear-gradient(90deg, rgba(229,9,20,.95), rgba(124,77,255,.75));
  border:0; color:#fff;
}
.btn-accent:hover{ filter: brightness(1.05); }

.modal-content{
  background:#111118;
  border:1px solid rgba(255,255,255,.12);
  color:#fff;
}

@media(max-width:992px){
  .sidebar{ position:relative; width:100%; min-height:auto; }
  .content{ margin-left:0; }
  .sidebar .bottom{ position:static; margin-top:14px; }
}
</style>
</head>

<body>

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

  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/movies">
    <i class="bi bi-camera-reels"></i> Movies
  </a>

  <a class="nav-itemx active" href="<%= request.getContextPath() %>/admin/showtimes">
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

<div class="content">

  <div class="topbar">
    <div>
      <div class="text-secondary small">Admin / Showtimes</div>
      <div class="fw-bold">Manage Showtimes</div>
    </div>
    <div class="d-flex gap-2">
      <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/admin/admin_page.jsp">
        <i class="bi bi-house"></i> Dashboard
      </a>
    </div>
  </div>

  <div class="page-title">Manage Showtimes</div>
  <div class="page-sub">Edit / delete showtime.</div>

  <!-- Movie List -->
    <div class="cardx p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <h4 class="m-0">Movie List</h4>
          <div class="text-secondary small">Click “Manage Showtimes” to add multiple showtimes</div>
        </div>

        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
        <tr>
          <th style="width:90px;">Movie ID</th>
          <th>Title</th>
          <th style="width:180px;">Genre</th>
          <th style="width:120px;">Duration</th>
          <th style="width:150px;">Status</th>
          <th class="text-end" style="width:200px;">Actions</th>
        </tr>
        </thead>

        <tbody>
        <%
          if(movies != null && !movies.isEmpty()){
            for(Movie m : movies){
        %>
          <tr>
            <td>#<%= m.getMovieId() %></td>
            <td><%= m.getTitle() %></td>
            <td><%= m.getGenre() %></td>
            <td><%= m.getDurationMinutes() %> mins</td>
            <td><%= m.getStatus() %></td>
            <td class="text-end">
              <button type="button"
                    class="btn btn-sm btn-outline-light js-manage-showtimes"
                    data-movie-id="<%= m.getMovieId() %>"
                    data-movie-title="<%= m.getTitle()
                        .replace("&","&amp;")
                        .replace("\"","&quot;")
                        .replace("<","&lt;")
                        .replace(">","&gt;")
                    %>">

              <i class="bi bi-plus-circle"></i> Manage Showtimes
            </button>
            </td>
          </tr>
        <%
            }
          } else {
        %>
          <tr><td colspan="6" class="text-secondary">No movies found.</td></tr>
        <% } %>
        </tbody>
          </table>
        </div>
      </div>
            
    
     <!-- Showtime List -->
     <div class="cardx p-4 mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h4 class="m-0">Showtime List</h4>
    </div>

    <div class="table-responsive">
      <table class="table align-middle">
        <thead>
          <tr>
            <th style="width:110px;">Showtime ID</th>
            <th>Movie</th>
            <th style="width:140px;">Date</th>
            <th style="width:120px;">Time</th>
            <th style="width:110px;">Hall</th>
            <th style="width:110px;">Price</th>
            <th class="text-end" style="width:170px;">Actions</th>
          </tr>
        </thead>
        <tbody>
        <%
  if(showtimes != null && !showtimes.isEmpty()){
    for(Showtime st : showtimes){
      Movie mv = movieMap.get(st.getMovieId());
      String title = (mv != null) ? mv.getTitle() : ("Movie #" + st.getMovieId());
%>
<tr>
  <td>#<%= st.getShowtimeId() %></td>
  <td><%= title %></td>
  <td><%= st.getShowDate() %></td>
  <td><%= st.getShowTime().toString().substring(0,5) %></td>
  <td><%= st.getHall() %></td>
  <td>RM <%= String.format("%.2f", st.getPrice()) %></td>

  <td class="text-end">
                <%
          String safeTitle = (title == null ? "" : title)
              .replace("&","&amp;").replace("\"","&quot;")
              .replace("<","&lt;").replace(">","&gt;")
              .replace("'","&#39;");

          String hallSafe = (st.getHall() == null || st.getHall().trim().isEmpty())
              ? "Hall 1"
              : st.getHall();

          hallSafe = hallSafe.replace("&","&amp;").replace("\"","&quot;")
              .replace("<","&lt;").replace(">","&gt;")
              .replace("'","&#39;");
        %>

        <button type="button"
          class="btn btn-sm btn-outline-light js-edit-showtime"
          data-showtime-id="<%= st.getShowtimeId() %>"
          data-movie-id="<%= st.getMovieId() %>"
          data-movie-title="<%= safeTitle %>"
          data-date="<%= st.getShowDate() %>"
          data-time="<%= st.getShowTime().toString().substring(0,5) %>"
          data-price="<%= st.getPrice() %>"
          data-hall="<%= hallSafe %>">
          <i class="bi bi-pencil-square"></i> Edit
        </button>


      <button type="button"
              class="btn btn-sm btn-outline-danger js-delete-showtime"
              data-showtime-id="<%= st.getShowtimeId() %>">
        <i class="bi bi-trash"></i> Delete
      </button>

  </td>
</tr>
<%
    }
  } else {
%>
<tr><td colspan="7" class="text-secondary">No showtimes yet.</td></tr>
<% } %>
        </tbody>
      </table>
    </div>
  </div>


</div>

<!-- EDIT SHOWTIME MODAL -->
<div class="modal fade" id="manageShowtimeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header" style="border-color: rgba(255,255,255,.10);">
        <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Edit / Add Showtimes</h5>
        <button type="button" class="btn-close btn-close-white"
            data-bs-dismiss="modal" onclick="hideModal('manageShowtimeModal')"></button>
      </div>

      <form action="<%=request.getContextPath()%>/admin/showtimes" method="post">
        <div class="modal-body">

        <!-- Selected Movie-->
        <input type="hidden" name="movieId" id="modalMovieId">

        <div class="mb-3">
          <label class="form-label">Movie</label>
          <input class="form-control" id="modalMovieTitle" readonly>
        </div>

        <hr style="border-color: rgba(255,255,255,.10); margin: 14px 0;">

        <!-- Slots section -->
        <div class="d-flex justify-content-between align-items-center mb-2">
          <label class="fw-bold text-light">
            <i class="bi bi-plus-circle me-1"></i> Showtime Slots
          </label>

          <button type="button" class="btn btn-sm btn-outline-success" onclick="addSlot()">
            + Add Time
          </button>
        </div>

        <!-- container for all slots -->
        <div id="slotsContainer"></div>

        <div class="text-secondary small mt-2">
          Tip: You can add multiple slots, then click “Save Changes” once.
        </div>

      </div>

        <div class="modal-footer" style="border-color: rgba(255,255,255,.10);">
          <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-accent" name="action" value="update_multi">Save Changes</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- DELETE SHOWTIME MODAL (LIKE DELETE MOVIE POPUP) -->
<div class="modal fade" id="deleteShowtimeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header" style="border-color: rgba(255,255,255,.10);">
        <h5 class="modal-title">
          <i class="bi bi-exclamation-triangle-fill text-warning me-2"></i> Confirm Delete
        </h5>
        <button type="button" class="btn-close btn-close-white"
        data-bs-dismiss="modal" onclick="hideModal('deleteShowtimeModal')"></button>
      </div>

      <div class="modal-body">
        Are you sure you want to delete this showtime?
        <div class="mt-2 text-secondary small">
          Showtime ID: <span class="text-light fw-semibold" id="deleteShowtimeIdText">-</span>
        </div>
      </div>

      <div class="modal-footer" style="border-color: rgba(255,255,255,.10);">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal"
            onclick="hideModal('deleteShowtimeModal')">Cancel</button>


        <!-- DELETE ACTION (GET) -->
        <form action="<%=request.getContextPath()%>/admin/showtimes" method="post" class="m-0">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="showtimeId" id="deleteShowtimeId">
            <button type="submit" class="btn btn-danger">
             <i class="bi bi-trash me-1"></i> Yes, Delete
            </button>
          </form>

      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
console.log("✅ manage_showtime.jsp script loaded");

// cleanup stuck bootstrap overlay
document.querySelectorAll(".modal-backdrop").forEach(b => b.remove());
document.body.classList.remove("modal-open");
document.body.style.removeProperty("padding-right");

function showModalById(id){
  const el = document.getElementById(id);
  if (!el) {
    console.log("❌ Modal element not found:", id);
    return;
  }
  if (window.bootstrap && bootstrap.Modal) {
    bootstrap.Modal.getOrCreateInstance(el).show();
  } else {
    // fallback
    el.classList.add("show");
    el.style.display = "block";
    el.removeAttribute("aria-hidden");
  }
}

window.fillShowtimeEdit = function(showtimeId, movieId, movieTitle, showDate, showTime, price, hall){
  document.getElementById("modalMovieId").value = movieId;
  document.getElementById("modalMovieTitle").value = movieTitle || ("Movie #" + movieId);

  document.getElementById("slotsContainer").innerHTML = "";

  addSlot({
    id: showtimeId,
    date: showDate,
    time: showTime,
    hall: hall || "Hall 1",
    price: price
  });
};

// attach AFTER DOM ready (very important)
window.addEventListener("DOMContentLoaded", () => {
  console.log("✅ DOMContentLoaded, attaching click handler");

  // CAPTURE mode so we bypass stopPropagation from other scripts
  document.addEventListener("click", (e) => {
    // proof (you should see this on ANY click)
    console.log("CLICK TARGET:", e.target);

    const manageBtn = e.target.closest(".js-manage-showtimes");
    if (manageBtn) {
      console.log("✅ Manage clicked:", manageBtn.dataset);

      const movieId = manageBtn.dataset.movieId;
      const title = manageBtn.dataset.movieTitle || ("Movie #" + movieId);

      const movieIdEl = document.getElementById("modalMovieId");
      const titleEl   = document.getElementById("modalMovieTitle");
      const slotsEl   = document.getElementById("slotsContainer");

      if (!movieIdEl || !titleEl || !slotsEl) {
        console.log("❌ Modal inputs not found in DOM");
        return;
      }

      movieIdEl.value = movieId;
      titleEl.value = title;

      // clear + add one row (simple)
      slotsEl.innerHTML = "";
      slotsEl.insertAdjacentHTML("beforeend", `
        <div class="row g-2 align-items-end mt-2">
          <input type="hidden" name="slotId" value="">
          <div class="col-4">
            <label class="small text-light mb-1">Date</label>
            <input type="date" class="form-control form-control-sm" name="slotDate" required>
          </div>
          <div class="col-3">
            <label class="small text-light mb-1">Time</label>
            <input type="time" class="form-control form-control-sm" name="slotTime" required>
          </div>
          <div class="col-2">
            <label class="small text-light mb-1">Hall</label>
            <input type="text" class="form-control form-control-sm" name="slotHall" value="Hall 1" required>
          </div>
          <div class="col-2">
            <label class="small text-light mb-1">Price</label>
            <input type="number" class="form-control form-control-sm" name="slotPrice" step="0.01" min="0" required>
          </div>
          <div class="col-1">
            <button type="button" class="btn btn-sm btn-outline-danger w-100" onclick="this.closest('.row').remove()">
              <i class="bi bi-trash"></i>
            </button>
          </div>
        </div>
      `);

      showModalById("manageShowtimeModal");
      e.preventDefault();
      return;
    }

    const delBtn = e.target.closest(".js-delete-showtime");
    if (delBtn) {
      console.log("✅ Delete clicked:", delBtn.dataset);
      document.getElementById("deleteShowtimeIdText").textContent = delBtn.dataset.showtimeId;
      document.getElementById("deleteShowtimeId").value = delBtn.dataset.showtimeId;
      showModalById("deleteShowtimeModal");
      e.preventDefault();
      return;
    }

    const editBtn = e.target.closest(".js-edit-showtime");
    if (editBtn) {
      console.log("✅ Edit clicked:", editBtn.dataset);
      // (we can re-add full edit-fill later once clicking works)
      showModalById("manageShowtimeModal");
      e.preventDefault();
      return;
    }

  }, true);
});
</script>



</body>
</html>