package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.UserDAO;
import model.User;

import java.io.IOException;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");

        if (email == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);

        // 현재 비밀번호 검증
        if (!user.getPassword().equals(currentPassword)) {
            // 현재 비밀번호가 다르면 실패
            response.sendRedirect("/jsp_project/myPage?tab=edit&error=wrongPassword");
            return;
        }

        // 새 비밀번호와 확인이 일치하는지 확인
        if (newPassword != null && !newPassword.isEmpty()) {
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("/jsp_project/myPage?tab=edit&error=passwordMismatch");
                return;
            }
        }

        // 정보 업데이트
        boolean success = userDAO.updateUserProfile(email, username, newPassword);

        if (success) {
            response.sendRedirect("/jsp_project/myPage?tab=edit&success=true");
        } else {
            response.sendRedirect("/jsp_project/myPage?tab=edit&error=updateFailed");
        }
    }
}
