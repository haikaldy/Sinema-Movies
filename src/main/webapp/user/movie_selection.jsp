<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="com.mycompany.sinema.model.Showtime"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // ====== Read movie attributes from CONTROLLER (match EXACT names you set) ======
    Integer movieId = (Integer) request.getAttribute("movie_id");

    String movieTitle = (String) request.getAttribute("title");               // ✅ controller uses "tile"
    String genre      = (String) request.getAttribute("genre");
    Integer durMin    = (Integer) request.getAttribute("duration_minutes");   // ✅ controller uses "duration_minues"
    String language   = (String) request.getAttribute("language");
    String posterDb   = (String) request.getAttribute("image_path");         // ✅ controller uses "image_path"
    String trailerId  = (String) request.getAttribute("yt_trailer");         // ✅ controller uses "yt_trailer"

String trailerEmbedId = "";
if (trailerId != null) {
    String t = trailerId.trim();

    // if full URL -> extract v=
    int vIdx = t.indexOf("v=");
    if (vIdx != -1) {
        trailerEmbedId = t.substring(vIdx + 2);
        int amp = trailerEmbedId.indexOf("&");
        if (amp != -1) trailerEmbedId = trailerEmbedId.substring(0, amp);
    }
    // if youtu.be/ID
    else if (t.contains("youtu.be/")) {
        trailerEmbedId = t.substring(t.indexOf("youtu.be/") + 9);
        int q = trailerEmbedId.indexOf("?");
        if (q != -1) trailerEmbedId = trailerEmbedId.substring(0, q);
    }
    // if already ID
    else {
        trailerEmbedId = t;
    }
}


    // ====== Duration format ======
    String duration = "2 hr 15 mins";
    if (durMin != null) {
        int mins = durMin;
        int h = mins / 60;
        int m = mins % 60;
        duration = (h > 0 ? (h + " hr ") : "") + (m > 0 ? (m + " mins") : (h > 0 ? "" : "0 mins"));
    }

    // ====== Poster path normalize ======
    // Your DB likely stores "xxx.jpg" so convert to /images/xxx.jpg
    String posterPath = "/images/default.jpg";
    if (posterDb != null && !posterDb.isBlank()) {
        String p = posterDb.replace("..", "");
        if (p.startsWith("/")) posterPath = p;
        else posterPath = "/images/" + p;
    }

    // ====== Default fallback ======
    if (movieTitle == null) movieTitle = "Movie";
    if (genre == null) genre = "Genre";
    if (language == null) language = "English";

    // ====== Get showtimes list ======
    List<Showtime> showtimes = (List<Showtime>) request.getAttribute("showtimes");

    // Build map dateKey -> showtime list
    SimpleDateFormat dateKeyFmt = new SimpleDateFormat("dd MMM yyyy");
    SimpleDateFormat dayFmt = new SimpleDateFormat("EEE");
    SimpleDateFormat ddMMM = new SimpleDateFormat("dd MMM");
    SimpleDateFormat timeFmt = new SimpleDateFormat("hh:mm a");

    Map<String, List<Showtime>> byDate = new LinkedHashMap<>();
    if (showtimes != null) {
        for (Showtime st : showtimes) {
            String key = dateKeyFmt.format(st.getShowDate());
            byDate.computeIfAbsent(key, k -> new ArrayList<>()).add(st);
        }
    }

    // First date tab
    String firstDateKey = null;
    if (!byDate.isEmpty()) firstDateKey = byDate.keySet().iterator().next();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%=movieTitle%> | Sinema Movies</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { background-color:#121212; color:#fff; font-family:'Segoe UI',sans-serif; }

        /* HERO */
        .hero-section { position:relative; width:100%; height:70vh; }
        .hero-overlay {
            position:absolute; inset:0;
            background: linear-gradient(to bottom, rgba(0,0,0,0.1) 0%, #121212 100%);
        }
        .movie-info-container { position:absolute; bottom:20px; left:0; width:100%; padding:0 5%; z-index:2; }
        .movie-title { font-size:3.5rem; font-weight:800; text-transform:uppercase; margin-bottom:10px; }
        .rating-badge { background:#ffc107; color:#000; font-weight:bold; padding:2px 8px; border-radius:4px; }

        .back-btn {
            position:absolute; top:30px; left:30px; z-index:10;
            color:#fff; text-decoration:none; font-size:1.2rem;
            text-shadow:0 2px 4px rgba(0,0,0,0.8);
        }
/* Buttons */
        .btn-red, .btn-outline-custom {
            height:50px; padding:0 30px; border-radius:50px;
            font-weight:800; font-size:1rem; text-decoration:none;
            display:inline-flex; align-items:center; justify-content:center;
            vertical-align:middle; transition:all 0.3s ease;
        }
        .btn-red {
            background:#eb3349; color:#fff; border:2px solid #eb3349;
            box-shadow:0 4px 15px rgba(235,51,73,0.3); margin-right:15px;
        }
        .btn-red:hover {
            background:#ff3f56; border-color:#ff3f56;
            transform:translateY(-3px); box-shadow:0 0 20px rgba(235,51,73,0.6);
            padding-right:25px;
        }
        .btn-red i { max-width:0; opacity:0; margin-left:0; overflow:hidden; transition:all 0.3s ease; }
        .btn-red:hover i { max-width:20px; opacity:1; margin-left:10px; }

        .btn-outline-custom { background:transparent; color:#fff; border:2px solid #fff; }
        .btn-outline-custom:hover { background:#fff; color:#000; transform:translateY(-3px); }

        /* Date tabs */
        .date-item { cursor:pointer; transition:all 0.3s ease; }
        .date-item:hover { color:#fff !important; }

        /* Showtime button */
        .time-btn {
            background:#3b3b3b; color:#2ecc71; border:none;
            border-radius:0px 20px 20px 20px;
            padding:15px 30px; font-weight:900; font-size:1.2rem;
            margin-right:15px; margin-bottom:15px;
            transition:all 0.3s cubic-bezier(0.25,0.8,0.25,1);
            box-shadow:0 4px 6px rgba(0,0,0,0.3);
            min-width:130px;
        }
        .time-btn:hover { background:#555; transform:translateY(-3px); }
        .time-btn.active { background:#fff; color:#2ecc71; box-shadow:0 0 20px rgba(255,255,255,0.1); }
    </style>
</head>

<body>

<a href="<%=request.getContextPath()%>/user_page" class="back-btn">
    <i class="fas fa-chevron-left"></i> Back
</a>

<div class="hero-section"
     style="background:url('<%=request.getContextPath()%><%=posterPath%>') no-repeat center center/cover;">
    <div class="hero-overlay"></div>

    <div class="movie-info-container">
        <div class="movie-title"><%=movieTitle%></div>

        <div class="d-flex align-items-center gap-3 mb-4 text-light">
            <span class="rating-badge">PG</span>
            <span><%=genre%></span>
            <span>|</span>
            <span><%=duration%></span>
            <span>|</span>
            <span><%=language%></span>
        </div>

        <div class="mb-5">
        <button type="button" class="btn-red" data-bs-toggle="modal" data-bs-target="#infoModal">
            MORE INFO <i class="fas fa-arrow-right"></i>
        </button>


            <button type="button" class="btn btn-outline-custom"
                    data-bs-toggle="modal" data-bs-target="#trailerModal">
                Watch Trailer
            </button>
        </div>

        <!-- Date Tabs -->
        <%
            if (byDate.isEmpty()) {
        %>
            <div class="text-secondary">No showtimes available for this movie.</div>
        <%
            } else {
                boolean firstTab = true;
        %>
        <div class="d-flex border-bottom border-secondary pb-0">
            <%
                for (Map.Entry<String, List<Showtime>> entry : byDate.entrySet()) {
                    String dateKey = entry.getKey();
                    Showtime sample = entry.getValue().get(0);
            %>
            <div class="date-item px-4 pb-2 text-center <%= firstTab ? "border-bottom border-danger border-3 fw-bold text-white" : "text-secondary" %>"
                 onclick="selectDate(this)"
                 data-date="<%= dateKey %>">
                <%= dayFmt.format(sample.getShowDate()) %><br>
                <span style="font-size:1.2rem"><%= ddMMM.format(sample.getShowDate()) %></span>
            </div>
            <%
                    firstTab = false;
                }
            %>
        </div>
        <%
            }
        %>

    </div>
</div>
<div class="container-fluid p-5">
    <h4 class="text-white mb-4">Available Showtimes</h4>

    <%
        if (!byDate.isEmpty()) {
            boolean firstGroup = true;
            for (Map.Entry<String, List<Showtime>> entry : byDate.entrySet()) {
                String dateKey = entry.getKey();
                List<Showtime> list = entry.getValue();
                String hall = (list.get(0).getHall() != null) ? list.get(0).getHall() : "Hall";

                String displayStyle = firstGroup ? "block" : "none"; // ✅ avoids red in IDE
    %>

    <div class="showtime-group" data-date="<%=dateKey%>" style="display:<%=displayStyle%>;">
        <p class="text-white mb-4"><i class="fas fa-film"></i> <%= hall %></p>

        <div class="mb-4">
            <%
                for (Showtime st : list) {
                    String t = timeFmt.format(st.getShowTime());
            %>
            <button class="btn time-btn"
                    onclick="selectTime(this)"
                    data-showtime="<%= st.getShowtimeId() %>"
                    data-time="<%= t %>"
                    data-date="<%= dateKey %>">
                <%= t %>
            </button>
            <%
                }
            %>
        </div>
    </div>

    <%
                firstGroup = false;
            }
        }
    %>
</div>

<!-- Trailer Modal -->
<div class="modal fade" id="trailerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content bg-black">
            <div class="modal-header border-0">
                <button type="button" class="btn-close btn-close-white"
                        data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0">
                <div class="ratio ratio-16x9">
                    <iframe id="trailerVideo"
                            src="https://www.youtube.com/embed/<%= trailerEmbedId %>?enablejsapi=1"
                            title="YouTube video" allowfullscreen></iframe>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function selectDate(el) {
        document.querySelectorAll('.date-item').forEach(d => {
            d.classList.remove('border-bottom','border-danger','border-3','fw-bold','text-white');
            d.classList.add('text-secondary');
        });

        el.classList.remove('text-secondary');
        el.classList.add('border-bottom','border-danger','border-3','fw-bold','text-white');

        const selected = el.getAttribute('data-date');
        document.querySelectorAll('.showtime-group').forEach(g => {
            g.style.display = (g.getAttribute('data-date') === selected) ? 'block' : 'none';
        });

        document.querySelectorAll('.time-btn').forEach(btn => btn.classList.remove('active'));
    }

    function selectTime(btn) {
        document.querySelectorAll('.time-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        const showtimeId = btn.getAttribute('data-showtime');
        const dateKey = btn.getAttribute('data-date');
        const timeTxt = btn.getAttribute('data-time');

        const params = new URLSearchParams();
        params.set('showtime_id', showtimeId);
        params.set('date', dateKey);
        params.set('time', timeTxt);

        window.location.href = '<%=request.getContextPath()%>/SeatSelectionController?' + params.toString();
    }

    const trailerModal = document.getElementById('trailerModal');
    if (trailerModal) {
        trailerModal.addEventListener('hidden.bs.modal', function () {
            const iframe = document.getElementById('trailerVideo');
            iframe.src = iframe.src;
        });
    }
</script>

<!-- Movie Info Modal -->
<div class="modal fade" id="infoModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content" style="background:#111118;color:#fff;border:1px solid rgba(255,255,255,.12);border-radius:16px;">
      
      <div class="modal-header border-0">
        <h5 class="modal-title fw-bold">Movie Details</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      
      <div class="modal-body">
        <div class="row g-4">
          
          <!-- Poster -->
          <div class="col-md-4">
            <img src="<%=request.getContextPath()%><%=posterPath%>" 
                 class="img-fluid rounded" 
                 style="box-shadow:0 8px 25px rgba(0,0,0,.6);" 
                 alt="Poster">
          </div>

          <!-- Info -->
          <div class="col-md-8">
            <h3 class="fw-bold mb-2"><%=movieTitle%></h3>

            <div class="mb-3 text-secondary">
              <span class="badge bg-warning text-dark me-2">PG</span>
              <span class="me-2"><%=genre%></span>
              <span class="me-2">|</span>
              <span class="me-2"><%=duration%></span>
              <span class="me-2">|</span>
              <span><%=language%></span>
            </div>

            <%
              String director = (String) request.getAttribute("director");
              String cast = (String) request.getAttribute("cast");
              String subtitle = (String) request.getAttribute("subtitle");
              String synopsis = (String) request.getAttribute("synopsis");
              if (director == null) director = "-";
              if (cast == null) cast = "-";
              if (subtitle == null) subtitle = "-";
              if (synopsis == null) synopsis = "No synopsis available.";
            %>

            <p class="mb-2"><b>Director:</b> <%=director%></p>
            <p class="mb-2"><b>Cast:</b> <%=cast%></p>
            <p class="mb-2"><b>Subtitle:</b> <%=subtitle%></p>

            <hr style="border-color: rgba(255,255,255,.12);">

            <p class="text-light" style="line-height:1.6;">
              <%=synopsis%>
            </p>

            <div class="mt-4 d-flex gap-2">
              <button class="btn btn-outline-light" data-bs-dismiss="modal">Close</button>

              <!-- Optional: open trailer modal from here -->
              <button class="btn btn-danger" data-bs-dismiss="modal"
                      data-bs-toggle="modal" data-bs-target="#trailerModal">
                Watch Trailer
              </button>
            </div>
          </div>

        </div>
      </div>

    </div>
  </div>
</div>

</body>
</html>