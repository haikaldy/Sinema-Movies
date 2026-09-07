<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Get Parameters
    String title = request.getParameter("title");
    String img = request.getParameter("img");
    String time = request.getParameter("time");
    String date = request.getParameter("date"); // Matches the fix from Step 1
    String seats = request.getParameter("seats");
    String countStr = request.getParameter("count");
    String foodItems = request.getParameter("foodItems");
    
    // 2. Parse Numbers
    double ticketTotal = 0.00;
    double foodTotal = 0.00;
    int count = 0;
    
    try {
        ticketTotal = Double.parseDouble(request.getParameter("ticketTotal"));
        foodTotal = Double.parseDouble(request.getParameter("foodTotal"));
        count = Integer.parseInt(countStr);
    } catch (Exception e) {
        // Handle errors or nulls gracefully
    }

    // 3. Calculate Prices
    double singlePrice = (count > 0) ? (ticketTotal / count) : 25.00; // Calculate single unit price
    double grandTotal = ticketTotal + foodTotal;
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${param.title} | Sinema Movies</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body { background-color: #121212; color: white; font-family: 'Segoe UI', sans-serif; padding-bottom: 100px; }

        /* HEADER & PROGRESS */
        .header-container { padding: 20px 30px; position: relative; }
        .close-btn { position: absolute; top: 20px; right: 30px; color: #fff; font-size: 1.5rem; text-decoration: none; }
        .progress-steps { display: flex; justify-content: center; align-items: center; margin-bottom: 20px; }
        .step-item { text-align: center; position: relative; width: 120px; }
        .step-circle { width: 30px; height: 30px; border-radius: 50%; background-color: #333; color: #888; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: bold; position: relative; z-index: 2; }
        .step-label { font-size: 0.8rem; color: #888; }
        .step-item:not(:last-child)::after { content: ''; position: absolute; top: 15px; right: -50%; width: 100%; height: 2px; background-color: #333; z-index: 1; }
        
        /* Active Step 3 */
        .step-item.completed .step-circle { background-color: #eb3349; color: white; }
        .step-item.active .step-circle { background-color: #eb3349; color: white; border: 2px solid white; }
        .step-item.active .step-label { color: white; }

        /* MOVIE BANNER */
        .movie-banner {
            position: relative; height: 200px; overflow: hidden;
            background: url('${pageContext.request.contextPath}/images/<%= img %>') no-repeat center center/cover;
        }
        .banner-overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to right, rgba(0,0,0,0.9) 30%, rgba(0,0,0,0.4));
            display: flex; flex-direction: column; justify-content: center; padding: 0 5%;
        }
        .movie-title { font-size: 2.5rem; font-weight: 800; margin-bottom: 10px; text-transform: uppercase; }
        .movie-info { display: flex; gap: 20px; font-size: 0.9rem; color: #ddd; }
        .movie-info i { color: #ccc; margin-right: 5px; }

        /* ORDER DETAILS */
        .order-container { padding: 20px 5%; max-width: 800px; margin: 0 auto; }
        .section-title { font-size: 0.9rem; color: #fff; margin-bottom: 15px; border-bottom: 1px solid #333; padding-bottom: 10px; display: flex; justify-content: space-between; text-transform: uppercase; letter-spacing: 1px; }
        .loyalty-points { font-size: 0.8rem; color: #ccc; text-transform: none; letter-spacing: 0; }
        .loyalty-points strong { color: white; }

        /* 3-Column Layout for Items (Name | Qty | Price) */
        .line-item { display: flex; align-items: center; margin-bottom: 20px; font-size: 0.95rem; }
        
        /* Column 1: Description (Flex grow to fill space) */
        .col-desc { flex: 1; }
        .item-name { font-weight: bold; font-size: 1rem; text-transform: uppercase; }
        .item-sub { color: #888; font-size: 0.9rem; margin-top: 2px; }
        
        /* Column 2: Quantity (Fixed width, centered) */
        .col-qty { flex: 0 0 80px; text-align: center; font-weight: bold; font-size: 1rem; color: #fff; }
        
        /* Column 3: Total Price (Right aligned) */
        .col-price { flex: 0 0 100px; text-align: right; font-weight: bold; font-size: 1rem; }

        .edit-link { color: #eb3349; text-decoration: none; font-size: 0.8rem; font-weight: bold; cursor: pointer; float: right; text-transform: uppercase; }

        /* FOOTER BUTTON */
        .checkout-btn {
            background-color: #eb3349; color: white; border: none;
            padding: 12px 40px; border-radius: 8px; font-weight: bold; font-size: 1rem;
            text-transform: uppercase; transition: all 0.3s;
        }
        .checkout-btn:hover { background-color: #ff4b5c; box-shadow: 0 0 15px rgba(235, 51, 73, 0.5); }
        .timer-badge { font-weight: bold; font-size: 0.9rem; margin-right: 20px; }

    </style>
</head>
<body>

    <div class="header-container">
        <a href="javascript:history.back()" class="close-btn"><i class="fas fa-times"></i></a>
        <div class="progress-steps">
            <div class="step-item completed"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Select Seats</div></div>
            <div class="step-item completed"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Food & Drinks</div></div>
            <div class="step-item active"><div class="step-circle">3</div><div class="step-label">Checkout & Payment</div></div>
        </div>
    </div>

    <div class="movie-banner">
        <div class="banner-overlay">
            <div class="movie-title"><%= title %></div>
            <div class="movie-info">
                <span><i class="fas fa-film"></i> Deluxe Hall</span>
                <span><i class="far fa-calendar-alt"></i> <%= (date != null ? date : "Today") %>, <%= (time != null ? time : "10:30 AM") %></span>
                <span><i class="fas fa-couch"></i> <%= seats %></span>
            </div>
        </div>
    </div>

    <div class="order-container">
        
        <div class="section-title">
            <span>Order Details</span>
        </div>

        <div class="d-flex justify-content-between mb-3">
            <span style="font-weight:bold; font-size:0.8rem; color:#888;">SEATS</span>
            <a href="javascript:history.go(-2)" class="edit-link">EDIT SEAT <i class="fas fa-chevron-right"></i></a>
        </div>

        <div class="line-item">
            <div class="col-desc">
                <div class="item-name">SINGLE</div>
                <div class="item-sub">RM <%= String.format("%.2f", singlePrice) %></div>
            </div>
            <div class="col-qty">
                <%= count %>
            </div>
            <div class="col-price">
                RM <%= String.format("%.2f", ticketTotal) %>
            </div>
        </div>
        <hr style="border-color:#333; opacity:0.3; margin: 30px 0;">

        <div class="d-flex justify-content-between mb-3">
            <span style="font-weight:bold; font-size:0.8rem; color:#888;">FOOD & DRINKS</span>
            <a href="javascript:history.back()" class="edit-link">Add <i class="fas fa-chevron-right"></i></a>
        </div>

        <% if (foodTotal > 0) { %>
            <div class="line-item">
                <div class="col-desc">
                    <div class="item-name" style="font-size:0.95rem;">
                        <%= (foodItems != null && !foodItems.isEmpty()) ? foodItems : "Food Combo" %>
                    </div>
                </div>
                <div class="col-qty">1</div> <div class="col-price">
                    RM <%= String.format("%.2f", foodTotal) %>
                </div>
            </div>
        <% } else { %>
            <div class="line-item" style="color:#666; font-style:italic;">No food selected</div>
        <% } %>

    </div>

    <div style="position: fixed; bottom: 0; width: 100%; background: #000; padding: 20px; text-align: center; border-top: 1px solid #222; z-index:100;">
        <button class="checkout-btn" onclick="alert('Payment Successful! Enjoy your movie.')">
            Checkout - RM <%= String.format("%.2f", grandTotal) %>
        </button>
    </div>

</body>
</html>