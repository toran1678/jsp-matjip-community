package controller;

import dao.PostDAO;
import model.Post;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/posts")
public class AdminPostsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 세션 체크 - 관리자만 접근 가능
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        
        // 페이징 처리
        int page = 1;
        int recordsPerPage = 10;
        String pageParam = request.getParameter("page");
        
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // 검색 파라미터
        String keyword = request.getParameter("keyword");
        String foodType = request.getParameter("foodType");
        
        PostDAO postDAO = new PostDAO();
        
        // 전체 게시물 수 조회
        int totalPosts;
        if (keyword != null && !keyword.isEmpty() || foodType != null && !foodType.isEmpty()) {
            totalPosts = postDAO.getFilteredPostCount(keyword, foodType);
        } else {
            totalPosts = postDAO.getPostCount();
        }
        
        int totalPages = (int) Math.ceil(totalPosts * 1.0 / recordsPerPage);
        int offset = (page - 1) * recordsPerPage;
        
        // 게시물 목록 조회
        List<Post> posts;
        if (keyword != null && !keyword.isEmpty() || foodType != null && !foodType.isEmpty()) {
            posts = postDAO.getFilteredPosts(keyword, foodType, "latest", offset, recordsPerPage);
        } else {
            posts = postDAO.getPostsByPage(offset, recordsPerPage);
        }
        
        // 요청 속성 설정
        request.setAttribute("posts", posts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("keyword", keyword);
        request.setAttribute("foodType", foodType);
        
        // 게시물 관리 JSP 페이지로 포워딩
        request.getRequestDispatcher("/admin/posts.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 세션 체크 - 관리자만 접근 가능
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        
        // 게시물 삭제 처리
        String action = request.getParameter("action");
        String postIdStr = request.getParameter("postId");
        
        if ("delete".equals(action) && postIdStr != null && !postIdStr.isEmpty()) {
            try {
                int postId = Integer.parseInt(postIdStr);
                PostDAO postDAO = new PostDAO();
                boolean success = postDAO.deletePostByAdmin(postId);
                
                if (success) {
                    request.setAttribute("message", "게시물이 성공적으로 삭제되었습니다.");
                } else {
                    request.setAttribute("error", "게시물 삭제 중 오류가 발생했습니다.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "잘못된 게시물 ID입니다.");
            }
        }
        
        // 게시물 목록 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/admin/posts");
    }
}