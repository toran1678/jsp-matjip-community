package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.UserDAO;
import dao.PostDAO;
import dao.CommentDAO;
import model.User;
import model.Post;
import model.Comment;

import java.io.IOException;
import java.util.List;

@WebServlet("/myPage")
public class MyPageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");

        if (email == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }

        // 사용자 정보 가져오기
        UserDAO userDAO = new UserDAO();
        PostDAO postDAO = new PostDAO();
        CommentDAO commentDAO = new CommentDAO();
        
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }
        
        int userId = Integer.parseInt(user.getUserid());
        List<Post> myPosts = postDAO.getPostsByUserId(userId);
        List<Post> likedPosts = postDAO.getLikedPostsByUserId(userId);
        List<Comment> myComments = commentDAO.getCommentsByUserId(userId);
        
        request.setAttribute("myPosts", myPosts);
        request.setAttribute("likedPosts", likedPosts);
        request.setAttribute("myComments", myComments);
        request.setAttribute("user", user);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/myPage.jsp");
        dispatcher.forward(request, response);
    }
}
