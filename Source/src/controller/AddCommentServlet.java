package controller;

import dao.CommentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/addComment")
public class AddCommentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        int postId = Integer.parseInt(request.getParameter("postId"));
        String content = request.getParameter("content");

        HttpSession session = request.getSession();
        
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }

        CommentDAO dao = new CommentDAO();
        dao.insertComment(postId, userId, content);

        response.sendRedirect("postDetail?postId=" + postId);
    }
}
