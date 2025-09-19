<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <title>맛스팟 - 회원가입</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/signup.css">
</head>
<body>
    <div class="container">
        <div class="signup-form">
            <div class="logo">
                <h1>맛스팟</h1>
                <p>맛있는 곳을 공유하는 공간</p>
            </div>
            
            <form action="/jsp_project/register" method="post" onsubmit="return finalValidation()">
                <!-- 이름 -->
                <div class="form-group">
                    <label for="username">이름</label>
                    <input type="text" id="username" name="username" placeholder="이름을 입력하세요" required>
                </div>
                
                <!-- 이메일 -->
                <div class="form-group">
                    <label for="email">이메일</label>
                    <div class="input-with-button">
                        <input type="email" id="email" name="email" placeholder="example@email.com" required>
                        <button type="button" class="btn-secondary" onclick="sendEmailCode()">인증번호 전송</button>
                    </div>
                    <div id="emailMessage" class="message"></div>
                </div>
                
                <!-- 이메일 인증번호 -->
                <div class="form-group">
                    <label for="email_code">인증번호</label>
                    <div class="input-with-button">
                        <input type="text" id="email_code" name="email_code" placeholder="인증번호 6자리">
                        <button type="button" class="btn-secondary" onclick="checkEmailCode()">확인</button>
                    </div>
                    <div id="emailConfirmMessage" class="message"></div>
                </div>
                
                <!-- 비밀번호 -->
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" 
                           placeholder="영문, 숫자, 특수문자 포함 8자 이상" 
                           oninput="validatePassword()" required>
                    <div id="passwordMessage" class="message"></div>
                </div>
                
                <!-- 비밀번호 확인 -->
                <div class="form-group">
                    <label for="confirm_password">비밀번호 확인</label>
                    <input type="password" id="confirm_password" name="confirm_password" 
                           placeholder="비밀번호 재입력" 
                           oninput="checkPasswordMatch()" required>
                    <div id="confirmMessage" class="message"></div>
                </div>
                
                <button type="submit" class="signup-btn">회원가입</button>
                
                <div class="login-link">
                    이미 계정이 있으신가요? <a href="login.jsp">로그인</a><br>
                    <a href="/jsp_project/main">메인 페이지</a>
                </div>
            </form>
        </div>
        
        <!-- 간소화된 학생 정보 푸터 -->
        <footer class="footer">
            <p class="project-info">맛스팟 - 맛집 추천 커뮤니티 프로젝트</p>
            <p class="student-info">소프트웨어학과 | 2020E7309 | 김선빈</p>
            <p class="copyright">© 2025 JSP 웹 프로그래밍 프로젝트</p>
        </footer>
    </div>
    
    <script>
        let sentCode = "";
        let emailVerified = false;
        
        function sendEmailCode() {
            const email = document.getElementById("email").value;
            const emailMessage = document.getElementById("emailMessage");
            
            if (email.trim() === "") {
                emailMessage.textContent = "이메일을 입력하세요.";
                emailMessage.className = "message error";
                return;
            }
            
            // 이메일 형식 검사
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                emailMessage.textContent = "올바른 이메일 형식이 아닙니다.";
                emailMessage.className = "message error";
                return;
            }
            
            fetch("${pageContext.request.contextPath}/checkEmail?email=" + encodeURIComponent(email))
            .then(response => response.json())
            .then(result => {
              if (result.duplicate) {
                emailMessage.textContent = "이미 등록된 이메일입니다.";
                emailMessage.className = "message error";
              } else {
                fetch("${pageContext.request.contextPath}/sendEmail?email=" + encodeURIComponent(email))
                .then(response => response.text())
                .then(code => {
                  sentCode = code;
                  emailMessage.textContent = "인증번호가 이메일로 전송되었습니다.";
                  emailMessage.className = "message success";
                });
              }
            })
            .catch(error => {
              emailMessage.textContent = "이메일 전송 중 오류가 발생했습니다.";
              emailMessage.className = "message error";
            });
        }
        
        function checkEmailCode() {
            const inputCode = document.getElementById("email_code").value;
            const confirmMessage = document.getElementById("emailConfirmMessage");
            
            if (sentCode === "") {
                confirmMessage.textContent = "인증번호를 먼저 전송하세요.";
                confirmMessage.className = "message error";
                emailVerified = false;
                return;
            }
            
            if (inputCode === sentCode) {
                confirmMessage.textContent = "이메일 인증 성공";
                confirmMessage.className = "message success";
                emailVerified = true;
            } else {
                confirmMessage.textContent = "인증번호가 일치하지 않습니다.";
                confirmMessage.className = "message error";
                emailVerified = false;
            }
        }
        
        function validatePassword() {
            const password = document.getElementById("password").value;
            const passwordMessage = document.getElementById("passwordMessage");
            
            if (password.length === 0) {
                passwordMessage.textContent = "";
                passwordMessage.className = "message";
                return;
            }
            
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?])[A-Za-z\d!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]{8,}$/;
            
            if (passwordRegex.test(password)) {
                passwordMessage.textContent = "비밀번호 조건 충족";
                passwordMessage.className = "message success";
            } else {
                passwordMessage.textContent = "8자 이상, 영문자, 숫자, 특수문자를 모두 포함해야 합니다.";
                passwordMessage.className = "message error";
            }
        }
        
        function checkPasswordMatch() {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirm_password").value;
            const confirmMessage = document.getElementById("confirmMessage");
            
            if (confirmPassword.length === 0) {
                confirmMessage.textContent = "";
                confirmMessage.className = "message";
                return;
            }
            
            if (password === confirmPassword) {
                confirmMessage.textContent = "비밀번호 일치";
                confirmMessage.className = "message success";
            } else {
                confirmMessage.textContent = "비밀번호가 일치하지 않습니다.";
                confirmMessage.className = "message error";
            }
        }
        
        function finalValidation() {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirm_password").value;
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?])[A-Za-z\d!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]{8,}$/;
            
            if (!emailVerified) {
                alert("이메일 인증을 완료하세요.");
                return false;
            }
            
            if (!passwordRegex.test(password)) {
                alert("비밀번호 조건을 다시 확인하세요.");
                return false;
            }
            
            if (password !== confirmPassword) {
                alert("비밀번호가 일치하지 않습니다.");
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>