<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="diary.DiaryDAO, diary.DiaryinfoDTO"%>
<%@page import="diary.CalendarDAO"%>
<%@ page import="image.ImageDAO"%>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
request.setCharacterEncoding("UTF-8");

String sessionUserId = (String)session.getAttribute("user_id");
if(sessionUserId == null){
  response.sendRedirect("../user/login.jsp");
  return;
}

String date = request.getParameter("selectedDate");
if(date == null || date.trim().isEmpty()){
  date = java.time.LocalDate.now().toString();
}

// ✅ 기존 데이터 불러오기
String contentVal = "";
int emotionVal = 0;
String imagePathVal = "";

try{
  DiaryDAO dDao = new DiaryDAO();
  int diaryId = dDao.getDiaryID(sessionUserId, date);
  DiaryinfoDTO dto = (diaryId > 0) ? dDao.getDiaryInfo(diaryId) : null;

  if(dto != null){
    if(dto.getContent() != null) contentVal = dto.getContent();
    if(dto.getEmotion() > 0) emotionVal = dto.getEmotion();

    String imageId = dto.getImage_id();
    if(imageId != null && !imageId.trim().isEmpty()){
      ImageDAO iDao = new ImageDAO();
      String p = iDao.getImageinfoPath(imageId); // "/resources/img/xxx" 형태 권장
      if(p != null) imagePathVal = p;
    }
  }
}catch(Exception e){
  // 화면 유지
}

// ✅ left calendar month/year = date 기준
int year = Integer.parseInt(date.substring(0,4));
int month = Integer.parseInt(date.substring(5,7));

Calendar cal = Calendar.getInstance();
cal.set(year, month - 1, 1);
int week = cal.get(Calendar.DAY_OF_WEEK);
int weekMon = (week == Calendar.SUNDAY) ? 7 : (week - 1); // Mon=1 ... Sun=7
int lastDay = cal.getActualMaximum(Calendar.DATE);

// 오늘
Calendar today = Calendar.getInstance();
int ty = today.get(Calendar.YEAR);
int tm = today.get(Calendar.MONTH) + 1;
int td = today.get(Calendar.DATE);

//월간차트 
DiaryDAO ddao = new DiaryDAO();
CalendarDAO cdao = new CalendarDAO();
int[] monthCounts = ddao.getMonthlyEmotionSummary(sessionUserId, year, month);
Vector<DiaryinfoDTO> Cbean = cdao.select_Diary_inDate(sessionUserId);


//혹시 데이터가 없을 경우를 대비해 기본값 설정
if (monthCounts == null) {
monthCounts = new int[]{0, 0, 0, 0, 0};
}

List<DiaryinfoDTO> otherUserBeans = ddao.getOtherUserDiaryInfoList(sessionUserId);
pageContext.setAttribute("otherUserBeans", otherUserBeans);

boolean hasOldImg;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>일기 수정</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/diary.css">
<link rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=Inter:slnt,wght@-10..0,100..900&display=swap">
  <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
  
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
/* ✅ P-log 링크 스타일 유지 */
.topbar__logo{
  color:#fff;
  font-weight:700;
  text-decoration:none;
}

/* ✅ 이모티콘 클릭/불투명 */
.emoji-pick{ display:flex; justify-content:center; gap:18px; }
.emoji-btn{ cursor:pointer; opacity:1; transition:.2s; user-select:none; }
.emoji-btn img{ width:32px; height:32px; display:block; pointer-events:none; }
.emoji-btn.dim{ opacity:.25; }
.emoji-btn.active{ opacity:1; transform:scale(1.10); }
</style>

<script>
function openImage(){
  showImageUI(true);
  document.getElementById("file").click();
}

function showImageUI(on){
  const imgBox = document.querySelector(".imgBox");
  const textarea = document.querySelector("textarea[name='content']");
  if(on){
    imgBox.classList.add("show");
    textarea.classList.add("hasImage");
    document.getElementById('isImageDelete').value = 'false';
	document.querySelector('.delete-btn').style.display = 'block';
  }else{
    imgBox.classList.remove("show");
    textarea.classList.remove("hasImage");
  }
}

function deleteImage() {
	  const previewImg = document.getElementById('previewImg');
	  previewImg.style.display = 'none';
	  document.getElementById('isImageDelete').value = 'true';
	  document.querySelector('.delete-btn').style.display = 'none';
}

function submitUpdate(){
  const txt = document.querySelector("textarea[name='content']").value.trim();
  const emo = document.getElementById("emotion").value;

  if(!txt){ alert("내용을 입력하세요."); return; }
  if(!emo){ alert("기분(이모티콘)을 선택하세요."); return; }

  document.getElementById("updateForm").submit();
}

window.addEventListener("DOMContentLoaded", ()=>{
  // ✅ 이미지 미리보기
  const fileInput = document.getElementById("file");
  const previewImg = document.getElementById("previewImg");

  const hasOld = previewImg && previewImg.getAttribute("data-old") === "1";
  if(hasOld){
    showImageUI(true);
    previewImg.style.display = "block";
  }else{
    showImageUI(false);
  }

  fileInput.addEventListener("change",(e)=>{
    const f = e.target.files && e.target.files[0];
    if(!f){
      return; // 선택 취소 → 기존 유지
    }
    previewImg.src = URL.createObjectURL(f);
    previewImg.style.display = "block";
    showImageUI(true);
  });

  // ✅ 이모티콘 단일 선택 + 토글(선택된 거 다시 누르면 전체 선명)
  const emotionInput = document.getElementById("emotion");
  const buttons = Array.from(document.querySelectorAll(".emoji-btn"));
  let selected = emotionInput.value ? emotionInput.value : null;

  function render(){
    if(!selected){
      buttons.forEach(b => b.classList.remove("dim","active"));
      emotionInput.value = "";
      return;
    }
    buttons.forEach(b => { b.classList.add("dim"); b.classList.remove("active"); });
    const active = document.querySelector('.emoji-btn[data-val="'+selected+'"]');
    if(active){
      active.classList.remove("dim");
      active.classList.add("active");
    }
    emotionInput.value = selected;
  }

  buttons.forEach(btn=>{
    btn.addEventListener("click", ()=>{
      const val = btn.dataset.val;
      if(selected === val) selected = null;
      else selected = val;
      render();
    });
  });

  render();
});

//✅ 토글 상태에 따라 hint 문구 업데이트
function updateHint(isPublic){
  const hint = document.getElementById("publicHint");
  if(!hint) return;

 
}

// ✅ 공개/비공개 토글 confirm + hidden 값 변경
function confirmPublicToggle(toggle){
  const toPublic = toggle.checked; // true=공개
  const msg = toPublic ? "작성할 일기 공개" : "작성할 일기를 비공개";

  if(!confirm(msg)){
    toggle.checked = !toPublic; // 취소하면 원복
    return;
  }

  const hidden = document.getElementById("is_public");
  if(hidden) hidden.value = toPublic ? "1" : "0";

  const label = document.getElementById("publicText");
  if(label) label.innerText = toPublic ? "일기공개" : "일기비공개";

  // ✅ 흐린 문구 변경
  updateHint(toPublic);
}
</script>
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

  <div class="desktop-layout">
    <!-- 좌측 패널(공통) -->
    <aside class="desktop-side desktop-side--left">
      <div class="left-cal">
        <div class="left-cal__nav">
               <a class="left-cal__btn"
                  href="<%=request.getContextPath()%>/diary/diarywrite.jsp?selectedDate=<%= (month==1 ? (year-1)+"-12-01" : year+"-"+String.format("%02d", (month-1))+"-01") %>">‹</a>
               <div class="left-cal__title"><%=year%>.
                  <%=String.format("%02d", month)%>.
               </div>
               <a class="left-cal__btn"
                  href="<%=request.getContextPath()%>/diary/diarywrite.jsp?selectedDate=<%= (month==12 ? (year+1)+"-01-01" : year+"-"+String.format("%02d", (month+1))+"-01") %>">›</a>
            </div>

        <div class="left-cal__dow">
          <div>월</div><div>화</div><div>수</div><div>목</div><div>금</div><div>토</div><div>일</div>
        </div>

        <div class="left-cal__grid">
          <%
          Calendar preCal = (Calendar)cal.clone();
          preCal.add(Calendar.MONTH, -1);
          int preLastDay = preCal.getActualMaximum(Calendar.DATE);
          int preStartDay = preLastDay - (weekMon - 2);

          for(int i=0;i<weekMon-1;i++){
          %>
            <div class="d inactive"><%=preStartDay+i%></div>
          <%
          }

          int dayCount = weekMon - 1;
          for(int d=1; d<=lastDay; d++){
            String todayClass = (year==ty && month==tm && d==td) ? " today" : "";
            String Fmonth = month < 10 ? "0"+month : String.valueOf(month);
            String Fday = d < 10 ? "0"+d : String.valueOf(d);
            String Cdate = year + "-" + Fmonth + "-" + Fday;
            
            DiaryinfoDTO foundDto = null;
            if(Cbean != null){
              for(DiaryinfoDTO dto : Cbean){
                if(dto.getCreate_date().equals(Cdate)){
                  foundDto = dto; break;
                }
              }
            }
            if(foundDto != null){
            %>
                <a class="d emotion_<%=foundDto.getEmotion()%><%=todayClass%>"
                   href="${pageContext.request.contextPath}/diary/Preview.do?selectedDate=<%=Cdate%>&year=<%=year%>&month=<%=month%>">
                   <%=d%>
                </a>
            <%
            } else {
            %>
                <a class="d no_diary<%=todayClass%>"
                   href="${pageContext.request.contextPath}/diary/Preview.do?selectedDate=<%=Cdate%>&year=<%=year%>&month=<%=month%>">
                   <%=d%>
                </a>
            <%
            }
            dayCount++;
          }

          int remain=1;
          while(dayCount % 7 != 0){
          %>
            <div class="d inactive"><%=remain++%></div>
          <%
            dayCount++;
          }
          %>
        </div>
      </div>

      <div class="panel-card panel-card--month">
        <p class="panel-cardTitle"><%=month %>월 달 기분 리포트</p>
        <div class="chart-container">
          <canvas id="monthChart"></canvas>
      </div>
      </div>
    </aside>

    <!-- 중앙 수정 -->
    <main class="desktop-center">
      <div class="phone">

        <header class="write-top">

          <div class="date-wrap">
            <div class="date-text"><%=date%></div>
            <div class="date-line"></div>
          </div>

          <div class="actions">
                  <button type="button" class="icon-btn circle1"
                     onclick="openImage()">
                    <i class="bi bi-card-image"></i>
                  </button>
                  <button type="button" class="icon-btn circle2"
                     onclick="submitUpdate()">
                     <i class="bi bi-check-lg"></i>
                  </button>
               </div>
        </header>

        <form id="updateForm"
              action="<%=request.getContextPath()%>/diary/DiaryUpdateCon.do?selectedDate=<%=date %>"
              method="post"
              enctype="multipart/form-data">

          <input type="hidden" name="create_date" value="<%=date%>">
          <input type="hidden" name="emotion" id="emotion" value="<%=emotionVal%>">
          <input type="hidden" name="isImageDelete" id="isImageDelete" value="false">

          <section class="emoji-row emoji-pick" style="margin-bottom: 50px">
            <div class="emoji-btn" data-val="1"><img src="<%=request.getContextPath()%>/resources/mood/mood1.png"></div>
            <div class="emoji-btn" data-val="2"><img src="<%=request.getContextPath()%>/resources/mood/mood2.png"></div>
            <div class="emoji-btn" data-val="3"><img src="<%=request.getContextPath()%>/resources/mood/mood3.png"></div>
            <div class="emoji-btn" data-val="4"><img src="<%=request.getContextPath()%>/resources/mood/mood4.png"></div>
            <div class="emoji-btn" data-val="5"><img src="<%=request.getContextPath()%>/resources/mood/mood5.png"></div>
          </section>

          <input type="file" name="file" id="file" accept="image/*" style="display:none;">

          <div class="photo-area imgBox">
            <%
              hasOldImg = (imagePathVal != null && !imagePathVal.trim().isEmpty());
              String showPath = imagePathVal;
              if(hasOldImg){
                if(showPath.startsWith("/")) showPath = request.getContextPath() + showPath;
                else if(!showPath.startsWith("http")) showPath = request.getContextPath() + "/" + showPath;
              }
            %>
			<button type="button" class="icon-btn circle2 delete-btn" onclick="deleteImage()">
            	<i class="bi bi-x"></i>
            </button>
            <% if(hasOldImg){ %>
              <img id="previewImg" class="photo" src="<%=imagePathVal%>" data-old="1" style="display:block;">
            <% } else { %>
              <img id="previewImg" class="photo" style="display:none;">
            <% } %>
          </div>

          <section class="content-area">
            <div class="content-box">
              <textarea name="content" class="diary-input" required><%=contentVal%></textarea>
            </div>
          </section>

        </form>
      </div>
    </main>

  <!-- 우측 패널: 소식 -->
      <aside class="desktop-side desktop-side--right">
         <!-- ✅ 일기공개 토글이 공유 스토리 위로 올라감 -->
         <div class="news-toolbar">
            <span class="news-toolbar__label" id="publicText">일기공개</span> <input
               type="checkbox" id="publicToggle" name="is_share" class="toggle" checked
               form="updateForm" onchange="confirmPublicToggle(this)"> <label
               for="publicToggle" class="toggle-ui"></label>
         </div>
         <h2 class="panel-title">❤️ 공유 스토리 ❤️</h2>



         <!-- (선택) 흐린 안내문구 자리: 네가 updateHint 쓰려면 이 span이 있어야 함 -->
         <div class="news-hint" id="publicHint"></div>


         <div class="news-list">
       <!-- 소식이 없을 때 -->
       <c:if test="${empty otherUserBeans}">
         <div class="news-empty">
           공유스토리가 없습니다.
         </div>
       </c:if>
   
       <!-- 소식이 있을 때 -->
       <c:if test="${not empty otherUserBeans}">
         <c:forEach var="bean" items="${otherUserBeans}">
           <c:choose>
             <c:when test="${bean.getEmotion() == 1}">
               <c:set var="path" value="/image/화남.png"/>
             </c:when>
             <c:when test="${bean.getEmotion() == 2}">
               <c:set var="path" value="/image/안좋음.png"/>
             </c:when>
             <c:when test="${bean.getEmotion() == 3}">
               <c:set var="path" value="/image/무표정.png"/>
             </c:when>
             <c:when test="${bean.getEmotion() == 4}">
               <c:set var="path" value="/image/웃음.png"/>
             </c:when>
             <c:otherwise>
               <c:set var="path" value="/image/빵긋.png"/>
             </c:otherwise>
           </c:choose>
   
           <article class="news-card">
             <div class="news-avatar" aria-hidden="true">
             <i class="bi bi-person-fill"></i>
             </div>
             <div class="news-body">
               <div class="news-name">${bean.getUser_id()} 님</div>
               <div class="news-text">
                 <span class="news-message">${bean.getContent()}</span>
                 <span class="news-emoji">
                   <img src="${pageContext.request.contextPath}${path}" alt="emotion">
                 </span>
               </div>
             </div>
           </article>
         </c:forEach>
       </c:if>
   
     </div>
   </aside>

  </div>
  <script>
document.addEventListener('DOMContentLoaded', function() {
    // 1. 데이터 준비
    const monthData = [
        <%= monthCounts[0] %>, <%= monthCounts[1] %>, <%= monthCounts[2] %>, <%= monthCounts[3] %>, <%= monthCounts[4] %>
    ];
    
    // 2. 하단 이미지를 그리기 위한 커스텀 플러그인 정의
    const xEmojiLabelsPlugin = {
        id: 'xEmojiLabelsPlugin',
        afterDraw(chart) {
            const opts = chart.options.plugins.xEmojiLabelsPlugin;
            if (!opts || !opts.images) return;

            const ctx = chart.ctx;
            const xAxis = chart.scales.x;
            const size = opts.size || 22;
            const yOffset = opts.yOffset || 14;

            ctx.save();
            xAxis.ticks.forEach((tick, i) => {
                const img = opts.images[i];
                if (img && img.complete) {
                    const x = xAxis.getPixelForTick(i);
                    const y = xAxis.bottom + yOffset;
                    ctx.drawImage(img, x - size/2, y - size/2, size, size);
                }
            });
            ctx.restore();
        }
    };

    // 3. 이미지 객체 생성 및 로드
     const moodSrcs = [
    '<%=request.getContextPath()%>/resources/mood/mood1.png',
    '<%=request.getContextPath()%>/resources/mood/mood2.png',
    '<%=request.getContextPath()%>/resources/mood/mood3.png',
    '<%=request.getContextPath()%>/resources/mood/mood4.png',
    '<%=request.getContextPath()%>/resources/mood/mood5.png'
  ];
    
    const moodImgs = moodSrcs.map(src => {
        const img = new Image();
        img.src = src;
        return img;
    });

    // 4. 모든 이미지가 로드된 후 차트 생성 (비동기 처리)
    Promise.all(moodImgs.map(img => {
        return new Promise(resolve => {
            if (img.complete) resolve();
            else img.onload = resolve;
        });
    })).then(() => {
        const canvas = document.getElementById('monthChart');
        if(!canvas) return;
        
        const ctx = canvas.getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['', '', '', '', ''], // 이미지 자리를 위해 비움
                datasets: [{
                    label: '이번 달 기분 통계',
                    data: monthData,
                    backgroundColor: ['#FF9AA2', '#D3D3D3', '#B5EAD7', '#A0D8FF', '#FFE066'],
                    borderColor: ['#FF5C5C', '#9E9E9E', '#4CAF50', '#2196F3', '#FBC02D'],
                    borderWidth: 1,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                layout: {
                    padding: { bottom: 30 } // 이미지 공간 확보
                },
                plugins: {
                    legend: { display: false },
                    xEmojiLabelsPlugin: { 
                        images: moodImgs, 
                        size: 24, 
                        yOffset: 18 
                    }
                },
                scales: {
                    x: { grid: { display: false } },
                    y: { 
                        beginAtZero: true, 
                        grid: { display: false },
                        ticks: { display: false } // 수치 숨김
                    }
                }
            },
            plugins: [xEmojiLabelsPlugin] // ✅ 플러그인 등록 확인
        });
    });
});
</script>
</body>
</html>
