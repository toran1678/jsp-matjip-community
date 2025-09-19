<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Post, model.User, model.Comment" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 관리자 - 대시보드</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <%@ include file="admin-header.jsp" %>

    <div class="admin-container">
        <div class="admin-content">
            <div class="dashboard-header">
                <h1>관리자 대시보드</h1>
                <p>맛스팟 서비스 현황을 한눈에 확인하세요.</p>
            </div>

            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-utensils"></i>
                    </div>
                    <div class="stat-info">
                        <h3>총 게시물</h3>
                        <p class="stat-value">${totalPosts}</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3>총 사용자</h3>
                        <p class="stat-value">${totalUsers}</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <div class="stat-info">
                        <h3>총 댓글</h3>
                        <p class="stat-value">${totalComments}</p>
                    </div>
                </div>
            </div>

            <div class="chart-container">
                <div class="chart-card">
                    <h3>최근 7일간 게시물 등록 현황</h3>
                    <div class="chart-wrapper">
                        <canvas id="dailyPostsChart"></canvas>
                    </div>
                </div>
                <div class="chart-card">
                    <h3>음식 종류별 게시물 분포</h3>
                    <div class="donut-chart-wrapper">
                        <canvas id="foodTypeChart"></canvas>
                    </div>
                    <div class="donut-legend" id="foodTypeLegend"></div>
                </div>
            </div>

            <div class="dashboard-tables">
                <div class="table-card">
                    <h3>최근 게시물</h3>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>제목</th>
                                <th>맛집 이름</th>
                                <th>작성자</th>
                                <th>등록일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            List<Post> recentPosts = (List<Post>)request.getAttribute("recentPosts");
                            if(recentPosts != null && !recentPosts.isEmpty()) {
                                for(Post post : recentPosts) {
                            %>
                            <tr>
                                <td><a href="${pageContext.request.contextPath}/postDetail?postId=<%= post.getPostId() %>" target="_blank"><%= post.getTitle() %></a></td>
                                <td><%= post.getStoreName() %></td>
                                <td><%= post.getUsername() %></td>
                                <td><%= post.getCreatedAt().toString().substring(0, 16) %></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/postDetail?postId=<%= post.getPostId() %>" class="action-link" target="_blank">보기</a>
                                </td>
                            </tr>
                            <% 
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="5" class="empty-row">최근 게시물이 없습니다.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <div class="table-footer">
                        <a href="${pageContext.request.contextPath}/admin/posts" class="view-all-link">모든 게시물 보기 <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>

                <div class="table-card">
                    <h3>최근 가입한 사용자</h3>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>사용자명</th>
                                <th>이메일</th>
                                <th>가입일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            List<User> recentUsers = (List<User>)request.getAttribute("recentUsers");
                            if(recentUsers != null && !recentUsers.isEmpty()) {
                                for(User user : recentUsers) {
                            %>
                            <tr>
                                <td><%= user.getUsername() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getCreatedAt().toString().substring(0, 16) %></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/users?keyword=<%= user.getEmail() %>" class="action-link">상세</a>
                                </td>
                            </tr>
                            <% 
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="4" class="empty-row">최근 가입한 사용자가 없습니다.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <div class="table-footer">
                        <a href="${pageContext.request.contextPath}/admin/users" class="view-all-link">모든 사용자 보기 <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>

            <div class="table-card">
                <h3>최근 댓글</h3>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>내용</th>
                            <th>작성자</th>
                            <th>맛집 이름</th>
                            <th>작성일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Comment> recentComments = (List<Comment>)request.getAttribute("recentComments");
                        if(recentComments != null && !recentComments.isEmpty()) {
                            for(Comment comment : recentComments) {
                        %>
                        <tr>
                            <td><%= comment.getContent() %></td>
                            <td><%= comment.getUsername() %></td>
                            <td><%= comment.getStoreName() %></td>
                            <td><%= comment.getCreatedAt().toString().substring(0, 16) %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/postDetail?postId=<%= comment.getPostId() %>" class="action-link" target="_blank">게시물 보기</a>
                            </td>
                        </tr>
                        <% 
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="5" class="empty-row">최근 댓글이 없습니다.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // 차트 생성 전에 canvas 요소 스타일 설정
        document.addEventListener('DOMContentLoaded', function() {
            // 차트 캔버스 스타일 설정
            const dailyPostsCanvas = document.getElementById('dailyPostsChart');
            if(dailyPostsCanvas) {
                dailyPostsCanvas.style.width = '100%';
                dailyPostsCanvas.style.height = '100%';
                dailyPostsCanvas.style.display = 'block';
            }
            
            const foodTypeCanvas = document.getElementById('foodTypeChart');
            if(foodTypeCanvas) {
                foodTypeCanvas.style.width = '100%';
                foodTypeCanvas.style.height = '100%';
                foodTypeCanvas.style.display = 'block';
            }
        });

        // 최근 7일간 게시물 등록 현황 차트
        const dailyPostsCtx = document.getElementById('dailyPostsChart').getContext('2d');
        const dailyPostsChart = new Chart(dailyPostsCtx, {
            type: 'line',
            data: {
                labels: [
                    <% 
                    Map<String, Integer> dailyPostsData = (Map<String, Integer>)request.getAttribute("dailyPostsData");
                    if(dailyPostsData != null && !dailyPostsData.isEmpty()) {
                        int i = 0;
                        for(String date : dailyPostsData.keySet()) {
                            if(i > 0) out.print(", ");
                            out.print("'" + date + "'");
                            i++;
                        }
                    } else {
                        // 데이터가 없을 경우 샘플 데이터 제공
                        String[] sampleDates = {"05-01", "05-02", "05-03", "05-04", "05-05", "05-06", "05-07"};
                        for(int i = 0; i < sampleDates.length; i++) {
                            if(i > 0) out.print(", ");
                            out.print("'" + sampleDates[i] + "'");
                        }
                    }
                    %>
                ],
                datasets: [{
                    label: '게시물 수',
                    data: [
                        <% 
                        if(dailyPostsData != null && !dailyPostsData.isEmpty()) {
                            int i = 0;
                            for(Integer count : dailyPostsData.values()) {
                                if(i > 0) out.print(", ");
                                out.print(count);
                                i++;
                            }
                        } else {
                            // 데이터가 없을 경우 샘플 데이터 제공
                            int[] sampleCounts = {3, 1, 4, 2, 5, 2, 3};
                            for(int i = 0; i < sampleCounts.length; i++) {
                                if(i > 0) out.print(", ");
                                out.print(sampleCounts[i]);
                            }
                        }
                        %>
                    ],
                    backgroundColor: 'rgba(255, 107, 107, 0.2)',
                    borderColor: 'rgba(255, 107, 107, 1)',
                    borderWidth: 2,
                    tension: 0.3,
                    pointRadius: 4,
                    pointBackgroundColor: 'rgba(255, 107, 107, 1)'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                layout: {
                    padding: {
                        left: 10,
                        right: 25,
                        top: 20,
                        bottom: 10
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: true,
                            drawBorder: true,
                            drawOnChartArea: true
                        },
                        ticks: {
                            font: {
                                size: 12
                            }
                        }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0,
                            font: {
                                size: 12
                            }
                        },
                        grid: {
                            drawBorder: true,
                            drawOnChartArea: true
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        labels: {
                            boxWidth: 15,
                            padding: 15,
                            font: {
                                size: 12
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.7)',
                        padding: 10,
                        titleFont: {
                            size: 14
                        },
                        bodyFont: {
                            size: 13
                        },
                        displayColors: false
                    }
                }
            }
        });

        // 음식 종류별 게시물 분포 차트
        const foodTypeCtx = document.getElementById('foodTypeChart').getContext('2d');
        
        // 차트 색상 배열
        const chartColors = [
            'rgba(255, 99, 132, 0.7)',   // 한식 - 분홍색
            'rgba(54, 162, 235, 0.7)',   // 중식 - 파란색
            'rgba(255, 206, 86, 0.7)',   // 일식 - 노란색
            'rgba(75, 192, 192, 0.7)',   // 양식 - 청록색
            'rgba(153, 102, 255, 0.7)',  // 분식 - 보라색
            'rgba(255, 159, 64, 0.7)',   // 카페/디저트 - 주황색
            'rgba(199, 199, 199, 0.7)',  // 기타 - 회색
        ];
        
        const chartBorderColors = [
            'rgba(255, 99, 132, 1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)',
            'rgba(199, 199, 199, 1)',
        ];
        
        // 라벨 데이터 - 기본 카테고리만 사용
        const foodTypeLabels = [
            <% 
            Map<String, Integer> foodTypeData = (Map<String, Integer>)request.getAttribute("foodTypeData");
            if(foodTypeData != null && !foodTypeData.isEmpty()) {
                // 표시할 카테고리 목록
                String[] displayCategories = {"한식", "중식", "일식", "양식", "분식", "카페/디저트", "기타"};
                
                int i = 0;
                for(String category : displayCategories) {
                    if(i > 0) out.print(", ");
                    out.print("'" + category + "'");
                    i++;
                }
            } else {
                // 데이터가 없을 경우 샘플 데이터 제공
                String[] sampleFoodTypes = {"한식", "중식", "일식", "양식", "분식", "카페/디저트", "기타"};
                for(int i = 0; i < sampleFoodTypes.length; i++) {
                    if(i > 0) out.print(", ");
                    out.print("'" + sampleFoodTypes[i] + "'");
                }
            }
            %>
        ];
        
        // 데이터 값
        const foodTypeValues = [
            <% 
            if(foodTypeData != null && !foodTypeData.isEmpty()) {
                // 표시할 카테고리 목록
                String[] displayCategories = {"한식", "중식", "일식", "양식", "분식", "카페/디저트", "기타"};
                
                int i = 0;
                for(String category : displayCategories) {
                    if(i > 0) out.print(", ");
                    // 해당 카테고리가 데이터에 있으면 그 값을, 없으면 0을 출력
                    Integer count = foodTypeData.getOrDefault(category, 0);
                    out.print(count);
                    i++;
                }
            } else {
                // 데이터가 없을 경우 샘플 데이터 제공
                int[] sampleCounts = {10, 8, 6, 5, 4, 7, 3};
                for(int i = 0; i < sampleCounts.length; i++) {
                    if(i > 0) out.print(", ");
                    out.print(sampleCounts[i]);
                }
            }
            %>
        ];
        
        const foodTypeChart = new Chart(foodTypeCtx, {
            type: 'doughnut',
            data: {
                labels: foodTypeLabels,
                datasets: [{
                    data: foodTypeValues,
                    backgroundColor: chartColors.slice(0, foodTypeLabels.length),
                    borderColor: chartBorderColors.slice(0, foodTypeLabels.length),
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '60%',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                    	enabled: true,
                        backgroundColor: 'rgba(0, 0, 0, 0.7)',
                        padding: 10,
                        titleFont: {
                            size: 14
                        },
                        bodyFont: {
                            size: 13
                        },
                        callbacks: {
                        	label: function(context) {
                                // 안전하게 필요한 속성만 로깅
                                /*
                                console.log('context.label:', context.label);
                                console.log('context.raw:', context.raw);
                                console.log('context.datasetIndex:', context.datasetIndex);
                                console.log('context.dataIndex:', context.dataIndex);
                                */
                                // 변수명 변경 및 명시적 타입 변환
                                var tooltipLabel = String(context.label || '');
                                var tooltipValue = Number(context.raw || 0);
                               
                                // 다른 방식으로 총합 계산
                                var tooltipTotal = 0;
                                try {
                                    if (context.chart && context.chart.data && context.chart.data.datasets && 
                                        context.chart.data.datasets[0] && context.chart.data.datasets[0].data) {
                                        var dataArray = context.chart.data.datasets[0].data;
                                        for (var i = 0; i < dataArray.length; i++) {
                                            tooltipTotal += Number(dataArray[i] || 0);
                                        }
                                    }
                                } catch (e) {
                                    // 대체 방법으로 전역 변수 사용
                                    tooltipTotal = foodTypeValues.reduce(function(a, b) { return a + b; }, 0);
                                }
                                
                                var tooltipPercentage = tooltipTotal > 0 ? Math.round((tooltipValue / tooltipTotal) * 100) : 0;
                                
                                // 문자열 연결 방식 변경
                                var resultText = tooltipLabel + ": " + tooltipValue + "개 (" + tooltipPercentage + "%)";
                                
                                return resultText;
                            }
                        }
                    }
                }
            }
        });
        
        // 커스텀 레전드 생성 - 개수와 퍼센트 표시 추가
        const legendContainer = document.getElementById('foodTypeLegend');
        legendContainer.innerHTML = ''; // 기존 레전드 초기화
        
        const total = foodTypeValues.reduce((a, b) => a + b, 0);
        
        foodTypeLabels.forEach((label, index) => {
            const value = foodTypeValues[index];
            const percentage = Math.round((value / total) * 100);
            
            const legendItem = document.createElement('div');
            legendItem.className = 'legend-item';
            
            const colorBox = document.createElement('div');
            colorBox.className = 'legend-color';
            colorBox.style.backgroundColor = chartColors[index];
            
            const labelText = document.createElement('span');
            // labelText.textContent = `${label}: ${value}개 (${percentage}%)`;
            labelText.textContent = label + ": " + value + "개 (" + percentage + "%)";
            
            legendItem.appendChild(colorBox);
            legendItem.appendChild(labelText);
            legendContainer.appendChild(legendItem);
            
            // 레전드 아이템 클릭 이벤트 (해당 항목 토글)
            legendItem.addEventListener('click', () => {
                const chart = foodTypeChart;
                const datasetIndex = 0;
                
                const meta = chart.getDatasetMeta(datasetIndex);
                const isHidden = meta.data[index].hidden || false;
                
                meta.data[index].hidden = !isHidden;
                
                // 레전드 아이템 스타일 변경
                if (meta.data[index].hidden) {
                    legendItem.style.opacity = 0.5;
                } else {
                    legendItem.style.opacity = 1;
                }
                
                chart.update();
            });
        });
    </script>
</body>
</html>