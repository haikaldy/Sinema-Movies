package com.mycompany.sinema.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Base64;

@WebServlet("/controllerV2")
public class SignInController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        String url = "jdbc:mariadb://localhost:3306/sinema";
        String dbUser = "root";
        String dbPassword = "";

        try {
            Class.forName("org.mariadb.jdbc.Driver");

            // Hash password
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            String hashedPassword = Base64.getEncoder().encodeToString(hash);

            String sql = "INSERT INTO users (username, password_hash, email, phone_no) VALUES (?,?,?,?)";

            try (Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);
                    PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, username);
                ps.setString(2, hashedPassword);
                ps.setString(3, email);
                ps.setString(4, phone);
                ps.executeUpdate();

                HttpSession session = request.getSession();
                session.setAttribute("username", username);

                response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            }

        } catch (Exception e) {
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
