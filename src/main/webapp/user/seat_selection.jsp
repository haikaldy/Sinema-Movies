<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.util.TreeMap, java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.mycompany.sinema.model.Seat" %>

<%
    // Seats list from controller
    List<Seat> seats = (List<Seat>) request.getAttribute("seats");

    // Showtime info from controller (trusted DB)
    Integer showtimeIdAttr = (Integer) request.getAttribute("showtime_id");
    int showtimeId = (showtimeIdAttr != null) ? showtimeIdAttr : 0;

    String movieTitleAttr = (String) request.getAttribute("movieTitle");
    Object showDateObj = request.getAttribute("showDate");   // java.sql.Date
    Object showTimeObj = request.getAttribute("showTime");   // java.sql.Time
    Object ticketPriceObj = request.getAttribute("ticketPrice");
    String hallAttr = (String) request.getAttribute("hall");

    // Fallback for image/title (if you still pass via query)
    String imgParam = request.getParameter("img");
    String titleParam = request.getParameter("title");

    String movieTitle = (movieTitleAttr != null && !movieTitleAttr.isBlank())
            ? movieTitleAttr
            : (titleParam != null ? titleParam : "Movie");

    String hall = (hallAttr != null && !hallAttr.isBlank()) ? hallAttr : "Deluxe Hall";

    // Format date/time
    String showDateStr = "—";
    if (showDateObj != null) {
        try {
            java.util.Date d = (java.util.Date) showDateObj;
            showDateStr = new SimpleDateFormat("dd MMM yyyy").format(d);
        } catch (Exception ignore) {}
    }

    String showTimeStr = "—";
    if (showTimeObj != null) {
        try {
            java.util.Date t = (java.util.Date) showTimeObj;
            showTimeStr = new SimpleDateFormat("hh:mm a").format(t);
        } catch (Exception ignore) {}
    }

    double ticketPrice = 0.0;
    if (ticketPriceObj != null) {
        try { ticketPrice = Double.parseDouble(ticketPriceObj.toString()); } catch (Exception ignore) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= movieTitle %> | Sinema Movies</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- ✅ FontAwesome (seat icon like your original design) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        
        .seat-btn.unavailable { 
  color: #eb3349 !important;   /* red */
  pointer-events: none;
  opacity: .7;
}
.seat-btn.unavailable:hover {
  transform: none;
}

        body { background-color: #121212; color: white; font-family: 'Segoe UI', sans-serif; min-height: 100vh; display: flex; flex-direction: column; overflow-x: hidden; }

        /* --- HEADER & PROGRESS --- */
        .header-container { padding: 20px 30px; position: relative; }
        .close-btn { position: absolute; top: 20px; right: 30px; color: #fff; font-size: 1.5rem; text-decoration: none; z-index: 10; }
        .progress-steps { display: flex; justify-content: center; align-items: center; margin-bottom: 20px; }
        .step-item { text-align: center; position: relative; width: 120px; }
        .step-circle { width: 30px; height: 30px; border-radius: 50%; background-color: #333; color: #888; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: bold; position: relative; z-index: 2; }
        .step-label { font-size: 0.8rem; color: #888; }
        .step-item:not(:last-child)::after { content: ''; position: absolute; top: 15px; right: -50%; width: 100%; height: 2px; background-color: #333; z-index: 1; }
        .step-item.active .step-circle { background-color: #eb3349; color: white; }
        .step-item.active .step-label { color: white; }

        /* --- INFO BAR --- */
        .info-bar{
            width: min(900px, 92%);
            margin: 0 auto 12px;
            padding: 12px 16px;
            background: #0f0f0f;
            border: 1px solid #222;
            border-radius: 14px;
            display:flex;
            justify-content: space-between;
            align-items:center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .info-left{ font-weight: 800; letter-spacing: .3px; }
        .info-right{ color:#bbb; font-size: .95rem; display:flex; flex-wrap:wrap; gap:10px; }
        .pill{
            display:inline-flex;
            gap: 8px;
            align-items:center;
            padding: 6px 10px;
            background:#141414;
            border:1px solid #222;
            border-radius: 999px;
            color:#ddd;
        }
        .pill i{ color:#eb3349; }

        /* --- SEAT MAP --- */
        .main-content { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; padding-bottom: 100px; }
        .screen-container { width: 80%; max-width: 600px; text-align: center; margin-bottom: 40px; }
        .screen-curve { height: 20px; border-top: 4px solid #555; border-radius: 50% / 100% 100% 0 0; box-shadow: 0 -10px 20px -5px rgba(255,255,255,0.2); margin-bottom: 10px; }
        .screen-text { font-size: 0.9rem; color: #888; letter-spacing: 2px; }

        .seat-row { display: flex; align-items: center; justify-content: center; margin-bottom: 8px; }
        .row-label { width: 30px; text-align: center; font-weight: bold; color: #ccc; }

        .seat-group { display: flex; gap: 6px; margin: 0 10px; }
        .seat-btn {
            background: transparent;
            border: none;
            padding: 2px;
            color: #00c4ff;
            font-size: 1.3rem;
            transition: all 0.2s;
        }
        .seat-btn:hover { color: #fff; transform: scale(1.1); }
        .seat-btn.selected { color: #eb3349; }

        .seat-btn.disabled { color: #555; pointer-events: none; }
        .seat-btn:disabled { pointer-events:none; opacity:.6; }

        /* --- BOTTOM FOOTER --- */
        .booking-footer { position: fixed; bottom: 0; left: 0; width: 100%; background-color: #121212; padding: 20px; display: flex; justify-content: center; border-top: 1px solid #222; z-index: 100; }
        .btn-book { background-color: #eb3349; color: white; border: none; padding: 12px 60px; border-radius: 30px; font-weight: bold; font-size: 1.1rem; transition: all 0.3s; }
        .btn-book:disabled { background-color: #442225; color: #888; cursor: not-allowed; }
        .btn-book:not(:disabled):hover { background-color: #ff4b5c; }

        /* --- CONFIRMATION OVERLAY --- */
        .confirmation-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.9);
            z-index: 200;
            display: none;
            justify-content: center; align-items: flex-end;
        }
        .confirmation-card {
            width: 100%; max-width: 600px;
            background-color: #1a1a1a;
            border-top-left-radius: 20px; border-top-right-radius: 20px;
            overflow: hidden; animation: slideUp 0.3s ease-out;
            box-shadow: 0 -5px 30px rgba(0,0,0,0.8);
        }
        @keyframes slideUp { from { transform: translateY(100%); } to { transform: translateY(0); } }

        .card-header-img {
            height: 150px;
            position: relative;
            background: linear-gradient(135deg, #1f1f1f, #111);
            background-position: center;
            background-size: cover;
            background-repeat: no-repeat;
        }

        .card-header-overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to bottom, rgba(0,0,0,0.2), #1a1a1a);
            display: flex; align-items: flex-end; padding: 20px;
        }
        .close-overlay-btn {
            position: absolute; top: 15px; right: 15px;
            background: rgba(0,0,0,0.5);
            border: none; color: white; font-size: 1.2rem;
            width: 32px; height: 32px; border-radius: 50%;
            z-index: 10; cursor: pointer;
        }

        .ticket-details { padding: 20px; }
        .ticket-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #333; padding-bottom: 15px; }
        .qty-control { background-color: #000; padding: 5px 15px; border-radius: 8px; border: 1px solid #333; font-weight: bold; font-size: 1.1rem; color: white; display: inline-block; min-width: 60px; text-align: center; }
        .price-text { font-size: 1.2rem; font-weight: bold; color: white; }

        .btn-add-cart {
            width: 100%; background-color: #eb3349; color: white; border: none;
            padding: 15px; font-weight: bold; text-transform: uppercase; font-size: 1.1rem; border-radius: 10px;
        }
        .btn-add-cart:hover { background-color: #ff4b5c; }
    </style>
</head>

<body>

    <div class="header-container">
        <a href="javascript:history.back()" class="close-btn"><i class="fas fa-times"></i></a>
        <div class="progress-steps">
            <div class="step-item active"><div class="step-circle">1</div><div class="step-label">Select Seats</div></div>
            <div class="step-item"><div class="step-circle">2</div><div class="step-label">Foods & Drinks</div></div>
            <div class="step-item"><div class="step-circle">3</div><div class="step-label">Payment</div></div>
        </div>
    </div>

    <div class="info-bar">
        <div class="info-left"><%= movieTitle %></div>
        <div class="info-right">
            <span class="pill"><i class="fas fa-location-dot"></i> <%= hall %></span>
            <span class="pill"><i class="far fa-calendar"></i> <%= showDateStr %></span>
            <span class="pill"><i class="far fa-clock"></i> <%= showTimeStr %></span>
            <span class="pill"><i class="fas fa-ticket"></i> RM <%= String.format("%.2f", ticketPrice) %></span>
        </div>
    </div>

    <div class="main-content">
        <div class="screen-container">
            <div class="screen-curve"></div>
            <div class="screen-text">SCREEN</div>
        </div>

        <div class="seats-container">
            <%
                if (seats != null && !seats.isEmpty()) {

                    Map<Character, List<Seat>> seatsByRow = new TreeMap<>();
                    for (Seat seat : seats) {
                        String sn = seat.getSeatNumber(); // expected like "A1"
                        if (sn == null || sn.length() < 2) continue;

                        char row = sn.charAt(0);
                        seatsByRow.computeIfAbsent(row, k -> new ArrayList<>()).add(seat);
                    }

                    for (Map.Entry<Character, List<Seat>> entry : seatsByRow.entrySet()) {
                        char rowLabel = entry.getKey();
                        List<Seat> rowSeats = entry.getValue();

                        rowSeats.sort((s1, s2) -> {
                            String n1 = s1.getSeatNumber().substring(1);
                            String n2 = s2.getSeatNumber().substring(1);
                            try {
                                return Integer.compare(Integer.parseInt(n1), Integer.parseInt(n2));
                            } catch (Exception e) {
                                return s1.getSeatNumber().compareTo(s2.getSeatNumber());
                            }
                        });
            %>

            <div class="seat-row">
                <div class="row-label"><%= rowLabel %></div>

                <div class="seat-group">
                    <%
                        int lastSeatNumber = 0;
                        for (Seat seat : rowSeats) {
                            String seatId = seat.getSeatNumber();  // A1
                           String status = seat.getStatus();
                            boolean isBlocked = status != null && (
                                        "booked".equalsIgnoreCase(status) ||
                                        "reserved".equalsIgnoreCase(status) ||
                                        "unavailable".equalsIgnoreCase(status)
                                );


                            int seatNumber = 0;
                            try { seatNumber = Integer.parseInt(seatId.substring(1)); } catch(Exception ignore){}

                            if (seatNumber == 6 && lastSeatNumber == 5) {
                    %>
                        <div style="width:25px;"></div>
                    <%
                            }
                    %>

                    <button type="button"
                        class="seat-btn <%= isBlocked ? "unavailable" : "" %>"
                        id="<%= seatId %>"
                        <%= isBlocked ? "disabled" : "" %>
                        onclick="<%= isBlocked ? "" : "toggleSeat(this)" %>">
                    <i class="fas fa-couch"></i>
                </button>


                    <%
                            lastSeatNumber = seatNumber;
                        }
                    %>
                </div>

                <div class="row-label"><%= rowLabel %></div>
            </div>

            <%
                    }
                } else {
            %>
                <div class="text-center text-secondary" style="padding:30px;">
                    No seats found for this showtime (ID: <%= showtimeId %>). <br/>
                    Make sure seats table has rows with this showtime_id.
                </div>
            <%
                }
            %>
        </div>
    </div>

    <div class="booking-footer">
        <button id="bookBtn" class="btn-book" disabled onclick="openConfirmation()">Book Seat(s)</button>
    </div>

    <!-- Confirmation overlay -->
    <div class="confirmation-overlay" id="confirmOverlay">
        <div class="confirmation-card">
            <div class="card-header-img">
                <% if (imgParam != null && !imgParam.isBlank()) { %>
                style="background-image: url('<%= request.getContextPath() %>/images/<%= imgParam %>');"
                <% } %>>
                <button class="close-overlay-btn" onclick="closeConfirmation()"><i class="fas fa-times"></i></button>
                <div class="card-header-overlay">
                    <div>
                        <h2 style="margin:0; font-weight:800; font-size:1.5rem; text-shadow:0 2px 4px rgba(0,0,0,0.8);"><%= movieTitle %></h2>
                        <div style="color:#ddd; font-size:0.9rem; margin-top:5px;">
                            <i class="fas fa-map-marker-alt text-danger me-2"></i> <%= hall %> &nbsp;|&nbsp;
                            <i class="far fa-clock text-danger me-2"></i> <%= showTimeStr %>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ticket-details">
                <div class="ticket-row">
                    <div>
                        <div style="font-weight:bold; font-size:1.1rem;">NORMAL TICKET</div>
                        <div style="color:#888; font-size:0.9rem;">
                            Seats: <span id="displaySeatList" style="color:#eb3349;"></span>
                        </div>
                    </div>
                    <div class="qty-control" id="displayQty">0</div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div style="color:#888;">Total Price</div>
                    <div class="price-text" id="displayTotal">RM 0.00</div>
                </div>

                <button class="btn-add-cart" type="button" onclick="proceedToSnack()">
                    ADD TO CART - <span id="btnTotal">RM 0.00</span>
                </button>
            </div>
        </div>
    </div>

    <!-- POST form to SeatSelectionController -->
    <form id="seatForm" method="post" action="<%=request.getContextPath()%>/SeatSelectionController">
        <input type="hidden" name="showtime_id" value="<%= showtimeId %>">
        <div id="hiddenSeats"></div>
    </form>

    <script>
        const pricePerSeat = Number('<%= String.format(java.util.Locale.US, "%.2f", ticketPrice) %>');

        function toggleSeat(btn) {
            btn.classList.toggle('selected');
            updateBookBtn();
        }

        function updateBookBtn() {
            const count = document.querySelectorAll('.seat-btn.selected').length;
            const btn = document.getElementById('bookBtn');

            if (count > 0) {
                btn.disabled = false;
                btn.innerText = "Book " + count + " Seat(s)";
            } else {
                btn.disabled = true;
                btn.innerText = "Book Seat(s)";
            }
        }

        function openConfirmation() {
            const selectedSeats = document.querySelectorAll('.seat-btn.selected');
            const count = selectedSeats.length;

            let seatIds = [];
            selectedSeats.forEach(s => seatIds.push(s.id));

            const total = (count * pricePerSeat).toFixed(2);

            document.getElementById('displaySeatList').innerText = seatIds.join(', ');
            document.getElementById('displayQty').innerText = count;
            document.getElementById('displayTotal').innerText = "RM " + total;
            document.getElementById('btnTotal').innerText = "RM " + total;

            document.getElementById('confirmOverlay').style.display = 'flex';
        }

        function closeConfirmation() {
            document.getElementById('confirmOverlay').style.display = 'none';
        }

        // ✅ Submit selected seats via POST (controller will redirect to SnackSelectionControllerV2)
        function proceedToSnack() {
            const selectedSeats = document.querySelectorAll('.seat-btn.selected');
            if (selectedSeats.length === 0) return;

            const hiddenSeatsDiv = document.getElementById("hiddenSeats");
            hiddenSeatsDiv.innerHTML = "";

            selectedSeats.forEach(s => {
                const input = document.createElement("input");
                input.type = "hidden";
                input.name = "seat";
                input.value = s.id;
                hiddenSeatsDiv.appendChild(input);
            });

            document.getElementById("seatForm").submit();
        }
    </script>

</body>
</html>
