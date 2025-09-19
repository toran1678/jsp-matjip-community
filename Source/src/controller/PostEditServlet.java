package controller;

import dao.PostDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Post;

import java.io.IOException;

@WebServlet("/editPost")
public class PostEditServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    private PostDAO postDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");

        if (email == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }

        int userId = userDAO.getUserIdByEmail(email); // 사용자 ID 가져오기

        String postIdParam = request.getParameter("postId");
        if (postIdParam == null) {
            response.sendRedirect("/jsp_project/board");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdParam);
            Post post = postDAO.getPostById(postId);

            // 로그인한 사용자의 게시글인지 확인 (user_id 기준)
            if (post == null || post.getUserId() != userId) {
                response.sendRedirect("/jsp_project/board");
                return;
            }

            request.setAttribute("post", post);
            request.getRequestDispatcher("/views/edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/jsp_project/board");
        }
    }
}
