package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.UserDAO;
import dao.PostDAO;
import model.User;

import java.io.IOException;

@WebServlet("/deletePost")
public class DeletePostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 게시글 ID 가져오기
        String postIdStr = request.getParameter("postId");
        if (postIdStr == null) {
            response.sendRedirect("/jsp_project/myPage");
            return;
        }

        // 로그인 사용자 이메일 확인
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");

        if (email == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }

        // 유저 정보 조회
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }

        int postId = Integer.parseInt(postIdStr);
        int userId = Integer.parseInt(user.getUserid());

        // 게시글 삭제
        PostDAO postDAO = new PostDAO();
        postDAO.deletePost(postId, userId);

        // 삭제 성공 여부에 따라 리다이렉트
        response.sendRedirect("/jsp_project/myPage?tab=posts");
    }
}
