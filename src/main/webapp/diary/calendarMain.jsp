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
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/calenderMain_css.css">
</head>
<body>
<%
// Calendarmain.do에서 받아온 값
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
	session.setAttribute("user_id", user_id); // 임시 코드
}

boolean showDiarySection = (selectedDate != null && !selectedDate.trim().isEmpty());

int ty = cal.get(Calendar.YEAR); // 오늘 연도
int tm = cal.get(Calendar.MONTH) + 1; // 오늘 월
int td = cal.get(Calendar.DATE); // 오늘 일

cal.set(year, month - 1, 1); // 서블릿에서 받은 연/월의 1일로 설정
int week = cal.get(Calendar.DAY_OF_WEEK); 
int lastDay = cal.getActualMaximum(Calendar.DATE);
%>

<div class="container">
    <!-- 오른쪽 캘린더 영역 -->
    <div class="wrapper <%=showDiarySection ? "shifted" : ""%>">
    <header>
        <div class="nav">
		  <a href="${pageContext.request.contextPath}/CalendarMain.do?&year=<%=year%>&month=<%=month-1%>" class="cal-btn">&lt;</a>
		  <p class="current-date"><%=year%>년 <%=month%>월</p>
		  <a href="${pageContext.request.contextPath}/CalendarMain.do?&year=<%=year%>&month=<%=month+1%>" class="cal-btn">&gt;</a>
		</div>
      </header>
      <div class="calendar">
      <table>
      <thead>
        <tr>
            <th>일</th>
            <th>월</th>
            <th>화</th>
            <th>수</th>
            <th>목</th>
            <th>금</th>
            <th>토</th>
        </tr>
    </thead>
    <tbody>
    	<tr class="days">
          <%
          // 이전 달의 날짜 계산
          Calendar preCal = (Calendar)cal.clone();
          preCal.add(Calendar.MONTH, -1);
          int preLastDay = preCal.getActualMaximum(Calendar.DATE);
          int preStartDay = preLastDay - (week - 2);
          
          // 이전 달의 날짜들 출력
          for(int i = 0; i < week - 1; i++) {
              %>
              <td class="inactive"><%=preStartDay + i%></td>
              <%
          }
          
          // 현재 월의 날짜 출력
          int dayCount = week - 1;
      	  for(int i = 1; i <= lastDay; i++) {
          String todayClass = (year == ty && month == tm && i == td) ? " active" : "";
          
          String Fmonth = month < 10 ? "0" + month : String.valueOf(month);
          String Fday = i < 10 ? "0" + i : String.valueOf(i);
          String Cdate = year + "-" + Fmonth + "-" + Fday;

          // 1. 해당 날짜에 일기가 있는지 자바 코드로 먼저 검색
          diary.DiaryinfoDTO foundDto = null;
          if(bean != null) {
              for(diary.DiaryinfoDTO dto : bean) {
                  // DB 날짜 포맷에 맞춰 비교 (String인 경우)
                  if(dto.getCreate_date().equals(Cdate)) {
                      foundDto = dto;
                      break; 
                  }
              }
          }

          // 2. 결과에 따라 <td> 하나만 출력
          if(foundDto != null) {
              // 일기가 있는 날 %>
              <td class="emotion_<%=foundDto.getEmotion()%><%=todayClass%>">
                  <a href="${pageContext.request.contextPath}/Preview.do?selectedDate=<%=Cdate%>"><%=i%></a>
              </td>
          <% } else {
              // 일기가 없는 날 %>
              <td class="no_diary<%=todayClass%>">
                  <a href="${pageContext.request.contextPath}/Preview.do?selectedDate=<%=Cdate%>"><%=i%></a>
              </td>
          <% } // if-else
              
              dayCount++;
              
              // 토요일이면 다음 줄로
              if(dayCount % 7 == 0 && i < lastDay) {
                  %>
                  </tr><tr class="days">
                  <%
              } // if
          } // for
          
          // 다음 달의 날짜 출력 (남은 칸 채우기)
          int remainDays = 1;
          while(dayCount % 7 != 0) {
              %>
              <td class="inactive"><%=remainDays%></td>
              <%
              remainDays++;
              dayCount++;
          }
          %>
        </tr>
    </tbody>
    </table>
      </div>
    </div>
</div>
</body>
</html>