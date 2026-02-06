<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="diary.DiaryDAO, diary.DiaryinfoDTO, image.ImageDAO" %>
<%
request.setCharacterEncoding("UTF-8");

String sessionUserId = (String)session.getAttribute("user_id");
if(sessionUserId == null){
  response.sendRedirect("../user/login.jsp");
  return;
}

// 수정할 날짜
String date = request.getParameter("date");
if(date == null || date.trim().isEmpty()){
  date = java.time.LocalDate.now().toString();
}

// 기존 데이터 불러오기
String content = "";
int emotion = 3; // 기본 보통
String imagePath = null; // DB에 "/resources/img/xxx" 형태로 저장되어 있다고 가정

try{
  DiaryDAO dDao = new DiaryDAO();
  int diaryId = dDao.getDiaryID(sessionUserId, date);
  DiaryinfoDTO dto = (diaryId > 0) ? dDao.getDiaryInfo(diaryId) : null;

  if(dto != null){
    if(dto.getContent() != null) content = dto.getContent();
    if(dto.getEmotion() > 0) emotion = dto.getEmotion();

    String imageId = dto.getImage_id();
    if(imageId != null && !imageId.trim().isEmpty()){
      ImageDAO iDao = new ImageDAO();
      String dbPath = iDao.getImageinfoPath(imageId); // "/resources/img/xxx" 권장
      if(dbPath != null && !dbPath.trim().isEmpty()){
        // 혹시 resources/img/xxx 처럼 /가 없으면 보정
        if(dbPath.startsWith("/")) imagePath = request.getContextPath() + dbPath;
        else imagePath = request.getContextPath() + "/" + dbPath;
      }
    }
  }
}catch(Exception e){
  // 화면은 뜨게 유지
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>일기 수정</title>

<!-- ✅ write 페이지와 같은 CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/diary.css">
<link rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=Inter:slnt,wght@-10..0,100..900&display=swap">

<script>
  function openImage(){
    document.getElementById("file").click();
  }

  function submitUpdate(){
    // 감정 선택 안 되어 있으면 막기
    const checked = document.querySelector('input[name="emotion"]:checked');
    if(!checked){
      alert("기분을 선택해줘!");
      return;
    }
    document.getElementById("updateForm").submit();
  }

  window.addEventListener("DOMContentLoaded", ()=>{
    const fileInput  = document.getElementById("file");
    const previewImg = document.getElementById("previewImg");
    const imgHint    = document.getElementById("imgHint");

    fileInput.addEventListener("change", (e)=>{
      const f = e.target.files && e.target.files[0];
      if(!f){
        // 취소 시: 기존 이미지가 있으면 그대로 유지, 없으면 힌트 표시
        const hasOld = previewImg.getAttribute("data-has-old") === "true";
        if(hasOld){
          previewImg.style.display = "block";
          imgHint.style.display = "none";
        }else{
          previewImg.src = "";
          previewImg.style.display = "none";
          imgHint.style.display = "block";
        }
        return;
      }

      previewImg.src = URL.createObjectURL(f);
      previewImg.style.display = "block";
      imgHint.style.display = "none";
    });
  });
</script>
</head>

<body>
<div class="phone">

  <!-- ✅ write와 동일한 상단바 구조 -->
  <header class="topbar">
    <button type="button" class="icon-btn back" onclick="history.back()">‹</button>

    <div class="date-wrap">
      <div class="date-text"><%=date%></div>
      <div class="date-line"></div>
    </div>

    <div class="actions">
      <button type="button" class="icon-btn circle" onclick="openImage()">＋</button>
      <button type="button" class="icon-btn circle" onclick="submitUpdate()">✓</button>
    </div>
  </header>

  <!-- ✅ 수정 폼 -->
  <form id="updateForm"
        action="<%=request.getContextPath()%>/DiaryUpdateProc.do"
        method="post"
        enctype="multipart/form-data">

    <!-- DiaryUpdateCon이 user_id/create_date로 찾아서 수정하니까 그대로 전송 -->
    <input type="hidden" name="user_id" value="<%=sessionUserId%>">
    <input type="hidden" name="create_date" value="<%=date%>">

    <!-- ✅ 감정 선택: radio (필수) -->
    <section class="emoji-row emoji-pick">

      <input type="radio" id="emo1" name="emotion" value="1" hidden <%= (emotion==1?"checked":"") %>>
      <label for="emo1" class="emoji-btn">
        <img src="<%=request.getContextPath()%>/resources/mood/mood1.png" alt="아주 나쁨">
      </label>

      <input type="radio" id="emo2" name="emotion" value="2" hidden <%= (emotion==2?"checked":"") %>>
      <label for="emo2" class="emoji-btn">
        <img src="<%=request.getContextPath()%>/resources/mood/mood2.png" alt="나쁨">
      </label>

      <input type="radio" id="emo3" name="emotion" value="3" hidden <%= (emotion==3?"checked":"") %>>
      <label for="emo3" class="emoji-btn">
        <img src="<%=request.getContextPath()%>/resources/mood/mood3.png" alt="보통">
      </label>

      <input type="radio" id="emo4" name="emotion" value="4" hidden <%= (emotion==4?"checked":"") %>>
      <label for="emo4" class="emoji-btn">
        <img src="<%=request.getContextPath()%>/resources/mood/mood4.png" alt="좋음">
      </label>

      <input type="radio" id="emo5" name="emotion" value="5" hidden <%= (emotion==5?"checked":"") %>>
      <label for="emo5" class="emoji-btn">
        <img src="<%=request.getContextPath()%>/resources/mood/mood5.png" alt="아주 좋음">
      </label>

    </section>

    <!-- 파일 -->
    <input type="file" name="file" id="file" accept="image/*" style="display:none;">

    <!-- ✅ 이미지 박스: write와 동일 클래스(imgBox) 사용 -->
    <div class="photo-area imgBox" onclick="openImage()">
      <%
        boolean hasOld = (imagePath != null && !imagePath.trim().isEmpty());
      %>

      <img id="previewImg" class="photo"
           alt="미리보기"
           style="<%= hasOld ? "display:block;" : "display:none;" %>"
           data-has-old="<%= hasOld ? "true" : "false" %>"
           <% if(hasOld){ %> src="<%=imagePath%>" <% } %>
      >

      <div id="imgHint" style="<%= hasOld ? "display:none;" : "display:block;" %>">이미지 변경</div>
    </div>

    <!-- 내용 -->
    <section class="content-area">
      <div class="content-box">
        <textarea name="content" class="diary-input" required><%=content%></textarea>
      </div>
    </section>

  </form>
</div>
</body>
</html>

