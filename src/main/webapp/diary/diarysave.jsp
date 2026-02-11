<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");
String userId = (String)session.getAttribute("user_id");
if(userId == null){ response.sendRedirect("../user/login.jsp"); return; }

String date = request.getParameter("date");
if(date == null) date = "";

/* =========================
   ✅ 여기서 "기존 일기" 불러오기
   - 아래는 예시 변수만 만들어둠
   - 너 프로젝트 DAO로 교체해서 사용
========================= */
// 예시 데이터(DAO로 교체)
String content = "";          // 기존 content
int emotion = 0;              // 기존 emotion(1~5), 없으면 0
String imageUrl = "";         // 기존 이미지 경로(웹에서 접근 가능한 경로). 없으면 ""

try{
  // DiaryDAO dao = new DiaryDAO();
  // DiaryinfoDTO dto = dao.getDiaryByUserAndDate(userId, date);
  // if(dto != null){
  //   content = dto.getContent();
  //   emotion = dto.getEmotion();
  //   imageUrl = dto.getImagePath(); // 너 구조에 맞게
  // }
}catch(Exception e){
  // 무시 or 로그
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수정 페이지</title>
<style>
  :root{
    --bg:#f3f4f6;
    --card:#ffffff;
    --line:#e6e8ee;
    --text:#111827;
    --muted:#6b7280;
    --blue:#2563eb;
    --red:#ef4444;
    --shadow:0 10px 25px rgba(0,0,0,.08);
  }
  *{box-sizing:border-box;}
  body{
    margin:0;
    font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
    background: var(--bg);
    padding: 22px;
    color: var(--text);
  }
  .phone{
    width: 360px;
    max-width: 92vw;
    margin: 0 auto;
    background:#fff;
    border-radius: 26px;
    box-shadow: var(--shadow);
    overflow:hidden;
    border:1px solid #f0f0f0;
  }

  .topbar{
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding: 14px 14px 8px;
    background:#fff;
  }
  .icon-btn{
    width:36px;height:36px;
    border:0;border-radius:12px;
    background:#f3f4f6;
    cursor:pointer;
    display:flex;align-items:center;justify-content:center;
    font-size:18px;
  }
  .title{
    text-align:center;
    font-weight:800;
    font-size:14px;
    line-height:1.1;
    display:flex;
    flex-direction:column;
    gap:4px;
  }
  .title .dateText{font-size:13px;color:var(--text);}

  .mood-line{
    display:flex;
    justify-content:center;
    padding: 6px 0 10px;
  }
  .moods{
    display:flex;
    gap:10px;
    padding: 0 14px;
  }
  .mood{
    font-size:20px;
    cursor:pointer;
    width:34px;height:34px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    transition: opacity .2s, transform .2s, background .2s;
    user-select:none;
  }
  .mood.active{
    transform: scale(1.2);
    background:#eef2ff;
  }
  .mood.inactive{opacity:0.25;}

  .img-card{
    margin: 0 14px 12px;
    border-radius: 16px;
    overflow:hidden;
    border:1px solid var(--line);
    background:#fafafa;
    height: 160px;
    display:flex;
    align-items:center;
    justify-content:center;
    position:relative;
  }
  .img-card img{
    width:100%;
    height:100%;
    object-fit:cover;
    display:none;
  }
  .img-placeholder{color:var(--muted);font-size:13px;}

  .img-remove{
    position:absolute;
    top:10px; right:10px;
    width:34px;height:34px;
    border:0;border-radius:12px;
    background:rgba(0,0,0,.45);
    color:#fff;
    cursor:pointer;
    display:none;
    font-size:16px;
    align-items:center;
    justify-content:center;
  }
  .img-remove.show{display:flex;}

  .content-card{
    margin: 0 14px 18px;
    border-radius: 16px;
    border:1px solid var(--line);
    background: var(--card);
    padding: 12px;
  }
  textarea{
    width:100%;
    border:0;
    outline:none;
    resize:none;
    min-height: 240px;
    font-size: 14px;
    line-height:1.6;
    color: var(--text);
  }
  textarea::placeholder{color:#9ca3af;}

  .mini{
    padding: 0 14px 12px;
    color: var(--muted);
    font-size: 12px;
  }

  .fab-wrap{position:relative;height:72px;}
  .fab{
    position:absolute;
    right: 14px;
    bottom: 14px;
    width: 52px;
    height: 52px;
    border-radius: 18px;
    border:0;
    background:#ffffff;
    box-shadow: 0 12px 22px rgba(0,0,0,.12);
    cursor:pointer;
    font-size: 28px;
    display:flex;align-items:center;justify-content:center;
  }
  .menu{
    position:absolute;
    right: 14px;
    bottom: 78px;
    width: 160px;
    background:#fff;
    border:1px solid var(--line);
    border-radius: 14px;
    box-shadow: 0 14px 30px rgba(0,0,0,.12);
    padding: 6px;
    display:none;
  }
  .menu.open{display:block;}
  .menu button{
    width:100%;
    border:0;
    background:transparent;
    padding: 10px 10px;
    border-radius: 12px;
    cursor:pointer;
    font-weight:700;
    font-size: 13px;
    text-align:left;
  }
  .menu button:hover{background:#f3f4f6;}
  .menu .primary{color: var(--blue);}
  .menu .danger{color: var(--red);}

  #image{display:none;}
</style>

<script>
  let selectedMood = null;

  function initMood(val){
    // 초기 값 세팅(기존 emotion)
    if(!val || val < 1 || val > 5){
      selectedMood = null;
      document.getElementById("emotion").value = "";
      document.querySelectorAll(".mood").forEach(m=>m.classList.remove("active","inactive"));
      return;
    }
    selectedMood = val;
    document.getElementById("emotion").value = val;

    document.querySelectorAll(".mood").forEach(m=>{
      m.classList.remove("active");
      m.classList.add("inactive");
    });

    const t = document.querySelector('.mood[data-val="'+val+'"]');
    if(t){
      t.classList.add("active");
      t.classList.remove("inactive");
    }
  }

  function setMood(val){
    const moods = document.querySelectorAll(".mood");
    const hidden = document.getElementById("emotion");

    if(selectedMood === val){
      selectedMood = null;
      hidden.value = "";
      moods.forEach(m => m.classList.remove("active","inactive"));
      return;
    }

    selectedMood = val;
    hidden.value = val;

    moods.forEach(m => {
      m.classList.remove("active");
      m.classList.add("inactive");
    });

    const target = document.querySelector('.mood[data-val="'+val+'"]');
    if(target){
      target.classList.add("active");
      target.classList.remove("inactive");
    }
  }

  function toggleMenu(){
    document.getElementById("fabMenu").classList.toggle("open");
  }
  function closeMenu(){
    document.getElementById("fabMenu").classList.remove("open");
  }

  function openImage(){
    closeMenu();
    document.getElementById("image").click();
  }

  function removeImage(){
    // ✅ 기존 이미지도 "삭제"로 표시하기 위해 hidden flag 사용
    document.getElementById("removeImageFlag").value = "1";

    const input = document.getElementById("image");
    const img = document.getElementById("previewImg");
    const ph = document.getElementById("imgPh");
    const rm = document.getElementById("removeBtn");

    input.value = "";
    img.src = "";
    img.style.display = "none";
    ph.style.display = "block";
    rm.classList.remove("show");
  }

  function submitEdit(){
    closeMenu();
    document.getElementById("editForm").submit();
  }

  function goBack(){
    closeMenu();
    // 원래는 조회 페이지로 이동 추천
    location.href = "diary_view.jsp?date=<%=date%>";
  }

  window.addEventListener("DOMContentLoaded", ()=>{
    document.getElementById("dateText").textContent = "<%=date%>".trim() ? "<%=date%>" : "날짜";

    // 바깥 클릭 메뉴 닫기
    document.addEventListener("click", (e)=>{
      const menu = document.getElementById("fabMenu");
      const fab = document.getElementById("fabBtn");
      if(menu.classList.contains("open")){
        if(!menu.contains(e.target) && e.target !== fab){
          closeMenu();
        }
      }
    });

    // ✅ 기존 이미지 표시
    const existing = "<%=imageUrl%>";
    const img = document.getElementById("previewImg");
    const ph = document.getElementById("imgPh");
    const rm = document.getElementById("removeBtn");
    if(existing && existing.trim() !== ""){
      img.src = existing;
      img.style.display = "block";
      ph.style.display = "none";
      rm.classList.add("show");
    }

    // ✅ 기존 emotion 반영
    initMood(parseInt("<%=emotion%>", 10));

    // ✅ 새 이미지 선택 시 미리보기
    document.getElementById("image").addEventListener("change",(e)=>{
      const f = e.target.files && e.target.files[0];
      if(!f) return;
      document.getElementById("removeImageFlag").value = "0"; // 새 이미지 선택 -> 삭제 아님

      const url = URL.createObjectURL(f);
      img.src = url;
      img.style.display = "block";
      ph.style.display = "none";
      rm.classList.add("show");
    });
  });
</script>
</head>

<body>
  <div class="phone">
    <div class="topbar">
      <button type="button" class="icon-btn" onclick="goBack()" title="뒤로">‹</button>
      <div class="title">
        <div class="dateText" id="dateText"></div>
      </div>
      <button type="button" class="icon-btn" onclick="submitEdit()" title="저장">✓</button>
    </div>

    <div class="mood-line">
      <div class="moods">
        <div class="mood" data-val="1" onclick="setMood(1)">😫</div>
        <div class="mood" data-val="2" onclick="setMood(2)">😟</div>
        <div class="mood" data-val="3" onclick="setMood(3)">😐</div>
        <div class="mood" data-val="4" onclick="setMood(4)">🙂</div>
        <div class="mood" data-val="5" onclick="setMood(5)">😄</div>
      </div>
    </div>

    <form id="editForm" action="DiaryUpdateCon.java" method="post" enctype="multipart/form-data">
      <input type="hidden" name="date" value="<%=date%>">
      <input type="hidden" name="emotion" id="emotion" value="">
      <input type="hidden" name="removeImage" id="removeImageFlag" value="0">

      <div class="img-card">
        <img id="previewImg" alt="preview">
        <div id="imgPh" class="img-placeholder">이미지를 추가하세요</div>
        <button type="button" id="removeBtn" class="img-remove" onclick="removeImage()">✕</button>
      </div>

      <div class="content-card">
        <textarea name="content" placeholder="일기" required><%=content%></textarea>
      </div>

      <input type="file" name="image" id="image" accept="image/*">
    </form>

    <div class="mini">플러스(+)로 이미지 추가/제거 가능</div>

    <div class="fab-wrap">
      <div class="menu" id="fabMenu">
        <button type="button" class="primary" onclick="openImage()">이미지 추가</button>
        <button type="button" class="danger" onclick="removeImage()">이미지 제거</button>
      </div>
      <button type="button" class="fab" id="fabBtn" onclick="toggleMenu()">+</button>
    </div>
  </div>
</body>
</html>
