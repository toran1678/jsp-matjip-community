<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Post, model.Comment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Post post = (Post) request.getAttribute("post");
    List<Comment> comments = (List<Comment>) request.getAttribute("comments");
    
    java.text.SimpleDateFormat commentSdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
    Boolean liked = (Boolean) request.getAttribute("liked");
    Integer sessionUserId = (Integer) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 - <%= post != null ? post.getTitle() : "게시글 상세" %></title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/postDetail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 카카오 지도 API - 동적으로 로드 -->
    <script>
        // API 키를 동적으로 로드
        fetch('${pageContext.request.contextPath}/apiKey')
            .then(response => response.json())
            .then(data => {
                const script = document.createElement('script');
                script.src = `//dapi.kakao.com/v2/maps/sdk.js?appkey=${data.kakaoApiKey}&libraries=services`;
                script.onload = function() {
                    // 카카오 지도 API가 로드된 후 실행할 코드
                    initializeDetailMap();
                };
                document.head.appendChild(script);
            })
            .catch(error => {
                console.error('API 키 로드 실패:', error);
            });
    </script>
</head>
<body>
<%@ include file="./header.jsp" %>

<div class="container">
    <% if (post != null) { %>
        <div class="post-container">
            <!-- 게시글 헤더 -->
            <div class="post-header">
                <h1 class="post-title"><%= post.getTitle() %></h1>
                <div class="post-info">
                    <div class="author-info">
                        <span class="author-avatar">
                            <i class="fas fa-user-circle"></i>
                        </span>
                        <span class="author-name"><%= post.getUsername() %></span>
                    </div>
                    <%
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                        String formattedTime = sdf.format(post.getCreatedAt());
                    %>
                    <span class="post-date"><i class="far fa-clock"></i> <%= formattedTime %></span>
                </div>
            </div>
            
            <!-- 게시글 메타 정보 -->
            <div class="restaurant-info">
                <div class="info-item">
                    <span class="info-label"><i class="fas fa-store"></i> 가게명</span>
                    <span class="info-value"><%= post.getStoreName() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label"><i class="fas fa-utensils"></i> 음식 종류</span>
                    <span class="info-value"><%= post.getFoodType() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label"><i class="fas fa-map-marker-alt"></i> 위치</span>
                    <span class="info-value"><%= post.getLocation() %></span>
                </div>
            </div>
            
            <!-- 위치 지도 -->
			<!-- 위치 지도 섹션 개선 -->
			<div class="map-section">
			    <h3 class="section-title"><i class="fas fa-map-marked-alt"></i> 위치 정보</h3>
			    
			    <div class="location-info">
			        <i class="fas fa-map-marker-alt location-icon"></i>
			        <span class="location-address"><%= post.getLocation() %></span>
			    </div>
			    
			    <div class="map-container">
			        <!-- 로딩 인디케이터 -->
			        <div id="map-loading" class="map-loading">
			            <div class="spinner"></div>
			            <p>지도를 불러오는 중...</p>
			        </div>
			        
			        <div id="map" class="map-canvas"></div>
			        
			        <div id="map-error" class="map-error" style="display: none;">
			            <i class="fas fa-exclamation-circle"></i>
			            <p>위치 정보를 지도에 표시할 수 없습니다.</p>
			        </div>
			        
			        <!-- 커스텀 컨트롤은 제거 -->
			    </div>
			    
			    <div class="map-actions">
			        <a href="#" id="find-way-btn" class="map-action-button" style="display: none;" target="_blank">
			            <i class="fas fa-route"></i> 길찾기
			        </a>
			        <a href="#" id="view-larger-btn" class="map-action-button" style="display: none;" target="_blank">
			            <i class="fas fa-expand-alt"></i> 큰 지도 보기
			        </a>
			        <a href="#" id="copy-address-btn" class="map-action-button">
			            <i class="fas fa-copy"></i> 주소 복사
			        </a>
			    </div>
			</div>
            
            <!-- 이미지 표시 영역 -->
			<% if (post.getImagePath() != null && !post.getImagePath().isEmpty()) { %>
			    <div class="post-image-section">
			        <h3 class="section-title"><i class="fas fa-camera"></i> 음식 사진</h3>
			        <div class="post-image-container">
			            <img src="${pageContext.request.contextPath}/<%= post.getImagePath() %>" 
			                 alt="게시글 이미지" class="post-image" onclick="openImageModal(this.src)">
			        </div>
			    </div>
			<% } %>
            
            <!-- 게시글 내용 -->
            <div class="post-content">
                <p><%= post.getContent() %></p>
            </div>
            
            <!-- 좋아요 버튼 -->
            <div class="post-actions">
			    <form action="likePost" method="post" class="like-form">
			        <input type="hidden" name="postId" value="<%= post.getPostId() %>">
			        <button type="submit" class="like-button <%= liked != null && liked ? "liked" : "" %>">
			            <span class="like-icon">
			                <i class="<%= liked != null && liked ? "fas" : "far" %> fa-heart"></i>
			            </span>
			            <span class="like-text">좋아요</span>
			            <span class="like-count"><%= post.getLikeCount() %></span>
			        </button>
			    </form>
                
                <div class="share-buttons">
                    <button class="share-button" onclick="sharePost()">
                        <i class="fas fa-share-alt"></i> 공유하기
                    </button>
                </div>
            </div>
        </div>
        
        <!-- 이미지 확대 모달 -->
        <div id="imageModal" class="image-modal">
            <span class="close-modal" onclick="closeImageModal()">&times;</span>
            <img class="modal-content" id="modalImage">
        </div>
        
        <!-- 댓글 섹션 -->
        <div class="comments-container">
            <h2 class="comments-title">
                <i class="far fa-comment-alt"></i> 댓글 <span class="comments-count"><%= comments != null ? comments.size() : 0 %></span>
            </h2>
            
            <!-- 댓글 작성 폼 -->
            <form action="addComment" method="post" class="comment-form" id="commentForm">
                <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                <div class="comment-input-wrapper">
                    <textarea name="content" id="commentTextarea" placeholder="댓글을 입력하세요..." required></textarea>
                    <button type="submit" class="comment-submit">
                        <i class="fas fa-paper-plane"></i> 등록
                    </button>
                </div>
            </form>
            
            <!-- 댓글 목록 -->
            <div class="comments-list">
                <% if (comments != null && !comments.isEmpty()) { %>
                    <% for (Comment c : comments) { %>
                        <div class="comment-item">
                            <div class="comment-header">
                                <div class="comment-author">
                                    <span class="author-avatar">
                                        <i class="fas fa-user-circle"></i>
                                    </span>
                                    <span class="author-name"><%= c.getUsername() %></span>
                                </div>
                                <div class="comment-actions">
                                    <span class="comment-date"><%= commentSdf.format(c.getCreatedAt()) %></span>
                                    <% if (sessionUserId != null && sessionUserId == c.getUserId()) { %>
                                        <form action="deleteComment" method="post" class="delete-form" onsubmit="return confirm('댓글을 삭제하시겠습니까?');">
                                            <input type="hidden" name="commentId" value="<%= c.getCommentId() %>">
                                            <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                                            <button type="submit" class="delete-button">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </div>
                            <div class="comment-content">
                                <p><%= c.getContent() %></p>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="no-comments">
                        <i class="far fa-comment-dots"></i>
                        <p>아직 댓글이 없습니다. 첫 댓글을 작성해보세요!</p>
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- 하단 네비게이션 -->
        <div class="post-navigation">
            <a href="board" class="nav-button">
                <i class="fas fa-list"></i> 목록으로
            </a>
            <% if (sessionUserId != null && post.getUserId() == sessionUserId) { %>
                <a href="editPost?postId=<%= post.getPostId() %>" class="nav-button edit-button">
                    <i class="fas fa-edit"></i> 수정하기
                </a>
            <% } %>
        </div>
    <% } else { %>
        <div class="error-container">
            <i class="fas fa-exclamation-circle"></i>
            <h2>게시글을 찾을 수 없습니다</h2>
            <p>요청하신 게시글이 존재하지 않거나 삭제되었을 수 있습니다.</p>
            <a href="board" class="back-button">게시판으로 돌아가기</a>
        </div>
    <% } %>
</div>

<script>
	// 지도 초기화 함수
	function initializeDetailMap() {
		//지도 초기화 및 표시
		<% if (post != null) { %>
	    // 로딩 인디케이터 표시
	    const mapLoading = document.getElementById('map-loading');
	    const mapContainer = document.getElementById('map');
	    const mapOption = {
	        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 기본 중심 좌표 (서울시청)
	        level: 3, // 지도 확대 레벨
	        scrollwheel: true, // 스크롤 확대/축소 허용
	        draggable: true // 드래그 허용
	    };
	
	    // 지도 생성
	    const map = new kakao.maps.Map(mapContainer, mapOption);
	    
	    // 지도 컨트롤 추가 (카카오맵 기본 컨트롤만 사용)
	    const zoomControl = new kakao.maps.ZoomControl();
	    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
	    
	    // 지도 타입 컨트롤 추가
	    const mapTypeControl = new kakao.maps.MapTypeControl();
	    map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
	    
	    const geocoder = new kakao.maps.services.Geocoder();
	    
	    // 주소 복사 버튼 이벤트
	    document.getElementById('copy-address-btn').addEventListener('click', function(e) {
	        e.preventDefault();
	        const address = '<%= post.getLocation() %>';
	        
	        // 임시 텍스트 영역 생성
	        const textarea = document.createElement("textarea");
	        textarea.value = address;
	        textarea.style.position = "fixed";  // 화면 밖으로
	        document.body.appendChild(textarea);
	        textarea.select();
	        
	        try {
	            // 클립보드에 복사
	            document.execCommand("copy");
	            alert("주소가 클립보드에 복사되었습니다.");
	        } catch (err) {
	            console.error("클립보드 복사 실패:", err);
	            alert("주소 복사에 실패했습니다.");
	        }
	        
	        document.body.removeChild(textarea);
	    });
	    
	    // 주소로 먼저 검색 시도
	    searchByAddress();
	    
	    // 주소로 위치 검색
	    function searchByAddress() {
	        const address = '<%= post.getLocation() %>';
	        
	        if (!address || address.trim() === '') {
	            // 주소가 없는 경우 좌표로 검색
	            searchByCoords();
	            return;
	        }
	        
	        geocoder.addressSearch(address, function(result, status) {
	            if (status === kakao.maps.services.Status.OK) {
	                const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
	                displayLocation(coords, '<%= post.getStoreName() %>');
	                
	                // 길찾기 및 큰 지도 보기 링크 설정
	                document.getElementById('find-way-btn').href = 'https://map.kakao.com/link/to/<%= post.getStoreName() %>,' + result[0].y + ',' + result[0].x;
	                document.getElementById('view-larger-btn').href = 'https://map.kakao.com/link/map/<%= post.getStoreName() %>,' + result[0].y + ',' + result[0].x;
	                
	                // 버튼 표시
	                document.getElementById('find-way-btn').style.display = 'flex';
	                document.getElementById('view-larger-btn').style.display = 'flex';
	                
	                // 로딩 인디케이터 숨기기
	                mapLoading.style.display = 'none';
	            } else {
	                // 주소 검색 실패 시 좌표로 검색 시도
	                console.log("주소 검색 실패, 좌표로 검색 시도");
	                searchByCoords();
	            }
	        });
	    }
	    
	    // 좌표로 위치 검색
	    function searchByCoords() {
	        <% if (post.getX() != null && post.getY() != null) { %>
	            try {
	                const coords = new kakao.maps.LatLng(<%= post.getY() %>, <%= post.getX() %>);
	                displayLocation(coords, '<%= post.getStoreName() %>');
	                
	                // 길찾기 및 큰 지도 보기 링크 설정
	                document.getElementById('find-way-btn').href = 'https://map.kakao.com/link/to/<%= post.getStoreName() %>,<%= post.getY() %>,<%= post.getX() %>';
	                document.getElementById('view-larger-btn').href = 'https://map.kakao.com/link/map/<%= post.getStoreName() %>,<%= post.getY() %>,<%= post.getX() %>';
	                
	                // 로딩 인디케이터 숨기기
	                mapLoading.style.display = 'none';
	            } catch (e) {
	                console.error("좌표 표시 오류:", e);
	                showMapError();
	            }
	        <% } else { %>
	            // 좌표도 없는 경우 에러 표시
	            console.error("주소 및 좌표 모두 사용할 수 없음");
	            showMapError();
	        <% } %>
	    }
	    
	    // 지도 에러 표시
	    function showMapError() {
	        // 로딩 인디케이터 숨기기
	        mapLoading.style.display = 'none';
	        
	        // 위치를 찾을 수 없는 경우
	        document.getElementById('map').style.display = 'none';
	        document.getElementById('map-error').style.display = 'flex';
	        document.getElementById('find-way-btn').style.display = 'none';
	        document.getElementById('view-larger-btn').style.display = 'none';
	    }
	    
	    // 지도에 위치 표시
	    function displayLocation(coords, placeName) {
	        // 지도 중심 이동
	        map.setCenter(coords);
	        
	        // 마커 이미지 설정 (기본 마커 대신 더 눈에 띄는 마커 사용)
	        const imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
	        const imageSize = new kakao.maps.Size(24, 35);
	        const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);
	        
	        // 마커 생성
	        const marker = new kakao.maps.Marker({
	            map: map,
	            position: coords,
	            image: markerImage // 커스텀 마커 이미지 적용
	        });
	        
	        // 인포윈도우 생성
	        const infowindow = new kakao.maps.InfoWindow({
	            content: '<div class="map-info-window">' + 
	                     '<strong>' + placeName + '</strong>' +
	                     '</div>'
	        });
	        
	        // 인포윈도우 표시
	        infowindow.open(map, marker);
	        
	        // 마커 클릭 이벤트 - 인포윈도우 토글
	        kakao.maps.event.addListener(marker, 'click', function() {
	            if (infowindow.getMap()) {
	                infowindow.close();
	            } else {
	                infowindow.open(map, marker);
	            }
	        });
	        
	        // 길찾기, 큰 지도 보기 버튼 표시
	        document.getElementById('find-way-btn').style.display = 'flex';
	        document.getElementById('view-larger-btn').style.display = 'flex';
	    }
	<% } %>
    
    // 좋아요 기능
    function toggleLike() {
        const formData = new FormData(document.getElementById("likeForm"));
        
        fetch("likePost", {
            method: "POST",
            body: formData,
        })
        .then(res => res.json())
        .then(data => {
            // 아이콘과 좋아요 수 업데이트
            const likeButton = document.querySelector(".like-button");
            const likeIcon = document.getElementById("likeIcon").querySelector("i");
            const likeCount = document.getElementById("likeCount");
            
            if (data.liked) {
                likeButton.classList.add("liked");
                likeIcon.classList.remove("far");
                likeIcon.classList.add("fas");
            } else {
                likeButton.classList.remove("liked");
                likeIcon.classList.remove("fas");
                likeIcon.classList.add("far");
            }
            
            likeCount.textContent = data.likeCount;
            
            // 애니메이션 효과
            likeButton.classList.add("animate");
            setTimeout(() => {
                likeButton.classList.remove("animate");
            }, 300);
        })
        .catch(err => console.error("에러:", err));
    }
    
    // 게시글 공유
    function sharePost() {
        // 현재 URL 복사
        const url = window.location.href;
        
        // 임시 텍스트 영역 생성
        const textarea = document.createElement("textarea");
        textarea.value = url;
        textarea.style.position = "fixed";  // 화면 밖으로
        document.body.appendChild(textarea);
        textarea.select();
        
        try {
            // 클립보드에 복사
            document.execCommand("copy");
            alert("게시글 링크가 클립보드에 복사되었습니다.");
        } catch (err) {
            console.error("클립보드 복사 실패:", err);
            alert("링크 복사에 실패했습니다.");
        }
        
        document.body.removeChild(textarea);
    }
    
 	// 댓글 엔터 키 제출 기능
    document.addEventListener('DOMContentLoaded', function() {
        const commentTextarea = document.getElementById('commentTextarea');
        const commentForm = document.getElementById('commentForm');
        
        if (commentTextarea && commentForm) {
            commentTextarea.addEventListener('keydown', function(e) {
                // Enter 키가 눌렸을 때 (Shift+Enter는 제외)
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault(); // 기본 엔터 동작 방지
                    
                    // 내용이 비어있지 않은 경우에만 제출
                    if (commentTextarea.value.trim() !== '') {
                        commentForm.submit();
                    }
                }
            });
            
            // 사용 안내 툴팁 추가
            const tooltipText = document.createElement('div');
            tooltipText.className = 'comment-tooltip';
            tooltipText.innerHTML = '<i class="fas fa-info-circle"></i> Enter 키로 댓글 작성, Shift+Enter로 줄바꿈';
            commentForm.appendChild(tooltipText);
        }
    });
    
 	// 이미지 모달 관련 함수
    function openImageModal(src) {
        const modal = document.getElementById('imageModal');
        const modalImg = document.getElementById('modalImage');
        modal.style.display = "block";
        modalImg.src = src;
    }
    
    function closeImageModal() {
        const modal = document.getElementById('imageModal');
        modal.style.display = "none";
    }
    
    // ESC 키로 모달 닫기
    document.addEventListener('keydown', function(event) {
        if (event.key === "Escape") {
            closeImageModal();
        }
    });
    
    // 모달 외부 클릭 시 닫기
    window.onclick = function(event) {
        const modal = document.getElementById('imageModal');
        if (event.target == modal) {
            closeImageModal();
        }
    }
    }
</script>

<%
    String deleteMessage = (String) session.getAttribute("deleteMessage");
    if (deleteMessage != null) {
%>
<script>
    alert("<%= deleteMessage %>");
</script>
<%
    session.removeAttribute("deleteMessage");
    }
%>
</body>
</html>