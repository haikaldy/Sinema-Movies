package com.mycompany.sinema.controller;

import com.mycompany.sinema.DAO.BookingDAO;
import com.mycompany.sinema.model.ReportRow;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/report")
public class ReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            BookingDAO dao = new BookingDAO();
            List<ReportRow> rows = dao.getReportRows();

            request.setAttribute("reportRows", rows);
            request.getRequestDispatcher("/admin/report.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load report", e);
        }
    }
}
