<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String userId = (String)session.getAttribute("user_id");
if(userId == null){response.sendRedirect("../user/login.jsp");return;}

String date = request.getParameter("selectedDate");
if(date == null || date.trim().isEmpty()){
  date = java.time.LocalDate.now().toString();
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>일기 작성</title>

<!-- ✅ 외부 CSS만 사용 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/diary.css">
<link rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=Inter:slnt,wght@-10..0,100..900&display=swap">

<script>
  /* 이미지 업로드 관련 JS만 유지 */

  function openImage(){
    showImageUI(true);
    document.getElementById("file").click();
  }

  function showImageUI(on){
    const imgBox = document.querySelector(".imgBox");
    const textarea = document.querySelector("textarea");
    if(on){
      imgBox.classList.add("show");
      textarea.classList.add("hasImage");
    }else{
      imgBox.classList.remove("show");
      textarea.classList.remove("hasImage");
    }
  }

  function submitWrite(){
    document.getElementById("writeForm").submit();
  }

  window.addEventListener("DOMContentLoaded", ()=>{
    const fileInput = document.getElementById("file");
    const previewImg = document.getElementById("previewImg");
    const imgHint = document.getElementById("imgHint");

    showImageUI(false);

    fileInput.addEventListener("change",(e)=>{
      const f = e.target.files && e.target.files[0];

      if(!f){
        previewImg.src = "";
        previewImg.style.display = "none";
        imgHint.style.display = "block";
        showImageUI(false);
        return;
      }

      previewImg.src = URL.createObjectURL(f);
      previewImg.style.display = "block";
      imgHint.style.display = "none";
      showImageUI(true);
    });
  });
</script>
</head>

<body>
<div class="phone">

  <!-- 상단바 -->
  <header class="topbar">
    <button type="button" class="icon-btn back" onclick="history.back()">‹</button>

    <div class="date-wrap">
      <div class="date-text"><%=date%></div>
      <div class="date-line"></div>
    </div>

    <div class="actions">
      <button type="button" class="icon-btn circle" onclick="openImage()">＋</button>
      <button type="button" class="icon-btn circle" onclick="submitWrite()">✓</button>
    </div>
  </header>

  <!-- 폼 -->
  <form id="writeForm"
        action="<%=request.getContextPath()%>/diary/DiaryWriteCon.do"
        method="post"
        enctype="multipart/form-data">

    <input type="hidden" name="create_date" value="<%=date%>">

    <!-- ✅ 표정 선택 (JSP + CSS ONLY) -->
    <section class="emoji-row emoji-pick">

      <input type="checkbox" id="emo1" name="emotion" value="1" class="emo" hidden>
      <label for="emo1" class="emoji-btn">
        <img src="<%=request.getContextPath()%>/resources/mood/mood1.png" alt="아주 나쁨">
      </label>

      <input type="checkbox" id="emo4" name="emotion" value="4" class="emo" hidden>
      <label for="emo2" class="emoji-btn">
       <img src="<%=request.getContextPath()%>/resources/mood/mood4.png" alt="나쁨">
      </label>

      <input type="checkbox" id="emo3" name="emotion" value="3" class="emo" hidden>
      <label for="emo3" class="emoji-btn">
        <img src="<%=request.getContextPath()%>/resources/mood/mood3.png" alt="보통">
      </label>

      <input type="checkbox" id="emo5" name="emotion" value="5" class="emo" hidden>
      <label for="emo4" class="emoji-btn">
        <img src="<%=request.getContextPath()%>/resources/mood/mood5.png" alt="좋음">
      </label>

      <input type="checkbox" id="emo2" name="emotion" value="2" class="emo" hidden>
      <label for="emo5" class="emoji-btn">
        <img src="<%=request.getContextPath()%>/resources/mood/mood2.png" alt="아주 좋음">
      </label>

    </section>

    <!-- 파일 -->
    <input type="file" name="file" id="file" accept="image/*" style="display:none;">

    <!-- 이미지 영역 -->
    <div class="photo-area imgBox">
      <img id="previewImg" class="photo" style="display:none;">
      
    </div>

    <!-- 내용 -->
    <section class="content-area">
      <div class="content-box">
        <textarea name="content" class="diary-input"
          placeholder="오늘 하루를 기록해보세요." required></textarea>
      </div>
    </section>

  </form>
</div>
</body>
</html>