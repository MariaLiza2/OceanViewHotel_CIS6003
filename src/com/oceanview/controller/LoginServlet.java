package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

import javax.servlet.annotation.WebServlet; // 1. Add this import
import javax.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Basic Validation
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            req.setAttribute("error", "Please enter both username and password");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        UserDAO userDao = new UserDAO();
        User user = userDao.validateUser(username, password);

        if (user != null) {
            // Success: Create session and store user data
            HttpSession session = req.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("role", user.getRole());

            // Redirect to dashboard
            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        } else {
            // Failure: Back to login with error
            req.setAttribute("error", "Invalid username or password");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}