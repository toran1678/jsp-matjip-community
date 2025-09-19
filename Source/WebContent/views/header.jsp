<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userEmailHeader = (String) session.getAttribute("userEmail");
	String usernameHeader = (String) session.getAttribute("username");
%>
<header class="header">
  <div class="header-container">
    <div class="logo">
      <a href="${pageContext.request.contextPath}/main">
        <img src="${pageContext.request.contextPath}/images/matjip.png" alt="맛스팟 로고" class="logo-image">
        <span class="logo-text">맛스팟</span>
      </a>
    </div>
    
    <nav class="main-nav">
      <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/board" class="nav-link">맛집 게시판</a></li>
        <li><a href="${pageContext.request.contextPath}/matjipMap" class="nav-link">지도 검색</a></li>
        <li><a href="${pageContext.request.contextPath}/popular" class="nav-link">인기 맛집</a></li>
      </ul>
    </nav>
    
    <div class="auth-buttons">
      <% if (userEmailHeader != null) { %>
      	<span class="welcome-text"><strong><%= usernameHeader %></strong>님 환영합니다!</span>
      	<a href="${pageContext.request.contextPath}/logout" class="btn btn-login">로그아웃</a>
      	<a href="${pageContext.request.contextPath}/myPage" class="btn btn-signup">마이페이지</a>
      <% } else { %>
      	<a href="${pageContext.request.contextPath}/views/login.jsp" class="btn btn-login">로그인</a>
      	<a href="${pageContext.request.contextPath}/views/signup.jsp" class="btn btn-signup">회원가입</a>
      <% } %>
    </div>
    
    <!-- 모바일 메뉴 토글 버튼 -->
    <button class="mobile-menu-toggle" aria-label="메뉴 열기">
      <span class="bar"></span>
      <span class="bar"></span>
      <span class="bar"></span>
    </button>
  </div>
</header>

<!-- 모바일 메뉴 -->
<div class="mobile-menu">
  <ul class="mobile-nav-links">
    <li><a href="${pageContext.request.contextPath}/board">맛집 게시판</a></li>
    <li><a href="${pageContext.request.contextPath}/matjipMap">지도 검색</a></li>
    <li><a href="${pageContext.request.contextPath}/popular">인기 맛집</a></li>
    <li class="mobile-auth"><a href="${pageContext.request.contextPath}/views/login.jsp">로그인</a></li>
    <li class="mobile-auth"><a href="${pageContext.request.contextPath}/views/signup.jsp">회원가입</a></li>
  </ul>
</div>

<style>
  /* 기본 리셋 */
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
  
  .welcome-text {
    font-size: 16px;
    color: #333;
    font-weight: 500;
    margin-right: 12px;
  }
  
  .logo-link {
    display: flex;
    align-items: center;
    text-decoration: none;
  }

  .logo-image {
    width: 32px;
    height: 32px;
    margin-right: 8px;
    object-fit: contain;
  }

  .logo-text {
    font-size: 24px;
    font-weight: 700;
    color: #ff6b6b;
  }
  
  /* 헤더 기본 스타일 */
  .header {
    background-color: white;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    position: sticky;
    top: 0;
    z-index: 1000;
    width: 100%;
  }
  
  .header-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
    height: 70px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  /* 로고 스타일 */
  .logo a {
    display: flex;
    align-items: center;
    text-decoration: none;
    color: #ff6b6b;
    font-weight: 700;
    font-size: 24px;
    transition: transform 0.3s ease;
  }
  
  .logo a:hover {
    transform: scale(1.05);
  }
  
  /* 네비게이션 스타일 */
  .main-nav {
    display: flex;
    align-items: center;
  }
  
  .nav-links {
    display: flex;
    list-style: none;
  }
  
  .nav-links li {
    margin: 0 5px;
  }
  
  .nav-link {
    display: block;
    padding: 10px 15px;
    color: #333;
    text-decoration: none;
    font-weight: 500;
    font-size: 16px;
    border-radius: 4px;
    transition: all 0.3s ease;
  }
  
  .nav-link:hover {
    background-color: #f8f9fa;
    color: #ff6b6b;
  }
  
  /* 인증 버튼 스타일 */
  .auth-buttons {
    display: flex;
    align-items: center;
  }
  
  .btn {
    padding: 8px 16px;
    border-radius: 4px;
    text-decoration: none;
    font-weight: 500;
    font-size: 14px;
    transition: all 0.3s ease;
    margin-left: 10px;
  }
  
  .btn-login {
    color: #ff6b6b;
    border: 1px solid #ff6b6b;
    background-color: transparent;
  }
  
  .btn-login:hover {
    background-color: #fff0f0;
  }
  
  .btn-signup {
    color: white;
    background-color: #ff6b6b;
    border: 1px solid #ff6b6b;
  }
  
  .btn-signup:hover {
    background-color: #ff5252;
  }
  
  /* 모바일 메뉴 토글 버튼 */
  .mobile-menu-toggle {
    display: none;
    background: none;
    border: none;
    cursor: pointer;
    padding: 10px;
  }
  
  .mobile-menu-toggle .bar {
    display: block;
    width: 25px;
    height: 3px;
    background-color: #333;
    margin: 5px 0;
    border-radius: 3px;
    transition: all 0.3s ease;
  }
  
  /* 모바일 메뉴 */
  .mobile-menu {
    display: none;
    background-color: white;
    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
    position: absolute;
    top: 70px;
    left: 0;
    width: 100%;
    z-index: 999;
    padding: 20px;
    transform: translateY(-10px);
    opacity: 0;
    transition: all 0.3s ease;
  }
  
  .mobile-menu.active {
    transform: translateY(0);
    opacity: 1;
  }
  
  .mobile-nav-links {
    list-style: none;
  }
  
  .mobile-nav-links li {
    margin: 15px 0;
  }
  
  .mobile-nav-links a {
    display: block;
    color: #333;
    text-decoration: none;
    font-size: 16px;
    padding: 10px 0;
    border-bottom: 1px solid #eee;
  }
  
  .mobile-nav-links a:hover {
    color: #ff6b6b;
  }
  
  .mobile-auth {
    margin-top: 20px;
  }
  
  .mobile-auth a {
    font-weight: 500;
  }
  
  /* 반응형 디자인 */
  @media (max-width: 768px) {
    .main-nav, .auth-buttons {
      display: none;
    }
    
    .mobile-menu-toggle {
      display: block;
    }
    
    .mobile-menu {
      display: block;
    }
    
    .header-container {
      height: 60px;
    }
  }
  
  /* 모바일 메뉴 토글 스크립트 */
  document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
    const mobileMenu = document.querySelector('.mobile-menu');
    
    mobileMenuToggle.addEventListener('click', function() {
      mobileMenu.classList.toggle('active');
      
      // 햄버거 아이콘을 X로 변경
      const bars = this.querySelectorAll('.bar');
      this.classList.toggle('active');
      
      if (this.classList.contains('active')) {
        bars[0].style.transform = 'rotate(45deg) translate(5px, 6px)';
        bars[1].style.opacity = '0';
        bars[2].style.transform = 'rotate(-45deg) translate(5px, -6px)';
      } else {
        bars[0].style.transform = 'none';
        bars[1].style.opacity = '1';
        bars[2].style.transform = 'none';
      }
    });
  });
</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
    const mobileMenu = document.querySelector('.mobile-menu');
    
    mobileMenuToggle.addEventListener('click', function() {
      mobileMenu.classList.toggle('active');
      
      // 햄버거 아이콘을 X로 변경
      const bars = this.querySelectorAll('.bar');
      this.classList.toggle('active');
      
      if (this.classList.contains('active')) {
        bars[0].style.transform = 'rotate(45deg) translate(5px, 6px)';
        bars[1].style.opacity = '0';
        bars[2].style.transform = 'rotate(-45deg) translate(5px, -6px)';
      } else {
        bars[0].style.transform = 'none';
        bars[1].style.opacity = '1';
        bars[2].style.transform = 'none';
      }
    });
  });
</script>