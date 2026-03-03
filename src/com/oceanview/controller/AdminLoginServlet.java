package com.oceanview.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AdminLoginServlet")
    public class AdminLoginServlet extends HttpServlet {

        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String username = request.getParameter("username");
            String password = request.getParameter("password");


            if ("admin".equals(username) && "admin123".equals(password)) {

                HttpSession session = request.getSession();
                session.setAttribute("admin", true);

                response.sendRedirect("admin-dashboard.jsp");

            } else {
                request.setAttribute("error", "Invalid Admin Credentials");
                request.getRequestDispatcher("admin-login.jsp").forward(request, response);
            }
        }
    }

