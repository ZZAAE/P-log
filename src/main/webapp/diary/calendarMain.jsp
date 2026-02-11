<%@page import="java.util.Map"%>
<%@page import="diary.DiaryinfoDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Calendar Main Page!</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">


</head>

<body>
<%
String user_id = (String) session.getAttribute("user_id");
if (user_id == null || user_id.trim().isEmpty()) {
  response.sendRedirect(request.getContextPath() + "/user/login.jsp");
  return;
}

Integer yearObj = (Integer) request.getAttribute("year");
Integer monthObj = (Integer) request.getAttribute("month");
Vector<DiaryinfoDTO> bean = (Vector<DiaryinfoDTO>) request.getAttribute("bean");
String selectedDate = (String) request.getAttribute("selectedDate");
Map weather = (Map) request.getAttribute("weather");

Calendar cal = Calendar.getInstance();
int year = (yearObj != null) ? yearObj.intValue() : cal.get(Calendar.YEAR);
int month = (monthObj != null) ? monthObj.intValue() : cal.get(Calendar.MONTH) + 1;

boolean showDiarySection = (selectedDate != null && !selectedDate.trim().isEmpty());

int ty = cal.get(Calendar.YEAR);
int tm = cal.get(Calendar.MONTH) + 1;
int td = cal.get(Calendar.DATE);

String displayDate = (selectedDate != null && !selectedDate.trim().isEmpty())
    ? selectedDate
    : (ty + "-" + (tm < 10 ? "0" + tm : String.valueOf(tm)) + "-" + (td < 10 ? "0" + td : String.valueOf(td)));

String[] displayParts = displayDate.split("-");
int displayYear = Integer.parseInt(displayParts[0]);
int displayMonth = Integer.parseInt(displayParts[1]);
int displayDay = Integer.parseInt(displayParts[2]);

Calendar displayCal = Calendar.getInstance();
displayCal.set(displayYear, displayMonth - 1, displayDay);
int displayWeek = displayCal.get(Calendar.DAY_OF_WEEK);

String[] dayWeek = {"", "일", "월", "화", "수", "목", "금", "토"};
String displayDateLabel = displayYear + "년 " + displayMonth + "월 " + displayDay + "일 (" + dayWeek[displayWeek] + ")";

cal.set(year, month - 1, 1);
int week = cal.get(Calendar.DAY_OF_WEEK);
int weekMon = (week == Calendar.SUNDAY) ? 7 : (week - 1);
int lastDay = cal.getActualMaximum(Calendar.DATE);

String wTemp = "정보 없음";
String wDesc = "정보 없음";
String wYesterday = "";
String wImgFile = "cloud.png";

if (weather != null) {
  Object t = weather.get("temp");
  Object d = weather.get("desc");
  Object y = weather.get("yesterday");
  Object img = weather.get("descImg");

  if (t != null) wTemp = t.toString();
  if (d != null) wDesc = d.toString();
  if (y != null) wYesterday = y.toString();
  if (img != null) wImgFile = img.toString();   // 예: "sunny.png"
}

String weatherImgSrc = request.getContextPath() + "/image/" + wImgFile;

/* 날씨 문장 너무 길면 짧게 */
String wShort = wDesc;
if (wShort != null) {
  wShort = wShort.trim();
  if (wShort.length() > 12) wShort = wShort.substring(0, 12);
}
String yShort = wYesterday;
if (yShort != null) {
  yShort = yShort.trim();
  if (yShort.length() > 22) yShort = yShort.substring(0, 22) + "...";
}
%>

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
</div>

<div class="desktop-layout">

  <aside class="desktop-side desktop-side--left">
    <h2 class="panel-title"><%=user_id%>님의 기분 통계</h2>

    <div class="panel-cardA">
      <p class="panel-subtitle">이번주 기분 추이</p>
      <div class="panel-chart">
        <canvas id="weekChart"></canvas>
      </div>
      <p class="panel-score">
        기분 점수: <%= (request.getAttribute("weekScore")==null?0:request.getAttribute("weekScore")) %>/35점
      </p>
    </div>

    <div class="panel-cardA">
      <p class="panel-cardTitle"><%=month%>월 달 기분 리포트</p>

      <!-- ✅ calendar.css의 monthChart 레이아웃 규칙이 먹게끔 클래스 추가 -->
      <div class="panel-month month-chart-wrap">
        <canvas id="monthChart"></canvas>
      </div>
    </div>
  </aside>

  <main class="desktop-center">
    <div class="container">
      <div class="wrapper <%=showDiarySection ? "shifted" : ""%>">

        <header>
          <div class="nav">
            <a href="${pageContext.request.contextPath}/diary/CalendarMain.do?year=<%=year%>&month=<%=month-1%>" class="cal-btn">&lt;</a>
            <p class="current-date"><%=year%>. <%= (month < 10 ? "0"+month : String.valueOf(month)) %>.</p>
            <a href="${pageContext.request.contextPath}/diary/CalendarMain.do?year=<%=year%>&month=<%=month+1%>" class="cal-btn">&gt;</a>
          </div>
        </header>

        <div class="calendar">
          <table>
            <thead>
              <tr>
                <th>Mo</th><th>Tu</th><th>We</th><th>Th</th><th>Fr</th><th>Sa</th><th>Su</th>
              </tr>
            </thead>
            <tbody>
              <tr class="days">
                <%
                Calendar preCal = (Calendar)cal.clone();
                preCal.add(Calendar.MONTH, -1);
                int preLastDay = preCal.getActualMaximum(Calendar.DATE);
                int preStartDay = preLastDay - (weekMon - 2);

                for(int i=0; i<weekMon-1; i++){
                %>
                  <td class="inactive"><a href="javascript:void(0)"><%=preStartDay+i%></a></td>
                <%
                }

                int dayCount = weekMon - 1;
                for(int i=1; i<=lastDay; i++){
                  String todayClass = (year==ty && month==tm && i==td) ? " active" : "";
                  String Fmonth = month < 10 ? "0"+month : String.valueOf(month);
                  String Fday = i < 10 ? "0"+i : String.valueOf(i);
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
                    <td class="emotion_<%=foundDto.getEmotion()%><%=todayClass%>">
                      <a href="${pageContext.request.contextPath}/diary/Preview.do?selectedDate=<%=Cdate%>&year=<%=year%>&month=<%=month%>"><%=i%></a>
                    </td>
                <%
                  } else {
                %>
                    <td class="no_diary<%=todayClass%>">
                      <a href="${pageContext.request.contextPath}/diary/Preview.do?selectedDate=<%=Cdate%>&year=<%=year%>&month=<%=month%>"><%=i%></a>
                    </td>
                <%
                  }

                  dayCount++;
                  if(dayCount % 7 == 0 && i < lastDay){
                %>
                    </tr><tr class="days">
                <%
                  }
                }

                int remainDays = 1;
                while(dayCount % 7 != 0){
                %>
                  <td class="inactive"><a href="javascript:void(0)"><%=remainDays%></a></td>
                <%
                  remainDays++;
                  dayCount++;
                }
                %>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="center-meta">
          <h3 class="selected-date"><%=displayDateLabel%></h3>

          <div class="weather-box">
            <% if(!"정보 없음".equals(wTemp)){ %>
              <div class="today-weather">
                <div class="weather-image-container">
                  <img class="weather-image" src="<%=weatherImgSrc%>" alt="weather">
                  <p class="big-temp"><%=wTemp%></p>
                </div>
                <div class="weather-content">
                  <div class="weather-desc"><%=wShort%></div>
                  <div class="yesterday-text"><%=yShort%></div>
                </div>
              </div>
            <% } else { %>
              <div class="weather-content">날씨 정보를 불러오는데 실패했어요.</div>
            <% } %>
          </div>
        </div>

      </div>
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

<c:if test="${msg eq 'success'}">
  <script>alert("수정 완료했습니다.");</script>
</c:if>
<c:if test="${msg eq 'fail'}">
  <script>alert("입력하신 정보가 틀렸습니다.");</script>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
  if (typeof Chart === 'undefined') {
    console.error('Chart.js가 로드되지 않았습니다.');
    return;
  }

  const weekLabels = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

  const weekEmotions = (function(){
    <% int[] we = (int[]) request.getAttribute("weekEmotions");
       if (we == null) { we = new int[]{0,0,0,0,0,0,0}; }
    %>
    return [<%=we[0]%>,<%=we[1]%>,<%=we[2]%>,<%=we[3]%>,<%=we[4]%>,<%=we[5]%>,<%=we[6]%>];
  })();

  const monthCounts = (function(){
    <% int[] mc = (int[]) request.getAttribute("monthCounts");
       if (mc == null) { mc = new int[]{0,0,0,0,0}; }
    %>
    return [<%=mc[0]%>,<%=mc[1]%>,<%=mc[2]%>,<%=mc[3]%>,<%=mc[4]%>];
  })();

  const weekCanvas = document.getElementById('weekChart');
  const monthCanvas = document.getElementById('monthChart');

  if (!weekCanvas || !monthCanvas) {
    console.error('canvas id가 없습니다. weekChart/monthChart 확인');
    return;
  }

  // ✅ 감정 컬러(파스텔)
  const EMO_COLORS  = ['#FF9AA2', '#D3D3D3', '#B5EAD7', '#A0D8FF', '#FFE066'];
  const EMO_BORDERS = ['#FF5C5C', '#9E9E9E', '#4CAF50', '#2196F3', '#FBC02D'];

  // ============================
  // [주간 차트] (선 그래프)
  // ============================
  new Chart(weekCanvas, {
    type: 'line',
    data: {
      labels: weekLabels,
      datasets: [{
        label: 'Emotion (1~5)',
        data: weekEmotions,
        tension: 0,

        borderColor: '#FF0000',
        backgroundColor: 'rgba(160, 216, 255, 0.25)',
        fill: false,

        pointBackgroundColor: '#FF0000',
        pointBorderColor: '#FF0000',
        
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        x: { grid: { display: false } },
        y: { min: 0, max: 5, ticks: { stepSize: 1 }, grid: { display: false } }
      }
    }
  });

  // ============================
  // [월간 차트] (막대 그래프)
  // - x축 아래에 감정 이미지(Chart.js plugin)
  // ============================
  const xEmojiLabelsPlugin = {
    id: 'xEmojiLabelsPlugin',
    afterDraw(chart) {
      const opts = chart?.options?.plugins?.xEmojiLabelsPlugin;
      if (!opts || !opts.images || opts.images.length === 0) return;

      const ctx = chart.ctx;
      const xAxis = chart.scales.x;
      if (!xAxis) return;

      const size = opts.size || 22;
      const yOffset = opts.yOffset || 14;

      ctx.save();
      for (let i = 0; i < xAxis.ticks.length; i++) {
        const img = opts.images[i];
        if (!img || !img.complete) continue;

        const x = xAxis.getPixelForTick(i);
        const y = xAxis.bottom + yOffset;
        ctx.drawImage(img, x - size/2, y - size/2, size, size);
      }
      ctx.restore();
    }
  };

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

  Promise.all(moodImgs.map(img => new Promise(res => {
    if (img.complete) return res();
    img.onload = () => res();
    img.onerror = () => res();
  }))).then(() => {
    new Chart(monthCanvas, {
      type: 'bar',
      data: {
        labels: ['','','','',''],
        datasets: [{
          label: 'Count',
          data: monthCounts,
          backgroundColor: EMO_COLORS,
          borderColor: EMO_BORDERS,
          borderWidth: 1,
          borderRadius: 8,
          borderSkipped: false,
          barPercentage: 0.6,
          categoryPercentage: 0.7
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        layout: { padding: { bottom: 28 } },
        plugins: {
          legend: { display: false },
          xEmojiLabelsPlugin: { images: moodImgs, size: 22, yOffset: 14 }
        },
        scales: {
          x: { ticks: { display: false }, grid: { display: false } },
          y: { beginAtZero: true, grid: { display: false }, ticks: { display: false } }
        }
      },
      plugins: [xEmojiLabelsPlugin]
    });
  });

});
</script>

</body>
</html>
