package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.UserDAO;
import dao.LikeDAO;
import model.User;

import java.io.IOException;

@WebServlet("/unlikePost")
public class UnlikePostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String postIdStr = request.getParameter("postId");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");

        if (email == null || postIdStr == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }

        int postId = Integer.parseInt(postIdStr);

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);
        int userId = Integer.parseInt(user.getUserid());

        LikeDAO likeDAO = new LikeDAO();
        
        likeDAO.removeLike(postId, userId);
        // boolean success = postDAO.unlikePost(userId, postId);

        response.sendRedirect("/jsp_project/myPage?tab=likes");
    }
}
