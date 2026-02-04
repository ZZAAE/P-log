<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<center>
		<h2>계정 탈퇴</h2>
		<form action="UserinfoDeleteProcCon.java">
			<table>
				<tr>
					<td>아이디</td>
					<td>${bean.user_id}
						<input type="hidden" name="user_id" value="${bean.user_id}"/></td>
				</tr>
				<tr>
					<td>패스워드</td>
					<td>
						<input type="password" name="password" />
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" name="user_pw" value="${bean.user_pw}"/>
						<input type="submit" value="계정삭제"/>
						<input type="button" value="취소" onclick="location.href='/user/main.jsp'" />
					</td>
				</tr>
			</table>
		</form>
	</center>
</body>
</html>