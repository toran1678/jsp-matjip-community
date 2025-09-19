<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 이미 로그인했다면 관리자 화면으로
	Boolean isAdmin = (Boolean) session.getAttribute("adminLoggedIn");
    if (isAdmin != null && isAdmin) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 - 관리자 로그인</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminLogin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="admin-login-container">
        <div class="login-box">
            <div class="login-header">
                <div class="logo">
                    <i class="fas fa-utensils"></i>
                    <h1>맛스팟</h1>
                </div>
                <h2>관리자 로그인</h2>
                <p>관리자 페이지에 접근하기 위해 로그인해주세요.</p>
            </div>
            
            <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/admin/login" method="post" class="login-form">
                <!-- CSRF 토큰 (보안 강화) -->
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                
                <div class="form-group">
                    <label for="adminId">
                        <i class="fas fa-user"></i>
                        <span>관리자 아이디</span>
                    </label>
                    <input type="text" id="adminId" name="adminId" required placeholder="관리자 아이디를 입력하세요">
                </div>
                
                <div class="form-group">
                    <label for="adminPassword">
                        <i class="fas fa-lock"></i>
                        <span>비밀번호</span>
                    </label>
                    <div class="password-input-wrapper">
                        <input type="password" id="adminPassword" name="adminPassword" required placeholder="비밀번호를 입력하세요">
                        <button type="button" id="togglePassword" class="toggle-password">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>
                <!-- 
                <div class="form-group remember-me">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe">로그인 상태 유지</label>
                </div> -->
                
                <button type="submit" class="login-button">
                    <i class="fas fa-sign-in-alt"></i>
                    관리자 로그인
                </button>
            </form>
            
            <div class="login-footer">
                <a href="${pageContext.request.contextPath}/" class="back-to-main">
                    <i class="fas fa-arrow-left"></i>
                    메인으로 돌아가기
                </a>
                <a href="${pageContext.request.contextPath}/views/login.jsp" class="forgot-password">
                    로그인으로 돌아가기
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            
            <div class="security-notice">
                <i class="fas fa-shield-alt"></i>
                <p>관리자 계정은 보안을 위해 정기적으로 비밀번호를 변경해주세요.</p>
            </div>
        </div>
    </div>
    
    <script>
        // 비밀번호 표시/숨김 토글
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordInput = document.getElementById('adminPassword');
            const icon = this.querySelector('i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
        
        // 폼 제출 시 유효성 검사
        document.querySelector('.login-form').addEventListener('submit', function(e) {
            const adminId = document.getElementById('adminId').value.trim();
            const adminPassword = document.getElementById('adminPassword').value.trim();
            
            if (adminId === '' || adminPassword === '') {
                e.preventDefault();
                alert('아이디와 비밀번호를 모두 입력해주세요.');
            }
        });
    </script>
</body>
</html>