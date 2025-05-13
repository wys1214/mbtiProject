<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/css/default.css">
<div class="login-box">
  <h3>로그인</h3>
  <form action="/member/login" method="post">
    <input type="text" name="memberId" placeholder="아이디" required>
    <input type="password" name="memberPw" placeholder="비밀번호" required>
    <button type="submit">로그인</button>
  </form>
</div>