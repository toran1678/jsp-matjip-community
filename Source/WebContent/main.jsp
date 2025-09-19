<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.*, model.Post, model.Comment, dao.UserDAO" %>
<%
	String userEmail = (String) session.getAttribute("userEmail");
	
	if (userEmail == null) {
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (Cookie cookie : cookies) {
	            if ("userEmail".equals(cookie.getName())) {
	                session.setAttribute("userEmail", cookie.getValue());
	            }
	            if ("username".equals(cookie.getName())) {
	                session.setAttribute("username", cookie.getValue());
	            }
	        }
	    }
	}
  
	if (userEmail != null && session.getAttribute("userId") == null) {
		UserDAO userDAO = new UserDAO();
		int userid = userDAO.getUserIdByEmail(userEmail); // 새로 만들어줘야 할 메서드
		session.setAttribute("userId", userid);
	}
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <title>맛스팟 - 메인</title>
</head>
<body>
<%@ include file="./views/header.jsp" %>

<div class="hero-section">
  <div class="hero-content">
    <h1>맛스팟에서 맛있는 발견을 시작하세요</h1>
    <p>사용자들이 직접 추천하는 진짜 맛집 정보</p>
    <div class="hero-buttons">
      <a href="/jsp_project/views/write.jsp" class="btn btn-primary">맛집 공유하기</a>
      <a href="#latest-posts" class="btn btn-secondary">추천 맛집 보기</a>
    </div>
  </div>
</div>

<div class="main-container">
  <div class="main-content">
    <section id="latest-posts" class="section">
      <div class="section-header">
        <h2 class="section-title"><i class="fas fa-utensils"></i> 최신 추천 맛집</h2>
        <a href="posts?category=latest" class="view-all">전체보기 <i class="fas fa-angle-right"></i></a>
      </div>
      <div class="post-grid">
        <%
          List<Post> posts = (List<Post>) request.getAttribute("latestPosts");
          if (posts != null && !posts.isEmpty()) {
            for (Post post : posts) {
        %>
        <a href="postDetail?postId=<%= post.getPostId() %>" class="post-card-link">
          <div class="post-card">
            <div class="post-card-header">
              <h3><%= post.getStoreName() %></h3>
              <span class="post-category"><%= post.getFoodType() %></span>
            </div>
            <div class="post-card-content">
              <p class="post-description"><%= post.getContent() %></p>
            </div>
            <div class="post-card-footer">
              <div class="post-location">
                <i class="fas fa-map-marker-alt"></i> <%= post.getLocation() %>
              </div>
              <div class="post-author">
                <i class="fas fa-user"></i> <%= post.getUsername() %>
              </div>
            </div>
          </div>
        </a>
        <%
            }
          } else {
        %>
        <div class="empty-state">
          <i class="fas fa-search"></i>
          <p>등록된 게시물이 없습니다.</p>
        </div>
        <%
          }
        %>
      </div>
    </section>

    <section class="section">
      <div class="section-header">
        <h2 class="section-title"><i class="fas fa-crown"></i> 추천 맛집 TOP 6</h2>
        <a href="posts?category=top" class="view-all">전체보기 <i class="fas fa-angle-right"></i></a>
      </div>
      <div class="post-grid">
        <%
          List<Post> top = (List<Post>) request.getAttribute("topLikedPosts");
          if (top != null && !top.isEmpty()) {
            for (Post post : top) {
        %>
        <a href="postDetail?postId=<%= post.getPostId() %>" class="post-card-link">
          <div class="post-card popular">
            <div class="post-card-header">
              <h3><%= post.getStoreName() %></h3>
              <span class="post-category"><%= post.getFoodType() %></span>
            </div>
            <div class="post-card-content">
              <p class="post-description"><%= post.getContent() %></p>
            </div>
            <div class="post-card-footer">
              <div class="post-location">
                <i class="fas fa-map-marker-alt"></i> <%= post.getLocation() %>
              </div>
              <div class="post-meta">
                <span class="post-likes"><i class="fas fa-heart"></i> <%= post.getLikeCount() %></span>
                <span class="post-author"><i class="fas fa-user"></i> <%= post.getUsername() %></span>
              </div>
            </div>
          </div>
        </a>
        <%
            }
          } else {
        %>
        <div class="empty-state">
          <i class="fas fa-heart"></i>
          <p>추천 맛집이 없습니다.</p>
        </div>
        <%
          }
        %>
      </div>
    </section>

    <div class="two-column-layout">
      <section class="section best-review-section">
        <div class="section-header">
          <h2 class="section-title"><i class="fas fa-medal"></i> 이번 주의 BEST 리뷰</h2>
        </div>
        <%
          Post best = (Post) request.getAttribute("bestReview");
          if (best != null) {
        %>
        <a href="postDetail?postId=<%= best.getPostId() %>" class="post-card-link">
          <div class="post-card best-review">
            <div class="post-card-header">
              <h3><%= best.getStoreName() %></h3>
              <span class="post-title"><%= best.getTitle() %></span>
            </div>
            <div class="post-card-content">
              <p class="post-description"><%= best.getContent() %></p>
            </div>
            <div class="post-card-footer">
              <div class="post-info">
                <span class="post-category"><%= best.getFoodType() %></span>
                <span class="post-location"><i class="fas fa-map-marker-alt"></i> <%= best.getLocation() %></span>
              </div>
              <div class="post-meta">
                <span class="post-likes"><i class="fas fa-heart"></i> <%= best.getLikeCount() %></span>
                <span class="post-author"><i class="fas fa-user"></i> <%= best.getUsername() %></span>
              </div>
            </div>
          </div>
        </a>
        <% } else { %>
        <div class="empty-state">
          <i class="fas fa-award"></i>
          <p>이번 주 BEST 리뷰가 아직 없습니다.</p>
        </div>
        <% } %>
      </section>

      <section class="section">
        <div class="section-header">
          <h2 class="section-title"><i class="fas fa-comments"></i> 실시간 댓글</h2>
          <a href="comments" class="view-all">전체보기 <i class="fas fa-angle-right"></i></a>
        </div>
        <div class="comment-list">
          <%
            List<Comment> comments = (List<Comment>) request.getAttribute("latestComments");
            if (comments != null && !comments.isEmpty()) {
              for (Comment c : comments) {
          %>
          <a href="postDetail?postId=<%= c.getPostId() %>" class="comment-link">
            <div class="comment-item">
              <div class="comment-header">
                <span class="comment-author"><i class="fas fa-user"></i> <%= c.getUsername() %></span>
                <span class="comment-store"><i class="fas fa-store"></i> <%= c.getStoreName() %></span>
              </div>
              <p class="comment-content">"<%= c.getContent() %>"</p>
            </div>
          </a>
          <%
              }
            } else {
          %>
          <div class="empty-state">
            <i class="fas fa-comment-slash"></i>
            <p>아직 댓글이 없습니다.</p>
          </div>
          <%
            }
          %>
        </div>
      </section>
    </div>
  </div>

  <aside class="sidebar">
    <div class="sidebar-section">
      <h3 class="sidebar-title">카테고리</h3>
      <ul class="category-list">
        <li><a href="board?foodType=한식"><i class="fas fa-utensils"></i> 한식</a></li>
        <li><a href="board?foodType=중식"><i class="fas fa-utensils"></i> 중식</a></li>
        <li><a href="board?foodType=일식"><i class="fas fa-utensils"></i> 일식</a></li>
        <li><a href="board?foodType=양식"><i class="fas fa-utensils"></i> 양식</a></li>
        <li><a href="board?foodType=분식"><i class="fas fa-utensils"></i> 분식</a></li>
        <li><a href="board?foodType=카페/디저트"><i class="fas fa-coffee"></i> 카페/디저트</a></li>
        <li><a href="board?foodType=기타"><i class="fas fa-ellipsis-h"></i> 기타</a></li>
      </ul>
    </div>

    <div class="sidebar-section">
      <h3 class="sidebar-title">오늘의 추천</h3>
      <%
        Post random = (Post) request.getAttribute("randomPost");
        if (random != null) {
      %>
      <a href="postDetail?postId=<%= random.getPostId() %>" class="sidebar-card-link">
        <div class="sidebar-card">
          <h4><%= random.getStoreName() %></h4>
          <p><%= random.getFoodType() %> | <%= random.getLocation() %></p>
          <p class="sidebar-card-author"><i class="fas fa-user"></i> <%= random.getUsername() %></p>
        </div>
      </a>
      <% } else { %>
      <div class="empty-state small">
        <p>추천 맛집을 불러올 수 없습니다.</p>
      </div>
      <% } %>
    </div>

    <div class="sidebar-section">
      <h3 class="sidebar-title">맛스팟 소개</h3>
      <p class="sidebar-text">맛스팟은 사용자들이 직접 추천하는 맛집 정보 공유 커뮤니티입니다. 나만 알고 있는 맛집을 공유하고, 다른 사람들의 추천도 확인해보세요!</p>
      <a href="/jsp_project/views/about.jsp" class="sidebar-link">더 알아보기 <i class="fas fa-angle-right"></i></a>
    </div>
  </aside>
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
        <li><a href="index.jsp">홈</a></li>
        <li><a href="/jsp_project/views/about.jsp">소개</a></li>
        <li><a href="board">맛집 목록</a></li>
        <li><a href="/jsp_project/views/write.jsp">맛집 등록</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/login.jsp">관리자 로그인</a></li>
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