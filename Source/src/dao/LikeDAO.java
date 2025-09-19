package dao;

import java.sql.*;
import util.DBConnection;

public class LikeDAO {
	// 유저가 이미 좋아요 눌렀는지 확인
    public boolean hasUserLikedPost(int postId, int userId) {
        String sql = "SELECT 1 FROM likes WHERE post_id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // 토글 좋아요
    public void toggleLike(int postId, int userId) {
        if (hasUserLikedPost(postId, userId)) {
            removeLike(postId, userId);
        } else {
            addLike(postId, userId);
        }
    }

    // 좋아요 추가
    public void addLike(int postId, int userId) {
        String insertLike = "INSERT INTO likes (post_id, user_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(insertLike)) {
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 좋아요 취소
    public void removeLike(int postId, int userId) {
        String deleteLike = "DELETE FROM likes WHERE post_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteLike)) {
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // 좋아요 수
    public int getLikeCount(int postId) {
	    String sql = "SELECT COUNT(*) FROM likes WHERE post_id = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, postId);
	        ResultSet rs = stmt.executeQuery();
	        if (rs.next()) return rs.getInt(1);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}
}