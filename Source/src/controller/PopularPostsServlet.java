package controller;

import dao.PostDAO;
import model.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/popular")
public class PopularPostsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 인기 맛집 상위 10개만 가져오기
        PostDAO postDAO = new PostDAO();
        List<Post> popularPosts = postDAO.getTopLikedPosts(10);
        
        // 요청 속성 설정
        request.setAttribute("popularPosts", popularPosts);
        
        // 인기 맛집 JSP 페이지로 포워딩
        request.getRequestDispatcher("/views/popular.jsp").forward(request, response);
    }
}