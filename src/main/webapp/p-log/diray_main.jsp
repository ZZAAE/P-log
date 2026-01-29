<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>작성된 일기</title>
<link rel="stylesheet" href="../css/post_css.css" type="text/css"/>
</head>
<body>
<%

%>
	<div class="all">
		<div id="var">
			<p>2026.01.26 월</p>
			<a onclick="" class="modify"></a>
			<a onclick="" class="delete"></a>
		</div>
		<div id="emotion">
			<div class="emoji" onclick="">😁</div>
		</div>
		<div id="img">
			<img src="../css/cafe.jpg" alt="" />
		</div>
		<div id="text">
			<textarea id="user-comment" rows="6" cols="22"
				placeholder="일기의 내용을 입력하세요..."></textarea>
		</div>
	</div>
</body>
</html>