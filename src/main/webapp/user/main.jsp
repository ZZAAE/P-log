<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>로그인 성공</h2>

<form action="UserinfoUpdateCon.do">
	<input type="button" value="정보수정"
       onclick="location.href='<%=request.getContextPath()%>/UserinfoList.do'">
	
	<c:if test="${msg eq 'success'}">
	  <script>alert("수정 완료했습니다.");</script>
	</c:if>
	
	<c:if test="${msg eq 'fail'}">
	  <script>alert("입력하신 정보가 틀렸습니다.");</script>
	</c:if>
	
</form>
</body>
</html>