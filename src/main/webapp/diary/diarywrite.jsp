<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String userId = (String)session.getAttribute("user_id");
if(userId == null){ response.sendRedirect("../user/login.jsp"); return; }

String date = request.getParameter("date");
if(date == null) date = "";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일기 작성</title>
<style>
  body{font-family:Arial;background:#f7f7f7;margin:0;padding:30px;}
  .wrap{max-width:860px;margin:0 auto;background:#fff;border-radius:14px;padding:22px;box-shadow:0 2px 10px rgba(0,0,0,.08);}
  .row{margin:14px 0;}
  label{display:block;font-weight:800;margin-bottom:8px;}
  textarea{width:100%;min-height:240px;padding:12px;border-radius:12px;border:1px solid #ccc;resize:vertical;}
  input[type="date"]{padding:10px 12px;border:1px solid #ccc;border-radius:10px;}

  .moods{display:flex;gap:10px;flex-wrap:wrap;}
  .mood{
    border:1px solid #ddd;
    background:#fafafa;
    border-radius:14px;
    padding:10px 12px;
    cursor:pointer;
    display:flex;
    align-items:center;
    transition: opacity .2s, transform .2s, box-shadow .2s;
    user-select:none;
    opacity:1;
  }
  .mood.active{
    border-color:#1565c0;
    box-shadow:0 0 0 3px rgba(21,101,192,.12);
    background:#f5f9ff;
    transform:scale(1.05);
    opacity:1;
  }
  .mood.inactive{opacity:0.25;}
  .emo{font-size:22px;}

  .bottom{display:flex;justify-content:flex-end;gap:10px;margin-top:18px;flex-wrap:wrap;}
  .btn{border:0;padding:10px 14px;border-radius:12px;cursor:pointer;font-weight:700;}
  .save{background:#2e7d32;color:#fff;}
  .main{background:#424242;color:#fff;text-decoration:none;display:inline-flex;align-items:center;}
  .photo{background:#1565c0;color:#fff;}
  .hint{color:#777;font-size:13px;margin-top:6px;}

  /* 미리보기 */
  #previewWrap{margin-top:10px;display:none;}
  #previewImg{max-width:320px;border-radius:12px;border:1px solid #e0e0e0;}
  #fileName{font-size:13px;color:#555;margin-top:6px;}
</style>

<script>
  let selectedMood = null;

  function setMood(val){
    const moods = document.querySelectorAll(".mood");

  
    if(selectedMood === val){
      selectedMood = null;
      document.getElementById("emotion").value = "";
      moods.forEach(el => el.classList.remove("active","inactive"));
      return;
    }
 
    selectedMood = val;
    document.getElementById("emotion").value = val;

    moods.forEach(el=>{
      el.classList.remove("active");
      el.classList.add("inactive");
    });

    const target = document.querySelector(".mood[data-val='"+val+"']");
    if(target){
      target.classList.add("active");
      target.classList.remove("inactive");
    }
  }

  function openImage(){
    document.getElementById("file").click();
  }

  window.addEventListener("DOMContentLoaded", ()=>{
    // 처음엔 5개 전부 선명
    document.querySelectorAll(".mood").forEach(el => el.classList.remove("active","inactive"));

    // 파일 선택 시 미리보기
    const fileInput = document.getElementById("file");
    const previewWrap = document.getElementById("previewWrap");
    const previewImg = document.getElementById("previewImg");
    const fileName = document.getElementById("fileName");

    fileInput.addEventListener("change",(e)=>{
      const f = e.target.files && e.target.files[0];
      if(!f){
        previewWrap.style.display = "none";
        previewImg.src = "";
        fileName.textContent = "";
        return;
      }
      previewWrap.style.display = "block";
      previewImg.src = URL.createObjectURL(f);
      fileName.textContent = "선택된 파일: " + f.name;
    });
  });
</script>
</head>

<body>
<div class="wrap">
  <h2>일기 작성</h2>

  <!-- ✅ 서블릿으로 전송 -->
  <form action="<%=request.getContextPath()%>/DiaryWriteProc.do" method="post" enctype="multipart/form-data">

    <!-- ✅ 서블릿에서 세션 user_id 쓰면 굳이 안 보내도 됨.
    <!-- <input type="hidden" name="user_id" value="<%=userId%>"> -->

    <input type="hidden" name="emotion" id="emotion">

    <div class="row">
      <label>작성 날짜</label>
      <!-- ✅ 네 서블릿은 create_date를 받으니까 name을 create_date로 맞춤 -->
      <input type="date" name="create_date" value="<%=date%>" required>
    </div>

    <div class="row">
      <label>그날의 기분</label>
      <div class="moods">
        <div class="mood" data-val="1" onclick="setMood(1)"><span class="emo">😫</span></div>
        <div class="mood" data-val="2" onclick="setMood(2)"><span class="emo">😟</span></div>
        <div class="mood" data-val="3" onclick="setMood(3)"><span class="emo">😐</span></div>
        <div class="mood" data-val="4" onclick="setMood(4)"><span class="emo">🙂</span></div>
        <div class="mood" data-val="5" onclick="setMood(5)"><span class="emo">😄</span></div>
      </div>
    </div>

    <div class="row">
      <label>일기 내용</label>
      <textarea name="content" placeholder="오늘의 기록을 작성하세요." required></textarea>
    </div>
                  <!-- 서블릿에서 실행되는 코드 -->
    <!-- ✅ 파일 input name을 서블릿 getPart("file")에 맞춤 -->
    <input type="file" name="file" id="file" accept="image/*" style="display:none;">

    <!-- ✅ 선택하면 작성페이지 안에 미리보기 표시 -->
    <div id="previewWrap">
      <img id="previewImg" alt="미리보기">
      <div id="fileName"></div>
    </div>

    <div class="bottom">
      <button type="button" class="btn photo" onclick="openImage()">📷 사진 추가</button>
      <a class="btn main" href="calendarMain.jsp">메인</a>
      <button class="btn save" type="submit">저장</button>
    </div>
  </form>
</div>
</body>
</html> 
