package dao;

import model.Post;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class PostDAO {
	// 관리자용 게시물 삭제 (사용자 ID 체크 없이)
	public boolean deletePostByAdmin(int postId) {
	    String sql = "DELETE FROM posts WHERE post_id = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, postId);
	        int result = pstmt.executeUpdate();
	        return result > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}

	// 날짜 범위별 게시물 수 조회 메소드 수정
	public int getPostCountByDateRange(Timestamp startDate, Timestamp endDate) {
	    String sql = "SELECT COUNT(*) FROM posts WHERE created_at BETWEEN ? AND ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setTimestamp(1, startDate);
	        pstmt.setTimestamp(2, endDate);
	        
	        System.out.println("SQL Query: " + sql);
	        System.out.println("Start Date: " + startDate);
	        System.out.println("End Date: " + endDate);
	        
	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            int count = rs.getInt(1);
	            System.out.println("Count result: " + count);
	            return count;
	        }
	    } catch (Exception e) {
	        System.out.println("Error in getPostCountByDateRange: " + e.getMessage());
	        e.printStackTrace();
	    }
	    return 0;
	}

	// 음식 종류별 게시물 수 조회 메소드 수정
	public Map<String, Integer> getPostCountByFoodType() {
	    Map<String, Integer> foodTypeData = new LinkedHashMap<>();
	    
	    // 기본 데이터 추가 (데이터가 없을 경우를 대비)
	    foodTypeData.put("한식", 0);
	    foodTypeData.put("중식", 0);
	    foodTypeData.put("일식", 0);
	    foodTypeData.put("양식", 0);
	    foodTypeData.put("분식", 0);
	    foodTypeData.put("카페/디저트", 0);
	    foodTypeData.put("기타", 0);
	    
	    String sql = "SELECT food_type, COUNT(*) as count FROM posts GROUP BY food_type ORDER BY count DESC";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
	            String foodType = rs.getString("food_type");
	            int count = rs.getInt("count");
	            foodTypeData.put(foodType, count);
	        }
	        
	        System.out.println("Food type data: " + foodTypeData);
	    } catch (Exception e) {
	        System.out.println("Error in getPostCountByFoodType: " + e.getMessage());
	        e.printStackTrace();
	    }
	    
	    return foodTypeData;
	}

	// 지역별 게시물 수 조회
	public Map<String, Integer> getPostCountByLocation() {
	    Map<String, Integer> locationData = new LinkedHashMap<>();
	    String sql = "SELECT SUBSTRING_INDEX(location, ' ', 1) as region, COUNT(*) as count " +
	                 "FROM posts GROUP BY region ORDER BY count DESC LIMIT 10";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
	            String region = rs.getString("region");
	            int count = rs.getInt("count");
	            locationData.put(region, count);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return locationData;
	}

	// 인기 게시물 상세 정보 조회
	public List<Map<String, Object>> getPopularPostsWithDetails(int limit) {
	    List<Map<String, Object>> popularPosts = new ArrayList<>();
	    String sql = """
	        SELECT p.post_id, p.title, p.store_name, p.food_type, p.location, 
	               u.username, p.created_at, 
	               (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id) AS like_count,
	               (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id) AS comment_count
	        FROM posts p
	        JOIN users u ON p.user_id = u.user_id
	        ORDER BY like_count DESC, comment_count DESC
	        LIMIT ?
	    """;
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, limit);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            Map<String, Object> post = new HashMap<>();
	            post.put("postId", rs.getInt("post_id"));
	            post.put("title", rs.getString("title"));
	            post.put("storeName", rs.getString("store_name"));
	            post.put("foodType", rs.getString("food_type"));
	            post.put("location", rs.getString("location"));
	            post.put("username", rs.getString("username"));
	            post.put("createdAt", rs.getTimestamp("created_at"));
	            post.put("likeCount", rs.getInt("like_count"));
	            post.put("commentCount", rs.getInt("comment_count"));
	            
	            popularPosts.add(post);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return popularPosts;
	}
	
	/**
	 * 위치 정보가 있는 모든 게시물을 가져오는 메소드
	 * @return 위치 정보가 있는 게시물 목록
	 */
	public List<Post> getAllPostsWithLocation() {
	    List<Post> posts = new ArrayList<>();
	    String sql = "SELECT p.*, u.username, " +
	                "(SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id) AS like_count, " +
	                "(SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id) AS comment_count " +
	                "FROM posts p " +
	                "JOIN users u ON p.user_id = u.user_id " +
	                "WHERE p.x IS NOT NULL AND p.y IS NOT NULL " +
	                "ORDER BY p.created_at DESC";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {
	        
	        while (rs.next()) {
	            Post post = new Post();
	            post.setPostId(rs.getInt("post_id"));
	            post.setUserId(rs.getInt("user_id"));
	            post.setTitle(rs.getString("title"));
	            post.setContent(rs.getString("content"));
	            post.setLocation(rs.getString("location"));
	            post.setStoreName(rs.getString("store_name"));
	            post.setFoodType(rs.getString("food_type"));
	            post.setX(rs.getDouble("y"));
	            post.setY(rs.getDouble("x"));
	            post.setCreatedAt(rs.getTimestamp("created_at"));
	            post.setUpdatedAt(rs.getTimestamp("updated_at"));
	            post.setUsername(rs.getString("username"));
	            post.setLikeCount(rs.getInt("like_count"));
	            post.setCommentCount(rs.getInt("comment_count"));
	            
	            posts.add(post);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	     
	    return posts;
	}
	
	// 키워드 + 음식 종류 검색 카운트
	public int getFilteredPostCount(String keyword, String foodType) {
	    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM posts p JOIN users u ON p.user_id = u.user_id");
	    List<String> conditions = new ArrayList<>();

	    if (foodType != null && !foodType.trim().isEmpty()) {
	        conditions.add("p.food_type = ?");
	    }
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        conditions.add("(p.store_name LIKE ? OR p.location LIKE ? OR u.username LIKE ?)");
	    }

	    if (!conditions.isEmpty()) {
	        sql.append(" WHERE ").append(String.join(" AND ", conditions));
	    }

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

	        int index = 1;
	        if (foodType != null && !foodType.trim().isEmpty()) {
	            pstmt.setString(index++, foodType);
	        }
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            String kw = "%" + keyword.trim() + "%";
	            for (int i = 0; i < 3; i++) pstmt.setString(index++, kw);
	        }

	        ResultSet rs = pstmt.executeQuery();
	        if (rs.next()) return rs.getInt(1);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}
	
	// 키워드 + 음식 종류 검색
	public List<Post> getFilteredPosts(String keyword, String foodType, String sort, int offset, int limit) {
	    List<Post> list = new ArrayList<>();
	    StringBuilder sql = new StringBuilder("""
	        SELECT p.*, u.username,
	               (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id) AS like_count,
	               (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id) AS comment_count
	        FROM posts p
	        JOIN users u ON p.user_id = u.user_id
	    """);

	    List<String> conditions = new ArrayList<>();

	    if (foodType != null && !foodType.trim().isEmpty()) {
	        conditions.add("p.food_type = ?");
	    }
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        conditions.add("(p.store_name LIKE ? OR p.location LIKE ? OR u.username LIKE ?)");
	    }

	    if (!conditions.isEmpty()) {
	        sql.append(" WHERE ").append(String.join(" AND ", conditions));
	    }

	    if ("popular".equals(sort)) {
	        sql.append(" ORDER BY like_count DESC, p.created_at DESC ");
	    } else {
	        sql.append(" ORDER BY p.created_at DESC ");
	    }

	    sql.append(" LIMIT ? OFFSET ?");

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

	        int index = 1;
	        if (foodType != null && !foodType.trim().isEmpty()) {
	            pstmt.setString(index++, foodType);
	        }
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            String kw = "%" + keyword.trim() + "%";
	            for (int i = 0; i < 3; i++) pstmt.setString(index++, kw);
	        }

	        pstmt.setInt(index++, limit);
	        pstmt.setInt(index, offset);

	        ResultSet rs = pstmt.executeQuery();
	        while (rs.next()) {
	            Post post = new Post();
	            post.setPostId(rs.getInt("post_id"));
	            post.setUserId(rs.getInt("user_id"));
	            post.setTitle(rs.getString("title"));
	            post.setLocation(rs.getString("location"));
	            post.setStoreName(rs.getString("store_name"));
	            post.setFoodType(rs.getString("food_type"));
	            post.setCreatedAt(rs.getTimestamp("created_at"));
	            post.setUsername(rs.getString("username"));
	            post.setLikeCount(rs.getInt("like_count"));
	            post.setCommentCount(rs.getInt("comment_count"));
	            list.add(post);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	// likes 테이블에서 userId를 통해 post_id를 가져옴
	public List<Post> getLikedPostsByUserId(int userId) {
	    List<Post> list = new ArrayList<>();
	    String sql = """
	        SELECT p.*, u.username,
	               (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id) AS like_count,
	               (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id) AS comment_count
	        FROM likes l
	        JOIN posts p ON l.post_id = p.post_id
	        JOIN users u ON p.user_id = u.user_id
	        WHERE l.user_id = ?
	        ORDER BY p.created_at DESC
	    """;

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, userId);
	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Post post = new Post();
	            post.setPostId(rs.getInt("post_id"));
	            post.setUserId(rs.getInt("user_id"));
	            post.setTitle(rs.getString("title"));
	            post.setContent(rs.getString("content"));
	            post.setLocation(rs.getString("location"));
	            post.setStoreName(rs.getString("store_name"));
	            post.setFoodType(rs.getString("food_type"));
	            post.setCreatedAt(rs.getTimestamp("created_at"));
	            post.setUsername(rs.getString("username"));
	            post.setLikeCount(rs.getInt("like_count"));
	            post.setCommentCount(rs.getInt("comment_count"));
	            list.add(post);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	// 마이페이지 유저 게시글 삭제
	public boolean deletePost(int postId, int userId) {
	    String sql = "DELETE FROM posts WHERE post_id = ? AND user_id = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, postId);
	        pstmt.setInt(2, userId); // 내가 쓴 글인지 확인용

	        int result = pstmt.executeUpdate();
	        return result > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	// 특정 유저의 게시글 조회
	public List<Post> getPostsByUserId(int userId) {
	    List<Post> list = new ArrayList<>();
	    String sql = """
	        SELECT p.*, u.username,
	               (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id) AS like_count,
	               (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id) AS comment_count
	        FROM posts p
	        JOIN users u ON p.user_id = u.user_id
	        WHERE p.user_id = ?
	        ORDER BY p.created_at DESC
	    """;

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, userId);
	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Post post = new Post();
	            post.setPostId(rs.getInt("post_id"));
	            post.setUserId(rs.getInt("user_id"));
	            post.setTitle(rs.getString("title"));
	            post.setContent(rs.getString("content"));
	            post.setLocation(rs.getString("location"));
	            post.setStoreName(rs.getString("store_name"));
	            post.setFoodType(rs.getString("food_type"));
	            post.setCreatedAt(rs.getTimestamp("created_at"));
	            post.setUsername(rs.getString("username"));
	            post.setLikeCount(rs.getInt("like_count"));
	            post.setCommentCount(rs.getInt("comment_count"));
	            list.add(post);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	// 게시글 1개 조회 (상세 페이지)
	public Post getPostById(int postId) {
	    String sql = """
	        SELECT p.*, u.username,
	          (SELECT COUNT(*) FROM likes WHERE post_id = p.post_id) AS like_count,
	          (SELECT COUNT(*) FROM comments WHERE post_id = p.post_id) AS comment_count
	        FROM posts p JOIN users u ON p.user_id = u.user_id
	        WHERE p.post_id = ?
	    """;

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	    	pstmt.setInt(1, postId);
	    	
	    	try (ResultSet rs = pstmt.executeQuery()) {
	    		if (rs.next()) {
		            Post post = new Post();
		            post.setPostId(rs.getInt("post_id"));
		            post.setUserId(rs.getInt("user_id"));
		            post.setUsername(rs.getString("username"));
		            post.setTitle(rs.getString("title"));
		            post.setContent(rs.getString("content"));
		            post.setStoreName(rs.getString("store_name"));
		            post.setLocation(rs.getString("location"));
		            post.setFoodType(rs.getString("food_type"));
		            
		            if (rs.getObject("x") != null) {
		            	post.setX(rs.getDouble("x"));
		            }
		            if (rs.getObject("y") != null) {
		            	post.setY(rs.getDouble("y"));
		            }
		            
		            post.setCommentCount(rs.getInt("comment_count"));
		            post.setLikeCount(rs.getInt("like_count"));
		            post.setCreatedAt(rs.getTimestamp("created_at"));
		            post.setImagePath(rs.getString("imagePath"));
		            
		            return post;
		        }
	    	}
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return null;
	}
	
	// 전체 게시물 수 (검색 + 정렬 반영)
	public int getFilteredPostCount(String keyword) {
	    String sql = "SELECT COUNT(*) FROM posts p JOIN users u ON p.user_id = u.user_id";
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        sql += " WHERE p.title LIKE ? OR p.store_name LIKE ? OR p.location LIKE ? OR p.food_type LIKE ?";
	    }

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        if (keyword != null && !keyword.trim().isEmpty()) {
	            String kw = "%" + keyword.trim() + "%";
	            for (int i = 1; i <= 4; i++) {
	                pstmt.setString(i, kw);
	            }
	        }

	        ResultSet rs = pstmt.executeQuery();
	        if (rs.next()) return rs.getInt(1);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	// 게시물 목록 가져오기 (검색 + 정렬 + 페이징)
	public List<Post> getFilteredPosts(String keyword, String sort, int offset, int limit) {
	    List<Post> list = new ArrayList<>();
	    StringBuilder sql = new StringBuilder("""
	        SELECT p.*, u.username,
	               (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id) AS like_count,
	               (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id) AS comment_count
	        FROM posts p
	        JOIN users u ON p.user_id = u.user_id
	    """);

	    if (keyword != null && !keyword.trim().isEmpty()) {
	        sql.append(" WHERE p.title LIKE ? OR p.store_name LIKE ? OR p.location LIKE ? OR p.food_type LIKE ? OR u.username LIKE ?");
	    }

	    if ("popular".equals(sort)) {
	        sql.append(" ORDER BY like_count DESC, p.created_at DESC ");
	    } else {
	        sql.append(" ORDER BY p.created_at DESC ");
	    }

	    sql.append(" LIMIT ? OFFSET ?");

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

	        int index = 1;
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            String kw = "%" + keyword.trim() + "%";
	            for (int i = 0; i < 5; i++) pstmt.setString(index++, kw);
	        }
	        pstmt.setInt(index++, limit);
	        pstmt.setInt(index, offset);

	        ResultSet rs = pstmt.executeQuery();
	        while (rs.next()) {
	            Post post = new Post();
	            post.setPostId(rs.getInt("post_id"));
	            post.setUserId(rs.getInt("user_id"));
	            post.setTitle(rs.getString("title"));
	            post.setLocation(rs.getString("location"));
	            post.setStoreName(rs.getString("store_name"));
	            post.setFoodType(rs.getString("food_type"));
	            post.setCreatedAt(rs.getTimestamp("created_at"));
	            post.setUsername(rs.getString("username"));
	            post.setLikeCount(rs.getInt("like_count"));
	            post.setCommentCount(rs.getInt("comment_count"));
	            list.add(post);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	// 게시물 작성
	public boolean insertPost(int userId, String title, String storeName, String location, String foodType, String content, Double x, Double y) {
	    String sql = "INSERT INTO posts (user_id, title, content, location, store_name, food_type, x, y) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, userId);
	        pstmt.setString(2, title);
	        pstmt.setString(3, content);
	        pstmt.setString(4, location);
	        pstmt.setString(5, storeName);
	        pstmt.setString(6, foodType);
	        pstmt.setDouble(7, x);
	        pstmt.setDouble(8, y);

	        return pstmt.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}
	
	// 이미지 경로를 포함한 게시물 저장
	public boolean insertPostWithImage(int userId, String title, String storeName, String location, 
	                                  String foodType, String content, Double x, Double y, String imagePath) {
	    String sql = "INSERT INTO posts (user_id, title, content, location, store_name, food_type, x, y, imagePath) " +
	                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, userId);
	        pstmt.setString(2, title);
	        pstmt.setString(3, content);
	        pstmt.setString(4, location);
	        pstmt.setString(5, storeName);
	        pstmt.setString(6, foodType);
	        
	        if (x != null && y != null) {
	            pstmt.setDouble(7, x);
	            pstmt.setDouble(8, y);
	        } else {
	            pstmt.setNull(7, java.sql.Types.DOUBLE);
	            pstmt.setNull(8, java.sql.Types.DOUBLE);
	        }
	        
	        pstmt.setString(9, imagePath);

	        return pstmt.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}
	
	// 게시물 Update 수정
	public boolean updatePost(Post post) {
	    String sql = "UPDATE posts SET title = ?, content = ?, location = ?, store_name = ?, food_type = ?, x = ?, y = ?, imagePath=? WHERE post_id = ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, post.getTitle());
	        pstmt.setString(2, post.getContent());
	        pstmt.setString(3, post.getLocation());
	        pstmt.setString(4, post.getStoreName());
	        pstmt.setString(5, post.getFoodType());
	        pstmt.setDouble(6, post.getX());
	        pstmt.setDouble(7, post.getY());
	        
	        // 이미지 경로가 'null'이면 NULL 값 설정, 아니면 경로 설정
	        if (post.getImagePath() == null) {
	            pstmt.setNull(8, java.sql.Types.VARCHAR);
	        } else {
	            pstmt.setString(8, post.getImagePath());
	        }
	        
	        pstmt.setInt(9, post.getPostId());

	        return pstmt.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}
	
	// 전체 게시물 수 조회
    public int getPostCount() {
        String sql = "SELECT COUNT(*) FROM posts";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // 페이지 단위로 게시물 조회
    public List<Post> getPostsByPage(int offset, int limit) {
        List<Post> list = new ArrayList<>();
        String sql = """
            SELECT p.*, u.username,
                   (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id) AS like_count,
                   (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id) AS comment_count
            FROM posts p
            JOIN users u ON p.user_id = u.user_id
            ORDER BY p.created_at, p.post_id asc
            LIMIT ? OFFSET ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            pstmt.setInt(2, offset);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setUserId(rs.getInt("user_id"));
                post.setTitle(rs.getString("title"));
                post.setLocation(rs.getString("location"));
                post.setStoreName(rs.getString("store_name"));
                post.setFoodType(rs.getString("food_type"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setUsername(rs.getString("username"));
                post.setLikeCount(rs.getInt("like_count"));
                post.setCommentCount(rs.getInt("comment_count"));
                list.add(post);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
	
	// 최신 게시물 6개 가져오기
    public List<Post> getLatestPosts(int limit) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT p.*, u.username FROM posts p JOIN users u ON p.user_id = u.user_id ORDER BY p.created_at DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setUserId(rs.getInt("user_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setLocation(rs.getString("location"));
                post.setStoreName(rs.getString("store_name"));
                post.setFoodType(rs.getString("food_type"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setUpdatedAt(rs.getTimestamp("updated_at"));
                post.setUsername(rs.getString("username"));
                list.add(post);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    // 추천(좋아요 수 많은) 게시물 6개 가져오기
    public List<Post> getTopLikedPosts(int limit) {
        List<Post> list = new ArrayList<>();
        String sql = """
            SELECT p.*, u.username, COUNT(l.like_id) AS like_count
            FROM posts p
            JOIN users u ON p.user_id = u.user_id
            LEFT JOIN likes l ON p.post_id = l.post_id
            GROUP BY p.post_id
            ORDER BY like_count DESC, p.created_at DESC
            LIMIT ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setUserId(rs.getInt("user_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setLocation(rs.getString("location"));
                post.setStoreName(rs.getString("store_name"));
                post.setFoodType(rs.getString("food_type"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setUpdatedAt(rs.getTimestamp("updated_at"));
                post.setUsername(rs.getString("username"));
                post.setLikeCount(rs.getInt("like_count"));
                list.add(post);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    // 최근 7일 좋아요 수가 가장 많은 게시글
    public Post getBestReviewThisWeek() {
        Post post = null;
        String sql = """
            SELECT p.*, u.username, COUNT(l.like_id) AS like_count
            FROM posts p
            JOIN users u ON p.user_id = u.user_id
            LEFT JOIN likes l ON p.post_id = l.post_id
            WHERE p.created_at >= NOW() - INTERVAL 7 DAY
            GROUP BY p.post_id
            ORDER BY like_count DESC, p.created_at DESC
            LIMIT 1
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setUserId(rs.getInt("user_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setLocation(rs.getString("location"));
                post.setStoreName(rs.getString("store_name"));
                post.setFoodType(rs.getString("food_type"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setUpdatedAt(rs.getTimestamp("updated_at"));
                post.setUsername(rs.getString("username"));
                post.setLikeCount(rs.getInt("like_count"));  // 좋아요 수 넣기
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return post;
    }
    
    public Post getRandomPost() {
        Post post = null;
        String sql = """
            SELECT p.*, u.username
            FROM posts p
            JOIN users u ON p.user_id = u.user_id
            ORDER BY RAND()
            LIMIT 1
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setUserId(rs.getInt("user_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setLocation(rs.getString("location"));
                post.setStoreName(rs.getString("store_name"));
                post.setFoodType(rs.getString("food_type"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setUpdatedAt(rs.getTimestamp("updated_at"));
                post.setUsername(rs.getString("username"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return post;
    }
}
