<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <title>맛스팟 - 로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <% if ("loginFailed".equals(request.getParameter("error"))) { %>
	    <script>alert("로그인에 실패하였습니다..");</script>
	<% } %>
	<% if ("true".equals(request.getParameter("deleted"))) { %>
	    <script>alert("계정이 성공적으로 삭제되었습니다.");</script>
	<% } %>
</head>
<body>
    <div class="container">
        <div class="login-form">
            <div class="logo">
                <h1>맛스팟</h1>
                <p>맛있는 곳을 공유하는 공간</p>
            </div>
            
            <form action="/jsp_project/login" method="post">
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" placeholder="이메일 주소를 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
                </div>
                
                <div class="form-options">
                    <div class="remember-me">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">로그인 상태 유지</label>
                    </div>
                    <a href="findPassword.jsp" class="forgot-password">비밀번호 찾기</a>
                </div>
                
                <button type="submit" class="login-btn">로그인</button>
                
                <div class="signup-link">
                    아직 회원이 아니신가요? <a href="signup.jsp">회원가입</a><br>
					<a href="/jsp_project/main">메인 페이지</a>
                </div>
            </form>
        </div>
        
        <!-- 학생 정보 푸터 -->
        <footer class="footer">
            <p class="project-info">맛스팟 - 맛집 추천 커뮤니티 프로젝트</p>
            <p class="student-info">소프트웨어학과 | 2020E7309 | 김선빈</p>
            <p class="copyright">© 2025 JSP 웹 프로그래밍 프로젝트</p>
        </footer>
    </div>
    
    <% 
    // 로그인 실패 시 에러 메시지 표시
    String error = request.getParameter("error");
    if(error != null && error.equals("1")) {
    %>
    <script>
        alert("이메일 또는 비밀번호가 올바르지 않습니다.");
    </script>
    <% } %>
</body>
</html>