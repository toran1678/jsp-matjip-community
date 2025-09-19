<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Post" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 관리자 - 게시물 관리</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%@ include file="admin-header.jsp" %>

    <div class="admin-container">
        <div class="admin-content">
            <div class="page-header">
                <h1>게시물 관리</h1>
                <p>맛스팟 게시물 목록을 관리합니다.</p>
            </div>

            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/posts" method="get" class="filter-form">
                    <div class="filter-group">
                        <label for="foodType">음식 종류</label>
                        <select id="foodType" name="foodType" class="filter-select">
                            <option value="">전체</option>
                            <option value="한식" ${param.foodType == '한식' ? 'selected' : ''}>한식</option>
                            <option value="중식" ${param.foodType == '중식' ? 'selected' : ''}>중식</option>
                            <option value="일식" ${param.foodType == '일식' ? 'selected' : ''}>일식</option>
                            <option value="양식" ${param.foodType == '양식' ? 'selected' : ''}>양식</option>
                            <option value="분식" ${param.foodType == '분식' ? 'selected' : ''}>분식</option>
                            <option value="카페" ${param.foodType == '카페' ? 'selected' : ''}>카페/디저트</option>
                            <option value="기타" ${param.foodType == '기타' ? 'selected' : ''}>기타</option>
                        </select>
                    </div>
                    <div class="filter-group search-group">
                        <input type="text" name="keyword" placeholder="제목, 맛집 이름, 위치 검색..." value="${keyword}" class="search-input">
                        <button type="submit" class="search-button"><i class="fas fa-search"></i></button>
                    </div>
                </form>
            </div>

            <div class="table-card">
                <div class="table-header">
                    <h3>게시물 목록</h3>
                    <span class="total-count">총 ${totalPosts}개</span>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>제목</th>
                            <th>맛집 이름</th>
                            <th>음식 종류</th>
                            <th>위치</th>
                            <th>작성자</th>
                            <th>등록일</th>
                            <th>좋아요</th>
                            <th>댓글</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Post> posts = (List<Post>)request.getAttribute("posts");
                        if(posts != null && !posts.isEmpty()) {
                            for(Post post : posts) {
                        %>
                        <tr>
                            <td><%= post.getPostId() %></td>
                            <td><%= post.getTitle() %></td>
                            <td><%= post.getStoreName() %></td>
                            <td><%= post.getFoodType() %></td>
                            <td><%= post.getLocation() %></td>
                            <td><%= post.getUsername() %></td>
                            <td><%= post.getCreatedAt().toString().substring(0, 16) %></td>
                            <td><%= post.getLikeCount() %></td>
                            <td><%= post.getCommentCount() %></td>
                            <td>
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/postDetail?postId=<%= post.getPostId() %>" class="action-link" title="게시물 보기" target="_blank"><i class="fas fa-eye"></i></a>
                                    <button class="action-button delete-button" data-postid="<%= post.getPostId() %>" title="게시물 삭제"><i class="fas fa-trash-alt"></i></button>
                                </div>
                            </td>
                        </tr>
                        <% 
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="10" class="empty-row">게시물이 없습니다.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <% 
                int currentPage = (int)request.getAttribute("currentPage");
                int totalPages = (int)request.getAttribute("totalPages");
                if(totalPages > 0) {
                %>
                <div class="pagination">
                    <% if(currentPage > 1) { %>
                        <a href="${pageContext.request.contextPath}/admin/posts?page=<%= currentPage - 1 %>&keyword=${keyword}&foodType=${param.foodType}" class="page-link"><i class="fas fa-chevron-left"></i></a>
                    <% } %>
                    
                    <% 
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);
                    
                    for(int i = startPage; i <= endPage; i++) {
                    %>
                        <a href="${pageContext.request.contextPath}/admin/posts?page=<%= i %>&keyword=${keyword}&foodType=${param.foodType}" class="page-link <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                    <% } %>
                    
                    <% if(currentPage < totalPages) { %>
                        <a href="${pageContext.request.contextPath}/admin/posts?page=<%= currentPage + 1 %>&keyword=${keyword}&foodType=${param.foodType}" class="page-link"><i class="fas fa-chevron-right"></i></a>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- 삭제 확인 모달 -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>게시물 삭제</h3>
            <p>정말로 이 게시물을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.</p>
            <div class="modal-buttons">
                <button id="cancelDelete" class="button button-secondary">취소</button>
                <form id="deleteForm" action="${pageContext.request.contextPath}/admin/posts" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" id="deletePostId" name="postId" value="">
                    <button type="submit" class="button button-danger">삭제</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // 삭제 모달 관련 스크립트
        const modal = document.getElementById('deleteModal');
        const deleteButtons = document.querySelectorAll('.delete-button');
        const closeBtn = document.querySelector('.close');
        const cancelBtn = document.getElementById('cancelDelete');
        const deletePostIdInput = document.getElementById('deletePostId');

        // 삭제 버튼 클릭 시 모달 표시
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                const postId = this.getAttribute('data-postid');
                deletePostIdInput.value = postId;
                modal.style.display = 'block';
            });
        });

        // 모달 닫기
        closeBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });

        cancelBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });

        // 모달 외부 클릭 시 닫기
        window.addEventListener('click', function(event) {
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        });
    </script>
</body>
</html>