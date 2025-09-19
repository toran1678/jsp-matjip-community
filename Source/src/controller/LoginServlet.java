package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    	String remember = request.getParameter("remember"); // 로그인 유지 확인

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", Integer.valueOf(user.getUserid()));
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("username", user.getUsername());
            
            if ("on".equals(remember)) {
                Cookie emailCookie = new Cookie("userEmail", user.getEmail());
                Cookie nameCookie = new Cookie("username", user.getUsername());
                emailCookie.setMaxAge(60 * 60 * 24 * 7); // 7일
                nameCookie.setMaxAge(60 * 60 * 24 * 7); 
                emailCookie.setPath("/");
                nameCookie.setPath("/");
                response.addCookie(emailCookie);
                response.addCookie(nameCookie);
            }
            
            response.sendRedirect("/jsp_project/main");
        } else {
            response.sendRedirect("/jsp_project/views/login.jsp?error=loginFailed");
        }
    }
}
