<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원가입</title>
</head>
<body>
	<center>
		<h2>회원가입</h2>
		<form action="create_id_proc.jsp" method="post">
			<table width="600" border="1">

				<tr height="40">
					<td width="200" align="center">아이디</td>
					<td width="400" align="left"><input type="text" name="user_id"
						style="border: none; outline: none;"></td>
				</tr>

				<tr height="40">
					<td width="200" align="center">패스워드</td>
					<td width="400" align="left"><input type="password"
						name="user_pw" style="border: none; outline: none;"></td>
				</tr>

				<tr height="40">
					<td width="200" align="center">성별</td>
					<td width="400" align="left"><input type="radio" name="gender"
						value="남">남 <input type="radio" name="gender" value="여">여
					</td>
				</tr>

				<tr height="40">
					<td width="200" align="center">전화번호</td>
					<td width="400" align="left"><input type="phone"
						name="phone_number" style="border: none; outline: none;"></td>
				</tr>


				<tr height="40">
					<td width="200" align="center">생년월일</td>
					<td width="400" align="left"><input type="date"
						name="birthday" style="border: none; outline: none;"></td>
				</tr>



				<tr height="40">
					<td width="600" align="center" colspan="2"><input
						type="submit" value="회원가입"> <input type="reset" value="취소">
					</td>
				</tr>
			</table>
		</form>
	</center>
</body>
</html>