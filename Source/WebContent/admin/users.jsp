<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 관리자 - 사용자 관리</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%@ include file="admin-header.jsp" %>

    <div class="admin-container">
        <div class="admin-content">
            <div class="page-header">
                <h1>사용자 관리</h1>
                <p>맛스팟 사용자 목록을 관리합니다.</p>
            </div>

            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/users" method="get" class="search-form">
                    <div class="search-group">
                        <input type="text" name="keyword" placeholder="사용자명 또는 이메일 검색..." value="${keyword}" class="search-input">
                        <button type="submit" class="search-button"><i class="fas fa-search"></i></button>
                    </div>
                </form>
            </div>

            <div class="table-card">
                <div class="table-header">
                    <h3>사용자 목록</h3>
                    <span class="total-count">총 ${totalUsers}명</span>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>사용자명</th>
                            <th>이메일</th>
                            <th>가입일</th>
                            <th>게시물</th>
                            <th>댓글</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<User> users = (List<User>)request.getAttribute("users");
                        if(users != null && !users.isEmpty()) {
                            for(User user : users) {
                        %>
                        <tr>
                            <td><%= user.getUserid() %></td>
                            <td><%= user.getUsername() %></td>
                            <td><%= user.getEmail() %></td>
                            <td><%= user.getCreatedAt().toString().substring(0, 16) %></td>
                            <td><%= user.getPostCount() %></td>
                            <td><%= user.getCommentCount() %></td>
                            <td>
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/admin/posts?keyword=<%= user.getUsername() %>" class="action-link" title="게시물 보기"><i class="fas fa-list"></i></a>
                                    <button class="action-button delete-button" data-email="<%= user.getEmail() %>" title="사용자 삭제"><i class="fas fa-trash-alt"></i></button>
                                </div>
                            </td>
                        </tr>
                        <% 
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7" class="empty-row">사용자가 없습니다.</td>
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
                        <a href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage - 1 %>&keyword=${keyword}" class="page-link"><i class="fas fa-chevron-left"></i></a>
                    <% } %>
                    
                    <% 
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);
                    
                    for(int i = startPage; i <= endPage; i++) {
                    %>
                        <a href="${pageContext.request.contextPath}/admin/users?page=<%= i %>&keyword=${keyword}" class="page-link <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                    <% } %>
                    
                    <% if(currentPage < totalPages) { %>
                        <a href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage + 1 %>&keyword=${keyword}" class="page-link"><i class="fas fa-chevron-right"></i></a>
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
            <h3>사용자 삭제</h3>
            <p>정말로 이 사용자를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.</p>
            <div class="modal-buttons">
                <button id="cancelDelete" class="button button-secondary">취소</button>
                <form id="deleteForm" action="${pageContext.request.contextPath}/admin/users" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" id="deleteEmail" name="email" value="">
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
        const deleteEmailInput = document.getElementById('deleteEmail');

        // 삭제 버튼 클릭 시 모달 표시
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                const email = this.getAttribute('data-email');
                deleteEmailInput.value = email;
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