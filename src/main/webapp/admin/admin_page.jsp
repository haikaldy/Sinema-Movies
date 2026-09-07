<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sinema.model.DashboardStats" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>sinema Admin Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

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
    radial-gradient(900px 450px at 20% 15%, rgba(229,9,20,.22), transparent 60%),
    radial-gradient(900px 450px at 85% 25%, rgba(124,77,255,.18), transparent 60%),
    linear-gradient(180deg, #08080b, var(--bg));
  color:var(--text);
  overflow-x:hidden;
}
a{ text-decoration:none; }

/* ===== SIDEBAR ===== */
.sidebar{
  width:270px;
  min-height:100vh;
  position:fixed;
  left:0; top:0;
  background: linear-gradient(180deg, rgba(255,255,255,.03), transparent 40%), var(--panel);
  border-right:1px solid var(--line);
  padding:22px 16px;
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
.brand .title{
  font-weight:900;
  letter-spacing:1px;
  margin:0;
}
.brand small{
  color:var(--muted);
  display:block;
  margin-top:-2px;
  font-size:12px;
}

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

/* ===== CONTENT ===== */
.content{
  margin-left:270px;
  padding:26px 26px 46px;
}

/* ===== TOPBAR (simple: no search, no avatar) ===== */
.topbar{
  display:flex;
  align-items:center;
  justify-content:flex-start;
  gap:12px;
  padding:14px 16px;
  border:1px solid var(--line);
  background: rgba(0,0,0,.35);
  border-radius:16px;
  backdrop-filter: blur(10px);
}

/* ===== HEADINGS ===== */
.h-title{
  font-size:42px;
  font-weight:900;
  margin:18px 0 6px;
}
.h-sub{
  color:var(--muted);
  margin-bottom:18px;
}

/* ===== STAT CARDS ===== */
.stat{
  border:1px solid var(--line);
  background: rgba(255,255,255,.03);
  border-radius:18px;
  padding:18px;
  height:100%;
  position:relative;
  overflow:hidden;
  transition:.2s ease;
  color:var(--text);
}
.stat:before{
  content:"";
  position:absolute;
  width:180px; height:180px;
  left:-70px; top:-80px;
  background: radial-gradient(circle, rgba(229,9,20,.22), transparent 65%);
}
.stat:hover{
  transform: translateY(-2px);
  box-shadow: 0 16px 30px rgba(0,0,0,.35);
  border-color: rgba(229,9,20,.25);
  color:var(--text);
}
.stat .top{
  display:flex;
  align-items:center;
  justify-content:space-between;
}
.stat .icon{
  width:44px; height:44px;
  border-radius:14px;
  display:flex;
  align-items:center;
  justify-content:center;
  background: rgba(124,77,255,.12);
  border:1px solid rgba(124,77,255,.22);
}
.stat .icon i{ font-size:20px; }
.stat h6{
  margin:14px 0 6px;
  color:var(--muted);
  font-weight:600;
}
.stat .value{
  font-size:28px;
  font-weight:900;
  margin:0;
}
.badge-soft{
  border:1px solid var(--line);
  background: rgba(0,0,0,.25);
  color:var(--muted);
  border-radius:999px;
  padding:6px 10px;
  font-size:12px;
}

/* ===== QUICK ACTIONS ===== */
.action{
  border:1px solid var(--line);
  background: linear-gradient(180deg, rgba(255,255,255,.03), rgba(0,0,0,.20));
  border-radius:18px;
  padding:18px;
  transition:.2s ease;
  height:100%;
  color:var(--text);
}
.action:hover{
  transform: translateY(-2px);
  border-color: rgba(124,77,255,.30);
  box-shadow: 0 16px 30px rgba(0,0,0,.35);
  color:var(--text);
}
.action .rowx{
  display:flex;
  align-items:center;
  gap:12px;
}
.action .aicon{
  width:46px; height:46px;
  border-radius:14px;
  background: rgba(229,9,20,.14);
  border:1px solid rgba(229,9,20,.25);
  display:flex;
  align-items:center;
  justify-content:center;
}
.action .aicon i{ font-size:20px; }
.action h5{ margin:0; font-weight:800; }
.action p{ margin:6px 0 0; color:var(--muted); font-size:13px; }

@media(max-width:992px){
  .sidebar{ position:relative; width:100%; min-height:auto; }
  .content{ margin-left:0; }
  .sidebar .bottom{ position:static; margin-top:14px; }
}
</style>
</head>
<%
  DashboardStats stats = (DashboardStats) request.getAttribute("stats");
  if (stats == null) {
      stats = new DashboardStats();
      stats.setTotalMovies(0);
      stats.setBookingsToday(0);
      stats.setUpcomingShowtimes(0);
      stats.setRevenueThisWeek(java.math.BigDecimal.ZERO);
  }
%>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
  <div class="brand">
    <div class="logo">
      <!-- Make sure logo2.png is inside: /webapp/images/logo2.png -->
      <img src="<%= request.getContextPath() %>/images/logo2.png" alt="Cinema Logo">
    </div>
    <div>
      <p class="title mb-0">SINEMA</p>
      <small>Admin Panel</small>
    </div>
  </div>

  <!-- LINKS -->
  <a class="nav-itemx active" href="<%= request.getContextPath() %>/admin/dashboard">
    <i class="bi bi-grid-1x2-fill"></i> Dashboard
  </a>

  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/movies">
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

  <!-- TOPBAR (no search, no avatar) -->
  <div class="topbar">
    <div>
      <strong>Welcome,
      <small style="color:var(--muted)">Sinema Management System</small>
    </div>
  </div>

  <div class="h-title">Admin Dashboard</div>
  <div class="h-sub">Sinema Management Overview</div>

  <!-- STATS -->
  <div class="row g-4 mb-2">
    <div class="col-md-6 col-xl-3">
      <a href="<%= request.getContextPath() %>/admin/update_movie.jsp" class="stat d-block">
        <div class="top">
          <div class="icon"><i class="bi bi-camera-reels"></i></div>
          <span class="badge-soft">Live</span>
        </div>
        <h6>Total Movies</h6>
        <p class="value"><%= stats.getTotalMovies() %></p>
      </a>
    </div>

    <div class="col-md-6 col-xl-3">
      <a href="<%= request.getContextPath() %>/admin/booking_details.jsp" class="stat d-block">
        <div class="top">
          <div class="icon"><i class="bi bi-ticket-perforated"></i></div>
          <span class="badge-soft">Today</span>
        </div>
        <h6>Bookings</h6>
        <p class="value"><%= stats.getBookingsToday() %></p>
      </a>
    </div>

    <div class="col-md-6 col-xl-3">
      <a href="<%= request.getContextPath() %>/admin/report.jsp" class="stat d-block">
        <div class="top">
          <div class="icon"><i class="bi bi-currency-dollar"></i></div>
          <span class="badge-soft">This week</span>
        </div>
        <h6>Revenue</h6>
        <p class="value">RM <%= String.format("%.2f", stats.getRevenueThisWeek()) %></p>
      </a>
    </div>

    <div class="col-md-6 col-xl-3">
      <a href="<%= request.getContextPath() %>/admin/manage_showtime.jsp" class="stat d-block">
        <div class="top">
          <div class="icon"><i class="bi bi-clock-history"></i></div>
          <span class="badge-soft">Upcoming</span>
        </div>
        <h6>Showtimes</h6>
        <p class="value"><%= stats.getUpcomingShowtimes() %></p>

      </a>
    </div>
  </div>
</div>

</div>
</body>
</html>
