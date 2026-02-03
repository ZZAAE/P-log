<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String userId = (String)session.getAttribute("user_id");
if(userId == null){ response.sendRedirect("login.jsp"); return; }

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
  .mood{border:1px solid #ddd;background:#fafafa;border-radius:14px;padding:10px 12px;cursor:pointer;display:flex;gap:8px;align-items:center;}
  .mood.active{border-color:#1565c0;box-shadow:0 0 0 3px rgba(21,101,192,.12);background:#f5f9ff;}
  .emo{font-size:20px;}
  .bottom{display:flex;justify-content:flex-end;gap:10px;margin-top:18px;}
  .btn{border:0;padding:10px 14px;border-radius:12px;cursor:pointer;font-weight:700;}
  .save{background:#2e7d32;color:#fff;}
  .main{background:#424242;color:#fff;text-decoration:none;display:inline-flex;align-items:center;}
  .hint{color:#777;font-size:13px;margin-top:6px;}
</style>
<script>
  function setMood(val){
    document.getElementById("emotion").value = val;
    document.querySelectorAll(".mood").forEach(el=>el.classList.remove("active"));
    document.querySelector(".mood[data-val='"+val+"']").classList.add("active");
  }
  window.addEventListener("DOMContentLoaded", ()=>{
    setMood(3);
    document.getElementById("image").addEventListener("change",(e)=>{
      const f = e.target.files && e.target.files[0];
      document.getElementById("fileName").textContent = f ? ("선택됨: " + f.name) : "선택된 이미지 없음";
    });
  });
</script>
</head>
<body>
<div class="wrap">
  <h2>일기 작성</h2>

  <form action="diary_save.jsp" method="post" enctype="multipart/form-data">
    <input type="hidden" name="emotion" id="emotion" value="3">

    <div class="row">
      <label>작성 날짜</label>
      <input type="date" name="date" value="<%=date%>" required>
    </div>

    <div class="row">
      <label>그날의 기분</label>
      <div class="moods">
        <div class="mood" data-val="1" onclick="setMood(1)"><span class="emo">😫</span>매우 나쁨</div>
        <div class="mood" data-val="2" onclick="setMood(2)"><span class="emo">😟</span>나쁨</div>
        <div class="mood" data-val="3" onclick="setMood(3)"><span class="emo">😐</span>보통</div>
        <div class="mood" data-val="4" onclick="setMood(4)"><span class="emo">🙂</span>좋음</div>
        <div class="mood" data-val="5" onclick="setMood(5)"><span class="emo">😄</span>매우 좋음</div>
      </div>
      <div class="hint">emotion 값은 1~5로 저장</div>
    </div>

    <div class="row">
      <label>일기 내용(장문)</label>
      <textarea name="content" placeholder="오늘의 기록을 작성하세요." required></textarea>
    </div>

    <div class="row">
      <label>이미지 업로드(선택)</label>
      <input type="file" name="image" id="image" accept="image/*">
      <div id="fileName" class="hint">선택된 이미지 없음</div>
    </div>

    <div class="bottom">
      <a class="btn main" href="calendarMain.jsp">메인</a>
      <button class="btn save" type="submit">저장</button>
    </div>
  </form>
</div>
</body>
</html>
