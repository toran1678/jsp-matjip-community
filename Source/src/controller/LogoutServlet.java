package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // 세션 무효화
        HttpSession session = request.getSession(false); // 기존 세션 가져오기
        if (session != null) {
            session.invalidate();
        }

        // 쿠키 제거
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("userEmail".equals(cookie.getName()) || "username".equals(cookie.getName())) {
                    cookie.setMaxAge(0); // 즉시 만료
                    cookie.setPath("/"); // 경로 명시
                    response.addCookie(cookie);
                }
            }
        }

        // 로그인 페이지로 이동
        response.sendRedirect("/jsp_project/views/login.jsp");
    }
}