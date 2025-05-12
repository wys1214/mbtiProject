<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="/resource/css/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/resources/js/sweetalert.min.js"></script>

<!-- 상단 헤더 전체 -->
<header>
  <!-- 상단 로고 영역 -->
  <div class="header_top">
    <div class="logo">성격봐라</div>
  </div>

  <!-- 메뉴바 + 로그인/회원가입 -->
  <div class="header_bottom">
    <div class="menubar">
      <a href="/board?type=notice">공지사항</a>
      <a href="/board?type=free">자유게시판</a>
      <a href="/board?type=worry">고민있어요</a>
      <a href="/board?type=recommend">추천합니다</a>
      <a href="/board?type=best">베스트게시글</a>
      <a href="/board?type=intro">가입인사</a>
      <a href="/board?type=test">테스트할래요</a>
    </div>
    <div>
      <button class="login-btn">로그인</button>
      <button class="signup-btn">회원가입</button>
    </div>
  </div>
</header>
