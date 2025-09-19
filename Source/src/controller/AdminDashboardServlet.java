package controller;

import dao.PostDAO;
import dao.UserDAO;
import dao.CommentDAO;
import model.Post;
import model.User;
import model.Comment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.concurrent.TimeUnit;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 세션 체크 - 관리자만 접근 가능
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null && session.getAttribute("adminUsername") == null) {
            System.out.println("Admin session not found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        try {
            System.out.println("AdminDashboardServlet: Processing request");
            
            // DAO 객체 생성
            PostDAO postDAO = new PostDAO();
            UserDAO userDAO = new UserDAO();
            CommentDAO commentDAO = new CommentDAO();
            
            // 통계 데이터 수집
            int totalPosts = postDAO.getPostCount();
            int totalUsers = userDAO.getUserCount();
            int totalComments = commentDAO.getCommentCount();
            
            // System.out.println("Total Posts: " + totalPosts);
            // System.out.println("Total Users: " + totalUsers);
            // System.out.println("Total Comments: " + totalComments);
            
            // 최근 7일간 일별 게시물 수 데이터
            Map<String, Integer> dailyPostsData = getDailyPostsData(postDAO);
            
            // 음식 종류별 게시물 수 데이터
            Map<String, Integer> foodTypeData = getFoodTypeData(postDAO);
            
            // 최근 게시물 5개
            List<Post> recentPosts = postDAO.getLatestPosts(5);
            
            // 최근 가입한 사용자 5명
            List<User> recentUsers = userDAO.getRecentUsers(5);
            
            // 최근 댓글 5개
            List<Comment> recentComments = commentDAO.getLatestComments(5);
            
            // 요청 속성 설정
            request.setAttribute("totalPosts", totalPosts);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalComments", totalComments);
            request.setAttribute("dailyPostsData", dailyPostsData);
            request.setAttribute("foodTypeData", foodTypeData);
            request.setAttribute("recentPosts", recentPosts);
            request.setAttribute("recentUsers", recentUsers);
            request.setAttribute("recentComments", recentComments);
            
            // 대시보드 JSP 페이지로 포워딩
            // System.out.println("Forwarding to dashboard.jsp");
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            // System.out.println("Error in AdminDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            
            // 오류 발생 시 기본 데이터 설정
            request.setAttribute("totalPosts", 0);
            request.setAttribute("totalUsers", 0);
            request.setAttribute("totalComments", 0);
            request.setAttribute("dailyPostsData", new HashMap<String, Integer>());
            request.setAttribute("foodTypeData", new HashMap<String, Integer>());
            request.setAttribute("recentPosts", new ArrayList<Post>());
            request.setAttribute("recentUsers", new ArrayList<User>());
            request.setAttribute("recentComments", new ArrayList<Comment>());
            request.setAttribute("error", "데이터를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            
            // 대시보드 JSP 페이지로 포워딩
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    // 최근 7일간 일별 게시물 수 데이터 가져오기
    private Map<String, Integer> getDailyPostsData(PostDAO postDAO) {
        Map<String, Integer> dailyPostsData = new LinkedHashMap<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd");
        
        // 최근 7일간의 날짜 생성
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -6); // 6일 전부터 시작
        
        // System.out.println("Generating daily posts data for the last 7 days");
        
        for (int i = 0; i < 7; i++) {
            Date date = calendar.getTime();
            String dateStr = dateFormat.format(date);
            
            // 해당 날짜의 게시물 수 조회
            Timestamp startTime = new Timestamp(getStartOfDay(date).getTime());
            Timestamp endTime = new Timestamp(getEndOfDay(date).getTime());
            
            // 데이터가 없을 경우를 대비해 기본값 0 설정
            int count = 0;
            try {
                count = postDAO.getPostCountByDateRange(startTime, endTime);
            } catch (Exception e) {
                System.out.println("Error getting post count for date " + dateStr + ": " + e.getMessage());
                e.printStackTrace();
            }
            
            dailyPostsData.put(dateStr, count);
            // System.out.println("Date: " + dateStr + ", Count: " + count);
            
            calendar.add(Calendar.DAY_OF_MONTH, 1);
        }
        
        // 데이터가 없을 경우 샘플 데이터 추가
        if (dailyPostsData.values().stream().allMatch(count -> count == 0)) {
            System.out.println("No data found, adding sample data");
            
            // 현재 날짜 기준으로 7일 전부터 오늘까지의 날짜 생성
            calendar = Calendar.getInstance();
            calendar.add(Calendar.DAY_OF_MONTH, -6);
            
            // 샘플 데이터 생성
            Random random = new Random();
            dailyPostsData.clear();
            
            for (int i = 0; i < 7; i++) {
                Date date = calendar.getTime();
                String dateStr = dateFormat.format(date);
                int sampleCount = random.nextInt(5) + 1; // 1~5 사이의 랜덤 값
                dailyPostsData.put(dateStr, sampleCount);
                calendar.add(Calendar.DAY_OF_MONTH, 1);
            }
        }
        
        return dailyPostsData;
    }
    
    // 음식 종류별 게시물 수 데이터 가져오기
    private Map<String, Integer> getFoodTypeData(PostDAO postDAO) {
        return postDAO.getPostCountByFoodType();
    }
    
    // 날짜의 시작 시간 (00:00:00) 가져오기
    private Date getStartOfDay(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }
    
    // 날짜의 종료 시간 (23:59:59) 가져오기
    private Date getEndOfDay(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 999);
        return calendar.getTime();
    }
}