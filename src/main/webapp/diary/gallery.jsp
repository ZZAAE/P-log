<%@page import="diary.GalleryDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내 이미지 갤러리</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/gallery.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">

<style>
.grid{ display:grid; grid-template-columns:repeat(4, 1fr); gap:12px; }
.card{ border-radius:14px; overflow:hidden; background:#fff; box-shadow:0 4px 16px rgba(0,0,0,.06); }
.thumb{ width:100%; height:180px; object-fit:cover; display:block; }
.empty{ padding:24px; color:#777; }
@media(max-width:900px){ .grid{ grid-template-columns:repeat(2,1fr); } }
</style>
</head>
<body>
<!-- ✅ Topbar (calendar.css 기준 구조로 정리) -->
   <div class="topbar">
      <div class="topbar__inner">
         <!-- 왼쪽 -->
         <div class="topbar__logo">P-log</div>
         <!-- 오른쪽 -->
         <div class="topbar__right">
            <!-- 집 아이콘 -->
            <a class="topbar__profile"
               href="${pageContext.request.contextPath}/diary/CalendarMain.do"
               aria-label="홈"> <span class="topbar__profileIcon"> <i
                  class="bi bi-house-door-fill"></i>
            </span>
            </a>
            <!-- ✅ 갤러리 아이콘 -->
            <a class="topbar__profile"
               href="${pageContext.request.contextPath}/diary/GalleryCon.do"
               aria-label="갤러리"> <span class="topbar__profileIcon"> <i
                  class="bi bi-card-image"></i>
            </span>
            </a>
            <!-- 사람 아이콘 -->
            <a class="topbar__profile"
               href="${pageContext.request.contextPath}/user/userinfo_update.jsp"
               aria-label="프로필"> <span class="topbar__profileIcon"> <i
                  class="bi bi-person-fill"></i>
            </span>
            </a> <a class="topbar__logout"
               href="${pageContext.request.contextPath}/user/LogoutCon.do">로그아웃</a>
         </div>
      </div>
   </div>

<%
List<GalleryDTO> images = (List<GalleryDTO>)request.getAttribute("images");
%>

<h2>내 이미지 갤러리</h2>

	<c:choose>
		<c:when test="${empty images}">
			<div class="empty">저장된 이미지가 없습니다.</div>
		</c:when>

		<c:otherwise>
			<div class="grid">
				<c:forEach var="img" items="${images}">
					<a class="card" href="${img.image_path}"> <img
						class="thumb" src="${img.image_path}" alt="img"> <!-- ./resources/img/puppy.jpg -->
					</a>
				</c:forEach>
			</div>
		</c:otherwise>
	</c:choose>

</body>
</html>
