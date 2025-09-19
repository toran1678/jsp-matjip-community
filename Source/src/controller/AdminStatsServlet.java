package controller;

import dao.PostDAO;
import dao.UserDAO;
import dao.CommentDAO;
import dao.LikeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;

@WebServlet("/admin/stats")
public class AdminStatsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 세션 체크 - 관리자만 접근 가능
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        
        // DAO 객체 생성
        PostDAO postDAO = new PostDAO();
        UserDAO userDAO = new UserDAO();
        CommentDAO commentDAO = new CommentDAO();
        
        // 기간 설정 (기본: 최근 30일)
        String period = request.getParameter("period");
        int days = 30;
        
        if ("7".equals(period)) {
            days = 7;
        } else if ("90".equals(period)) {
            days = 90;
        } else if ("365".equals(period)) {
            days = 365;
        }
        
        // 일별 통계 데이터
        Map<String, Integer> dailyPostsData = getDailyData(postDAO, days, "posts");
        Map<String, Integer> dailyUsersData = getDailyData(userDAO, days, "users");
        Map<String, Integer> dailyCommentsData = getDailyData(commentDAO, days, "comments");
        
        // 음식 종류별 게시물 수 데이터
        Map<String, Integer> foodTypeData = postDAO.getPostCountByFoodType();
        
        // 지역별 게시물 수 데이터
        Map<String, Integer> locationData = postDAO.getPostCountByLocation();
        
        // 인기 게시물 (좋아요 수 기준)
        List<Map<String, Object>> popularPosts = postDAO.getPopularPostsWithDetails(10);
        
        // 활발한 사용자 (게시물 + 댓글 수 기준)
        List<Map<String, Object>> activeUsers = userDAO.getMostActiveUsers(10);
        
        // 요청 속성 설정
        request.setAttribute("period", days);
        request.setAttribute("dailyPostsData", dailyPostsData);
        request.setAttribute("dailyUsersData", dailyUsersData);
        request.setAttribute("dailyCommentsData", dailyCommentsData);
        request.setAttribute("foodTypeData", foodTypeData);
        request.setAttribute("locationData", locationData);
        request.setAttribute("popularPosts", popularPosts);
        request.setAttribute("activeUsers", activeUsers);
        
        // 통계 JSP 페이지로 포워딩
        request.getRequestDispatcher("/admin/stats.jsp").forward(request, response);
    }
    
    // 일별 데이터 가져오기
    private Map<String, Integer> getDailyData(Object dao, int days, String type) {
        Map<String, Integer> dailyData = new LinkedHashMap<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd");
        
        // 지정된 일수만큼의 날짜 생성
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -(days - 1)); // (days-1)일 전부터 시작
        
        for (int i = 0; i < days; i++) {
            Date date = calendar.getTime();
            String dateStr = dateFormat.format(date);
            
            // 해당 날짜의 데이터 수 조회
            Timestamp startTime = new Timestamp(getStartOfDay(date).getTime());
            Timestamp endTime = new Timestamp(getEndOfDay(date).getTime());
            
            int count = 0;
            if ("posts".equals(type)) {
                count = ((PostDAO)dao).getPostCountByDateRange(startTime, endTime);
            } else if ("users".equals(type)) {
                count = ((UserDAO)dao).getUserCountByDateRange(startTime, endTime);
            } else if ("comments".equals(type)) {
                count = ((CommentDAO)dao).getCommentCountByDateRange(startTime, endTime);
            }
            
            dailyData.put(dateStr, count);
            calendar.add(Calendar.DAY_OF_MONTH, 1);
        }
        
        return dailyData;
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