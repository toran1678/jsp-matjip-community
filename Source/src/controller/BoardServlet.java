package controller;

import dao.PostDAO;
import model.Post;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/board")
public class BoardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    private static final int POSTS_PER_PAGE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && pageParam.matches("\\d+")) {
            page = Integer.parseInt(pageParam);
        }
        
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");
        String foodType = request.getParameter("foodType");

        if (sort == null || (!sort.equals("popular") && !sort.equals("newest"))) {
            sort = "newest";
        }

        PostDAO dao = new PostDAO();
        int totalPosts = dao.getFilteredPostCount(keyword, foodType);
        int offset = (page - 1) * POSTS_PER_PAGE;
        int totalPages = (int) Math.ceil((double) totalPosts / POSTS_PER_PAGE);

        List<Post> postList = dao.getFilteredPosts(keyword, foodType, sort, offset, POSTS_PER_PAGE);

        request.setAttribute("postList", postList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);
        request.setAttribute("foodType", foodType);

        request.getRequestDispatcher("/views/board.jsp").forward(request, response);
    }
}
