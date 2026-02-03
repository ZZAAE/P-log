<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="diary.DiaryInfo_DTO"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/calenderMain_c1ss.css">
</head>
<body>
<%
DiaryInfo_DTO preview = (DiaryInfo_DTO)request.getAttribute("preview");
String selectedDate = (String)request.getAttribute("selectedDate");
%>

<div id="diarySection" class="diary-section">
        <div class="diary-body">
            <div class="emotion-display">
                <span id="diaryEmotion" class="emotion-icon">
                    <%
                    if(preview != null) {
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
                    } else out.print("일기가 없습니다.");
                    %>
                </span>
            </div>
            
            <div class="diary-text">
                <p id="diaryContent">
                    <%
                    if(preview != null) {
                    if(preview.getContent() != null) {
                        // TODO: DB에서 해당 날짜의 일기 내용 가져오기
                        out.print(selectedDate + " 일자의 일기. \n" + preview.getContent());
                    }else{
                    	out.print("일기 데이터는 있는데 내용이 없어요." + preview.getContent());
                    }
                    }else {
                        out.print("일기가 없습니다.");
                    }
                    %>
                </p>
            </div>
            
            <div class="diary-image" id="diaryImage" style="display:none;">
                <img src="" alt="일기 이미지" id="diaryImg">
            </div>
        </div>
        <c:if test="${preview != null }">
        	<div class="diary-footer">
        	<!-- showDiarySection == true 일 시 showDiarySection에서 추출한 날짜 제출, id: 세션에 저장된 id 제출 -->
            <a href="diary_edit.jsp?diary_id=<%=preview.getDiary_id()%>" class="diary-btn edit-btn">수정</a>
            <a href="diary_delete.jsp?diary_id=<%=preview.getDiary_id()%>" class="diary-btn delete-btn">삭제</a>
            <a href="write.jsp?diary_id=<%=preview.getDiary_id()%>" class="diary-btn write-btn">새 일기 작성</a>
        </div>
        </c:if>
        
    </div>

</body>
</html>