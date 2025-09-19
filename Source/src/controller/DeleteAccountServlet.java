package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.UserDAO;
import model.User;

import java.io.IOException;

@WebServlet("/deleteAccount")
public class DeleteAccountServlet extends HttpServlet {
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

        // JS로 currentPassword 값을 복사해서 전송한 deletePassword 받기
        String inputPassword = request.getParameter("deletePassword");

        if (inputPassword == null || inputPassword.isEmpty()) {
            response.sendRedirect("/jsp_project/myPage?tab=profile&error=missingPassword");
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);

        // DB에 저장된 비밀번호와 비교
        if (!user.getPassword().equals(inputPassword)) {
            response.sendRedirect("/jsp_project/myPage?tab=profile&error=wrongPassword");
            return;
        }

        // 삭제 처리
        boolean deleted = userDAO.deleteUserByEmail(email);

        if (deleted) {
            session.invalidate();
            response.sendRedirect("/jsp_project/views/login.jsp?deleted=true");
        } else {
            response.sendRedirect("/jsp_project/myPage?tab=profile&error=deleteFailed");
        }
    }
}