<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/login_css.css">
</head>
<body>

<div class="login-page">
  <section class="login-card">

    <h1 class="brand">P-log</h1>
    <h2 class="title">로그인/회원가입</h2>

    <%
      String msg = (String) request.getAttribute("msg");
      if (msg != null) {
    %>
      <script>
	    alert("아이디 또는 비밀번호가 일치하지 않습니다.");
	</script>
    <%
      }
    %>

    <%-- <form class="form" action="<%=request.getContextPath()%>/user/LoginCon.do" method="post"> --%>
    <form class="form" action="LoginCon.do" method="post">
      <input class="input" type="text" name="user_id" placeholder="아이디를 입력해주세요." required>
      <input class="input" type="password" name="user_pw" placeholder="비밀번호를 입력해주세요." required>

      <button class="btn-login" type="submit">로그인</button>
    </form>

    <div class="links">
      <a href="<%=request.getContextPath()%>/user/create_id.jsp">회원가입</a>
    </div>

    <div class="oauth">
      <button class="btn-google" type="button">
        <span class="google-icon"></span>
        <span>Sign in with Google</span>
      </button>
    </div>
	
  </section>
</div>
	<%
	    String signup = request.getParameter("signup");
	    if ("success".equals(signup)) {
	%>
	<script>
	    alert("회원가입이 완료되었습니다. 로그인해주세요.");
	</script>
	<%
	    }
	%>
</body>
</html>
