<%@page import="java.util.Vector"%>
<%@page import="advise.AdviseinfoDAO"%>
<%@ page import="image.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="java.util.Calendar"%>
<%@ page import="diary.DiaryinfoDTO" %>
<%@ page import="java.util.List" %>
<%
request.setCharacterEncoding("UTF-8");
String userId = (String)session.getAttribute("user_id");
if(userId == null){response.sendRedirect("../user/login.jsp");return;}
Vector<DiaryinfoDTO> bean = (Vector<DiaryinfoDTO>) request.getAttribute("bean");

String date = request.getParameter("selectedDate");
if(date == null || date.trim().isEmpty()){
  date = java.time.LocalDate.now().toString();
}

// left calendar month/year = date 기준
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
%>

<%
// 캘린더 
int[] monthCounts = (int[]) request.getAttribute("monthCounts");
if (monthCounts == null) {
    monthCounts = new int[]{0,0,0,0,0};
}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>일기 작성</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet"
   href="<%=request.getContextPath()%>/css/diary.css">
<link rel="stylesheet"
   href="https://fonts.googleapis.com/css2?family=Inter:slnt,wght@-10..0,100..900&display=swap">
<link rel="stylesheet"
   href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
   

<script>
  /* 이미지 업로드 관련 JS 유지 */
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

    showImageUI(false);

    fileInput.addEventListener("change",(e)=>{
      const f = e.target.files && e.target.files[0];
      if(!f){
        previewImg.src = "";
        previewImg.style.display = "none";
        showImageUI(false);
        return;
      }
      previewImg.src = URL.createObjectURL(f);
      previewImg.style.display = "block";
      showImageUI(true);
    });
  });
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

      <!-- 좌측 패널: 캘린더 + 월간 현황(기능 페이지 기준) -->
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
               <div>Mo</div>
               <div>Tu</div>
               <div>We</div>
               <div>Th</div>
               <div>Fr</div>
               <div>Sa</div>
               <div>Su</div>
            </div>

            <div class="left-cal__grid">
               <%
          // prev month filler
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
              if(bean != null){
                for(DiaryinfoDTO dto : bean){
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

          // next month filler
          int remain = 1;
          while(dayCount % 7 != 0){
          %>
               <div class="d inactive"><%=remain++%></div>
               <%
            dayCount++;
          }
          %>
            </div>
         </div>

         <div class="panel-cardA">
            <p class="panel-cardTitle"><%=month%>월 달 기분 리포트
            </p>

            <!-- ✅ calendar.css의 monthChart 레이아웃 규칙이 먹게끔 클래스 추가 -->
            <div class="panel-month month-chart-wrap">
               <canvas id="monthChart"></canvas>
            </div>
         </div>
      </aside>

      <!-- 중앙: 작성 UI (390 고정) -->
      <main class="desktop-center">
         <div class="phone">
            <!-- 작성 상단바 -->
            <header class="write-top">

               <div class="date-wrap">
                  <div class="date-text"><%=date%></div>
                  <div class="date-line"></div>
               </div>

               <div class="actions">
                  <button type="button" class="icon-btn circle"
                     onclick="openImage()">
                     <i class="bi bi-plus"></i>
                  </button>
                  <button type="button" class="icon-btn circle"
                     onclick="submitWrite()">
                     <i class="bi bi-check2"></i>
                  </button>
               </div>
            </header>

            <!-- 폼 -->
            <form id="writeForm"
               action="<%=request.getContextPath()%>/diary/DiaryWriteCon.do"
               method="post" enctype="multipart/form-data">

               <input type="hidden" name="create_date" value="<%=date%>">

               <!-- 표정 선택 -->
               <section class="emoji-row emoji-pick">
                  <input type="checkbox" id="emo1" name="emotion" value="1"
                     class="emo" hidden> <label for="emo1" class="emoji-btn">
                     <img src="<%=request.getContextPath()%>/image/화남.png"
                     alt="아주 나쁨">
                  </label> <input type="checkbox" id="emo2" name="emotion" value="2"
                     class="emo" hidden> <label for="emo2" class="emoji-btn">
                     <img src="<%=request.getContextPath()%>/image/안좋음.png"
                     alt="나쁨">
                  </label> <input type="checkbox" id="emo3" name="emotion" value="3"
                     class="emo" hidden> <label for="emo3" class="emoji-btn">
                     <img src="<%=request.getContextPath()%>/image/무표정.png"
                     alt="보통">
                  </label> <input type="checkbox" id="emo4" name="emotion" value="4"
                     class="emo" hidden> <label for="emo4" class="emoji-btn">
                     <img src="<%=request.getContextPath()%>/image/웃음.png"
                     alt="좋음">
                  </label> <input type="checkbox" id="emo5" name="emotion" value="5"
                     class="emo" hidden> <label for="emo5" class="emoji-btn">
                     <img src="<%=request.getContextPath()%>/image/빵긋.png"
                     alt="아주 좋음">
                  </label>
               </section>

               <input type="file" name="file" id="file" accept="image/*"
                  style="display: none;">


               <div class="phone ${empty imgSrc ? 'no-photo' : 'has-photo'}">
                  <!-- 이미지 -->
                  <div class="photo-area imgBox">
                     <img id="previewImg" class="photo" style="display: none;">
                  </div>

                  <!-- 내용 -->

                  <section class="content-area">
                     <div class="content-box1">
                        <textarea name="content" class="diary-input"
                           placeholder="오늘 하루를 기록해보세요." required></textarea>
                     </div>
               </div>
               </section>
            </form>
         </div>
      </main>

      <!-- 우측 패널: 메인과 동일(소식) -->
      <!-- 우측 패널: 소식 -->
   <aside class="desktop-side desktop-side--right">
     <h2 class="panel-title">소식</h2>
   
     <div class="news-list">
   
       <!-- 소식이 없을 때 -->
       <c:if test="${empty otherUserBeans}">
         <div class="news-empty">
           표시할 소식이 없습니다.
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
  // 1) 서버에서 받은 데이터
  const monthData = [
    <%= monthCounts[0] %>, <%= monthCounts[1] %>, <%= monthCounts[2] %>, <%= monthCounts[3] %>, <%= monthCounts[4] %>
  ];

  // 2) 하단 이미지를 그리기 위한 커스텀 플러그인
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

  // 3) 이미지 로드
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

  Promise.all(moodImgs.map(img => new Promise(resolve => {
    if (img.complete) resolve();
    else img.onload = resolve;
  }))).then(() => {
    const canvas = document.getElementById('monthChart');
    if(!canvas) return;

    const ctx = canvas.getContext('2d');
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: ['', '', '', '', ''], // 이미지 자리 비움
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
        layout: { padding: { bottom: 30 } },
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
            ticks: { display: false }
          }
        }
      },
      plugins: [xEmojiLabelsPlugin]
    });
  });
});
</script>
</body>
</html>
