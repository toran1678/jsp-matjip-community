<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.User, model.Post, model.Comment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dao.UserDAO" %>
<%
    UserDAO userDAO = new UserDAO();
	String email = (String) session.getAttribute("userEmail");
	
	User user = userDAO.getUserByEmail(email);
    List<Post> myPosts = (List<Post>) request.getAttribute("myPosts");
    List<Post> likedPosts = (List<Post>) request.getAttribute("likedPosts");
    List<Comment> myComments = (List<Comment>) request.getAttribute("myComments");
    
    // 날짜 포맷
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    
    // 현재 활성화된 탭 (기본값: profile)
    String activeTab = request.getParameter("tab");
    if (activeTab == null) {
        activeTab = "profile";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 - 마이페이지</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myPage.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<%@ include file="./header.jsp" %>

<div class="container">
    <div class="profile-header">
        <div class="profile-avatar">
            <i class="fas fa-user-circle"></i>
        </div>
        <div class="profile-info">
            <h1><%= user.getUsername() %> 님의 마이페이지</h1>
            <p><i class="fas fa-envelope"></i> <%= user.getEmail() %></p>
            <p><i class="fas fa-calendar-alt"></i> 가입일: <%= sdf.format(user.getCreatedAt() ) %></p>
        </div>
    </div>
    
    <div class="tab-container">
        <div class="tabs">
            <a href="?tab=profile" class="tab <%= activeTab.equals("profile") ? "active" : "" %>">
                <i class="fas fa-user"></i> 회원 정보
            </a>
            <a href="?tab=posts" class="tab <%= activeTab.equals("posts") ? "active" : "" %>">
                <i class="fas fa-file-alt"></i> 내 게시글
                <% if (myPosts != null && !myPosts.isEmpty()) { %>
                    <span class="badge"><%= myPosts.size() %></span>
                <% } %>
            </a>
            <a href="?tab=likes" class="tab <%= activeTab.equals("likes") ? "active" : "" %>">
                <i class="fas fa-heart"></i> 좋아요
                <% if (likedPosts != null && !likedPosts.isEmpty()) { %>
                    <span class="badge"><%= likedPosts.size() %></span>
                <% } %>
            </a>
            <a href="?tab=comments" class="tab <%= activeTab.equals("comments") ? "active" : "" %>">
                <i class="fas fa-comment"></i> 내 댓글
                <% if (myComments != null && !myComments.isEmpty()) { %>
                    <span class="badge"><%= myComments.size() %></span>
                <% } %>
            </a>
        </div>
        
        <div class="tab-content">
            <!-- 회원 정보 수정 탭 -->
            <div id="profile" class="tab-pane <%= activeTab.equals("profile") ? "active" : "" %>">
                <div class="section-title">
                    <i class="fas fa-user-edit"></i> 회원 정보 수정
                </div>
                
                <%
				    String error = request.getParameter("error");
				    String success = request.getParameter("success");
				%>
				
				<% if ("wrongPassword".equals(error)) { %>
				    <script>alert("현재 비밀번호가 올바르지 않습니다."); window.location.href = 'myPage?tab=profile';</script>
				<% } else if ("passwordMismatch".equals(error)) { %>
				    <script>alert("새 비밀번호와 확인 비밀번호가 일치하지 않습니다."); window.location.href = 'myPage?tab=profile';</script>
				<% } else if ("updateFailed".equals(error)) { %>
				    <script>alert("회원 정보 수정에 실패했습니다."); window.location.href = 'myPage?tab=profile';</script>
				<% } else if ("true".equals(success)) { %>
				    <script>alert("회원 정보가 성공적으로 수정되었습니다."); window.location.href = 'myPage?tab=profile';</script>
				<% } %>
                <form action="updateProfile" method="post" class="profile-form" onsubmit="return validateProfileForm()">
                    <div class="form-group">
                        <label for="username">이름</label>
                        <input type="text" id="username" name="username" value="<%= user.getUsername() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">이메일</label>
                        <input type="email" id="email" name="email" value="<%= user.getEmail() %>" readonly>
                        <small>이메일은 변경할 수 없습니다.</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="currentPassword">현재 비밀번호</label>
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="현재 비밀번호">
                    </div>
                    
                    <div class="form-group">
                        <label for="newPassword">새 비밀번호</label>
                        <input type="password" id="newPassword" name="newPassword" placeholder="새 비밀번호">
                        <small>비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">비밀번호 확인</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="새 비밀번호 확인">
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">정보 수정</button>
                    </div>
                </form>
                
                <div class="danger-zone">
                    <div class="section-title">
                        <i class="fas fa-exclamation-triangle"></i> 계정 관리
                    </div>
                    <p>계정을 삭제하면 모든 데이터가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.</p>
                    <% if ("deleteFailed".equals(request.getParameter("error"))) { %>
					    <script>alert("계정 삭제에 실패했습니다. 다시 시도해주세요.");</script>
					<% } %>
                    <form action="<%= request.getContextPath() %>/deleteAccount" method="post" onsubmit="return confirmDeleteAccount();">
                    	<input type="hidden" id="deletePassword" name="deletePassword">
				        <button type="submit" class="btn btn-danger">계정 삭제</button>
				    </form>
                </div>
            </div>
            
            <!-- 내 게시글 탭 -->
            <div id="posts" class="tab-pane <%= activeTab.equals("posts") ? "active" : "" %>">
                <div class="section-title">
                    <i class="fas fa-file-alt"></i> 내가 작성한 게시글
                </div>
                
                <% if (myPosts != null && !myPosts.isEmpty()) { %>
                    <div class="post-list">
                        <% for (Post post : myPosts) { %>
                            <div class="post-item">
                                <div class="post-info">
                                    <h3 class="post-title">
                                    	<a href="postDetail?postId=<%= post.getPostId() %>"><%= post.getTitle() %></a>
                                    </h3>
                                    <div class="post-meta">
                                        <span><i class="fas fa-store"></i> <%= post.getStoreName() %></span>
                                        <span><i class="fas fa-utensils"></i> <%= post.getFoodType() %></span>
                                        <span><i class="fas fa-map-marker-alt"></i> <%= post.getLocation() %></span>
                                    </div>
                                    <div class="post-stats">
                                        <span><i class="fas fa-heart"></i> <%= post.getLikeCount() %></span>
                                        <span><i class="fas fa-comment"></i> <%= post.getCommentCount() %></span>
                                        <span><i class="fas fa-clock"></i> <%= sdf.format(post.getCreatedAt()) %></span>
                                    </div>
                                </div>
                                <div class="post-actions">
                                    <a href="editPost?postId=<%= post.getPostId() %>" class="btn btn-sm btn-edit">
                                        <i class="fas fa-edit"></i> 수정
                                    </a>
                                    <button class="btn btn-sm btn-delete" onclick="confirmDeletePost(<%= post.getPostId() %>)">
                                        <i class="fas fa-trash"></i> 삭제
                                    </button>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-file-alt"></i>
                        <p>작성한 게시글이 없습니다.</p>
                        <a href="/jsp_project/views/write.jsp" class="btn btn-primary">첫 게시글 작성하기</a>
                    </div>
                <% } %>
            </div>
            
            <!-- 좋아요 탭 -->
            <div id="likes" class="tab-pane <%= activeTab.equals("likes") ? "active" : "" %>">
                <div class="section-title">
                    <i class="fas fa-heart"></i> 내가 좋아요한 게시글
                </div>
                
                <% if (likedPosts != null && !likedPosts.isEmpty()) { %>
                    <div class="post-list">
                        <% for (Post post : likedPosts) { %>
                            <div class="post-item">
                                <div class="post-info">
                                    <h3 class="post-title">
                                        <a href="postDetail?postId=<%= post.getPostId() %>"><%= post.getTitle() %></a>
                                    </h3>
                                    <div class="post-meta">
                                        <span><i class="fas fa-store"></i> <%= post.getStoreName() %></span>
                                        <span><i class="fas fa-utensils"></i> <%= post.getFoodType() %></span>
                                        <span><i class="fas fa-map-marker-alt"></i> <%= post.getLocation() %></span>
                                    </div>
                                    <div class="post-stats">
                                        <span><i class="fas fa-user"></i> <%= post.getUsername() %></span>
                                        <span><i class="fas fa-heart"></i> <%= post.getLikeCount() %></span>
                                        <span><i class="fas fa-comment"></i> <%= post.getCommentCount() %></span>
                                        <span><i class="fas fa-clock"></i> <%= sdf.format(post.getCreatedAt()) %></span>
                                    </div>
                                </div>
                                <div class="post-actions">
                                    <form action="/jsp_project/unlikePost" method="post" onsubmit="return confirm('좋아요를 취소하시겠습니까?');">
								        <input type="hidden" name="postId" value="<%= post.getPostId() %>">
								        <button type="submit" class="btn btn-sm btn-unlike">
								            <i class="fas fa-heart-broken"></i> 좋아요 취소
								        </button>
								    </form>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-heart"></i>
                        <p>좋아요한 게시글이 없습니다.</p>
                        <a href="board" class="btn btn-primary">게시판 둘러보기</a>
                    </div>
                <% } %>
            </div>
            
            <!-- 내 댓글 탭 -->
            <div id="comments" class="tab-pane <%= activeTab.equals("comments") ? "active" : "" %>">
                <div class="section-title">
                    <i class="fas fa-comment"></i> 내가 작성한 댓글
                </div>
                
                <% if (myComments != null && !myComments.isEmpty()) { %>
                    <div class="comment-list">
                        <% for (Comment comment : myComments) { %>
                            <div class="comment-item">
                                <div class="comment-content">
                                    <p><%= comment.getContent() %></p>
                                </div>
                                <div class="comment-meta">
                                    <div class="comment-info">
                                    	<%
										String postTitle = comment.getPostTitle();
										String shortTitle = postTitle.length() > 10 ? postTitle.substring(0, 10) + "…" : postTitle;
										%>
                                        <span><i class="fas fa-file-alt"></i> 게시글: <a href="postDetail?postId=<%= comment.getPostId() %>"><%= shortTitle %></a></span>
                                        <span><i class="fas fa-clock"></i> <%= sdf.format(comment.getCreatedAt()) %></span>
                                    </div>
                                    <div class="comment-actions">
                                        <form action="/jsp_project/deleteCommentMyPage" method="post" onsubmit="return confirm('댓글을 삭제하시겠습니까?');">
										    <input type="hidden" name="commentId" value="<%= comment.getCommentId() %>">
										    <button type="submit" class="btn btn-sm btn-delete">
										        <i class="fas fa-trash"></i> 삭제
										    </button>
										</form>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-comment"></i>
                        <p>작성한 댓글이 없습니다.</p>
                        <a href="board" class="btn btn-primary">게시판 둘러보기</a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
    // 프로필 폼 유효성 검사
    function validateProfileForm() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const currentPassword = document.getElementById('currentPassword').value;
        
        // 비밀번호를 변경하려는 경우
        if (newPassword || confirmPassword) {
            // 현재 비밀번호 필수
            if (!currentPassword) {
                alert('현재 비밀번호를 입력해주세요.');
                return false;
            }
            
            // 비밀번호 유효성 검사
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?])[A-Za-z\d!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]{8,}$/;
            if (!passwordRegex.test(newPassword)) {
                alert('비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.');
                return false;
            }
            
            // 비밀번호 확인 일치 여부
            if (newPassword !== confirmPassword) {
                alert('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.');
                return false;
            }
        }
        
        return true;
    }
    
    // 게시글 삭제 확인
    function confirmDeletePost(postId) {
        if (confirm('이 게시글을 삭제하시겠습니까?')) {
            window.location.href = 'deletePost?postId=' + postId;
        }
    }
    
    // 계정 삭제 시 비밀번호 입력 확인
    function confirmDeleteAccount() {
        const currentPwInput = document.getElementById('currentPassword');
        const deletePwInput = document.getElementById('deletePassword');

        if (!currentPwInput || !currentPwInput.value) {
            alert('계정 삭제를 위해 현재 비밀번호를 입력해주세요.');
            return false;
        }

        // currentPassword 값을 deletePassword hidden input에 복사
        deletePwInput.value = currentPwInput.value;

        return confirm('정말로 계정을 삭제하시겠습니까?');
    }
</script>

<%
    String message = (String) session.getAttribute("message");
    if (message != null) {
%>
<script>
    alert("<%= message %>");
</script>
<%
    session.removeAttribute("message");
    }
%>
</body>
</html>