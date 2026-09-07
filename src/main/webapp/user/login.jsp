<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Sinema Movies</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />

    <style>
      /* 1. The Background Gradient */
      body {
        background: linear-gradient(
          135deg,
          #eb3349 0%,
          #f45c43 40%,
          #a445b2 100%
        );
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }

      /* 2. The Dark Card */
      .login-card {
        background-color: #1c1c1c;
        width: 100%;
        max-width: 400px;
        padding: 40px;
        border-radius: 8px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.5);
        color: #ffffff;
      }

      /* 3. Input Fields Customization */
      .form-control {
        background-color: #2b2b2b;
        border: 1px solid #444;
        color: #fff;
        height: 50px;
        border-right: none; /* Merge with the eye button */
      }

      .form-control:focus {
        background-color: #2b2b2b;
        color: #fff;
        border-color: #eb3349;
        box-shadow: none;
        border-right: none;
      }

      /* Fix the border color of the eye button when input is focused */
      .form-control:focus + .input-group-text {
        border-color: #eb3349;
      }

      .form-label {
        color: #aaa;
        font-size: 0.9rem;
      }

      /* 4. The Eye Icon Container */
      .input-group-text {
        background-color: #2b2b2b;
        border: 1px solid #444;
        border-left: none;
        cursor: pointer;
        color: #aaa;
      }

      .input-group-text:hover {
        color: #fff;
      }

      /* 5. The Gradient Button */
      .btn-gradient {
        background: linear-gradient(90deg, #eb3349, #a445b2);
        border: none;
        color: white;
        font-weight: bold;
        height: 50px;
        width: 100%;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-top: 20px;
      }

      .btn-gradient:hover {
        opacity: 0.9;
        color: white;
      }

      .forgot-link {
        color: #888;
        text-decoration: none;
        font-size: 0.9rem;
        display: block;
        margin-top: 15px;
      }

      .signup-text {
        color: #fff;
        margin-top: 30px;
        font-size: 0.9rem;
      }

      .signup-link {
        color: #eb3349;
        text-decoration: none;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <div class="position-absolute top-0 start-0 p-4">
      <a class="text-decoration-none">
        <img
          src="<%= request.getContextPath() %>/images/logo2.png"
          alt="Logo"
          height="400"
        />
      </a>
    </div>

    <div class="login-card text-center">
      <h2 class="mb-5 fw-bold">SIGN IN</h2>

      <form action="<%= request.getContextPath() %>/login" method="POST">
        <div class="mb-3 text-start">
          <label for="email" class="form-label">Email</label>
          <input
            type="email"
            class="form-control"
            id="email"
            name="email"
            style="border-right: 1px solid #444"
            required
          />
        </div>

        <div class="mb-3 text-start">
          <label for="password" class="form-label">Password</label>
          <div class="input-group">
            <input
              type="password"
              class="form-control"
              id="password"
              name="password"
              required
            />
            <span class="input-group-text" id="togglePassword">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                fill="currentColor"
                class="bi bi-eye"
                viewBox="0 0 16 16"
              >
                <path
                  d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8zM1.173 8a13.133 13.133 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13.133 13.133 0 0 1 14.828 8c-.058.087-.122.183-.195.288-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5c-2.12 0-3.879-1.168-5.168-2.457A13.134 13.134 0 0 1 1.172 8z"
                />
                <path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5z" />
              </svg>
            </span>
          </div>
        </div>

        <button type="submit" class="btn btn-gradient">SIGN IN</button>
      </form>

      <div class="signup-text">
        Need an account? <a href="signup.jsp" class="signup-link">Sign Up</a>
      </div>
    </div>

    <script>
      const togglePassword = document.querySelector("#togglePassword");
      const password = document.querySelector("#password");

      togglePassword.addEventListener("click", function (e) {
        // 1. Toggle the type attribute
        const type =
          password.getAttribute("type") === "password" ? "text" : "password";
        password.setAttribute("type", type);

        // 2. Optional: Change opacity or icon color to indicate state
        this.style.color = type === "text" ? "#eb3349" : "#aaa";
      });
    </script>
  </body>
</html>
