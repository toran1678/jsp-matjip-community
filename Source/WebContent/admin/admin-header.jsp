<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentURI = request.getRequestURI();
    String adminUsername = (String) session.getAttribute("adminUsername");
    
    // 디버깅 정보 출력
    System.out.println("Current URI: " + currentURI);
    System.out.println("Admin Username: " + adminUsername);
    
    if (adminUsername == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }
%>
<header class="admin-header">
    <div class="header-container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <h1>맛스팟 <span>관리자</span></h1>
            </a>
        </div>
        <nav class="admin-nav">
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="<%= currentURI.contains("/dashboard") ? "active" : "" %>"><i class="fas fa-tachometer-alt"></i> 대시보드</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users" class="<%= currentURI.contains("/users") ? "active" : "" %>"><i class="fas fa-users"></i> 사용자 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/posts" class="<%= currentURI.contains("/posts") ? "active" : "" %>"><i class="fas fa-utensils"></i> 게시물 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/stats" class="<%= currentURI.contains("/stats") ? "active" : "" %>"><i class="fas fa-chart-bar"></i> 통계</a></li>
            </ul>
        </nav>
        <div class="admin-actions">
            <a href="${pageContext.request.contextPath}/main" class="view-site" target="_blank"><i class="fas fa-external-link-alt"></i> 사이트 보기</a>
            <a href="${pageContext.request.contextPath}/admin/logout" class="logout-button"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
        </div>
    </div>
</header>

<!-- 디버깅 정보 (개발 중에만 사용) -->
<div style="display: none;">
    <p>Current URI: <%= currentURI %></p>
    <p>Dashboard Active: <%= currentURI.contains("/dashboard") %></p>
    <p>Users Active: <%= currentURI.contains("/users") %></p>
    <p>Posts Active: <%= currentURI.contains("/posts") %></p>
    <p>Stats Active: <%= currentURI.contains("/stats") %></p>
</div>