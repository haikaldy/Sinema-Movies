package com.mycompany.sinema.controller;

import com.mycompany.sinema.model.Admin;
import com.mycompany.sinema.DAO.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/profiles")
public class AdminProfileController extends HttpServlet {

    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Admin sessionAdmin = (session == null) ? null : (Admin) session.getAttribute("admin");

        // fallback if your project uses a different session key:
        if (sessionAdmin == null && session != null) {
            sessionAdmin = (Admin) session.getAttribute("loggedAdmin");
        }

        if (sessionAdmin == null) {
            response.sendRedirect(request.getContextPath() + "/admin_login.jsp");
            return;
        }

        try {
            Admin full = adminDAO.getProfileByAdminId(sessionAdmin.getAdminId());
            request.setAttribute("admin", full);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error loading admin profile", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Admin sessionAdmin = (session == null) ? null : (Admin) session.getAttribute("admin");
        if (sessionAdmin == null && session != null)
            sessionAdmin = (Admin) session.getAttribute("loggedAdmin");

        if (sessionAdmin == null) {
            response.sendRedirect(request.getContextPath() + "/admin_login.jsp");
            return;
        }

        // form inputs
        String username = request.getParameter("username");
        String userEmail = request.getParameter("userEmail");
        String phoneNo = request.getParameter("phoneNo");

        String adminEmail = request.getParameter("adminEmail");
        String position = request.getParameter("position");
        String newPassword = request.getParameter("newPassword");

        try {
            Admin updated = new Admin();
            updated.setAdminId(sessionAdmin.getAdminId());
            updated.setUserId(sessionAdmin.getUserId());
            updated.setRole(sessionAdmin.getRole()); // not editable

            updated.setUsername(username);
            updated.setUserEmail(userEmail);
            updated.setPhoneNo(phoneNo);

            updated.setAdminEmail(adminEmail);
            updated.setPosition(position);

            boolean ok = adminDAO.updateProfile(updated, newPassword);

            // reload latest info
            Admin full = adminDAO.getProfileByAdminId(sessionAdmin.getAdminId());
            request.setAttribute("admin", full);

            if (ok) {
                request.setAttribute("success", "Profile updated successfully ✅");
                // update session email/position too (optional but nice)
                sessionAdmin.setAdminEmail(full.getAdminEmail());
                sessionAdmin.setPosition(full.getPosition());
            } else {
                request.setAttribute("error", "No changes saved.");
            }

            request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error updating admin profile", e);
        }
    }
}
