package com.mycompany.sinema.filter;

import com.mycompany.sinema.model.Admin;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        boolean isLoginPage = uri.endsWith("/admin/admin_login.jsp");
        boolean isLoginServlet = uri.endsWith("/adminLogin");

        if (isLoginPage || isLoginServlet) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        Admin admin = (session == null) ? null : (Admin) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin_login.jsp");
            return;
        }

        chain.doFilter(req, res);
    }
}
