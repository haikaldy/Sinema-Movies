<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.sinema.model.ReportRow" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Report</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
:root{
  --bg:#0b0b0f;
  --panel:#111118;
  --card:rgba(255,255,255,.03);
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
.content{
  margin-left:270px;
  padding:26px 26px 46px;
}
.brand{
  display:flex; align-items:center; gap:10px;
  padding:10px 10px 18px;
  border-bottom:1px solid var(--line);
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
.topbar .crumb{ color:var(--muted); font-size:13px; }
.topbar .t{ font-weight:800; }

/* ===== HEADINGS ===== */
.page-title{
  font-size:34px;
  font-weight:900;
  margin:18px 0 6px;
}
.page-sub{ color:var(--muted); margin-bottom:18px; }

/* ===== CARDS ===== */
.cardx{
  background: var(--card);
  border:1px solid var(--line);
  border-radius:18px;
  padding:18px;
}

/* inputs */
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

/* buttons */
.btn-accent{
  background: linear-gradient(90deg, rgba(229,9,20,.95), rgba(124,77,255,.75));
  border:0;
  color:#fff;
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

/* summary mini stat */
.mini{
  border:1px solid var(--line);
  background: rgba(0,0,0,.18);
  border-radius:16px;
  padding:16px;
  height:100%;
}
.mini .label{
  color:var(--muted);
  font-size:12px;
  margin-bottom:6px;
}
.mini .value{
  font-size:24px;
  font-weight:900;
  margin:0;
}
.mini .hint{
  color:var(--muted);
  font-size:12px;
  margin-top:6px;
}

/* table */
.table{
  --bs-table-bg: transparent;
  --bs-table-color: var(--text);
}
.table thead th{
  border-bottom:1px solid var(--line);
  color:#fff;
}
.table td, .table th{
  border-top:1px solid var(--line);
}

@media(max-width:992px){
  .sidebar{ position:relative; width:100%; min-height:auto; }
  .content{ margin-left:0; }
  .sidebar .bottom{ position:static; margin-top:14px; }
}

/* ===== PRINT (PRINT REPORT SECTION ONLY) ===== */
@media print{
  body{ background:#fff !important; color:#000 !important; }
  .sidebar, .topbar, .no-print{ display:none !important; }
  .content{ margin:0 !important; padding:0 !important; }
  #printArea{
    display:block !important;
    color:#000 !important;
    background:#fff !important;
  }
  #printArea .cardx, #printArea .mini{
    border:1px solid #ddd !important;
    background:#fff !important;
    box-shadow:none !important;
  }
  #printArea .table{
    --bs-table-color: #000;
  }
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

  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/movies"><i class="bi bi-camera-reels"></i> Movies</a>
  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/showtimes"><i class="bi bi-clock-history"></i> Showtimes</a>
  <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/bookings"><i class="bi bi-ticket-perforated"></i> Bookings</a>

  <a class="nav-itemx active" href="<%= request.getContextPath() %>/admin/report"><i class="bi bi-graph-up-arrow"></i> Report</a>

  <div class="bottom">
    <a class="nav-itemx" href="<%= request.getContextPath() %>/admin/admin_login.jsp"><i class="bi bi-box-arrow-right"></i> Logout</a>
  </div>
</div>

<!-- CONTENT -->
<div class="content">

  <!-- TOPBAR -->
  <div class="topbar">
    <div>
      <div class="crumb">Admin / Reports</div>
      <div class="t">Sales Report</div>
    </div>
    <div class="d-flex gap-2">
      <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/admin/admin_page.jsp">
        <i class="bi bi-house"></i> Dashboard
      </a>
    </div>
  </div>

  <div class="page-title">Report</div>
  <div class="page-sub">Filter by date range to view total ticket sold, snack sold, and revenue. You can print the report.</div>

  <!-- FILTERS -->
  <div class="cardx mb-4 no-print">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
      <div class="fw-bold"><i class="bi bi-funnel me-1"></i> Filters</div>
    </div>

    <div class="row g-3 align-items-end">
      <div class="col-md-4">
        <label class="form-label">Start Date</label>
        <input type="date" class="form-control" id="startDate">
      </div>

      <div class="col-md-4">
        <label class="form-label">End Date</label>
        <input type="date" class="form-control" id="endDate">
      </div>

      <div class="col-md-4 d-grid gap-2">
        <button class="btn btn-accent" type="button" onclick="applyFilter()">
          <i class="bi bi-check2-circle"></i> Apply Filter
        </button>
        <button class="btn btn-outline-light" type="button" onclick="printReport()">
          <i class="bi bi-printer"></i> Print Report
        </button>
      </div>
    </div>
  </div>

  <!-- PRINT AREA (this is what will be printed) -->
  <div id="printArea">
    <!-- Report header for print -->
    <div class="cardx mb-4">
      <div class="d-flex align-items-start justify-content-between">
        <div>
          <div class="text-secondary small">Sinema Admin Report</div>
          <div class="fw-bold fs-5">Sales Summary</div>
          <div class="text-secondary small mt-1">
            Date Range:
            <span class="text-light" id="rangeText">All dates </span>
          </div>
        </div>
        <div class="text-end">
          <div class="text-secondary small">Generated</div>
          <div class="fw-bold" id="generatedAt">-</div>
        </div>
      </div>
    </div>

    <!-- SUMMARY -->
    <div class="row g-4 mb-4">
      <div class="col-md-6 col-xl-4">
        <div class="mini">
          <div class="label"><i class="bi bi-ticket-perforated me-1"></i>Total Ticket Sold</div>
          <p class="value" id="ticketSold">0</p>
          <div class="hint">Within selected range</div>
        </div>
      </div>

      <div class="col-md-6 col-xl-4">
        <div class="mini">
          <div class="label"><i class="bi bi-cup-straw me-1"></i>Total Snack Sold</div>
          <p class="value" id="snackSold">0</p>
          <div class="hint">Units sold</div>
        </div>
      </div>

      <div class="col-md-6 col-xl-4">
        <div class="mini">
          <div class="label"><i class="bi bi-cash-coin me-1"></i>Total Revenue</div>
          <p class="value" id="totalRevenue">RM 0.00</p>
          <div class="hint">Tickets + Snacks</div>
        </div>
      </div>
    </div>

    <!-- DETAILS TABLE -->
    <div class="cardx">
      <div class="d-flex align-items-center justify-content-between mb-2">
        <div class="fw-bold"><i class="bi bi-table me-1"></i>Transactions</div>
        <span class="badge-soft" id="rowsCount">0 rows</span>
      </div>
      <hr style="border-color: rgba(255,255,255,.10)">

      <div class="table-responsive">
        <table class="table align-middle">
          <thead>
            <tr>
              <th style="width:140px;">Date</th>
              <th style="width:130px;">Booking ID</th>
              <th style="width:140px;">Ticket Qty</th>
              <th style="width:140px;">Snack Qty</th>
              <th style="width:180px;">Revenue (RM)</th>
            </tr>
          </thead>
          <tbody id="txBody">
            <!-- JS inject -->
          </tbody>
        </table>
      </div>

    </div>
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<%
  List<ReportRow> reportRows = (List<ReportRow>) request.getAttribute("reportRows");
  if (reportRows == null) reportRows = new ArrayList<>();
%>

<script type="application/json" id="transactionsData">
  [
    <%
    for (int i = 0; i < reportRows.size(); i++) {
        ReportRow r = reportRows.get(i);
      %>
          {
              "date": "<%= r.getDate() %>",
              "bookingId": "<%= r.getBookingId() %>",
              "ticketQty": <%= r.getTicketQty() %>,
              "snackQty": <%= r.getSnackQty() %>,
              "revenue": <%= String.format(java.util.Locale.US, "%.2f", r.getRevenue()) %>
          }<%= (i < reportRows.size() - 1) ? "," : "" %>
      <%
    }
    %>
  ]
</script>

<script>

  const transactions = JSON.parse(
        document.getElementById('transactionsData').textContent
    );

    console.log(transactions);

function pad(n){
  return String(n).padStart(2, "0");
}

function setGeneratedAt(){
  const now = new Date();
  const stamp =
    now.getFullYear() + "-" +
    pad(now.getMonth()+1) + "-" +
    pad(now.getDate()) + " " +
    pad(now.getHours()) + ":" +
    pad(now.getMinutes());

  document.getElementById("generatedAt").textContent = stamp;
}

function inRange(dateStr, startStr, endStr){
  if(!startStr && !endStr) return true;

  const d = new Date(dateStr + "T00:00:00");
  if(startStr){
    const s = new Date(startStr + "T00:00:00");
    if(d < s) return false;
  }
  if(endStr){
    const e = new Date(endStr + "T23:59:59");
    if(d > e) return false;
  }
  return true;
}

function formatRM(n){
  return "RM " + Number(n).toFixed(2);
}

function renderTable(rows){
  const tb = document.getElementById("txBody");
  tb.innerHTML = "";

  if(rows.length === 0){
    tb.innerHTML = '<tr><td colspan="5" class="text-secondary">No data in this range.</td></tr>';
    return;
  }

  let html = "";
  for(let i=0; i<rows.length; i++){
    const r = rows[i];
    html +=
      "<tr>" +
        "<td>" + r.date + "</td>" +
        "<td>" + r.bookingId + "</td>" +
        "<td>" + r.ticketQty + "</td>" +
        "<td>" + r.snackQty + "</td>" +
        "<td>" + Number(r.revenue).toFixed(2) + "</td>" +
      "</tr>";
  }
  tb.innerHTML = html;
}

function applyFilter(){
  const start = document.getElementById("startDate").value;
  const end = document.getElementById("endDate").value;

  const rows = transactions.filter(t => inRange(t.date, start, end));

  const totalTickets = rows.reduce((a,b)=> a + b.ticketQty, 0);
  const totalSnacks  = rows.reduce((a,b)=> a + b.snackQty, 0);
  const totalRev     = rows.reduce((a,b)=> a + b.revenue, 0);

  document.getElementById("ticketSold").textContent = totalTickets;
  document.getElementById("snackSold").textContent = totalSnacks;
  document.getElementById("totalRevenue").textContent = formatRM(totalRev);

  const rangeText = (!start && !end)
    ? "All dates (sample)"
    : (start || "...") + " to " + (end || "...");
  document.getElementById("rangeText").textContent = rangeText;

  document.getElementById("rowsCount").textContent = rows.length + " rows";
  renderTable(rows);

  setGeneratedAt();
}

function printReport(){
  applyFilter();
  window.print();
}

window.addEventListener("load", () => {
  setGeneratedAt();
  applyFilter();
});
</script>

</body>
</html>
