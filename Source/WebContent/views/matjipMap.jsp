<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛스팟 - 지도 검색</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/matjipMap.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 카카오 지도 API - 동적으로 로드 -->
    <script>
        // API 키를 동적으로 로드
        fetch('${pageContext.request.contextPath}/apiKey')
            .then(response => response.json())
            .then(data => {
                const script = document.createElement('script');
                script.src = `//dapi.kakao.com/v2/maps/sdk.js?appkey=${data.kakaoApiKey}&libraries=services,clusterer,drawing`;
                script.onload = function() {
                    // 카카오 지도 API가 로드된 후 실행할 코드
                    initializeMap();
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

    <div class="map-container">
        <div class="map-header">
            <h1><i class="fas fa-map-marked-alt"></i> 맛집 지도</h1>
            <p>사용자들이 공유한 맛집을 지도에서 확인해보세요!</p>
        </div>

        <div class="map-filter-container">
            <div class="map-filter">
                <div class="filter-group">
                    <label for="foodType">음식 종류</label>
                    <select id="foodType" class="filter-select">
                        <option value="">전체</option>
                        <option value="한식">한식</option>
                        <option value="중식">중식</option>
                        <option value="일식">일식</option>
                        <option value="양식">양식</option>
                        <option value="분식">분식</option>
                        <option value="카페">카페/디저트</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="region">지역</label>
                    <select id="region" class="filter-select">
                        <option value="">전체</option>
                        <option value="서울">서울</option>
                        <option value="경기도">경기도</option>
                        <option value="인천">인천</option>
                        <option value="부산">부산</option>
                        <option value="대구">대구</option>
                        <option value="광주">광주</option>
                        <option value="대전">대전</option>
                        <option value="울산">울산</option>
                        <option value="강원도">강원도</option>
                        <option value="충청북도">충청북도</option>
                        <option value="충청남도">충청남도</option>
                        <option value="전라북도">전라북도</option>
                        <option value="전라남도">전라남도</option>
                        <option value="경상북도">경상북도</option>
                        <option value="경상남도">경상남도</option>
                        <option value="제주도">제주도</option>
                    </select>
                </div>
                <button id="filterButton" class="filter-button">
                    <i class="fas fa-filter"></i> 필터 적용
                </button>
            </div>
        </div>

        <div class="map-content">
            <div id="map" class="kakao-map"></div>
            <div class="map-sidebar">
                <div class="sidebar-header">
                    <h3>맛집 목록</h3>
                    <div class="sidebar-controls">
                        <button id="refreshMap" class="refresh-button" title="지도 새로고침">
                            <i class="fas fa-sync-alt"></i>
                        </button>
                        <button id="toggleSidebar" class="toggle-button" title="사이드바 접기/펼치기">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="맛집 이름 검색...">
                    <button id="searchButton"><i class="fas fa-search"></i></button>
                </div>
                <div class="restaurant-list" id="restaurantList">
                    <% 
                    java.util.List<model.Post> restaurants = (java.util.List<model.Post>)request.getAttribute("restaurants");
                    if(restaurants != null) {
                        for(model.Post restaurant : restaurants) {
                    %>
                        <div class="restaurant-item" data-id="<%= restaurant.getPostId() %>" data-lat="<%= restaurant.getX() %>" data-lng="<%= restaurant.getY() %>" data-type="<%= restaurant.getFoodType() %>">
                            <div class="restaurant-info">
                                <h4><%= restaurant.getStoreName() %></h4>
                                <p class="restaurant-address"><i class="fas fa-map-marker-alt"></i> <%= restaurant.getLocation() %></p>
                                <p class="restaurant-category"><span class="category-tag"><%= restaurant.getFoodType() %></span></p>
                            </div>
                            <div class="restaurant-rating">
                                <span class="rating-score"><i class="fas fa-heart"></i> <%= restaurant.getLikeCount() %></span>
                                <span class="review-count">(<%= restaurant.getCommentCount() %>)</span>
                            </div>
                        </div>
                    <% 
                        }
                    }
                    %>
                </div>
            </div>
            <!-- 접힌 상태에서 보이는 토글 버튼 추가 -->
            <button id="expandSidebar" class="expand-sidebar-button" title="사이드바 펼치기">
                <i class="fas fa-chevron-left"></i>
            </button>
        </div>
    </div>

    <script>
        // 지도 초기화 함수
        function initializeMap() {
            // 지도 초기화
            var mapContainer = document.getElementById('map');
            var mapOption = {
                center: new kakao.maps.LatLng(37.566826, 126.9786567), // 서울 시청
                level: 7 // 지도 확대 레벨
            };
            
            // 지도 생성
            var map = new kakao.maps.Map(mapContainer, mapOption);
            
            // 마커 클러스터러 생성
            var clusterer = new kakao.maps.MarkerClusterer({
                map: map,
                averageCenter: true,
                minLevel: 5
            });
            
            // 맛집 데이터 (서버에서 받아온 데이터)
            var restaurants = [];
            <% 
            if(restaurants != null) {
                for(model.Post restaurant : restaurants) {
            %>
                restaurants.push({
                    id: <%= restaurant.getPostId() %>,
                    name: "<%= restaurant.getStoreName() %>",
                    latitude: <%= restaurant.getX() %>,
                    longitude: <%= restaurant.getY() %>,
                    location: "<%= restaurant.getLocation() %>",
                    foodType: "<%= restaurant.getFoodType() %>",
                    likeCount: <%= restaurant.getLikeCount() %>,
                    commentCount: <%= restaurant.getCommentCount() %>
                });
            <% 
                }
            }
            %>
            
            // 마커 생성 및 클러스터러에 추가
            var markers = [];
            var infowindows = [];
            
            restaurants.forEach(function(restaurant) {
                var marker = new kakao.maps.Marker({
                    position: new kakao.maps.LatLng(restaurant.latitude, restaurant.longitude)
                });
                
                markers.push(marker);
                
                // 인포윈도우 생성
                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div class="map-infowindow">' +
                             '<h4>' + restaurant.name + '</h4>' +
                             '<p><i class="fas fa-map-marker-alt"></i> ' + restaurant.location + '</p>' +
                             '<p><span class="category-tag">' + restaurant.foodType + '</span></p>' +
                             '<p><i class="fas fa-heart"></i> ' + restaurant.likeCount + ' <i class="fas fa-comment"></i> ' + restaurant.commentCount + '</p>' +
                             '<a href="${pageContext.request.contextPath}/postDetail?postId=' + restaurant.id + '" class="view-detail">상세보기</a>' +
                             '</div>'
                });
                
                infowindows.push(infowindow);
                
                // 마커 클릭 이벤트
                kakao.maps.event.addListener(marker, 'click', function() {
                    // 모든 인포윈도우 닫기
                    infowindows.forEach(function(infowindow) {
                        infowindow.close();
                    });
                    
                    // 클릭한 마커의 인포윈도우 열기
                    infowindow.open(map, marker);
                    
                    // 해당 맛집 항목 강조
                    highlightRestaurant(restaurant.id);
                });
            });
            
            // 클러스터러에 마커 추가
            clusterer.addMarkers(markers);
            
            // 맛집 목록 항목 클릭 이벤트
            document.querySelectorAll('.restaurant-item').forEach(function(item) {
                item.addEventListener('click', function() {
                    var id = this.getAttribute('data-id');
                    var lat = parseFloat(this.getAttribute('data-lat'));
                    var lng = parseFloat(this.getAttribute('data-lng'));
                    
                    // 지도 중심 이동
                    map.setCenter(new kakao.maps.LatLng(lat, lng));
                    map.setLevel(3);
                    
                    // 해당 마커의 인포윈도우 열기
                    var index = restaurants.findIndex(function(restaurant) {
                        return restaurant.id == id;
                    });
                    
                    if (index !== -1) {
                        // 모든 인포윈도우 닫기
                        infowindows.forEach(function(infowindow) {
                            infowindow.close();
                        });
                        
                        // 클릭한 맛집의 인포윈도우 열기
                        infowindows[index].open(map, markers[index]);
                    }
                    
                    // 클릭한 맛집 항목 강조
                    highlightRestaurant(id);
                });
            });
            
            // 맛집 항목 강조 함수
            function highlightRestaurant(id) {
                document.querySelectorAll('.restaurant-item').forEach(function(item) {
                    item.classList.remove('active');
                    if (item.getAttribute('data-id') == id) {
                        item.classList.add('active');
                        item.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                    }
                });
            }
            
            // 필터 적용 버튼 클릭 이벤트
            document.getElementById('filterButton').addEventListener('click', function() {
                var foodType = document.getElementById('foodType').value;
                var region = document.getElementById('region').value;
                
                // 필터링된 맛집 목록 표시
                document.querySelectorAll('.restaurant-item').forEach(function(item) {
                    var itemFoodType = item.getAttribute('data-type');
                    var itemAddress = item.querySelector('.restaurant-address').textContent;
                    
                    var showItem = true;
                    
                    if (foodType && itemFoodType !== foodType) {
                        showItem = false;
                    }
                    
                    if (region && !itemAddress.includes(region)) {
                        showItem = false;
                    }
                    
                    item.style.display = showItem ? 'flex' : 'none';
                });
                
                // 필터링된 마커만 표시
                markers.forEach(function(marker, index) {
                    var restaurant = restaurants[index];
                    var showMarker = true;
                    
                    if (foodType && restaurant.foodType !== foodType) {
                        showMarker = false;
                    }
                    
                    if (region && !restaurant.location.includes(region)) {
                        showMarker = false;
                    }
                    
                    if (showMarker) {
                        marker.setMap(map);
                    } else {
                        marker.setMap(null);
                    }
                });
            });
            
            // 검색 기능
            document.getElementById('searchButton').addEventListener('click', function() {
                searchRestaurants();
            });
            
            document.getElementById('searchInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchRestaurants();
                }
            });
            
            function searchRestaurants() {
                var searchText = document.getElementById('searchInput').value.toLowerCase();
                
                if (!searchText) {
                    // 검색어가 없으면 모든 맛집 표시
                    document.querySelectorAll('.restaurant-item').forEach(function(item) {
                        item.style.display = 'flex';
                    });
                    
                    markers.forEach(function(marker) {
                        marker.setMap(map);
                    });
                    
                    return;
                }
                
                // 맛집 목록 필터링
                document.querySelectorAll('.restaurant-item').forEach(function(item, index) {
                    var name = item.querySelector('h4').textContent.toLowerCase();
                    var address = item.querySelector('.restaurant-address').textContent.toLowerCase();
                    
                    if (name.includes(searchText) || address.includes(searchText)) {
                        item.style.display = 'flex';
                        markers[index].setMap(map);
                    } else {
                        item.style.display = 'none';
                        markers[index].setMap(null);
                    }
                });
            }
            
            // 지도 새로고침 버튼
            document.getElementById('refreshMap').addEventListener('click', function() {
                // 지도 초기 위치로 이동
                map.setCenter(new kakao.maps.LatLng(37.566826, 126.9786567));
                map.setLevel(7);
                
                // 모든 인포윈도우 닫기
                infowindows.forEach(function(infowindow) {
                    infowindow.close();
                });
                
                // 모든 맛집 표시
                document.querySelectorAll('.restaurant-item').forEach(function(item) {
                    item.style.display = 'flex';
                    item.classList.remove('active');
                });
                
                // 모든 마커 표시
                markers.forEach(function(marker) {
                    marker.setMap(map);
                });
                
                // 필터 초기화
                document.getElementById('foodType').value = '';
                document.getElementById('region').value = '';
                document.getElementById('searchInput').value = '';
            });
            
            // 사이드바 토글 버튼 (접기)
            document.getElementById('toggleSidebar').addEventListener('click', function() {
                toggleSidebar(false);
            });
            
            // 사이드바 확장 버튼 (펼치기)
            document.getElementById('expandSidebar').addEventListener('click', function() {
                toggleSidebar(true);
            });
            
            // 사이드바 토글 함수
            function toggleSidebar(expand) {
                var sidebar = document.querySelector('.map-sidebar');
                var mapContent = document.querySelector('.map-content');
                var expandButton = document.getElementById('expandSidebar');
                
                if (expand) {
                    // 사이드바 펼치기
                    sidebar.classList.remove('collapsed');
                    mapContent.classList.remove('expanded');
                    expandButton.style.display = 'none';
                } else {
                    // 사이드바 접기
                    sidebar.classList.add('collapsed');
                    mapContent.classList.add('expanded');
                    expandButton.style.display = 'block';
                }
            }
            
            // 초기 상태에서는 확장 버튼 숨기기
            document.getElementById('expandSidebar').style.display = 'none';
        }
    </script>
</body>
</html>