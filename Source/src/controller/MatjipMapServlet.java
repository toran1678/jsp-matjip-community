package controller;

import dao.PostDAO;
import model.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/matjipMap")
public class MatjipMapServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // DAO 호출
            PostDAO postDAO = new PostDAO();
            List<Post> posts = postDAO.getAllPostsWithLocation();

            // JSP로 전달
            request.setAttribute("restaurants", posts);
            request.getRequestDispatcher("/views/matjipMap.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "맛집 데이터를 불러오는 중 오류 발생");
        }
    }
}
