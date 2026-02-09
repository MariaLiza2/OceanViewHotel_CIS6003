package com.oceanview.service;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import com.oceanview.util.PasswordUtil;

public class AuthService {

    private UserDAO UserDAO = new UserDAO();

    public User login(String username, String password) {
        String hashed = PasswordUtil.hashPassword(password);
        return UserDAO.validateUser(username, hashed);
    }
}
