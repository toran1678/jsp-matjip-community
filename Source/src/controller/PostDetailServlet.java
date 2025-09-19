package controller;

import dao.PostDAO;
import dao.CommentDAO;
import dao.LikeDAO;
import model.Post;
import model.Comment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/postDetail")
public class PostDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String postIdParam = request.getParameter("postId");
        if (postIdParam == null || !postIdParam.matches("\\d+")) {
            response.sendRedirect("board");
            return;
        }

        int postId = Integer.parseInt(postIdParam);
        PostDAO dao = new PostDAO();
        CommentDAO commentDao = new CommentDAO();
        
        Post post = dao.getPostById(postId);
        List<Comment> comments = commentDao.getCommentsByPostId(postId);
        
        // 좋아요 여부 확인
        HttpSession session = request.getSession(false);
        boolean liked = false;
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (Integer) session.getAttribute("userId");
            LikeDAO likeDao = new LikeDAO();
            liked = likeDao.hasUserLikedPost(postId, userId);
        }

        if (post == null) {
            response.sendRedirect("board");
            return;
        }

        request.setAttribute("post", post);
        request.setAttribute("comments", comments);
        request.setAttribute("liked", liked);
        request.getRequestDispatcher("views/postDetail.jsp").forward(request, response);
    }
}
