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
      /* 1. Background Gradient */
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
      .signup-card {
        background-color: #1c1c1c;
        width: 100%;
        max-width: 450px;
        padding: 40px;
        border-radius: 8px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.5);
        color: #ffffff;
      }

      /* 3. Input Styling */
      .form-control {
        background-color: #2b2b2b;
        border: 1px solid #444;
        color: #fff;
        height: 50px;
      }

      .form-control:focus {
        background-color: #2b2b2b;
        color: #fff;
        border-color: #eb3349;
        box-shadow: none;
      }

      .input-group-text {
        background-color: #2b2b2b;
        border: 1px solid #444;
        color: #aaa;
        border-right: none;
      }

      .form-label {
        color: #aaa;
        font-size: 0.9rem;
        margin-top: 10px;
      }

      /* 4. Gradient Button */
      .btn-gradient {
        background: linear-gradient(90deg, #eb3349, #a445b2);
        border: none;
        color: white;
        font-weight: bold;
        height: 50px;
        width: 100%;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-top: 30px;
      }

      .btn-gradient:hover {
        opacity: 0.9;
        color: white;
      }

      /* 5. Links */
      .login-text {
        color: #fff;
        margin-top: 25px;
        font-size: 0.9rem;
      }

      .login-link {
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

    <div class="signup-card text-center">
      <h2 class="mb-4 fw-bold">SIGN UP</h2>

      <form action="<%= request.getContextPath() %>/controllerV2" method="post">
        <div class="mb-3 text-start">
          <label for="username" class="form-label">Username</label>
          <input
            type="text"
            class="form-control"
            id="username"
            name="username"
            placeholder="Pick a username"
            required
          />
        </div>

        <div class="mb-3 text-start">
          <label for="mobile" class="form-label">Mobile Number</label>
          <div class="input-group">
            <span class="input-group-text">+60</span>
            <input
              type="tel"
              class="form-control"
              id="phone"
              name="phone"
              placeholder="12 345 6789"
              required
            />
          </div>
        </div>

        <div class="mb-3 text-start">
          <label for="email" class="form-label">Email Address</label>
          <input
            type="email"
            class="form-control"
            id="email"
            name="email"
            required
          />
        </div>

        <div class="mb-3 text-start">
          <label for="password" class="form-label">Password</label>
          <input
            type="password"
            class="form-control"
            id="password"
            name="password"
            required
          />
        </div>

        <button type="submit" class="btn btn-gradient">SIGN UP</button>
      </form>

      <div class="login-text">
        Have an account? <a href="login.jsp" class="login-link">Sign In</a>
      </div>
    </div>
  </body>
</html>
