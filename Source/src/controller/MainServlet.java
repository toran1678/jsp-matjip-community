package controller;

import dao.PostDAO;
import dao.CommentDAO;

import model.Post;
import model.Comment;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/main")
public class MainServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    		throws ServletException, IOException {
        PostDAO dao = new PostDAO();
        CommentDAO commentDAO = new CommentDAO();
        
        List<Comment> latestComments = commentDAO.getLatestComments(6);
        request.setAttribute("latestComments", latestComments);
        
        List<Post> latestPosts = dao.getLatestPosts(6); // 6개 최신순 게시물
        List<Post> topLikedPosts = dao.getTopLikedPosts(6); // 6개 좋아요순 게시물
        Post bestReview = dao.getBestReviewThisWeek(); // 최근 7일 좋아요가 가장 많은 게시물
        Post randomPost = dao.getRandomPost();
        
        request.setAttribute("latestPosts", latestPosts);
        request.setAttribute("topLikedPosts", topLikedPosts);
        request.setAttribute("bestReview", bestReview);
        request.setAttribute("randomPost", randomPost);
        
        request.getRequestDispatcher("/main.jsp").forward(request, response);
    }
}