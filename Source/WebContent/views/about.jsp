<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 - 서비스 소개</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/about.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%@ include file="./header.jsp" %>

    <div class="about-container">
        <!-- 헤더 배너 섹션 -->
        <section class="hero-section">
            <div class="hero-content">
                <h1>맛스팟 <span>MatSpot</span></h1>
                <p class="tagline">맛있는 발견의 시작, 맛스팟과 함께하세요</p>
            </div>
        </section>

        <!-- 서비스 소개 섹션 -->
        <section class="intro-section">
            <div class="section-header">
                <h2>맛스팟 소개</h2>
                <div class="divider"></div>
            </div>
            <div class="intro-content">
                <div class="intro-text">
                    <p>맛스팟은 맛집을 사랑하는 모든 분들을 위한 커뮤니티 플랫폼입니다. 숨겨진 맛집을 발견하고, 나만의 맛집 경험을 공유하며, 다양한 음식 문화를 탐험할 수 있는 공간을 제공합니다.</p>
                    <p>2025년에 시작된 맛스팟은 사용자들의 진솔한 리뷰와 추천을 바탕으로 신뢰할 수 있는 맛집 정보를 제공하는 것을 목표로 합니다. 전국 각지의 다양한 맛집 정보를 한 곳에서 쉽게 찾아보고, 자신만의 맛집 리스트를 만들어 보세요.</p>
                </div>
                <div class="intro-image">
                    <img src="${pageContext.request.contextPath}/images/about-intro.png" alt="맛스팟 소개 이미지">
                </div>
            </div>
        </section>

        <!-- 주요 기능 섹션 -->
        <section class="features-section">
            <div class="section-header">
                <h2>주요 기능</h2>
                <div class="divider"></div>
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3>맛집 검색</h3>
                    <p>지역, 음식 종류, 가게명 등 다양한 조건으로 맛집을 검색하고 찾아보세요.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-pencil-alt"></i>
                    </div>
                    <h3>리뷰 작성</h3>
                    <p>방문한 맛집에 대한 솔직한 리뷰와 평가를 작성하고 공유하세요.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <h3>맛집 저장</h3>
                    <p>마음에 드는 맛집을 저장하고 나만의 맛집 리스트를 만들어보세요.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h3>커뮤니티</h3>
                    <p>다른 사용자들과 맛집 정보를 공유하고 소통하는 커뮤니티에 참여하세요.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-map-marker-alt"></i>
                    </div>
                    <h3>위치 기반 추천</h3>
                    <p>현재 위치를 기반으로 주변의 인기 맛집을 추천받을 수 있습니다.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>평점 시스템</h3>
                    <p>맛, 가격, 서비스 등 다양한 기준으로 맛집을 평가하고 참고할 수 있습니다.</p>
                </div>
            </div>
        </section>

        <!-- 이용 방법 섹션 -->
        <section class="how-to-section">
            <div class="section-header">
                <h2>이용 방법</h2>
                <div class="divider"></div>
            </div>
            <div class="steps-container">
                <div class="step">
                    <div class="step-number">01</div>
                    <div class="step-content">
                        <h3>회원가입</h3>
                        <p>간단한 정보로 맛스팟에 가입하세요. 이메일 인증 후 모든 서비스를 이용할 수 있습니다.</p>
                    </div>
                </div>
                <div class="step">
                    <div class="step-number">02</div>
                    <div class="step-content">
                        <h3>맛집 검색</h3>
                        <p>지역, 음식 종류 등 원하는 조건으로 맛집을 검색하고 다양한 정보를 확인하세요.</p>
                    </div>
                </div>
                <div class="step">
                    <div class="step-number">03</div>
                    <div class="step-content">
                        <h3>리뷰 확인</h3>
                        <p>다른 사용자들의 솔직한 리뷰와 평점을 확인하고 방문할 맛집을 결정하세요.</p>
                    </div>
                </div>
                <div class="step">
                    <div class="step-number">04</div>
                    <div class="step-content">
                        <h3>맛집 방문</h3>
                        <p>맛스팟에서 찾은 맛집을 방문하고 직접 맛있는 음식을 경험해보세요.</p>
                    </div>
                </div>
                <div class="step">
                    <div class="step-number">05</div>
                    <div class="step-content">
                        <h3>리뷰 작성</h3>
                        <p>방문한 맛집에 대한 솔직한 리뷰와 평가를 작성하고 다른 사용자들과 경험을 공유하세요.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- 팀 소개 섹션 -->
        <section class="team-section">
            <div class="section-header">
                <h2>맛스팟 팀</h2>
                <div class="divider"></div>
            </div>
            <div class="team-intro">
                <p>맛스팟은 맛집을 사랑하는 열정적인 팀원들이 모여 만든 서비스입니다. 사용자들에게 더 나은 맛집 경험을 제공하기 위해 항상 노력하고 있습니다.</p>
            </div>
            <div class="team-grid">
                <div class="team-member">
                    <div class="member-photo">
                        <img src="${pageContext.request.contextPath}/images/team-member1.png" alt="팀원 1">
                    </div>
                    <h3>김선빈</h3>
                    <p class="member-role">서비스 기획</p>
                </div>
                <div class="team-member">
                    <div class="member-photo">
                        <img src="${pageContext.request.contextPath}/images/team-member2.png" alt="팀원 2">
                    </div>
                    <h3>김토란</h3>
                    <p class="member-role">개발 총괄</p>
                </div>
                <div class="team-member">
                    <div class="member-photo">
                        <img src="${pageContext.request.contextPath}/images/team-member3.png" alt="팀원 3">
                    </div>
                    <h3>김디자인</h3>
                    <p class="member-role">UI/UX 디자인</p>
                </div>
                <div class="team-member">
                    <div class="member-photo">
                        <img src="${pageContext.request.contextPath}/images/team-member4.png" alt="팀원 4">
                    </div>
                    <h3>김마케팅</h3>
                    <p class="member-role">마케팅 담당</p>
                </div>
            </div>
        </section>

        <!-- 연락처 섹션 -->
        <section class="contact-section">
            <div class="section-header">
                <h2>문의하기</h2>
                <div class="divider"></div>
            </div>
            <div class="contact-content">
                <div class="contact-info">
                    <div class="contact-item">
                        <i class="fas fa-envelope"></i>
                        <p>이메일: toran16784@gmail.com</p>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-phone"></i>
                        <p>전화: 010-7178-5852</p>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <p>주소: 안양대학교 소프트웨어학과</p>
                    </div>
                </div>
                <div class="social-links">
                <!--
                	<a href="#" class="social-link"><i class="fab fa-facebook"></i></a>
                    <a href="#" class="social-link"><i class="fab fa-twitter"></i></a> 
                 -->
                    <a href="https://github.com/toran1678" class="social-link"><i class="fab fa-github"></i></a>
                    <a href="https://www.instagram.com/s__empty_/" class="social-link"><i class="fab fa-instagram"></i></a>
                    <a href="https://www.youtube.com/@%EA%B9%80%EC%84%A0%EB%B9%88-f6w" class="social-link"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
        </section>

        <!-- CTA 섹션 -->
        <section class="cta-section">
            <div class="cta-content">
                <h2>지금 바로 맛스팟과 함께 맛있는 여정을 시작하세요!</h2>
                <p>맛스팟에 가입하고 다양한 맛집 정보를 확인하고 공유해보세요.</p>
                <div class="cta-buttons">
                    <a href="${pageContext.request.contextPath}/views/signup.jsp" class="cta-button primary">회원가입</a>
                    <a href="${pageContext.request.contextPath}/board" class="cta-button secondary">맛집 둘러보기</a>
                </div>
            </div>
        </section>
    </div>

    <!-- 푸터 포함 -->
    <footer class="about-footer">
        <div class="footer-content">
            <div class="footer-logo">
                <i class="fas fa-utensils"></i>
                <span>맛스팟</span>
            </div>
            <p class="copyright">© 2025 맛스팟. All rights reserved.</p>
            <div class="footer-links">
            	<a>소프트웨어학과 2020E7309 김선빈</a>
            	<!--
	                <a href="${pageContext.request.contextPath}/views/terms.jsp">이용약관</a>
	                <a href="${pageContext.request.contextPath}/views/privacy.jsp">개인정보처리방침</a>
	                <a href="${pageContext.request.contextPath}/views/about.jsp">서비스 소개</a>
                -->
            </div>
        </div>
    </footer>

    <script>
        // 스크롤 애니메이션
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('section');
            
            sections.forEach(section => {
                const sectionTop = section.getBoundingClientRect().top;
                const windowHeight = window.innerHeight;
                
                if (sectionTop < windowHeight * 0.75) {
                    section.classList.add('animate');
                }
            });
        });

        // 페이지 로드 시 첫 번째 섹션 애니메이션 적용
        window.addEventListener('load', function() {
            document.querySelector('.hero-section').classList.add('animate');
            document.querySelector('.intro-section').classList.add('animate');
        });
    </script>
</body>
</html>