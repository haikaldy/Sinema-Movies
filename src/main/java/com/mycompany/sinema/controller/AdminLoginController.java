package com.mycompany.sinema.controller;

import com.mycompany.sinema.model.Admin;
import com.mycompany.sinema.DAO.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/adminLogin")
public class AdminLoginController extends HttpServlet {

    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String adminEmail = request.getParameter("adminEmail");
        String password = request.getParameter("password");

        if (adminEmail != null)
            adminEmail = adminEmail.trim();
        if (password != null)
            password = password.trim();

        Admin admin = null;
        try {
            admin = adminDAO.authenticate(adminEmail, password);
        } catch (Exception e) {
            throw new ServletException("Error during admin authentication", e);
        }

        if (admin != null) {
            HttpSession session = request.getSession(true);

            session.setAttribute("admin", admin);

            session.setAttribute("adminEmail", admin.getAdminEmail());

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/admin_login.jsp?error=invalid");
        }
    }
}
