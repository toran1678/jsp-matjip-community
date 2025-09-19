package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
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
        
        UserDAO userDAO = new UserDAO();
        
        // 전체 사용자 수 조회
        int totalUsers;
        if (keyword != null && !keyword.isEmpty()) {
            totalUsers = userDAO.getUserCountByKeyword(keyword);
        } else {
            totalUsers = userDAO.getUserCount();
        }
        
        int totalPages = (int) Math.ceil(totalUsers * 1.0 / recordsPerPage);
        int offset = (page - 1) * recordsPerPage;
        
        // 사용자 목록 조회
        List<User> users;
        if (keyword != null && !keyword.isEmpty()) {
            users = userDAO.getUsersByKeyword(keyword, offset, recordsPerPage);
        } else {
            users = userDAO.getAllUsers(offset, recordsPerPage);
        }
        
        // 요청 속성 설정
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("keyword", keyword);
        
        // 사용자 관리 JSP 페이지로 포워딩
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 세션 체크 - 관리자만 접근 가능
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        
        // 사용자 삭제 처리
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        
        if ("delete".equals(action) && email != null && !email.isEmpty()) {
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.deleteUserByEmail(email);
            
            if (success) {
                request.setAttribute("message", "사용자가 성공적으로 삭제되었습니다.");
            } else {
                request.setAttribute("error", "사용자 삭제 중 오류가 발생했습니다.");
            }
        }
        
        // 사용자 목록 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}