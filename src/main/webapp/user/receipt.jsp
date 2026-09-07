<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@taglib prefix="fmt"
uri="jakarta.tags.fmt"%> <%@taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Receipt | Sinema Movies</title>

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
        padding: 20px;
      }
      .wrap {
        width: min(900px, 92%);
        margin: 0 auto;
      }
      .cardx {
        background: #0f0f0f;
        border: 1px solid #222;
        border-radius: 14px;
        padding: 18px;
        margin-bottom: 12px;
      }
      .title {
        font-weight: 900;
        font-size: 1.2rem;
      }
      .muted {
        color: #aaa;
      }
      .rowx {
        display: flex;
        justify-content: space-between;
        gap: 14px;
        flex-wrap: wrap;
        padding: 10px 0;
        border-bottom: 1px solid #222;
      }
      .rowx:last-child {
        border-bottom: none;
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
      .bigTotal {
        font-size: 1.5rem;
        font-weight: 900;
        color: #fff;
      }
      .btnx {
        background: #eb3349;
        border: none;
        color: #fff;
        font-weight: 800;
        border-radius: 30px;
        padding: 10px 20px;
      }
      .btnx:hover {
        background: #ff4b5c;
      }
      .btnGhost {
        background: transparent;
        border: 1px solid #333;
        color: #fff;
        font-weight: 800;
        border-radius: 30px;
        padding: 10px 20px;
      }
      .btnGhost:hover {
        border-color: #555;
      }
    </style>
  </head>

  <body>
    <div class="wrap">
      <div class="cardx">
        <div
          class="d-flex justify-content-between align-items-center flex-wrap gap-2"
        >
          <div>
            <div class="title">
              <i class="fa-solid fa-receipt"></i> Payment Receipt
            </div>
            <div class="muted">
              Booking ID: <b>#<c:out value="${booking_id}" /></b> • Status:
              <b><c:out value="${status}" /></b>
            </div>
          </div>
          <div class="d-flex gap-2 flex-wrap">
            <span class="pill"
              ><i class="fa-solid fa-film"></i> <c:out value="${movieTitle}"
            /></span>
            <span class="pill"
              ><i class="fa-solid fa-location-dot"></i> <c:out value="${hall}"
            /></span>
          </div>
        </div>
      </div>

      <div class="cardx">
        <div class="rowx">
          <span class="muted">Customer</span>
          <span
            ><b><c:out value="${sessionScope.username}" /></b
          ></span>
        </div>

        <div class="rowx">
          <span class="muted">Seats</span>
          <span
            ><b><c:out value="${seats}" /></b
          ></span>
        </div>

        <div class="rowx">
          <span class="muted">Tickets</span>
          <span>
            <b><c:out value="${ticket_qty}" /></b>
            x RM
            <fmt:formatNumber
              value="${ticket_price}"
              minFractionDigits="2"
              maxFractionDigits="2"
            />
          </span>
        </div>

        <div class="rowx">
          <span class="muted">Snacks</span>
          <span>
            <b>
              <c:choose>
                <c:when test="${not empty snack_summary}">
                  <c:out value="${snack_summary}" />
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </b>
          </span>
        </div>
      </div>

      <div class="cardx">
        <div class="rowx">
          <span class="muted">Snack Total</span>
          <span>
            RM
            <fmt:formatNumber
              value="${snack_total}"
              minFractionDigits="2"
              maxFractionDigits="2"
            />
          </span>
        </div>

        <div class="rowx">
          <span class="muted">Grand Total</span>
          <span class="bigTotal">
            RM
            <fmt:formatNumber
              value="${grand_total}"
              minFractionDigits="2"
              maxFractionDigits="2"
            />
          </span>
        </div>
      </div>

      <div
        class="cardx d-flex justify-content-between align-items-center flex-wrap gap-2"
      >
        <button class="btnGhost" type="button" onclick="window.print()">
          <i class="fa-solid fa-print"></i> Print
        </button>
        <a class="btnx" href="${pageContext.request.contextPath}/user_page">
          Back to Home
        </a>
      </div>
    </div>
  </body>
</html>
