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
		<form action="<%=request.getContextPath()%>/UserinfoUpdateProcCon.do" method="post">
			<table>
				<tr>
					<td>아이디</td>
					<td>
						${bean.user_id}
						<input type="hidden" name="user_id" value="${bean.user_id}" />
					</td>
				</tr>

				<!-- ✅ 현재 비밀번호 확인용 -->
				<tr>
					<td>현재 비밀번호</td>
					<td><input type="password" name="current_pw" /></td>
				</tr>

				<tr>
					<td>새 비밀번호</td>
					<td><input type="password" name="user_pw"/></td>
				</tr>

				<tr>
					<td >성별</td>
					<td><input type="radio" name="gender"
						value="남">남 <input type="radio" name="gender" value="여">여
					</td>
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
						<input type="submit" value="수정하기" >
						
						<input type="button" value="취소" onclick="location.href='/user/main.jsp'">
					</td>
				</tr>

			</table>
		</form>
	</center>

	<% if(request.getAttribute("msg") != null && (int)request.getAttribute("msg") == 0) { %>
		<script>alert('현재 비밀번호가 틀렸습니다.');</script>
	<% } %>
</body>
</html>
