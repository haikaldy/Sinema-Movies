<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.sinema.model.Booking" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Booking Details</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
  width:48px;
  height:48px;
  border-radius:14px;
  display:flex;
  align-items:center;
  justify-content:center;
  background: rgba(124,77,255,.08);
  border:1px solid rgba(124,77,255,.22);
  overflow:hidden;
  flex: 0 0 auto;              /* elak dia stretch */
}

.brand .logo img{
  width:100%;
  height:100%;
  object-fit: contain;          /* penting: contain supaya tak lari */
  object-position: center;      /* center betul-betul */
  display:block;
}

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
.form-control::placeholder{ color: rgba(255,255,255,.35); }
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

.modal-content{
  background:#111118;
  border:1px solid rgba(255,255,255,.12);
  color:#fff;
}
.btn-accent{
  background: linear-gradient(90deg, rgba(229,9,20,.95), rgba(124,77,255,.75));
  border:0; color:#fff;
}
.btn-accent:hover{ filter: brightness(1.05); }

.badge-soft{
  border:1px solid var(--line);
  background: rgba(0,0,0,.25);
  color:var(--muted);
  border-radius:999px;
  padding:6px 10px;
  font-size:12px;
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

  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/showtimes">
    <i class="bi bi-clock-history"></i> Showtimes
  </a>

  <a class="nav-itemx active" href="<%= request.getContextPath() %>/admin/bookings">
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
      <div class="text-secondary small">Admin / Bookings</div>
      <div class="fw-bold">Booking Details</div>
    </div>
    <div class="d-flex gap-2">
      <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/admin/admin_page.jsp">
        <i class="bi bi-house"></i> Dashboard
      </a>
    </div>
  </div>

  <div class="page-title">Booking Details</div>
  <div class="page-sub">View customer bookings and ticket information.</div>

  <!-- FILTERS -->
  <div class="cardx mb-4">
    <div class="row g-3 align-items-end">
      <div class="col-md-4">
        <label class="form-label">Search (name / email / booking id)</label>
        <input id="qSearch" class="form-control" placeholder="e.g. S001 or user@gmail.com">
      </div>
      <div class="col-md-3">
        <label class="form-label">Date</label>
        <input id="qDate" type="date" class="form-control">
      </div>
      <div class="col-md-3">
        <label class="form-label">Status</label>
        <select id="qStatus" class="form-select">
          <option value="all" selected>All</option>
          <option value="paid">Paid</option>
          <option value="pending">Pending</option>
          <option value="cancelled">Cancelled</option>
        </select>
      </div>
      <div class="col-md-2 d-grid">
        <button class="btn btn-accent" type="button" onclick="applyFilter()">
          <i class="bi bi-funnel"></i> Filter
        </button>
      </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap gap-2">
      <button class="btn btn-outline-light btn-sm" type="button" onclick="resetFilter()">
        <i class="bi bi-arrow-counterclockwise"></i> Reset
      </button>
    </div>
  </div>

  <!-- BOOKINGS TABLE -->
  <div class="cardx">
    <div class="d-flex align-items-center justify-content-between mb-2">
      <h5 class="mb-0"><i class="bi bi-table me-2"></i>Booking List</h5>
      <span class="badge text-bg-secondary" id="countBadge">0</span>
    </div>
    <hr style="border-color: rgba(255,255,255,.10)">

    <div class="table-responsive">
      <table class="table align-middle">
        <thead>
          <tr>
            <th style="width:110px;">Booking ID</th>
            <th>Customer</th>
            <th>Movie</th>
            <th style="width:130px;">Show Date</th>
            <th style="width:100px;">Time</th>
            <th style="width:110px;">Seats</th>
            <th style="width:110px;">Total</th>
            <th style="width:120px;">Status</th>
            <th style="width:140px;" class="text-end">Action</th>
          </tr>
        </thead>

        <tbody id="bookingBody">
            <%
              List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
            %>

            <% if(bookings != null && !bookings.isEmpty()) {
                 for(Booking b : bookings) {

                   String seatsSafe = (b.getSeatNumbers() == null) ? "" : b.getSeatNumbers();
                   String seatsJs = seatsSafe.replace("\\", "\\\\").replace("'", "\\'");
            %>

            <tr
              data-id="<%= b.getBookingId() %>"
              data-name="<%= b.getCustomerName() %>"
              data-email="<%= b.getCustomerEmail() %>"
              data-date="<%= b.getShowDate() %>"
              data-status="<%= b.getStatus() %>"
            >
              <td><%= b.getBookingId() %></td>

              <td>
                <div><%= b.getCustomerName() %></div>
                <div class="text-secondary small"><%= b.getCustomerEmail() %></div>
              </td>

              <td><%= b.getMovieTitle() %></td>
              <td><%= b.getShowDate() %></td>
              <td><%= b.getShowTime().toString().substring(0,5) %></td>

              <!-- use safe seats, not b.getSeatNumbers() -->
              <td><%= seatsSafe %></td>

              <td>RM <%= String.format("%.2f", b.getTotalPrice()) %></td>
              <td><%= b.getStatus() %></td>

              <td class="text-end">
                <button type="button"
                        class="btn btn-sm btn-outline-light view-booking-btn"
                        data-bs-toggle="modal"
                        data-bs-target="#viewBookingModal"

                        data-id="<%= b.getBookingId() %>"
                        data-name="<%= b.getCustomerName() %>"
                        data-email="<%= b.getCustomerEmail() %>"
                        data-movie="<%= b.getMovieTitle() %>"
                        data-date="<%= b.getShowDate() %>"
                        data-time="<%= b.getShowTime().toString().substring(0,5) %>"
                        data-seats="<%= b.getSeatNumbers() %>"
                        data-total="<%= String.format("%.2f", b.getTotalAmount()) %>"
                        data-status="<%= b.getStatus() %>">

                    <i class="bi bi-eye"></i> View
                </button>
              </td>
            </tr>

            <%   }
               } else { %>
            <tr><td colspan="9" class="text-secondary">No bookings found.</td></tr>
            <% } %>
            </tbody>

      </table>
    </div>

  </div>

</div>

<!-- VIEW BOOKING MODAL -->
<div class="modal fade" id="viewBookingModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header" style="border-color: rgba(255,255,255,.10);">
        <h5 class="modal-title"><i class="bi bi-receipt me-2"></i>Booking Details</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <div class="mb-2"><span class="text-secondary">Booking ID:</span> <strong id="vId"></strong></div>
        <div class="mb-2">
          <span class="text-secondary">Customer:</span> <strong id="vName"></strong>
          <div class="text-secondary small" id="vEmail"></div>
        </div>
        <hr style="border-color: rgba(255,255,255,.10)">

        <div class="mb-2"><span class="text-secondary">Movie:</span> <strong id="vMovie"></strong></div>
        <div class="mb-2"><span class="text-secondary">Showtime:</span> <strong id="vDate"></strong> <span class="text-secondary">at</span> <strong id="vTime"></strong></div>
        <div class="mb-2"><span class="text-secondary">Seats:</span> <strong id="vSeats"></strong></div>
        <div class="mb-2"><span class="text-secondary">Total:</span> <strong>RM <span id="vTotal"></span></strong></div>
        <div class="mb-2"><span class="text-secondary">Status:</span> <strong id="vStatus"></strong></div>
      </div>
            
      <div class="modal-footer" style="border-color: rgba(255,255,255,.10);">
        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.querySelectorAll('.view-booking-btn').forEach(button => {
    button.addEventListener('click', function () {

        document.getElementById('vId').textContent = this.dataset.id;
        document.getElementById('vName').textContent = this.dataset.name;
        document.getElementById('vEmail').textContent = this.dataset.email;
        document.getElementById('vMovie').textContent = this.dataset.movie;
        document.getElementById('vDate').textContent = this.dataset.date;
        document.getElementById('vTime').textContent = this.dataset.time;
        document.getElementById('vSeats').textContent = this.dataset.seats;
        document.getElementById('vTotal').textContent = this.dataset.total;
        document.getElementById('vStatus').textContent = this.dataset.status;
    });
});

/* ===== FILTER LOGIC (UI only) ===== */
const qSearch = document.getElementById("qSearch");
const qDate = document.getElementById("qDate");
const qStatus = document.getElementById("qStatus");
const countBadge = document.getElementById("countBadge");

function normalize(s){ return (s || "").toString().trim().toLowerCase(); }

function applyFilter(){
  const s = normalize(qSearch.value);
  const d = qDate.value; // YYYY-MM-DD
  const st = normalize(qStatus.value);

  const rows = document.querySelectorAll("#bookingBody tr");
  let shown = 0;

  rows.forEach(r => {
    const id = normalize(r.dataset.id);
    const name = normalize(r.dataset.name);
    const email = normalize(r.dataset.email);
    const date = (r.dataset.date || "");
    const status = normalize(r.dataset.status);

    const matchSearch = !s || id.includes(s) || name.includes(s) || email.includes(s);
    const matchDate = !d || date === d;
    const matchStatus = (st === "all") || (status === st);

    const ok = matchSearch && matchDate && matchStatus;
    r.style.display = ok ? "" : "none";
    if(ok) shown++;
  });

  countBadge.textContent = shown + " shown";
}

function resetFilter(){
  qSearch.value = "";
  qDate.value = "";
  qStatus.value = "all";
  applyFilter();
}

/* auto filter bila type / change */
qSearch.addEventListener("input", applyFilter);
qDate.addEventListener("change", applyFilter);
qStatus.addEventListener("change", applyFilter);

window.addEventListener("load", applyFilter);
</script>

</body>
</html>
