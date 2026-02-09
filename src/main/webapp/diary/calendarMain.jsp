<%@page import="diary.DiaryinfoDTO"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Calendar Main Page!</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar_n.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<%
Integer yearObj = (Integer)request.getAttribute("year");
Integer monthObj = (Integer)request.getAttribute("month");
String user_id = (String)session.getAttribute("user_id");
Vector<DiaryinfoDTO> bean = (Vector<DiaryinfoDTO>)request.getAttribute("bean");
String selectedDate = (String)request.getAttribute("selectedDate");

Calendar cal = Calendar.getInstance();
int year = (yearObj != null) ? yearObj : cal.get(Calendar.YEAR);
int month = (monthObj != null) ? monthObj : cal.get(Calendar.MONTH) + 1;

if(user_id == null){
   user_id = "test";
   session.setAttribute("user_id", user_id);
}

boolean showDiarySection = (selectedDate != null && !selectedDate.trim().isEmpty());

String displayDateLabel;
if(showDiarySection){
   String[] partsDate = selectedDate.split("-");
   displayDateLabel = Integer.parseInt(partsDate[0]) + "년 " + Integer.parseInt(partsDate[1]) + "월 " + Integer.parseInt(partsDate[2]) + "일";
}else{
   int tdTmp = cal.get(Calendar.DATE);
   displayDateLabel = year + "년 " + month + "월 " + tdTmp + "일";
}

int ty = cal.get(Calendar.YEAR);
int tm = cal.get(Calendar.MONTH) + 1;
int td = cal.get(Calendar.DATE);

cal.set(year, month - 1, 1);
int week = cal.get(Calendar.DAY_OF_WEEK);
int weekMon = (week == Calendar.SUNDAY) ? 7 : (week - 1);
int lastDay = cal.getActualMaximum(Calendar.DATE);
%>

<div class="topbar">
  <div class="topbar__inner">
    <div class="topbar__logo">P-log</div>
    <a class="topbar__profile" href="#" aria-label="프로필">
      <span class="topbar__profileIcon" aria-hidden="true"></span>
    </a>
  </div>
</div>

<div class="desktop-layout">

  <!-- 좌측 패널 -->
  <aside class="desktop-side desktop-side--left">
    <h2 class="panel-title"><%=user_id%>님의 기분 통계</h2>

    <div class="panel-card">
      <p class="panel-subtitle">이번주 기분 추이</p>
      <div class="panel-chart" aria-label="이번주 기분 추이 차트 영역"></div>
      <p class="panel-score">이번 주 기분 점수: 19/30점</p>
    </div>

    <p class="panel-hint">이 달의 기분이 쌓이고 있어요!</p>

    <div class="panel-card">
      <p class="panel-cardTitle">1월 달 기분 현황</p>
      <div class="panel-month" aria-label="월간 기분 현황 차트 영역"></div>
    </div>
  </aside>

  <!-- 중앙 (기존 앱 화면 390px 유지) -->
  <main class="desktop-center">
    <div class="container">
      <div class="wrapper <%=showDiarySection ? "shifted" : ""%>">

        <header>
          <div class="nav">
            <a href="${pageContext.request.contextPath}/diary/CalendarMain.do?&year=<%=year%>&month=<%=month-1%>" class="cal-btn">&lt;</a>
            <p class="current-date"><%=year%>. <%= (month < 10 ? "0"+month : String.valueOf(month)) %>.</p>
            <a href="${pageContext.request.contextPath}/diary/CalendarMain.do?&year=<%=year%>&month=<%=month+1%>" class="cal-btn">&gt;</a>
          </div>
        </header>

        <div class="calendar">
          <table>
            <thead>
              <tr>
                <th>Mo</th>
                <th>Tu</th>
                <th>We</th>
                <th>Th</th>
                <th>Fr</th>
                <th>Sa</th>
                <th>Su</th>
              </tr>
            </thead>
            <tbody>
              <tr class="days">
                <%
                Calendar preCal = (Calendar)cal.clone();
                preCal.add(Calendar.MONTH, -1);
                int preLastDay = preCal.getActualMaximum(Calendar.DATE);
                int preStartDay = preLastDay - (weekMon - 2);

                for(int i = 0; i < weekMon - 1; i++) {
                %>
                  <td class="inactive"><a href="javascript:void(0)"><%=preStartDay + i%></a></td>
                <%
                }

                int dayCount = weekMon - 1;
                for(int i = 1; i <= lastDay; i++) {
                  String todayClass = (year == ty && month == tm && i == td) ? " active" : "";

                  String Fmonth = month < 10 ? "0" + month : String.valueOf(month);
                  String Fday = i < 10 ? "0" + i : String.valueOf(i);
                  String Cdate = year + "-" + Fmonth + "-" + Fday;

                  diary.DiaryinfoDTO foundDto = null;
                  if(bean != null) {
                    for(diary.DiaryinfoDTO dto : bean) {
                      if(dto.getCreate_date().equals(Cdate)) {
                        foundDto = dto;
                        break;
                      }
                    }
                  }

                  if(foundDto != null) {
                %>
                    <td class="emotion_<%=foundDto.getEmotion()%><%=todayClass%>">
                      <a href="${pageContext.request.contextPath}/diary/Preview.do?selectedDate=<%=Cdate%>"><%=i%></a>
                    </td>
                <%
                  } else {
                %>
                    <td class="no_diary<%=todayClass%>">
                      <a href="${pageContext.request.contextPath}/diary/Preview.do?selectedDate=<%=Cdate%>"><%=i%></a>
                    </td>
                <%
                  }

                  dayCount++;

                  if(dayCount % 7 == 0 && i < lastDay) {
                %>
                    </tr><tr class="days">
                <%
                  }
                }

                int remainDays = 1;
                while(dayCount % 7 != 0) {
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

        <!-- 날짜/날씨: '왼쪽 정렬' 요구사항 반영 -->
        <div class="center-meta">
          <h3 class="selected-date"><%=displayDateLabel%></h3>
          <div class="weather-box">날씨 정보</div>
        </div>

      </div>
    </div>
  </main>

  <!-- 우측 패널 -->
  <aside class="desktop-side desktop-side--right">
    <!-- '소식' 왼쪽 정렬 요구사항 반영 (센터 클래스 제거) -->
    <h2 class="panel-title">소식</h2>

    <div class="news-list">
      <article class="news-card">
        <div class="news-avatar" aria-hidden="true"></div>
        <div class="news-body">
          <div class="news-name">smile1225 님</div>

          <!-- 이모지가 '내용 상자(news-text)' 안으로 들어가도록 구조 변경 -->
          <div class="news-text">
            <span class="news-message">
              혼자 산책 다녀왔다... 요즘 날씨가 춥네 내일은 해피 공원에 가야겠다. 요즘 혼자 산책을 즐기는 중...
            </span>
            <span class="news-emoji">
              <!-- 실제 프로젝트 이미지 경로로 교체 -->
              <img src="${pageContext.request.contextPath}/images/emotion_angry.png" alt="emotion">
            </span>
          </div>
        </div>
      </article>

      <article class="news-card">
        <div class="news-avatar" aria-hidden="true"></div>
        <div class="news-body">
          <div class="news-name">smile1225 님</div>
          <div class="news-text">
            <span class="news-message">
              혼자 산책 다녀왔다... 요즘 날씨가 춥네 내일은 해피 공원에 가야겠다. 요즘 혼자 산책을 즐기는 중...
            </span>
            <span class="news-emoji">
              <img src="${pageContext.request.contextPath}/images/emotion_angry.png" alt="emotion">
            </span>
          </div>
        </div>
      </article>

      <article class="news-card">
        <div class="news-avatar" aria-hidden="true"></div>
        <div class="news-body">
          <div class="news-name">smile1225 님</div>
          <div class="news-text">
            <span class="news-message">
              혼자 산책 다녀왔다... 요즘 날씨가 춥네 내일은 해피 공원에 가야겠다. 요즘 혼자 산책을 즐기는 중...
            </span>
            <span class="news-emoji">
              <img src="${pageContext.request.contextPath}/images/emotion_angry.png" alt="emotion">
            </span>
          </div>
        </div>
      </article>

      <article class="news-card">
        <div class="news-avatar" aria-hidden="true"></div>
        <div class="news-body">
          <div class="news-name">smile1225 님</div>
          <div class="news-text">
            <span class="news-message">
              혼자 산책 다녀왔다... 요즘 날씨가 춥네 내일은 해피 공원에 가야겠다. 요즘 혼자 산책을 즐기는 중...
            </span>
            <span class="news-emoji">
              <img src="${pageContext.request.contextPath}/images/emotion_angry.png" alt="emotion">
            </span>
          </div>
        </div>
      </article>
    </div>
  </aside>

</div>

</body>
</html>
