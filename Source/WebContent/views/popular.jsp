<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Post" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 - 인기 맛집</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/popular.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%@ include file="./header.jsp" %>

    <div class="popular-container">
        <div class="popular-header">
            <h1><i class="fas fa-crown"></i> 인기 맛집 TOP 10</h1>
            <p>사용자들이 가장 많이 추천한 맛집들을 확인해보세요!</p>
        </div>

        <div class="popular-content">
            <% 
            List<Post> popularPosts = (List<Post>)request.getAttribute("popularPosts");
            if(popularPosts != null && !popularPosts.isEmpty()) {
                int rank = 1;
                for(Post post : popularPosts) {
            %>
                <div class="post-card">
                    <div class="post-rank">
                        <span class="rank-number"><%= rank++ %></span>
                        <span class="like-count"><i class="fas fa-heart"></i> <%= post.getLikeCount() %></span>
                    </div>
                    <div class="post-info">
                        <h3 class="post-title"><a href="${pageContext.request.contextPath}/postDetail?postId=<%= post.getPostId() %>"><%= post.getStoreName() %></a></h3>
                        <div class="post-meta">
                            <span class="post-category"><i class="fas fa-utensils"></i> <%= post.getFoodType() %></span>
                            <span class="post-location"><i class="fas fa-map-marker-alt"></i> <%= post.getLocation() %></span>
                        </div>
                        <p class="post-description"><%= post.getTitle() %></p>
                        <div class="post-footer">
                            <span class="post-author"><i class="fas fa-user"></i> <%= post.getUsername() %></span>
                            <span class="post-date"><i class="fas fa-calendar-alt"></i> <%= post.getCreatedAt().toString().substring(0, 10) %></span>
                        </div>
                    </div>
                </div>
            <% 
                }
            } else {
            %>
                <div class="empty-state">
                    <i class="fas fa-heart-broken"></i>
                    <p>아직 인기 맛집이 없습니다.</p>
                </div>
            <% } %>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-content">
            <div class="footer-logo">
                <h3>맛스팟</h3>
                <p>맛있는 발견의 시작</p>
            </div>
            <div class="footer-links">
                <h4>바로가기</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/main">홈</a></li>
                    <li><a href="${pageContext.request.contextPath}/views/about.jsp">소개</a></li>
                    <li><a href="${pageContext.request.contextPath}/board">맛집 목록</a></li>
                    <li><a href="${pageContext.request.contextPath}/views/write.jsp">맛집 등록</a></li>
                </ul>
            </div>
            <div class="footer-contact">
                <h4>문의하기</h4>
                <p><i class="fas fa-envelope"></i> toran16784@gmail.com</p>
                <p><i class="fas fa-phone"></i> 010-7178-5852</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 맛스팟. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>