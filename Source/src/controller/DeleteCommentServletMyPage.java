package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.CommentDAO;
import dao.UserDAO;
import model.User;

import java.io.IOException;

@WebServlet("/deleteCommentMyPage")
public class DeleteCommentServletMyPage extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String commentIdStr = request.getParameter("commentId");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");

        if (email == null || commentIdStr == null) {
            response.sendRedirect("/jsp_project/views/login.jsp");
            return;
        }

        int commentId = Integer.parseInt(commentIdStr);

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);
        int userId = Integer.parseInt(user.getUserid());

        CommentDAO commentDAO = new CommentDAO();
        commentDAO.deleteCommentMyPage(commentId, userId);

        response.sendRedirect("/jsp_project/myPage?tab=comments");
    }
}
