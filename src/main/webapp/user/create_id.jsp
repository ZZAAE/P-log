<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>P-log | 회원가입</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/login_css.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/create_id_css.css">
</head>
<body>

<div class="login-page">
    <section class="signup-card">
        <div class="signup-header">
            <h1 class="brand" style="margin-bottom:10px;">P-log</h1>
            <h2 class="title">회원가입</h2>
        </div>

        <form action="create_id_proc.jsp" method="post" style="display:contents;">
            
            <div class="form-group">
                <label>아이디</label>
                <input class="input-field" type="text" name="user_id" placeholder="아이디를 입력하세요" required>
            </div>

            <div class="form-group">
                <label>비밀번호</label>
                <input class="input-field" type="password" name="user_pw" placeholder="비밀번호를 입력하세요" required>
            </div>

            <div class="form-group">
                <label>전화번호</label>
                <div class="flex-row">
                    <select class="input-field code-select">
                        <option>+82</option>
                        <option>+1</option>
                    </select>
                    <input class="input-field" type="tel" name="phone_number" placeholder="번호 입력" required>
                </div>
            </div>

            <div class="birth-gender-row">
                <div class="form-group birth-box">
                    <label>생년월일</label>
                    <input class="input-field" type="date" name="birthday" required>
                </div>
                <div class="form-group gender-box">
                    <label>성별</label>
                    <select class="input-field" name="gender">
                        <option value="남">남성</option>
                        <option value="여">여성</option>
                    </select>
                </div>
            </div>

            <div class="btn-area">
                <button type="submit" class="btn-submit">회원가입 완료</button>
                <button type="button" class="btn-cancel" onclick="location.href='login.jsp'">돌아가기</button>
            </div>

        </form>
    </section>
</div>

</body>
</html>