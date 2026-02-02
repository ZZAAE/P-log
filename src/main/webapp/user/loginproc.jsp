<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.LoginDAO,user.LoginDTO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>loginproc</title>
</head>
<body>
	<%

		request.setCharacterEncoding("UTF-8");

		String user_id = request.getParameter("user_id");
		String user_pw = request.getParameter("user_pw");

		if (user_id == null || user_pw == null || user_id.trim().isEmpty() || user_pw.trim().isEmpty()) {
	%>
	<script>
		alert("아이디/비밀번호를 입력하세요.");
		history.go(-1);
	</script>
	<%

		return;
		}

		LoginDTO lDTO = new LoginDTO();
		lDTO.setUser_id(user_id);
		lDTO.setUser_pw(user_pw);

		LoginDAO lDAO = new LoginDAO();
		boolean ok = lDAO.userCheck(lDTO);

		if (ok) {
		session.setAttribute("user_id", user_id);
		session.setAttribute("user_pw", user_pw);
	%>
	<script>
		alert("로그인 성공!");	
		location.href='calenderMain.jsp';
	</script>
	<%
	// response.sendRedirect("calenderMain.jsp");
	} 
	else {
	%>
	<script>
		alert("아이디또는 비밀번호가 일치하지 않습니다.");
		history.go(-1);
	</script>
	<%
	}
	%>
</body>
</html>
