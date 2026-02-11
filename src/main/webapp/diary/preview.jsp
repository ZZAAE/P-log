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
if(userId == null){ response.sendRedirect("../user/login.jsp"); return; }
Vector<DiaryinfoDTO> bean = (Vector<DiaryinfoDTO>) request.getAttribute("bean");
int[] monthCounts = (int[]) request.getAttribute("monthCounts");

// 혹시 데이터가 없을 경우를 대비해 기본값 설정
if (monthCounts == null) {
    monthCounts = new int[]{0, 0, 0, 0, 0};
}

// 조회 날짜
//String date = request.getParameter("selectedDate");
String date = (String)request.getAttribute("selectedDate");
if(date == null || date.trim().isEmpty()){
  date = java.time.LocalDate.now().toString();
}

//Preview.do에서 전달된 값
DiaryinfoDTO preview = (DiaryinfoDTO)request.getAttribute("preview");
if(date == null || date.trim().isEmpty()){
date = java.time.LocalDate.now().toString();
}

String imagePath = (String)request.getAttribute("imagePath");
System.out.println("Preview.jsp imagePath: " + imagePath);

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

/*
  ===== 실제 데이터 바인딩 자리 =====
*/
AdviseinfoDAO aDao = new AdviseinfoDAO();
//String advice = (String)request.getAttribute("advice");
System.out.println("preview.getAdvise_id(): " + preview.getAdvise_id());
String advice = aDao.getAdviseininfo(preview.getAdvise_id());
System.out.println("advice: " + advice);
if(advice == null) advice = "내일은 더 좋은 하루를 보내길 바라요.";

//String content = (String)request.getAttribute("content");
String content = preview.getContent();
if(content == null) content = "오늘은 수민이를 만나서 떡볶이를 먹었다. 처음 가보는 떡볶이 집이었는데 만족! 다음은 그 옆에 있는 토마토라면 집에 가보기로 했다. 기대돼!! 벌써 배고픈 느낌...";

String imageUrl = (String)request.getAttribute("imagePath");
if(imageUrl == null) imageUrl = request.getContextPath() + "/images/sample_dog.jpg";

//Integer emotion = (Integer)request.getAttribute("emotion"); // 1~5
Integer emotion = preview.getEmotion();
if(emotion == null) emotion = 4;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>일기 조회</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/preview_n.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/diary.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">


<script>
  function openDeleteModal(){
    const overlay = document.getElementById("deleteOverlay");
    overlay.classList.add("is-open");
    overlay.setAttribute("aria-hidden", "false");
  }

  function closeDeleteModal(){
    const overlay = document.getElementById("deleteOverlay");
    overlay.classList.remove("is-open");
    overlay.setAttribute("aria-hidden", "true");
  }

  function confirmDelete(){
    const url = document.getElementById("deleteConfirmYes").getAttribute("data-delete-url");
    window.location.href = url;
  }

  window.addEventListener("DOMContentLoaded", function(){
    const overlay = document.getElementById("deleteOverlay");

    // overlay 바깥 클릭 시 닫기
    overlay.addEventListener("click", function(e){
      if(e.target === overlay) closeDeleteModal();
    });

    // ESC 닫기
    document.addEventListener("keydown", function(e){
      if(e.key === "Escape") closeDeleteModal();
    });
  });
</script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
          <div>Mo</div><div>Tu</div><div>We</div><div>Th</div><div>Fr</div><div>Sa</div><div>Su</div>
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

    <!-- 중앙: 조회 UI (390 고정) -->
    <main class="desktop-center">
      <div class="phone">
        <!-- 상단: 날짜 + 연필(수정) -->
        <header class="view-top">
        <button type="button" class="icon-btn back" onclick="location.href='CalendarMain.do'">‹</button>
          <div class="date-wrap">
            <div class="date-text"><%=date%></div>
            <div class="date-line"></div>
          </div>
			
          <a class="icon-btn pencil"          	
             href="<%=request.getContextPath()%>/diary/diaryupdate.jsp?selectedDate=<%=date%>"
             aria-label="수정"></a>
        </header>

		<!-- 감정(1개) + 조언 -->
        <section class="view-emotion">
          <div class="emotion-one">
            <img src="<%=request.getContextPath()%>/resources/mood/mood<%=emotion%>.png" alt="emotion">
          </div>
          <%
          DiaryinfoDTO foundDto = null;
          if(bean != null){
            for(DiaryinfoDTO dto : bean){
              if(dto.getCreate_date().equals(date)){
                foundDto = dto; break;
              }
            }
          }
          if(foundDto != null){   %>
                <div class="advice-pill emotion_<%=foundDto.getEmotion()%>"><%=advice%></div>
            <% } %>
          
        </section>
		
			 <!-- 이미지 -->
        <section class="view-photo">
	        <c:if test="${!imagePath.isEmpty()}">
	        	<img src="<%=imageUrl%>" alt="diary photo">
	        </c:if>          
        </section>

        <!-- 본문 -->
        <section class="view-content">
          <div class="content-box">
            <pre class="content-text"><%=content%></pre>
            <!-- 삭제 버튼: 이제 바로 삭제하지 않고 모달 오픈 -->
          <button type="button" class="trash-btn" onclick="openDeleteModal()" aria-label="삭제"></button>
          </div>
        </section>
		
       
      </div>
    </main>

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

  <!-- 삭제 확인 모달 (페이지 위 오버레이) -->
  <div id="deleteOverlay" class="confirm-overlay" aria-hidden="true">
    <div class="confirm-modal" role="dialog" aria-modal="true" aria-label="삭제 확인">
      <div class="confirm-head">
        <!-- 임시 SVG(빨간 휴지통) -->
        <span class="confirm-icon" aria-hidden="true">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
               xmlns="http://www.w3.org/2000/svg">
            <path d="M9 3h6l1 2h4v2H4V5h4l1-2z" fill="#FF4D4F"/>
            <path d="M7 9h2v10H7V9zm4 0h2v10h-2V9zm4 0h2v10h-2V9z" fill="#FF4D4F"/>
            <path d="M6 7h12l-1 14H7L6 7z" stroke="#FF4D4F" stroke-width="1.2" fill="none"/>
          </svg>
        </span>
        <span class="confirm-title">삭제하시겠습니까?</span>
      </div>

      <div class="confirm-actions">
        <button id="deleteConfirmYes"
                type="button"
                class="confirm-btn confirm-yes"
                data-delete-url="<%=request.getContextPath()%>/diary/DiaryDeleteCon.do?create_date=<%=date%>"
                onclick="confirmDelete()">예</button>

        <button type="button"
                class="confirm-btn confirm-no"
                onclick="closeDeleteModal()">아니요</button>
      </div>
    </div>
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
        '<%=request.getContextPath()%>/image/화남.png',
        '<%=request.getContextPath()%>/image/안좋음.png',
        '<%=request.getContextPath()%>/image/무표정.png',
        '<%=request.getContextPath()%>/image/웃음.png',
        '<%=request.getContextPath()%>/image/빵긋.png'
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
