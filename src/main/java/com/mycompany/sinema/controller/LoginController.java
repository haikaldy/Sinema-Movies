package com.mycompany.sinema.controller;

import com.mycompany.sinema.model.User;
import com.mycompany.sinema.DAO.UserDAO;
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
import java.sql.ResultSet;
import java.util.Base64;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath() + "/user/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            byte[] hash = md.digest(
                    password.getBytes(StandardCharsets.UTF_8));

            String hashedPassword = Base64.getEncoder().encodeToString(hash);

            UserDAO userDAO = new UserDAO();

            User user = userDAO.authenticate(email, hashedPassword);

            if (user != null) {

                HttpSession session = request.getSession();

                session.setAttribute(
                        "user_id",
                        user.getUserId());

                session.setAttribute(
                        "username",
                        user.getUsername());

                response.sendRedirect(
                        request.getContextPath() + "/user_page");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                                + "/user/login.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/user/login.jsp?error=server");
        }
    }
}
