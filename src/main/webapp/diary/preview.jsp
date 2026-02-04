<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="diary.DiaryinfoDTO"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Preview Page</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/calenderMain_c1ss.css">
</head>
<body>
<%
DiaryinfoDTO preview = (DiaryinfoDTO)request.getAttribute("preview");
String selectedDate = (String)request.getAttribute("selectedDate");
%>
<div class="container">
	<div class = "header">
		<a href="CalendarMain.do" class="cal-btn">&lt;</a>
		<p class="current-date"><%=selectedDate%>.</p>
		
		<% if(preview == null){ %>
        <a href="DiaryWriteCon.do" class="diary-btn write-btn">새 일기 작성</a>
        <%} else{ %>
        <a href="DiaryUpdateCon.do?diary_id=<%=preview.getDiary_id()%>" class="diary-btn edit-btn">수정</a>
        <%} %>
        
	</div>
	
	<div id="diarySection" class="diary-section">
        <div class="diary-body">
            <div class="emotion-display">
                <span id="diaryEmotion" class="emotion-icon">
                    <%
                    if(preview != null) {
                    	if (preview.getContent() != null) {
	                        int emo = preview.getEmotion();
	                        if (emo == 1) out.print("😊1");
	                        else if (emo == 2) out.print("😊2");
	                        else if (emo == 3) out.print("😊3");
	                        else if (emo == 4) out.print("😊4");
	                        else if (emo == 5) out.print("😊5");
	                    } else {
	                        out.print("오늘 기분은 어땠나요?");
                    	} 
                    } else out.print("일기가 없습니다.");
                    %>
                </span>
                
                <div class="advice-display">
                	<!-- 어드바이스 -->
                </div>
            </div>
            
            <!-- 이미지 부분 -->
            <div class="diary-image" id="diaryImage" style="display:none;">
                <img src="" alt="일기 이미지" id="diaryImg">
            </div>
            
            <!-- 이미 작성된 일기 -->
            <div class="diary-text">
                <p id="diaryContent">
                    <%
                    if(preview != null) {
                    if(preview.getContent() != null) {
                        // preview에서 해당 날짜의 일기 내용 가져오기
                        out.print(selectedDate + " 일자의 일기. \n" + preview.getContent());
                    }else{
                    	out.print("오늘 하루를 입력해주세요!." + preview.getContent());
                    }
                    }else {
                        out.print("일기가 없습니다.");
                    }
                    %>
                </p>
            </div>
        </div>
        
        <div class="diary-footer">
            <a href="diary_delete.jsp?diary_id=<%=preview.getDiary_id()%>" class="diary-btn delete-btn">삭제</a>
            
        </div>
        
    </div>
</div>

</body>
</html>