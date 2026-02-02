<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>user_update</title>
</head>
<body>
	<center>
		<form action="userinfoUpdateProcCon.do" method="post">
			<table>
				<tr>
					<td>아이디</td>
					<td>${bean.user_id}</td>
				</tr>

				<tr>
					<td>비밀번호</td>
					<td><input type="text" name="user_pw" value="${bean.user_pw}"/></td>
				</tr>

				<tr>
					<td>성별</td>
					<td><input type="text" name="gender" value="${bean.gender}"/></td>
				</tr>

				<tr>
					<td>핸드폰번호</td>
					<td><input type="text" name="phone_number" value="${bean.phone_number}"/></td>
				</tr>
				
				<tr>
					<td>생일</td>
					<td><input type="date" name="birthday" value="${bean.birthday}"/></td>
				</tr>
				
				<tr height="40">
					<td width="600" align="center" colspan="2">
					<input type="hidden" name="user_pass" value="${bean.user_pw }" />
					<input type="submit" value="수정하기"> <input type="button" value="취소" onclick="location.href='main.jsp'"> 
					</td>
				</tr>

			</table>
		</form>
	</center>

</body>
</html>