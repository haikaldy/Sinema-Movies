<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sinema.model.Admin" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Profile</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
/* (YOUR ORIGINAL CSS — unchanged) */
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

.sidebar{
  width:270px; min-height:100vh;
  position:fixed; left:0; top:0;
  background: linear-gradient(180deg, rgba(255,255,255,.03), transparent 40%), var(--panel);
  border-right:1px solid var(--line);
  padding:22px 16px;
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
  padding:12px 12px; border-radius:12px;
  color:#ddd; margin-bottom:8px;
  transition:.2s ease; border:1px solid transparent;
}
.nav-itemx i{ font-size:18px; }
.nav-itemx:hover{ background: rgba(229,9,20,.10); border-color: rgba(229,9,20,.25); color:#fff; }
.nav-itemx.active{
  background: linear-gradient(90deg, rgba(229,9,20,.25), rgba(124,77,255,.15));
  border-color: rgba(229,9,20,.35);
  color:#fff;
  box-shadow: 0 10px 25px rgba(0,0,0,.35);
}
.sidebar .bottom{
  position:absolute; left:16px; right:16px; bottom:16px;
  padding-top:12px; border-top:1px solid var(--line);
}

.content{ margin-left:270px; padding:26px 26px 46px; }

.topbar{
  display:flex; align-items:center; justify-content:space-between;
  gap:12px; padding:14px 16px;
  border:1px solid var(--line);
  background: rgba(0,0,0,.35);
  border-radius:16px;
  backdrop-filter: blur(10px);
}
.topbar .crumb{ color: rgba(255,255,255,.55); font-size:12px; }
.topbar .title{ font-weight:700; font-size:16px; margin-top:2px; }

.page-title{ font-size:34px; font-weight:900; margin:18px 0 6px; }
.page-sub{ color:var(--muted); margin-bottom:18px; }

.panel{
  border:1px solid var(--line);
  background: rgba(255,255,255,.03);
  border-radius:20px;
  padding:22px;
  box-shadow: 0 18px 40px rgba(0,0,0,.35);
}

.form-title{
  display:flex; align-items:center; justify-content:space-between;
  gap:10px;
  font-weight:900;
  margin-bottom:14px;
}
.form-title .left{
  display:flex; align-items:center; gap:10px;
}

.form-label{ color:var(--muted); font-size:13px; margin-bottom:6px; }
.form-control{
  background: rgba(255,255,255,.04) !important;
  border:1px solid var(--line) !important;
  color: var(--text) !important;
  border-radius:12px !important;
  padding:10px 12px !important;
}
.form-control:focus{
  box-shadow:none !important;
  border-color: rgba(229,9,20,.40) !important;
}

/* readonly look */
.readonly .form-control{
  opacity: .85;
}
.readonly .form-control[readonly]{
  cursor: not-allowed;
}

.btn-save{
  border:0;
  border-radius:12px;
  padding:10px 14px;
  background: linear-gradient(90deg, rgba(229,9,20,1), rgba(124,77,255,1));
  color:#fff;
  font-weight:700;
}
.btn-cancel{
  border:1px solid var(--line);
  border-radius:12px;
  padding:10px 14px;
  background: rgba(0,0,0,.15);
  color:#fff;
}
.btn-edit{
  border:1px solid var(--line);
  border-radius:12px;
  padding:10px 14px;
  background: rgba(255,255,255,.04);
  color:#fff;
}
.btn-edit:hover{
  border-color: rgba(124,77,255,.40);
  background: rgba(124,77,255,.12);
}

.note{ color:var(--muted); font-size:13px; margin-top:14px; }

@media(max-width:992px){
  .sidebar{ position:relative; width:100%; min-height:auto; }
  .content{ margin-left:0; }
  .sidebar .bottom{ position:static; margin-top:14px; }
}
</style>
</head>

<%
  // ✅ Prefer data loaded by controller (joined admins + users)
  Admin profile = (Admin) request.getAttribute("adminProfile");

  // ✅ Fallback to session admin (from login)
  Admin sessionAdmin = (Admin) session.getAttribute("admin");

  if (sessionAdmin == null) {
      response.sendRedirect(request.getContextPath() + "/admin/admin_login.jsp");
      return;
  }

  // if controller didn’t set, at least show session data
  if (profile == null) profile = sessionAdmin;

  String msg = request.getParameter("msg");     // success message (redirect)
  String err = request.getParameter("err");     // error message (redirect)
%>

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

  <div class="topbar">
    <div>
      <div class="crumb">Admin / Profile</div>
      <div class="title">Manage profile</div>
    </div>
    <div class="d-flex gap-2">
      <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/admin/admin_page.jsp">
        <i class="bi bi-house"></i> Dashboard
      </a>
    </div>
  </div>

  <div class="page-title">Profile</div>
  <div class="page-sub">View your information. Click edit to update.</div>

  <!-- ✅ Alerts -->
  <% if (msg != null && !msg.isBlank()) { %>
    <div class="alert alert-success border-0" style="background:rgba(25,135,84,.15); color:#d1ffe6;">
      <i class="bi bi-check-circle"></i> <%= msg %>
    </div>
  <% } %>

  <% if (err != null && !err.isBlank()) { %>
    <div class="alert alert-danger border-0" style="background:rgba(220,53,69,.15); color:#ffd6db;">
      <i class="bi bi-exclamation-triangle"></i> <%= err %>
    </div>
  <% } %>

  <!-- ONE PANEL ONLY -->
  <div class="panel readonly" id="profilePanel">
    <div class="form-title">
      <div class="left">
        <i class="bi bi-pencil-square"></i>
        <span>Profile</span>
      </div>

      <!-- EDIT BUTTON -->
      <button type="button" class="btn-edit" id="btnEdit">
        <i class="bi bi-pencil"></i> Edit Profile
      </button>
    </div>

    <!-- ✅ POST to controller -->
    <form action="${pageContext.request.contextPath}/admin/profiles"
      method="post">

      <div class="row g-3">

        <!-- Full Name (from users.username) -->
        <div class="col-md-6">
          <label class="form-label">Full Name</label>
          <input class="form-control editable" type="text" name="username"
                 value="<%= (profile.getUsername() != null ? profile.getUsername() : "") %>" readonly>
        </div>

        <!-- User Email (from users.email) -->
        <div class="col-md-6">
          <label class="form-label">Email</label>
          <input class="form-control editable" type="email" name="userEmail"
                 value="<%= (profile.getUserEmail() != null ? profile.getUserEmail() : "") %>" readonly>
        </div>

        <!-- Admin Login Email (from admins.adminEmail) -->
        <div class="col-md-6">
          <label class="form-label">Admin Login Email</label>
          <input class="form-control editable" type="email" name="adminEmail"
                 value="<%= (profile.getAdminEmail() != null ? profile.getAdminEmail() : "") %>" readonly>
        </div>

        <!-- Phone (from users.phone_no) -->
        <div class="col-md-6">
          <label class="form-label">PhoneNo</label>
          <input class="form-control editable" type="text" name="phoneNo"
                 value="<%= (profile.getPhoneNo() != null ? profile.getPhoneNo() : "") %>" readonly>
        </div>

        <div class="col-md-6">
          <label class="form-label">New Password</label>
          <input class="form-control editable" type="password" name="newPassword" placeholder="••••••••" readonly>
        </div>

        <div class="col-md-6">
          <label class="form-label">Confirm Password</label>
          <input class="form-control editable" type="password" name="confirmPassword" placeholder="••••••••" readonly>
        </div>

      </div>

      <!-- ACTION BUTTONS -->
      <div class="d-flex gap-2 mt-4" id="actionButtons" style="display:none;">
        <button type="submit" class="btn-save">
          <i class="bi bi-check2-square me-1"></i> Save Changes
        </button>
        <button type="button" class="btn-cancel" id="btnCancel">Cancel</button>
      </div>

      <div class="note">
        Leave password empty if you don’t want to change it.
      </div>

    </form>
  </div>

</div>

<script>
const btnEdit = document.getElementById("btnEdit");
const btnCancel = document.getElementById("btnCancel");
const actionButtons = document.getElementById("actionButtons");
const panel = document.getElementById("profilePanel");
const fields = document.querySelectorAll(".editable");

let originalValues = {};

function setReadonly(isReadonly){
  fields.forEach(f => {
    if(isReadonly){
      f.setAttribute("readonly","readonly");
    }else{
      f.removeAttribute("readonly");
    }
  });
}

function storeOriginal(){
  originalValues = {};
  fields.forEach(f => {
    originalValues[f.name] = f.value;
  });
}

function restoreOriginal(){
  fields.forEach(f => {
    if(originalValues.hasOwnProperty(f.name)){
      f.value = originalValues[f.name];
    }
  });
}

btnEdit.addEventListener("click", () => {
  storeOriginal();
  setReadonly(false);
  actionButtons.style.display = "flex";
  btnEdit.style.display = "none";
  panel.classList.remove("readonly");
  fields[0].focus();
});

btnCancel.addEventListener("click", () => {
  restoreOriginal();
  setReadonly(true);
  actionButtons.style.display = "none";
  btnEdit.style.display = "inline-block";
  panel.classList.add("readonly");
});
</script>

</body>
</html>
