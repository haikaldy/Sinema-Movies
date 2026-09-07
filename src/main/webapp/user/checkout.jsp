<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@taglib prefix="c"
uri="jakarta.tags.core"%> <%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Checkout | Sinema Movies</title>

    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />

    <style>
      body {
        background: #121212;
        color: #fff;
        font-family: "Segoe UI", sans-serif;
        min-height: 100vh;
        padding-bottom: 120px;
      }

      .header-container {
        padding: 20px 30px;
        position: relative;
      }
      .close-btn {
        position: absolute;
        top: 20px;
        right: 30px;
        color: #fff;
        font-size: 1.5rem;
        text-decoration: none;
      }

      .progress-steps {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-bottom: 20px;
      }
      .step-item {
        text-align: center;
        position: relative;
        width: 120px;
      }
      .step-circle {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background: #333;
        color: #888;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 8px;
        font-weight: 700;
        z-index: 2;
      }
      .step-label {
        font-size: 0.8rem;
        color: #888;
      }
      .step-item:not(:last-child)::after {
        content: "";
        position: absolute;
        top: 15px;
        right: -50%;
        width: 100%;
        height: 2px;
        background: #333;
        z-index: 1;
      }
      .step-item.completed .step-circle {
        background: #eb3349;
        color: #fff;
      }
      .step-item.active .step-circle {
        background: #eb3349;
        color: #fff;
        border: 2px solid #fff;
      }
      .step-item.active .step-label {
        color: #fff;
      }

      .wrap {
        width: min(900px, 92%);
        margin: 0 auto;
      }

      .info-bar {
        padding: 14px 16px;
        background: #0f0f0f;
        border: 1px solid #222;
        border-radius: 14px;
        display: flex;
        justify-content: space-between;
        gap: 12px;
        flex-wrap: wrap;
        margin-bottom: 14px;
      }
      .info-left {
        font-weight: 900;
        letter-spacing: 0.3px;
      }
      .info-right {
        color: #bbb;
        font-size: 0.95rem;
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
      .pill {
        display: inline-flex;
        gap: 8px;
        align-items: center;
        padding: 6px 10px;
        background: #141414;
        border: 1px solid #222;
        border-radius: 999px;
        color: #ddd;
      }
      .pill i {
        color: #eb3349;
      }

      .cardish {
        background: #0f0f0f;
        border: 1px solid #222;
        border-radius: 14px;
        padding: 16px;
        margin-bottom: 14px;
      }
      .rowline {
        display: flex;
        justify-content: space-between;
        gap: 12px;
        margin: 8px 0;
      }
      .label {
        color: #aaa;
      }
      .value {
        font-weight: 800;
        text-align: right;
      }
      .muted {
        color: #888;
      }

      .total-box {
        border-top: 1px solid #222;
        margin-top: 12px;
        padding-top: 12px;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
      .grand {
        font-size: 1.25rem;
        font-weight: 900;
      }

      .footer-bar {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        background: #121212;
        border-top: 1px solid #222;
        padding: 18px 20px;
        z-index: 100;
        display: flex;
        justify-content: center;
      }
      .btn-pay {
        background: #eb3349;
        color: #fff;
        border: none;
        padding: 14px 70px;
        border-radius: 999px;
        font-weight: 900;
        font-size: 1.1rem;
        transition: 0.2s;
      }
      .btn-pay:hover {
        background: #ff4b5c;
        transform: translateY(-1px);
      }

      .btn-back {
        background: transparent;
        border: 1px solid #333;
        color: #ddd;
        padding: 10px 18px;
        border-radius: 999px;
        font-weight: 700;
      }
      .btn-back:hover {
        border-color: #555;
        color: #fff;
      }
    </style>
  </head>

  <body>
    <div class="header-container">
      <a href="javascript:history.back()" class="close-btn"
        ><i class="fas fa-times"></i
      ></a>
      <div class="progress-steps">
        <div class="step-item completed">
          <div class="step-circle"><i class="fas fa-check"></i></div>
          <div class="step-label">Select Seats</div>
        </div>
        <div class="step-item completed">
          <div class="step-circle"><i class="fas fa-check"></i></div>
          <div class="step-label">Foods & Drinks</div>
        </div>
        <div class="step-item active">
          <div class="step-circle">3</div>
          <div class="step-label">Payment</div>
        </div>
      </div>
    </div>

    <div class="wrap">
      <!-- Top info -->
      <div class="info-bar">
        <div class="info-left">
          <c:out value="${sessionScope.movieTitle}" />
        </div>
        <div class="info-right">
          <span class="pill"
            ><i class="fa-solid fa-location-dot"></i>
            <c:out value="${sessionScope.hall}"
          /></span>
          <span class="pill"
            ><i class="fa-regular fa-calendar"></i>
            <fmt:formatDate
              value="${sessionScope.showDate}"
              pattern="dd MMM yyyy"
          /></span>
          <span class="pill"
            ><i class="fa-regular fa-clock"></i>
            <fmt:formatDate value="${sessionScope.showTime}" pattern="hh:mm a"
          /></span>
        </div>
      </div>

      <!-- Order summary -->
      <div class="cardish">
        <div style="font-weight: 900; margin-bottom: 10px">
          <i class="fa-solid fa-receipt" style="color: #eb3349"></i> Order
          Summary
        </div>

        <div class="rowline">
          <span class="label">Seats</span>
          <span class="value"
            ><c:out value="${sessionScope.selectedSeats}"
          /></span>
        </div>

        <div class="rowline">
          <span class="label">Ticket Qty</span>
          <span class="value"><c:out value="${sessionScope.ticketQty}" /></span>
        </div>

        <div class="rowline">
          <span class="label">Ticket Price</span>
          <span class="value"
            >RM
            <fmt:formatNumber
              value="${sessionScope.ticketPrice}"
              minFractionDigits="2"
              maxFractionDigits="2"
          /></span>
        </div>

        <div class="rowline">
          <span class="label">Ticket Total</span>
          <span class="value"
            >RM
            <fmt:formatNumber
              value="${sessionScope.ticketTotalValue}"
              minFractionDigits="2"
              maxFractionDigits="2"
          /></span>
        </div>

        <hr style="border-color: #222" />

        <div class="rowline">
          <span class="label">Snacks</span>
          <span class="value">
            <c:choose>
              <c:when test="${not empty sessionScope.snackSummary}">
                <c:out value="${sessionScope.snackSummary}" />
              </c:when>
              <c:otherwise><span class="muted">None</span></c:otherwise>
            </c:choose>
          </span>
        </div>

        <div class="rowline">
          <span class="label">Snack Total</span>
          <span class="value">
            RM
            <fmt:formatNumber
              value="${sessionScope.snackTotalValue}"
              minFractionDigits="2"
              maxFractionDigits="2"
            />
          </span>
        </div>

        <div class="total-box">
          <span class="label">Grand Total</span>
          <span class="grand">
            RM
            <fmt:formatNumber
              value="${sessionScope.grandTotalValue}"
              minFractionDigits="2"
              maxFractionDigits="2"
            />
          </span>
        </div>

        <div class="mt-3 d-flex justify-content-between align-items-center">
          <a
            class="btn-back"
            href="<%=request.getContextPath()%>/SnackSelectionControllerV2"
            >Back</a
          >

          <c:if test="${not empty requestScope.error}">
            <span class="text-danger fw-bold"
              ><c:out value="${requestScope.error}"
            /></span>
          </c:if>
        </div>
      </div>
    </div>

    <!-- PAY NOW -->
    <div class="footer-bar">
      <form
        method="post"
        action="<%=request.getContextPath()%>/CheckoutController"
      >
        <button type="submit" class="btn-pay">PAY NOW</button>
      </form>
    </div>
  </body>
</html>
