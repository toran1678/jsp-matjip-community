package dao;

import model.Comment;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class CommentDAO {
	// 전체 댓글 수 조회
	public int getCommentCount() {
	    String sql = "SELECT COUNT(*) FROM comments";
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

	// 날짜 범위별 댓글 수 조회
	public int getCommentCountByDateRange(Timestamp startDate, Timestamp endDate) {
	    String sql = "SELECT COUNT(*) FROM comments WHERE created_at BETWEEN ? AND ?";
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
	
	// 댓글 삭제
	public boolean deleteCommentMyPage(int commentId, int userId) {
	    String sql = "DELETE FROM comments WHERE comment_id = ? AND user_id = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, commentId);
	        pstmt.setInt(2, userId);

	        int result = pstmt.executeUpdate();
	        return result > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	// 댓글 작성
	public boolean insertComment(int postId, int userId, String content) {
	    String sql = "INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, postId);
	        stmt.setInt(2, userId);
	        stmt.setString(3, content);
	        return stmt.executeUpdate() == 1;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	
	// userId에 따른 댓글 가져오기
	public List<Comment> getCommentsByUserId(int userId) {
	    List<Comment> list = new ArrayList<>();
	    String sql = """
	        SELECT c.*, p.title AS post_title
	        FROM comments c
	        JOIN posts p ON c.post_id = p.post_id
	        WHERE c.user_id = ?
	        ORDER BY c.created_at DESC
	    """;

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, userId);
	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Comment comment = new Comment();
	            comment.setCommentId(rs.getInt("comment_id"));
	            comment.setUserId(rs.getInt("user_id"));
	            comment.setPostId(rs.getInt("post_id"));
	            comment.setContent(rs.getString("content"));
	            comment.setCreatedAt(rs.getTimestamp("created_at"));
	            comment.setPostTitle(rs.getString("post_title"));  // 댓글이 달린 게시글 제목
	            list.add(comment);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	// PostId에 따른 댓글 가져오기
	public List<Comment> getCommentsByPostId(int postId) {
	    List<Comment> list = new ArrayList<>();
	    String sql = """
	        SELECT c.*, u.username, u.user_id
	        FROM comments c
	        JOIN users u ON c.user_id = u.user_id
	        WHERE c.post_id = ?
	        ORDER BY c.created_at ASC
	    """;

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, postId);
	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Comment c = new Comment();
	            c.setUserId(rs.getInt("user_id"));
	            c.setCommentId(rs.getInt("comment_id"));
	            c.setContent(rs.getString("content"));
	            c.setUsername(rs.getString("username"));
	            c.setCreatedAt(rs.getTimestamp("created_at"));
	            list.add(c);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	
    // 실시간 댓글 가져오기
    public List<Comment> getLatestComments(int limit) {
        List<Comment> list = new ArrayList<>();
        String sql = """
            SELECT c.*, u.username, p.store_name, c.post_id 
            FROM comments c
            JOIN users u ON c.user_id = u.user_id
            JOIN posts p ON c.post_id = p.post_id
            ORDER BY c.created_at DESC
            LIMIT ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Comment c = new Comment();
                c.setContent(rs.getString("content"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setUsername(rs.getString("username"));
                c.setStoreName(rs.getString("store_name"));
                c.setPostId(rs.getInt("post_id"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    // 댓글 작성자 확인
    public boolean checkCommentOwner(int commentId, int userId) {
        String sql = "SELECT user_id FROM comments WHERE comment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                int ownerId = rs.getInt("user_id");
                return ownerId == userId;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 댓글 삭제
    public boolean deleteComment(int commentId) {
        String sql = "DELETE FROM comments WHERE comment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}