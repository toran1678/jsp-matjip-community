<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Post" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    // 현재 선택된 카테고리 가져오기
    String currentFoodType = request.getParameter("foodType");
    
    // 검색어와 정렬 파라미터 가져오기
    String keywordParam = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
    String sortParam = request.getParameter("sort") != null ? request.getParameter("sort") : "newest";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 - 맛집 게시판</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<%@ include file="./header.jsp" %>

<div class="board-container">
    <h2 class="section-title">
        <i class="fas fa-utensils"></i> 맛집 게시판
        <% if(currentFoodType != null && !currentFoodType.isEmpty()) { %>
            <span class="current-category"><%= currentFoodType %></span>
        <% } %>
    </h2>
    
    <!-- 카테고리 필터 -->
    <div class="category-filter">
        <a href="board" class="category-item <%= currentFoodType == null ? "active" : "" %>">전체</a>
        <a href="board?foodType=한식<%= keywordParam.isEmpty() ? "" : "&keyword=" + keywordParam %><%= sortParam.equals("newest") ? "" : "&sort=" + sortParam %>" 
           class="category-item <%= "한식".equals(currentFoodType) ? "active" : "" %>">
           <i class="fas fa-bowl-food"></i> 한식
        </a>
        <a href="board?foodType=중식<%= keywordParam.isEmpty() ? "" : "&keyword=" + keywordParam %><%= sortParam.equals("newest") ? "" : "&sort=" + sortParam %>" 
           class="category-item <%= "중식".equals(currentFoodType) ? "active" : "" %>">
           <i class="fas fa-bowl-rice"></i> 중식
        </a>
        <a href="board?foodType=일식<%= keywordParam.isEmpty() ? "" : "&keyword=" + keywordParam %><%= sortParam.equals("newest") ? "" : "&sort=" + sortParam %>" 
           class="category-item <%= "일식".equals(currentFoodType) ? "active" : "" %>">
           <i class="fas fa-fish"></i> 일식
        </a>
        <a href="board?foodType=양식<%= keywordParam.isEmpty() ? "" : "&keyword=" + keywordParam %><%= sortParam.equals("newest") ? "" : "&sort=" + sortParam %>" 
           class="category-item <%= "양식".equals(currentFoodType) ? "active" : "" %>">
           <i class="fas fa-pizza-slice"></i> 양식
        </a>
        <a href="board?foodType=분식<%= keywordParam.isEmpty() ? "" : "&keyword=" + keywordParam %><%= sortParam.equals("newest") ? "" : "&sort=" + sortParam %>" 
           class="category-item <%= "분식".equals(currentFoodType) ? "active" : "" %>">
           <i class="fas fa-hotdog"></i> 분식
        </a>
        <a href="board?foodType=카페/디저트<%= keywordParam.isEmpty() ? "" : "&keyword=" + keywordParam %><%= sortParam.equals("newest") ? "" : "&sort=" + sortParam %>" 
           class="category-item <%= "카페/디저트".equals(currentFoodType) ? "active" : "" %>">
           <i class="fas fa-coffee"></i> 카페/디저트
        </a>
        <a href="board?foodType=기타<%= keywordParam.isEmpty() ? "" : "&keyword=" + keywordParam %><%= sortParam.equals("newest") ? "" : "&sort=" + sortParam %>" 
           class="category-item <%= "기타".equals(currentFoodType) ? "active" : "" %>">
           <i class="fas fa-ellipsis-h"></i> 기타
        </a>
    </div>

    <div class="board-tools">
        <form action="board" method="get" class="search-form">
            <div class="search-input-wrapper">
                <i class="fas fa-search search-icon"></i>
                <input type="text" name="keyword" placeholder="가게명, 지역, 작성자 이름 검색" 
                       value="<%= keywordParam %>">
                <% if(currentFoodType != null && !currentFoodType.isEmpty()) { %>
                    <input type="hidden" name="foodType" value="<%= currentFoodType %>">
                <% } %>
            </div>
            <button type="submit" class="search-button">검색</button>
            
            <div class="sort-buttons">
                <button type="submit" name="sort" value="newest"
                    class="<%= "newest".equals(sortParam) ? "active" : "" %>">
                    <i class="fas fa-clock"></i> 최신순
                </button>
                <button type="submit" name="sort" value="popular"
                    class="<%= "popular".equals(sortParam) ? "active" : "" %>">
                    <i class="fas fa-heart"></i> 인기순
                </button>
            </div>
            
            <div class="write-button-wrap">
                <a href="${pageContext.request.contextPath}/views/write.jsp" class="write-button">
                    <i class="fas fa-pencil-alt"></i> 글쓰기
                </a>
            </div>
        </form>
    </div>
    
    <!-- 게시글 목록 (테이블 형식) -->
    <div class="post-list-container">
        <table class="post-table">
            <thead>
                <tr>
                    <th>제목</th>
                    <th>가게명</th>
                    <th class="hide-on-mobile">음식 종류</th>
                    <th class="hide-on-mobile">위치</th>
                    <th class="hide-on-mobile">작성자</th>
                    <th class="hide-on-mobile">작성일</th>
                    <th><i class="fas fa-heart"></i></th>
                    <th><i class="fas fa-comment"></i></th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Post> postList = (List<Post>) request.getAttribute("postList");
                    if (postList != null && !postList.isEmpty()) {
                        for (Post p : postList) {
                            String date = sdf.format(p.getCreatedAt());
                %>
                <tr onclick="location.href='postDetail?postId=<%= p.getPostId() %>'" class="post-row">
                    <td class="post-title"><%= p.getTitle() %></td>
                    <td><%= p.getStoreName() %></td>
                    <td class="hide-on-mobile"><span class="food-type-badge"><%= p.getFoodType() %></span></td>
                    <td class="hide-on-mobile"><i class="fas fa-map-marker-alt"></i> <%= p.getLocation() %></td>
                    <td class="hide-on-mobile"><i class="fas fa-user"></i> <%= p.getUsername() %></td>
                    <td class="hide-on-mobile"><%= date %></td>
                    <td><span class="like-count"><%= p.getLikeCount() %></span></td>
                    <td><span class="comment-count"><%= p.getCommentCount() %></span></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="8" class="no-posts">
                        <div class="empty-state">
                            <i class="fas fa-search"></i>
                            <p>등록된 게시글이 없습니다.</p>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- 게시글 목록 (카드 형식 - 모바일용) -->
    <div class="post-cards">
        <%
            if (postList != null && !postList.isEmpty()) {
                for (Post p : postList) {
                    String date = sdf.format(p.getCreatedAt());
        %>
        <a href="postDetail?postId=<%= p.getPostId() %>" class="post-card">
            <div class="post-card-header">
                <h3><%= p.getTitle() %></h3>
                <span class="food-type-badge"><%= p.getFoodType() %></span>
            </div>
            <div class="post-card-body">
                <p class="store-name"><i class="fas fa-store"></i> <%= p.getStoreName() %></p>
                <p class="location"><i class="fas fa-map-marker-alt"></i> <%= p.getLocation() %></p>
            </div>
            <div class="post-card-footer">
                <span class="author"><i class="fas fa-user"></i> <%= p.getUsername() %></span>
                <span class="date"><i class="fas fa-calendar"></i> <%= date %></span>
                <div class="post-stats">
                    <span class="like-count"><i class="fas fa-heart"></i> <%= p.getLikeCount() %></span>
                    <span class="comment-count"><i class="fas fa-comment"></i> <%= p.getCommentCount() %></span>
                </div>
            </div>
        </a>
        <%
                }
            } else {
        %>
        <div class="empty-state">
            <i class="fas fa-search"></i>
            <p>등록된 게시글이 없습니다.</p>
        </div>
        <%
            }
        %>
    </div>

    <!-- 페이지네이션 -->
    <div class="pagination">
    	<%
	        int currentPage = (Integer) request.getAttribute("currentPage");
	        int totalPages = (Integer) request.getAttribute("totalPages");
	
	        int startPage = Math.max(1, currentPage - 2);
	        int endPage = Math.min(totalPages, currentPage + 2);
	
	        // 이전 페이지
	        if (currentPage > 1) {
	            StringBuilder prevUrl = new StringBuilder("board?page=" + (currentPage - 1));
	            if(currentFoodType != null && !currentFoodType.isEmpty()) {
	                prevUrl.append("&foodType=").append(currentFoodType);
	            }
	            if(!keywordParam.isEmpty()) {
	                prevUrl.append("&keyword=").append(keywordParam);
	            }
	            if(!"newest".equals(sortParam)) {
	                prevUrl.append("&sort=").append(sortParam);
	            }
	    %>
	        <a href="<%= prevUrl.toString() %>" class="page-nav">
	            <i class="fas fa-chevron-left"></i>
	        </a>
	    <%
	        }
	
	        // 페이지 번호들
	        for (int i = startPage; i <= endPage; i++) {
	            StringBuilder pageUrl = new StringBuilder("board?page=" + i);
	            if(currentFoodType != null && !currentFoodType.isEmpty()) {
	                pageUrl.append("&foodType=").append(currentFoodType);
	            }
	            if(!keywordParam.isEmpty()) {
	                pageUrl.append("&keyword=").append(keywordParam);
	            }
	            if(!"newest".equals(sortParam)) {
	                pageUrl.append("&sort=").append(sortParam);
	            }
	    %>
	        <a href="<%= pageUrl.toString() %>" class="page-num <%= (i == currentPage ? "active" : "") %>"><%= i %></a>
	    <%
	        }
	
	        // 다음 페이지
	        if (currentPage < totalPages) {
	            StringBuilder nextUrl = new StringBuilder("board?page=" + (currentPage + 1));
	            if(currentFoodType != null && !currentFoodType.isEmpty()) {
	                nextUrl.append("&foodType=").append(currentFoodType);
	            }
	            if(!keywordParam.isEmpty()) {
	                nextUrl.append("&keyword=").append(keywordParam);
	            }
	            if(!"newest".equals(sortParam)) {
	                nextUrl.append("&sort=").append(sortParam);
	            }
	    %>
	        <a href="<%= nextUrl.toString() %>" class="page-nav">
	            <i class="fas fa-chevron-right"></i>
	        </a>
	    <%
	        }
	    %>
	</div>
</div>

<script>
    // 모바일에서 테이블 헤더 고정
    window.addEventListener('scroll', function() {
        const tableHeader = document.querySelector('.post-table thead');
        if (tableHeader) {
            if (window.scrollY > 200) {
                tableHeader.classList.add('sticky');
            } else {
                tableHeader.classList.remove('sticky');
            }
        }
    });
</script>
</body>
</html>