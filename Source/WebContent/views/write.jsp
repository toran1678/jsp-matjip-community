<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>맛스팟 - 게시물 작성</title>
  <link rel="icon" href="${pageContext.request.contextPath}/images/matjip2.ico" type="image/x-icon">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/write.css">
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
                  initializeWriteMap();
              };
              document.head.appendChild(script);
          })
          .catch(error => {
              console.error('API 키 로드 실패:', error);
          });
  </script>
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container">
  <div class="write-container">
    <div class="page-header">
      <h1><i class="fas fa-edit"></i> 맛집 게시글 작성</h1>
      <p>맛있는 식당을 공유해주세요!</p>
    </div>

    <!-- enctype="multipart/form-data" 추가 -->
    <form action="${pageContext.request.contextPath}/createPost" method="post" id="postForm" enctype="multipart/form-data">
      <div class="form-section">
        <div class="form-group">
          <label for="title"><i class="fas fa-heading"></i> 제목</label>
          <input type="text" id="title" name="title" placeholder="제목을 입력하세요" required>
        </div>
      </div>

      <div class="form-section">
        <div class="section-header">
          <h2><i class="fas fa-map-marker-alt"></i> 장소를 검색해 음식점을 선택하세요</h2>
        </div>
        
        <div class="search-container">
          <div class="search-box">
            <input type="text" id="keyword" placeholder="음식점 이름 검색">
            <button type="button" onclick="searchPlaces()" class="search-btn">
              <i class="fas fa-search"></i> 검색
            </button>
          </div>
          
          <div class="category-buttons">
            <button type="button" onclick="searchCategory('FD6')" class="category-btn">
              <i class="fas fa-utensils"></i> 음식점
            </button>
            <button type="button" onclick="searchCategory('CE7')" class="category-btn">
              <i class="fas fa-coffee"></i> 카페
            </button>
            <button type="button" onclick="searchCategory('CS2')" class="category-btn">
              <i class="fas fa-store"></i> 편의점
            </button>
          </div>
        </div>
        
        <div class="map-container">
          <div id="map"></div>
        </div>
        
        <div class="place-info">
          <div class="form-group">
            <label for="storeName"><i class="fas fa-store"></i> 가게 이름</label>
            <input type="text" id="storeName" name="storeName" readonly placeholder="지도에서 장소를 선택하세요" required>
          </div>
          
          <div class="form-group">
            <label for="location"><i class="fas fa-map"></i> 위치</label>
            <input type="text" id="location" name="location" readonly placeholder="지도에서 장소를 선택하세요" required>
          </div>
          
          <!-- 좌표값은 hidden으로 저장 -->
          <input type="hidden" id="x" name="x">
          <input type="hidden" id="y" name="y">
        </div>
      </div>

      <div class="form-section">
        <div class="form-group">
          <label for="foodType"><i class="fas fa-utensils"></i> 음식 종류</label>
          <select id="foodType" name="foodType" required>
            <option value="" disabled selected>음식 종류를 선택하세요</option>
            <option value="한식">한식</option>
            <option value="중식">중식</option>
            <option value="일식">일식</option>
            <option value="양식">양식</option>
            <option value="분식">분식</option>
            <option value="카페/디저트">카페/디저트</option>
            <option value="기타">기타</option>
          </select>
        </div>
        
        <!-- 이미지 업로드 필드 추가 -->
        <div class="form-group">
          <label><i class="fas fa-image"></i> 이미지 첨부</label>
          
          <div class="image-upload-wrapper">
            <!-- 이미지 업로드 버튼과 파일 이름 표시 영역 -->
            <div class="image-upload-controls">
              <label for="image" class="image-upload-btn">
                <i class="fas fa-upload"></i> 이미지 선택
              </label>
              <input type="file" id="image" name="image" accept="image/*" class="hidden-file-input" onchange="previewImage(this)">
              <span class="file-name" id="fileName"></span>
            </div>
            
            <span class="file-help-text">JPG, PNG, GIF 형식의 이미지만 업로드 가능합니다. (최대 5MB)</span>
            
            <!-- 이미지 미리보기 영역 -->
            <div class="image-preview" id="imagePreview">
              <img id="preview" src="#" alt="이미지 미리보기">
              <div class="image-preview-controls">
                <button type="button" class="remove-image-btn" onclick="removeImage()">
                  <i class="fas fa-trash"></i> 이미지 제거
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <div class="form-group">
          <label for="content"><i class="fas fa-comment"></i> 추천 이유</label>
          <textarea id="content" name="content" placeholder="이 맛집을 추천하는 이유를 자세히 적어주세요" required></textarea>
        </div>
      </div>

      <div class="form-actions">
        <button type="button" id="cancelBtn" class="cancel-btn">
          <i class="fas fa-times"></i> 취소
        </button>
        <button type="submit" class="submit-btn" id="submitBtn" disabled>
          <i class="fas fa-check"></i> 작성 완료
        </button>
      </div>
    </form>
  </div>
</div>

<script>
  // 지도 초기화 함수
  function initializeWriteMap() {
    // 지도 초기화
    let mapContainer = document.getElementById('map');
    let mapOption = {
      center: new kakao.maps.LatLng(37.566826, 126.9786567),
      level: 3
    };

    let map = new kakao.maps.Map(mapContainer, mapOption);
    let ps = new kakao.maps.services.Places();
    let infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });
    let markers = [];
    let selectedPlace = null;

  // 현재 위치로 지도 이동
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      let lat = position.coords.latitude;
      let lng = position.coords.longitude;
      let locPosition = new kakao.maps.LatLng(lat, lng);
      map.setCenter(locPosition);
    });
  }

  // 장소 검색
  function searchPlaces() {
    let keyword = document.getElementById('keyword').value.trim();
    if (!keyword) {
      alert('키워드를 입력해주세요!');
      return;
    }
    ps.keywordSearch(keyword, placesSearchCB);
  }

  // 검색 콜백
  function placesSearchCB(data, status) {
    if (status === kakao.maps.services.Status.OK) {
      displayPlaces(data);
    } else {
      alert('검색 결과가 없습니다.');
    }
  }

  // 검색 결과 표시
  function displayPlaces(places) {
    removeMarkers();
    let bounds = new kakao.maps.LatLngBounds();

    for (let i = 0; i < places.length; i++) {
      let place = places[i];
      let position = new kakao.maps.LatLng(place.y, place.x);
      
      // 마커 생성
      let marker = new kakao.maps.Marker({
        map: map,
        position: position
      });
      
      markers.push(marker);
      bounds.extend(position);

      // 마커 클릭 이벤트
      (function(marker, place) {
        kakao.maps.event.addListener(marker, 'click', function() {
          // 이전에 선택된 마커가 있으면 기본 이미지로 변경
          if (selectedPlace) {
            for (let i = 0; i < markers.length; i++) {
              markers[i].setImage(null);
            }
          }
          
          // 선택된 마커 표시
          let selectedMarkerImage = new kakao.maps.MarkerImage(
            'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png',
            new kakao.maps.Size(24, 35)
          );
          marker.setImage(selectedMarkerImage);
          
          // 인포윈도우 표시
          let content = '<div class="info-window">' + 
                        '  <strong>' + place.place_name + '</strong>' +
                        '  <p>' + (place.road_address_name || place.address_name) + '</p>' +
                        '</div>';
          infowindow.setContent(content);
          infowindow.open(map, marker);
          
          // 폼에 정보 채우기
          fillForm(place);
          selectedPlace = place;
          
          // 작성 완료 버튼 활성화
          document.getElementById('submitBtn').disabled = false;
        });
      })(marker, place);
    }

    map.setBounds(bounds);
  }

  // 마커 제거
  function removeMarkers() {
    for (let i = 0; i < markers.length; i++) {
      markers[i].setMap(null);
    }
    markers = [];
  }

  // 폼에 정보 채우기
  function fillForm(place) {
    document.getElementById('storeName').value = place.place_name;
    document.getElementById('location').value = place.road_address_name || place.address_name;
    document.getElementById('x').value = place.x;
    document.getElementById('y').value = place.y;
  }

  // 카테고리 검색
  function searchCategory(categoryCode) {
    removeMarkers();
    let center = map.getCenter();
    ps.categorySearch(categoryCode, function(data, status) {
      if (status === kakao.maps.services.Status.OK) {
        displayPlaces(data);
      } else {
        alert('카테고리 검색 결과가 없습니다.');
      }
    }, { location: center });
  }
  
  // 취소 버튼
  function goToBoardPage() {
	    location.href = '/jsp_project/board';  // 경로 확인 필요
	  }

	  document.addEventListener('DOMContentLoaded', function() {
	    const cancelBtn = document.getElementById('cancelBtn');
	    if (cancelBtn) {
	      cancelBtn.addEventListener('click', function(e) {
	        e.preventDefault();
	        goToBoardPage();
	      });
	    }
	  });

  // 엔터키로 검색
  document.getElementById('keyword').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
      e.preventDefault();
      searchPlaces();
    }
  });

  // 폼 제출 전 유효성 검사
  document.getElementById('postForm').addEventListener('submit', function(e) {
    if (!selectedPlace) {
      e.preventDefault();
      alert('지도에서 장소를 선택해주세요.');
    }
  });
  
  //이미지 미리보기 함수
  function previewImage(input) {
    const preview = document.getElementById('preview');
    const imagePreview = document.getElementById('imagePreview');
    const fileName = document.getElementById('fileName');
    
    if (input.files && input.files[0]) {
      const file = input.files[0];
      
      // 파일 크기 검사 (5MB 제한)
      if (file.size > 5 * 1024 * 1024) {
        alert('이미지 크기는 5MB를 초과할 수 없습니다.');
        input.value = '';
        fileName.textContent = '';
        return;
      }
      
      // 파일 형식 검사
      const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
      if (!validTypes.includes(file.type)) {
        alert('JPG, PNG, GIF 형식의 이미지만 업로드 가능합니다.');
        input.value = '';
        fileName.textContent = '';
        return;
      }
      
      // 파일 이름 표시
      fileName.textContent = file.name;
      
      const reader = new FileReader();
      
      reader.onload = function(e) {
        preview.src = e.target.result;
        imagePreview.style.display = 'block';
      }
      
      reader.readAsDataURL(file);
    } else {
      imagePreview.style.display = 'none';
      fileName.textContent = '';
    }
  }
  
  // 이미지 제거 함수
  function removeImage() {
    const imageInput = document.getElementById('image');
    const imagePreview = document.getElementById('imagePreview');
    const fileName = document.getElementById('fileName');
    
    imageInput.value = '';
    imagePreview.style.display = 'none';
    fileName.textContent = '';
  }
  }
</script>
</body>
</html>