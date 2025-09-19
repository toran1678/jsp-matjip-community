package controller;

import dao.CommentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/deleteComment")
public class DeleteCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer sessionUserId = (Integer) session.getAttribute("userId");

        int commentId = Integer.parseInt(request.getParameter("commentId"));
        int postId = Integer.parseInt(request.getParameter("postId"));

        CommentDAO dao = new CommentDAO();

        boolean isOwner = dao.checkCommentOwner(commentId, sessionUserId);

        if (isOwner) {
            boolean deleted = dao.deleteComment(commentId);
            if (deleted) {
                session.setAttribute("deleteMessage", "댓글이 삭제되었습니다.");
            } else {
                session.setAttribute("deleteMessage", "댓글 삭제에 실패했습니다.");
            }
        } else {
            session.setAttribute("deleteMessage", "본인의 댓글만 삭제할 수 있습니다.");
        }

        response.sendRedirect("/jsp_project/postDetail?postId=" + postId);
    }    
}
