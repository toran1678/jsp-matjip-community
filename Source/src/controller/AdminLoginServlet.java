package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.ConfigUtil;

import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // 관리자 계정 정보는 설정 파일에서 읽어옴

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 이미 로그인된 관리자라면 바로 dashboard로 리디렉션
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        
        // 로그인 페이지로 포워딩
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 이미 로그인된 관리자라면 바로 dashboard로 리디렉션
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        String adminId = request.getParameter("adminId");
        String adminPassword = request.getParameter("adminPassword");
        
        System.out.println("Admin login attempt - ID: " + adminId);

        // 설정 파일에서 관리자 계정 정보 읽기
        String adminIdFromConfig = ConfigUtil.getProperty("admin.id", "admin");
        String adminPasswordFromConfig = ConfigUtil.getProperty("admin.password", "1234");
        
        // 관리자 인증
        if (adminIdFromConfig.equals(adminId) && adminPasswordFromConfig.equals(adminPassword)) {
            // 세션에 관리자 정보 저장
            session.setAttribute("adminId", adminId);
            session.setAttribute("adminUsername", adminId);
            session.setAttribute("adminLoggedIn", true);
            
            System.out.println("Admin login successful - ID: " + adminId);
            
            // 대시보드 서블릿으로 리다이렉트 (JSP 직접 접근 방지)
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            System.out.println("Admin login failed - ID: " + adminId);
            
            request.setAttribute("errorMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}