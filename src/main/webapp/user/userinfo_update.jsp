<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>회원 정보 수정</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/userinfo_update_css.css">
<link rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=Inter:slnt,wght@-10..0,100..900&display=swap">

</head>
<body>
<%
	String user_id = (String) session.getAttribute("user_id");
%>
<div class="page">
  <section class="card">
 

    <div class="profile">
      <div class="avatar" aria-hidden="true"></div>
      <div class="name"></div>
    </div>

    <form class="form" action="<%=request.getContextPath()%>/UserinfoUpdateProcCon.do" method="post">
      <!-- 아이디는 표시 + hidden 유지 -->
      <div class="field">
        <label class="label">아이디</label>
        <div class="static-row">
          <span class="static-text"><%=user_id%></span>
          <input type="hidden" name="user_id" value="<%=user_id%>" />
        </div>
      </div>

      <div class="field">
        <label class="label">현재 비밀번호</label>
        <input class="input" type="password" name="current_pw" placeholder="현재 비밀번호를 입력하세요" required />
      </div>

      <div class="field">
        <label class="label">새 비밀번호</label>
        <input class="input" type="password" name="user_pw" placeholder="새 비밀번호를 입력하세요" required />
      </div>

      <div class="field">
        <label class="label">핸드폰 번호</label>
        <input class="input" type="text" name="phone_number" value="${bean.phone_number}" placeholder="010-0000-0000" required />
      </div>

      <div class="field">
        <label class="label">생일</label>
        <!-- date input은 value가 yyyy-MM-dd 포맷이어야 함 -->
        <input class="input" type="date" name="birthday" value="${bean.birthday}" required />
      </div>

      <div class="field">
        <label class="label">성별</label>
        <div class="radio-row">
          <label class="radio">
            <input type="radio" name="gender" value="남"
              <c:if test="${bean.gender eq '남'}">checked</c:if> required/>
            <span>남</span>
          </label>

          <label class="radio">
            <input type="radio" name="gender" value="여"
              <c:if test="${bean.gender eq '여'}">checked</c:if> required />
            <span>여</span>
          </label>
        </div>
      </div>

      <div class="btn-row">
        <button type="submit" class="btn btn-primary">수정</button>
        <button type="button" class="btn btn-ghost"
          onclick="location.href='<%=request.getContextPath()%>/diary/CalendarMain.do'">취소</button>
      </div>
    </form>
  </section>
</div>



</body>
</html>
