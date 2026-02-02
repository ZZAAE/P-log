<%@page import="diary.DiaryInfo_DTO"%>
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
<title>Calender Main Page!</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/calenderMain_css.css">
</head>
<body>
<%
// 세션에서 ID, Calendermain.do에서 벡터, Preview.do에서 preview 받아오기
String user_id = (String)session.getAttribute("user_id");
user_id = "test"; // 임시 테스트용
Vector<DiaryInfo_DTO> bean = (Vector<DiaryInfo_DTO>)request.getAttribute("bean");
DiaryInfo_DTO preview = (DiaryInfo_DTO)session.getAttribute("preview");

// 선택된 날짜 파라미터 받기
String selectedDate = request.getParameter("selectedDate");
boolean showDiarySection = (selectedDate != null && !selectedDate.trim().isEmpty());



// 캘린더 객체 생성
Calendar cal = Calendar.getInstance();

// URL 파라미터로 년도와 월 받기
String yearParam = request.getParameter("year");
String monthParam = request.getParameter("month");

int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH) + 1;

if(yearParam != null && monthParam != null) {
    year = Integer.parseInt(yearParam);
    month = Integer.parseInt(monthParam);
    
    // 월이 13이면 다음년도 1월로
    if(month > 12) {
        year++;
        month = 1;
    }
    // 월이 0이면 이전년도 12월로
    if(month < 1) {
        year--;
        month = 12;
    }
}

// 현재 날짜 정보
int ty = cal.get(Calendar.YEAR);
int tm = cal.get(Calendar.MONTH) + 1;
int td = cal.get(Calendar.DATE);

// 캘린더를 해당 월의 1일로 설정
cal.set(year, month-1, 1);
int week = cal.get(Calendar.DAY_OF_WEEK); // 1일의 요일 (1=일요일 ~ 7=토요일)

// 해당 월의 마지막 날짜
int lastDay = cal.getActualMaximum(Calendar.DATE);
%>

<div class="container">
    <!-- 왼쪽 일기 내용 영역 (프리뷰) -->
    <div id="diarySection" class="diary-section <%=showDiarySection ? "active" : ""%>">
        <div class="diary-header">
            <h2 id="selectedDate"><%=showDiarySection ? selectedDate : "날짜 선택"%></h2>
            <a href="calenderMain.jsp?year=<%=year%>&month=<%=month%>" class="close-btn">✕</a>
        </div>
        
        <div class="diary-body">
            <div class="emotion-display">
                <span id="diaryEmotion" class="emotion-icon">
                    <%
                    
                    if (preview.getContent() != null) {
                        int emo = preview.getEmotion(); // getter 호출
                        if (emo == 1) out.print("😊1");
                        else if (emo == 2) out.print("😊2");
                        else if (emo == 3) out.print("😊3");
                        else if (emo == 4) out.print("😊4");
                        else if (emo == 5) out.print("😊5");
                    } else {
                        out.print("일기가 없습니다");
                    }
                    %>
                </span>
            </div>
            
            <div class="diary-text">
                <p id="diaryContent">
                    <%
                    if(selectedDiary != null) {
                    if(selectedDiary.getContent() != null) {
                        // TODO: DB에서 해당 날짜의 일기 내용 가져오기
                        out.print(selectedDate + " 일자의 일기. \n" + selectedDiary.getContent());
                    }else{
                    	out.print("일기 데이터는 있는데 내용이 없어요.");
                    }
                    }else {
                        out.print("일기가 없어요.");
                    }
                    %>
                </p>
            </div>
            
            <div class="diary-image" id="diaryImage" style="display:none;">
                <img src="" alt="일기 이미지" id="diaryImg">
            </div>
        </div>
        
        <div class="diary-footer">
        	<!-- showDiarySection == true 일 시 showDiarySection에서 추출한 날짜 제출, id: 세션에 저장된 id 제출 -->
            <a href="diary_edit.jsp?date=<%=showDiarySection ? selectedDate : ""%>" class="diary-btn edit-btn">수정</a>
            <a href="diary_delete.jsp?date=<%=showDiarySection ? selectedDate : ""%>" class="diary-btn delete-btn">삭제</a>
            <a href="write.jsp?date=<%=showDiarySection ? selectedDate : "" %>&id=<%=user_id%>" class="diary-btn write-btn">새 일기 작성</a>
        </div>
    </div>

    <!-- 오른쪽 캘린더 영역 -->
    <div class="wrapper <%=showDiarySection ? "shifted" : ""%>">
    <header>
        <div class="nav">
		  <a href="${pageContext.request.contextPath}/CalenderMain.do?user_id=<%=user_id%>&year=<%=year%>&month=<%=month-1%>" class="cal-btn">&lt;</a>
		  <p class="current-date"><%=year%>년 <%=month%>월</p>
		  <a href="${pageContext.request.contextPath}/CalenderMain.do?user_id=<%=user_id%>&year=<%=year%>&month=<%=month+1%>" class="cal-btn">&gt;</a>
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
          diary.DiaryInfo_DTO foundDto = null;
          if(bean != null) {
              for(diary.DiaryInfo_DTO dto : bean) {
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
                  <a href="${pageContext.request.contextPath}/Preview.do?user_id=<%=user_id%>&selectedDate=<%=Cdate%>"><%=i%></a>
              </td>
          <% } else {
              // 일기가 없는 날 %>
              <td class="no_diary<%=todayClass%>">
                  <a href="${pageContext.request.contextPath}/Preview.do?user_id=<%=user_id%>&selectedDate=<%=Cdate%>"><%=i%></a>
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