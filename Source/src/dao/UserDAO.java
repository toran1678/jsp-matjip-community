package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.User;
import util.DBConnection;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

public class UserDAO {
	// 전체 사용자 수 조회
	public int getUserCount() {
	    String sql = "SELECT COUNT(*) FROM users";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {
	        
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}

	// 키워드로 사용자 수 조회
	public int getUserCountByKeyword(String keyword) {
	    String sql = "SELECT COUNT(*) FROM users WHERE username LIKE ? OR email LIKE ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        String searchKeyword = "%" + keyword + "%";
	        pstmt.setString(1, searchKeyword);
	        pstmt.setString(2, searchKeyword);
	        
	        ResultSet rs = pstmt.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}

	// 날짜 범위별 사용자 수 조회
	public int getUserCountByDateRange(Timestamp startDate, Timestamp endDate) {
	    String sql = "SELECT COUNT(*) FROM users WHERE created_at BETWEEN ? AND ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setTimestamp(1, startDate);
	        pstmt.setTimestamp(2, endDate);
	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}

	// 전체 사용자 목록 조회 (페이징)
	public List<User> getAllUsers(int offset, int limit) {
	    List<User> users = new ArrayList<>();
	    String sql = """
	        SELECT u.*, 
	               (SELECT COUNT(*) FROM posts p WHERE p.user_id = u.user_id) AS post_count,
	               (SELECT COUNT(*) FROM comments c WHERE c.user_id = u.user_id) AS comment_count
	        FROM users u
	        ORDER BY u.created_at DESC
	        LIMIT ? OFFSET ?
	    """;
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, limit);
	        pstmt.setInt(2, offset);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            User user = new User();
	            user.setUserid(rs.getString("user_id"));
	            user.setUsername(rs.getString("username"));
	            user.setEmail(rs.getString("email"));
	            user.setCreatedAt(rs.getTimestamp("created_at"));
	            user.setPostCount(rs.getInt("post_count"));
	            user.setCommentCount(rs.getInt("comment_count"));
	            
	            users.add(user);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return users;
	}

	// 키워드로 사용자 목록 조회 (페이징)
	public List<User> getUsersByKeyword(String keyword, int offset, int limit) {
	    List<User> users = new ArrayList<>();
	    String sql = """
	        SELECT u.*, 
	               (SELECT COUNT(*) FROM posts p WHERE p.user_id = u.user_id) AS post_count,
	               (SELECT COUNT(*) FROM comments c WHERE c.user_id = u.user_id) AS comment_count
	        FROM users u
	        WHERE u.username LIKE ? OR u.email LIKE ? 
	        ORDER BY u.created_at DESC
	        LIMIT ? OFFSET ?
	    """;
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        String searchKeyword = "%" + keyword + "%";
	        pstmt.setString(1, searchKeyword);
	        pstmt.setString(2, searchKeyword);
	        pstmt.setInt(3, limit);
	        pstmt.setInt(4, offset);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            User user = new User();
	            user.setUserid(rs.getString("user_id"));
	            user.setUsername(rs.getString("username"));
	            user.setEmail(rs.getString("email"));
	            user.setCreatedAt(rs.getTimestamp("created_at"));
	            user.setPostCount(rs.getInt("post_count"));
	            user.setCommentCount(rs.getInt("comment_count"));
	            
	            users.add(user);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return users;
	}

	// 최근 가입한 사용자 목록 조회
	public List<User> getRecentUsers(int limit) {
	    List<User> users = new ArrayList<>();
	    String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ?";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, limit);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            User user = new User();
	            user.setUserid(rs.getString("user_id"));
	            user.setUsername(rs.getString("username"));
	            user.setEmail(rs.getString("email"));
	            user.setCreatedAt(rs.getTimestamp("created_at"));
	            
	            users.add(user);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return users;
	}

	// 활발한 사용자 목록 조회 (게시물 + 댓글 수 기준)
	public List<Map<String, Object>> getMostActiveUsers(int limit) {
	    List<Map<String, Object>> activeUsers = new ArrayList<>();
	    String sql = """
	        SELECT u.user_id, u.username, u.email, u.created_at,
	               COUNT(DISTINCT p.post_id) AS post_count,
	               COUNT(DISTINCT c.comment_id) AS comment_count,
	               (COUNT(DISTINCT p.post_id) + COUNT(DISTINCT c.comment_id)) AS activity_count
	        FROM users u
	        LEFT JOIN posts p ON u.user_id = p.user_id
	        LEFT JOIN comments c ON u.user_id = c.user_id
	        GROUP BY u.user_id
	        ORDER BY activity_count DESC
	        LIMIT ?
	    """;
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, limit);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            Map<String, Object> user = new HashMap<>();
	            user.put("userId", rs.getInt("user_id"));
	            user.put("username", rs.getString("username"));
	            user.put("email", rs.getString("email"));
	            user.put("createdAt", rs.getTimestamp("created_at"));
	            user.put("postCount", rs.getInt("post_count"));
	            user.put("commentCount", rs.getInt("comment_count"));
	            user.put("activityCount", rs.getInt("activity_count"));
	            
	            activeUsers.add(user);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return activeUsers;
	}
	
	// 유저 정보 삭제
	public boolean deleteUserByEmail(String email) {
	    String sql = "DELETE FROM users WHERE email = ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, email);
	        return pstmt.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}
	
	// 유저 정보 수정
	public boolean updateUserProfile(String email, String username, String newPassword) {
	    String sql = "UPDATE users SET username = ?, user_pw = ? WHERE email = ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, username);
	        pstmt.setString(2, newPassword);  // 비밀번호는 항상 전달됨 (기존 비번 그대로여도 OK)
	        pstmt.setString(3, email);

	        return pstmt.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	// userId 가져오기
	public int getUserIdByEmail(String email) {
	    String sql = "SELECT user_id FROM users WHERE email = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, email);
	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            return rs.getInt("user_id");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1;
	}
	
	// 이메일로 유저 정보 가져오기
	public User getUserByEmail(String email) {
	    String sql = "SELECT * FROM users WHERE email = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setString(1, email);
	        ResultSet rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            User user = new User();
	            user.setUserid(rs.getString("user_id"));
	            user.setPassword(rs.getString("user_pw"));
	            user.setUsername(rs.getString("username"));
	            user.setEmail(rs.getString("email"));
	            user.setCreatedAt(rs.getTimestamp("created_at"));
	            return user;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}

	
	// 로그인 검증
    public User login(String email, String password) {
        String sql = "SELECT user_id, username FROM users WHERE email = ? AND user_pw = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setEmail(email);
                user.setPassword(password);
                user.setUserid(rs.getString("user_id"));
                user.setUsername(rs.getString("username"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
	
	// 사용자 회원가입
	public int registerUser(User user) {
        int result = 0;
        String sql = "INSERT INTO users (username, email, user_pw) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword());
            result = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
	
	// 이메일 중복 확인
	public boolean isEmailDuplicate(String email) {
	    String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
	    
	    try (Connection conn = DBConnection.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, email);
	        var rs = pstmt.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1) > 0;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	
}
