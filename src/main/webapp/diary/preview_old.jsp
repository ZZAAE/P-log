<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="diary.DiaryinfoDTO" %>
<%
request.setCharacterEncoding("UTF-8");

// 로그인 체크
String userId = (String)session.getAttribute("user_id");
if(userId == null){
  response.sendRedirect("../user/login.jsp");
  return;
}

// Preview.do에서 전달된 값
DiaryinfoDTO preview = (DiaryinfoDTO)request.getAttribute("preview");
String date = (String)request.getAttribute("selectedDate");
if(date == null || date.trim().isEmpty()){
  date = java.time.LocalDate.now().toString();
}

String imagePath = (String)request.getAttribute("imagePath");
System.out.println("Preview.jsp imagePath: " + imagePath);
// ✅ imagePath -> imgSrc 보정 (/resources/... 또는 resources/... 모두 OK)
String imgSrc = null;
if(imagePath != null && !imagePath.trim().isEmpty()){
  if(imagePath.startsWith("/")) imgSrc = request.getContextPath() + imagePath;
  else imgSrc = request.getContextPath() + "/" + imagePath;
}

// 데이터
String content = (preview == null || preview.getContent() == null) ? "" : preview.getContent();
int emotion = (preview == null) ? 0 : preview.getEmotion();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>일기 미리보기</title>

<!-- ✅ 작성페이지와 같은 CSS 사용 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/diary.css">
<link rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=Inter:slnt,wght@-10..0,100..900&display=swap">

<style>
  /* preview 전용 보정 (작성 CSS를 해치지 않게 최소만) */

  /* 상단 아이콘 SVG */
  .icon-btn svg{ width:18px; height:18px; display:block; }

  /* 읽기 전용 textarea */
  .diary-input[readonly]{ background:transparent; }

  /* 기분: 선택한 것만 선명 */
  .emoji-row .emoji-btn{ opacity:.25; transition:opacity .15s ease, transform .15s ease; }
  .emoji-row .emoji-btn.active{ opacity:1; transform:scale(1.05); }

  /* 이미지 없을 때 안내문(작성페이지 imgHint 느낌) */
  #imgHint{
    color:#6b7280;
    font-weight:800;
    letter-spacing:-.2px;
  }
</style>

<script>
  function goDelete(){
    if(confirm("정말 삭제하시겠습니까?")){
      location.href = "<%=request.getContextPath()%>/diary/DiaryDeleteCon.do?create_date=<%=date%>";
    }
  }
</script>
</head>

<body>
<div class="phone">

  <!-- ✅ 작성페이지와 동일한 상단바 구조 -->
  <header class="topbar">

    <!-- ✅ 메인(캘린더) -->
    <button type="button"
            class="icon-btn back"
            onclick="location.href='<%=request.getContextPath()%>/diary/calendarMain.jsp'"
            aria-label="메인">
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <path fill="currentColor" d="M12 3l9 8h-3v9h-5v-6H11v6H6v-9H3z"/>
      </svg>
    </button>

    <!-- ✅ 날짜 가운데 -->
    <div class="date-wrap">
      <div class="date-text"><%=date%></div>
      <div class="date-line"></div>
    </div>

    <!-- ✅ 우측 상단 수정/삭제 -->
    <div class="actions">

      <!-- 수정 -->
      <button type="button" class="icon-btn circle"
        onclick="location.href='<%=request.getContextPath()%>/diary/diaryupdate.jsp?date=<%=date%>'"
        aria-label="수정">
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path fill="currentColor"
            d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zm2.92 2.33H5v-.92l8.48-8.48.92.92-8.48 8.48zM20.71 7.04a1.003 1.003 0 0 0 0-1.42L18.37 3.29a1.003 1.003 0 0 0-1.42 0l-1.83 1.83 3.75 3.75 1.84-1.83z"/>
        </svg>
      </button>

      <!-- 삭제 -->
      <button type="button" class="icon-btn circle" onclick="goDelete()" aria-label="삭제">
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path fill="currentColor"
            d="M6 7h12l-1 14H7L6 7zm3-3h6l1 2H8l1-2zm-3 2h12v2H6V6z"/>
        </svg>
      </button>

    </div>
  </header>

  <!-- ✅ 기분 표시 (선택한 것만 active) -->
  <section class="emoji-row">
    <div class="emoji-btn <%= (emotion==1 ? "active" : "") %>">
      <img src="<%=request.getContextPath()%>/resources/mood/mood1.png" alt="아주 나쁨">
    </div>
    <div class="emoji-btn <%= (emotion==4 ? "active" : "") %>">
      <img src="<%=request.getContextPath()%>/resources/mood/mood4.png" alt="나쁨">
    </div>
    <div class="emoji-btn <%= (emotion==3 ? "active" : "") %>">
      <img src="<%=request.getContextPath()%>/resources/mood/mood3.png" alt="보통">
    </div>
    <div class="emoji-btn <%= (emotion==5 ? "active" : "") %>">
      <img src="<%=request.getContextPath()%>/resources/mood/mood5.png" alt="좋음">
    </div>
    <div class="emoji-btn <%= (emotion==2 ? "active" : "") %>">
      <img src="<%=request.getContextPath()%>/resources/mood/mood2.png" alt="아주 좋음">
    </div>
  </section>

  <!-- ✅ 이미지 영역: 작성페이지와 동일하게 imgBox 사용 -->
  <div class="photo-area imgBox <%= (imagePath == null ? "" : "show") %>">
    <% if(imagePath != null){ %>
      <img src="<%=imagePath%>" class="photo" alt="일기 이미지">
    <% } else { %>
      <div id="imgHint">이미지 없음</div>
    <% } %>
  </div>

  <!-- ✅ 큰 테이블(작성페이지와 동일) -->
  <section class="content-area">
    <div class="content-box">
      <textarea class="diary-input" readonly><%=content%></textarea>
    </div>
  </section>

</div>
</body>
</html>
