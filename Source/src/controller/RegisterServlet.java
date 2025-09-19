package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = new User(username, email, password);
        UserDAO userDAO = new UserDAO();
        int result = userDAO.registerUser(user);

        if (result > 0) {
            response.sendRedirect("/jsp_project/views/login.jsp");
        } else {
            response.sendRedirect("/jsp_project/views/fail.jsp");
        }
    }
}