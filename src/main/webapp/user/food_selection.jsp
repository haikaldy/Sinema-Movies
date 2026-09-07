<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${movieTitle} | Sinema Movies</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { background-color: #121212; color: white; font-family: 'Segoe UI', sans-serif; padding-bottom: 120px; }

        /* --- HEADER & PROGRESS --- */
        .header-container { padding: 20px 30px; position: relative; }
        .close-btn { position: absolute; top: 20px; right: 30px; color: #fff; font-size: 1.5rem; text-decoration: none; }

        .progress-steps { display: flex; justify-content: center; align-items: center; margin-bottom: 20px; }
        .step-item { text-align: center; position: relative; width: 140px; }
        .step-circle { width: 30px; height: 30px; border-radius: 50%; background-color: #333; color: #888; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: bold; position: relative; z-index: 2; }
        .step-label { font-size: 0.8rem; color: #888; }
        .step-item:not(:last-child)::after { content: ''; position: absolute; top: 15px; right: -50%; width: 100%; height: 2px; background-color: #333; z-index: 1; }

        .step-item.completed .step-circle { background-color: #eb3349; color: white; }
        .step-item.active .step-circle { background-color: #eb3349; color: white; border: 2px solid white; }
        .step-item.active .step-label { color: white; }

        /* --- FOOD GRID --- */
        .food-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; padding: 20px 5%; }

        .food-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            position: relative;
            color: black;
            transition: transform 0.2s;
        }
        .food-card:hover { transform: translateY(-5px); }

        .promo-tag {
            position: absolute; top: 10px; left: 0; right: 0;
            text-align: center; font-weight: 800; font-size: 1.5rem;
            color: rgba(235, 51, 73, 0.2);
            z-index: 1; pointer-events: none; text-transform: uppercase;
        }

        .food-img-container { height: 180px; display: flex; align-items: center; justify-content: center; position: relative; z-index: 2; }
        .food-img { max-height: 140px; width: auto; filter: drop-shadow(0 5px 10px rgba(0,0,0,0.3)); }

        .food-details { padding: 15px; background-color: #fff; position: relative; z-index: 2; border-top: 1px solid #eee; }
        .food-title { font-weight: 800; font-size: 0.9rem; margin-bottom: 5px; text-transform: uppercase; }
        .food-price { font-weight: bold; font-size: 1rem; color: #eb3349; margin-bottom: 5px; }

        .btn-add {
            width: 100%;
            border: 2px solid #eb3349;
            background: transparent;
            color: #eb3349;
            font-weight: bold;
            padding: 8px;
            border-radius: 5px;
            margin-top: 10px;
            transition: all 0.2s;
        }
        .btn-add:hover, .btn-add.selected { background-color: #eb3349; color: white; }

        /* --- BOTTOM CHECKOUT BAR --- */
        .footer-bar {
            position: fixed; bottom: 0; left: 0; width: 100%;
            background-color: #eb3349;
            color: white; padding: 15px 22px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 -4px 15px rgba(0,0,0,0.3); z-index: 100;
        }
        .footer-left { font-weight: 800; display:flex; flex-direction: column; line-height: 1.1; }
        .footer-left small { font-weight: 600; opacity: .85; }

        .btn-continue {
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.35);
            color: white;
            font-weight: 900;
            padding: 10px 16px;
            border-radius: 10px;
            text-transform: uppercase;
        }
        .btn-continue:hover { background: rgba(255,255,255,0.25); }

        .qty-control {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    margin-top: 8px;
}

.qty-control button {
    width: 30px;
    height: 30px;
    border: none;
    border-radius: 50%;
    cursor: pointer;
    font-weight: bold;
}

.qty-value {
    min-width: 20px;
    text-align: center;
    font-weight: bold;
}
    </style>
</head>

<body>

    <div class="header-container">
        <a href="javascript:history.back()" class="close-btn"><i class="fas fa-times"></i></a>
        <div class="progress-steps">
            <div class="step-item completed">
                <div class="step-circle"><i class="fas fa-check"></i></div>
                <div class="step-label">Select Seats</div>
            </div>
            <div class="step-item active">
                <div class="step-circle">2</div>
                <div class="step-label">Food & Drinks</div>
            </div>
            <div class="step-item">
                <div class="step-circle">3</div>
                <div class="step-label">Checkout & Payment</div>
            </div>
        </div>
    </div>

    <div class="food-grid">
        <c:forEach var="s" items="${snacks}" varStatus="st">
            <div class="food-card">
                <c:if test="${st.first}">
                    <div class="promo-tag">RECOMMENDED</div>
                </c:if>

                <div class="food-img-container">
                    <img
                        src="${pageContext.request.contextPath}${fn:replace(s.imagePath,'..','')}"
                        class="food-img"
                        alt="${s.snackName}">
                </div>

                <div class="food-details">
                    <div class="food-title">${s.snackName}</div>

                    <div class="food-price">
                        RM <fmt:formatNumber value="${s.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </div>

                    <div class="qty-control" style="display:none;">
                        <button type="button" class="qty-minus">−</button>
                        <span class="qty-value">1</span>
                        <button type="button" class="qty-plus">+</button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- ✅ Hidden form (POST to SnackSelectionControllerV2) -->
    <form id="snackForm" method="post" action="<%=request.getContextPath()%>/SnackSelectionControllerV2">
        <input type="hidden" name="snackSummary" id="snackSummary">
        <input type="hidden" name="snackTotalValue" id="snackTotalValue">
    </form>

    <!-- ✅ CHECKOUT BAR -->
    <div class="footer-bar">
        <div class="footer-left">
            <small>Total</small>
            <span id="grandTotal">RM 0.00</span>
        </div>

        <button class="btn-continue" type="button" onclick="checkout()">
            Checkout <i class="fa-solid fa-arrow-right ms-2"></i>
        </button>
    </div>

<script>

    quantityControl.style.display = 'flex';

    plusButton.addEventListener('click', () => {
    quantity++;
    quantityText.textContent = quantity;
    updateTotal();
    });

    minusButton.addEventListener('click', () => {
    if (quantity > 1) {
        quantity--;
        quantityText.textContent = quantity;
    } else {
        quantity = 0;
        quantityControl.style.display = 'none';

        // also return the existing food button/card
        // to its unselected state
    }

    updateTotal();
    });

    // ticketTotalValue is from request/session (set by SeatSelectionController)
    const ticketTotal = Number("${ticketTotalValue}");
    let currentTotal = isFinite(ticketTotal) ? ticketTotal : 0;

    // snackId -> {name, price}
    const selectedSnacks = new Map();

    function updateTotalUI(){
        document.getElementById("grandTotal").innerText = "RM " + currentTotal.toFixed(2);
    }
    updateTotalUI();

    function toggleFood(btn) {
        const id = btn.dataset.id;
        const name = btn.dataset.name;
        const price = Number(btn.dataset.price);
        if (!isFinite(price)) return;

        if (btn.classList.contains("selected")) {
            btn.classList.remove("selected");
            btn.innerText = "ADD";
            currentTotal -= price;
            selectedSnacks.delete(id);
        } else {
            btn.classList.add("selected");
            btn.innerText = "ADDED";
            currentTotal += price;
            selectedSnacks.set(id, {name, price});
        }

        updateTotalUI();
    }

    function checkout(){
        // Build snackSummary + snackTotalValue
        let snackSummaryArr = [];
        let snackTotalValue = 0;

        selectedSnacks.forEach((v) => {
            snackSummaryArr.push(v.name + " x1");
            snackTotalValue += Number(v.price);
        });

        document.getElementById("snackSummary").value = snackSummaryArr.join(", ");
        document.getElementById("snackTotalValue").value = snackTotalValue.toFixed(2);

        // ✅ POST to SnackSelectionControllerV2 -> it will set session and redirect to CheckoutController
        document.getElementById("snackForm").submit();
    }
    
</script>

</body>
</html>
