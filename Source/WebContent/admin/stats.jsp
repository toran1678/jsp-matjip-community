<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 관리자 - 통계</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
</head>
<body>
    <%@ include file="admin-header.jsp" %>

    <div class="admin-container">
        <div class="admin-content">
            <div class="page-header">
                <h1>서비스 통계</h1>
                <p>맛스팟 서비스의 상세 통계 정보를 확인합니다.</p>
            </div>

            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/stats" method="get" class="period-form">
                    <div class="period-group">
                        <label>기간 선택:</label>
                        <div class="period-buttons">
                            <button type="submit" name="period" value="7" class="period-button <%= request.getAttribute("period").equals(7) ? "active" : "" %>">7일</button>
                            <button type="submit" name="period" value="30" class="period-button <%= request.getAttribute("period").equals(30) ? "active" : "" %>">30일</button>
                            <button type="submit" name="period" value="90" class="period-button <%= request.getAttribute("period").equals(90) ? "active" : "" %>">90일</button>
                            <button type="submit" name="period" value="365" class="period-button <%= request.getAttribute("period").equals(365) ? "active" : "" %>">1년</button>
                        </div>
                    </div>
                </form>
            </div>

            <div class="chart-container" style="width: 100%;">
			    <div class="chart-card">
			        <h3>일별 활동 추이</h3>
			        <div class="chart-wrapper" style="width: 100%; height: 300px;">
			            <canvas id="activityChart"></canvas>
			        </div>
			    </div>
			</div>
			
			<div class="chart-container two-column">
			    <div class="chart-card">
				    <h3>음식 종류별 분포</h3>
				    <div class="donut-chart-wrapper">
				        <canvas id="foodTypeChart"></canvas>
				    </div>
				    <div class="donut-legend" id="foodTypeLegend"></div>
				</div>
			    <div class="chart-card">
			        <h3>지역별 분포</h3>
			        <div class="chart-wrapper">
			            <canvas id="locationChart"></canvas>
			        </div>
			    </div>
			</div>

            <div class="table-card">
                <h3>인기 게시물 TOP 10</h3>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>순위</th>
                            <th>제목</th>
                            <th>맛집 이름</th>
                            <th>음식 종류</th>
                            <th>위치</th>
                            <th>작성자</th>
                            <th>좋아요</th>
                            <th>댓글</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Map<String, Object>> popularPosts = (List<Map<String, Object>>)request.getAttribute("popularPosts");
                        if(popularPosts != null && !popularPosts.isEmpty()) {
                            int rank = 1;
                            for(Map<String, Object> post : popularPosts) {
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                                String createdAt = sdf.format((java.sql.Timestamp)post.get("createdAt"));
                        %>
                        <tr>
                            <td><%= rank++ %></td>
                            <td><%= post.get("title") %></td>
                            <td><%= post.get("storeName") %></td>
                            <td><%= post.get("foodType") %></td>
                            <td><%= post.get("location") %></td>
                            <td><%= post.get("username") %></td>
                            <td><%= post.get("likeCount") %></td>
                            <td><%= post.get("commentCount") %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/postDetail?postId=<%= post.get("postId") %>" class="action-link" target="_blank">보기</a>
                            </td>
                        </tr>
                        <% 
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="9" class="empty-row">인기 게시물이 없습니다.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="table-card">
                <h3>활발한 사용자 TOP 10</h3>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>순위</th>
                            <th>사용자명</th>
                            <th>이메일</th>
                            <th>가입일</th>
                            <th>게시물 수</th>
                            <th>댓글 수</th>
                            <th>활동 지수</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        List<Map<String, Object>> activeUsers = (List<Map<String, Object>>)request.getAttribute("activeUsers");
                        if(activeUsers != null && !activeUsers.isEmpty()) {
                            int rank = 1;
                            for(Map<String, Object> user : activeUsers) {
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                String createdAt = sdf.format((java.sql.Timestamp)user.get("createdAt"));
                        %>
                        <tr>
                            <td><%= rank++ %></td>
                            <td><%= user.get("username") %></td>
                            <td><%= user.get("email") %></td>
                            <td><%= createdAt %></td>
                            <td><%= user.get("postCount") %></td>
                            <td><%= user.get("commentCount") %></td>
                            <td><%= user.get("activityCount") %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/users?keyword=<%= user.get("email") %>" class="action-link">상세</a>
                            </td>
                        </tr>
                        <% 
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="8" class="empty-row">활발한 사용자가 없습니다.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
	    // 일별 활동 추이 차트
	    const activityCtx = document.getElementById('activityChart').getContext('2d');
	    const activityChart = new Chart(activityCtx, {
	        type: 'line',
	        data: {
	            labels: [
	                <% 
	                Map<String, Integer> dailyPostsData = (Map<String, Integer>)request.getAttribute("dailyPostsData");
	                if(dailyPostsData != null) {
	                    int i = 0;
	                    for(String date : dailyPostsData.keySet()) {
	                        if(i > 0) out.print(", ");
	                        out.print("'" + date + "'");
	                        i++;
	                    }
	                }
	                %>
	            ],
	            datasets: [
	                {
	                    label: '게시물',
	                    data: [
	                        <% 
	                        if(dailyPostsData != null) {
	                            int i = 0;
	                            for(Integer count : dailyPostsData.values()) {
	                                if(i > 0) out.print(", ");
	                                out.print(count);
	                                i++;
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
	                },
	                {
	                    label: '사용자 가입',
	                    data: [
	                        <% 
	                        Map<String, Integer> dailyUsersData = (Map<String, Integer>)request.getAttribute("dailyUsersData");
	                        if(dailyUsersData != null) {
	                            int i = 0;
	                            for(Integer count : dailyUsersData.values()) {
	                                if(i > 0) out.print(", ");
	                                out.print(count);
	                                i++;
	                            }
	                        }
	                        %>
	                    ],
	                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
	                    borderColor: 'rgba(54, 162, 235, 1)',
	                    borderWidth: 2,
	                    tension: 0.3,
	                    pointRadius: 4,
	                    pointBackgroundColor: 'rgba(54, 162, 235, 1)'
	                },
	                {
	                    label: '댓글',
	                    data: [
	                        <% 
	                        Map<String, Integer> dailyCommentsData = (Map<String, Integer>)request.getAttribute("dailyCommentsData");
	                        if(dailyCommentsData != null) {
	                            int i = 0;
	                            for(Integer count : dailyCommentsData.values()) {
	                                if(i > 0) out.print(", ");
	                                out.print(count);
	                                i++;
	                            }
	                        }
	                        %>
	                    ],
	                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
	                    borderColor: 'rgba(75, 192, 192, 1)',
	                    borderWidth: 2,
	                    tension: 0.3,
	                    pointRadius: 4,
	                    pointBackgroundColor: 'rgba(75, 192, 192, 1)'
	                }
	            ]
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
	                    }
	                }
	            }
	        }
	    });
	
	    // 음식 종류별 분포 차트 (도넛 차트)
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
	        if(foodTypeData != null) {
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
	        if(foodTypeData != null) {
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
	            	datalabels: {
	                    color: '#000',
	                    formatter: (value, context) => {
	                        return `${value}개`;
	                    },
	                    font: {
	                        weight: 'bold',
	                        size: 14
	                    }
	                },
	                legend: {
	                    display: false
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
	                    callbacks: {
	                    	label: function(context) {
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
	        /*
	        console.log(label);
	        console.log(value);
	        console.log(labelText);
	        console.log(percentage);
	        console.log(labelText.textContent);
	        */
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
	
	    // 지역별 분포 차트 (바 차트)
	    const locationCtx = document.getElementById('locationChart').getContext('2d');
	    const locationChart = new Chart(locationCtx, {
	        type: 'bar',
	        data: {
	            labels: [
	                <% 
	                Map<String, Integer> locationData = (Map<String, Integer>)request.getAttribute("locationData");
	                if(locationData != null) {
	                    int i = 0;
	                    for(String location : locationData.keySet()) {
	                        if(i > 0) out.print(", ");
	                        out.print("'" + location + "'");
	                        i++;
	                    }
	                }
	                %>
	            ],
	            datasets: [{
	                label: '게시물 수',
	                data: [
	                    <% 
	                    if(locationData != null) {
	                        int i = 0;
	                        for(Integer count : locationData.values()) {
	                            if(i > 0) out.print(", ");
	                            out.print(count);
	                            i++;
	                        }
	                    }
	                    %>
	                ],
	                backgroundColor: 'rgba(75, 192, 192, 0.7)',
	                borderColor: 'rgba(75, 192, 192, 1)',
	                borderWidth: 1,
	                borderRadius: 5,
	                maxBarThickness: 35
	            }]
	        },
	        options: {
	            responsive: true,
	            maintainAspectRatio: false,
	            layout: {
	                padding: {
	                    left: 10,
	                    right: 10,
	                    top: 20,
	                    bottom: 10
	                }
	            },
	            scales: {
	                x: {
	                    grid: {
	                        display: false
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
	                    display: false
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
	</script>
</body>
</html>