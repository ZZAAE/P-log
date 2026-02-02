<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Create_Id_Proc</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
%>
	<jsp:useBean class="user.PlogDTO" id="pDTO">
		<jsp:setProperty name="pDTO" property="*"/>
	</jsp:useBean>
	
	<jsp:useBean class="user.PlogDAO" id="pDAO"/>
	
	<%
	pDAO.insert_Member(pDTO);
	response.sendRedirect("login.jsp");
	%>
</body>
</html>