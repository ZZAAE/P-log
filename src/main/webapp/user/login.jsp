<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
</head>
<body>
<center>
		<h2>로그인</h2>
		<form action="loginproc.jsp" method="post">
		<table align="center" width="300" border="1">
			<tr height="40">
				<td width="120" align="center">아이디</td>
				<td width="180" align="center" >
					<input type="text" name="user_id" required/>
				</td>
			</tr>
			<tr height="40">
				<td width="120" align="center">패스워드</td>
				<td width="180" align="center">
				<input type="password" name="user_pw" required/></td>
			</tr>
			<tr>
				<td align="center" colspan="2">
				<input type="submit" value="로그인"></td>
			</tr>
			<tr>
				<td align="center" colspan="2">
				<input type="button" value="회원가입" onclick="location.href='create_id.jsp'"/>
				</td>
			</tr>
			
		</table>
		</form>
	</center>
</body>
</html>