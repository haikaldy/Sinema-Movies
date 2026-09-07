package com.mycompany.sinema.controller;

import com.mycompany.sinema.DAO.DashboardDAO;
import com.mycompany.sinema.model.DashboardStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class DashboardController extends HttpServlet {

    private DashboardDAO dashboardDAO;

    @Override
    public void init() {
        dashboardDAO = new DashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        DashboardStats stats = dashboardDAO.getStats();
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("/admin/admin_page.jsp").forward(request, response);
    }
}
