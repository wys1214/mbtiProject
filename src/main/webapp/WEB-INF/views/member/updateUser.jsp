<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="/resources/css/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/resources/js/sweetalert.min.js"></script>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원 정보 수정</title>
</head>
<body>

  <!-- 헤더 포함 -->
  <header>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
  </header>

  <!-- 메인 콘텐츠 레이아웃 -->
  <div class="container">
    
    <!-- 메인 수정 폼 -->
    <div class="main">
      <div class="ranking-box">
        <h3>회원정보 수정</h3>
        <form action="/member/update" method="post">
          <input type="hidden" name="memberNo" value="${loginMember.memberNo}">
          <table style="width:100%; border-spacing: 12px;">
            <tr>
              <th>MBTI</th>
              <td><input type="text" name="memberMbti" value="${loginMember.memberMbti}" /></td>
            </tr>
            <tr>
              <th>ID</th>
              <td><input type="text" name="memberId" value="${loginMember.memberId}" /></td>
            </tr>
            <tr>
              <th>비밀번호</th>
              <td><button type="button" onclick="chgPassword()">비밀번호 변경</button></td>
            </tr>
            <tr>
              <th>닉네임</th>
              <td><input type="text" name="memberNickname" value="${loginMember.memberNickname}" /></td>
            </tr>
            <tr>
              <th>이메일</th>
              <td><input type="text" name="memberEmail" value="${loginMember.memberEmail}" /></td>
            </tr>
            <tr>
              <th>전화번호</th>
              <td><input type="text" name="memberPhone" value="${loginMember.memberPhone}" /></td>
            </tr>
            <tr>
              <th>등급</th>
              <td>
                <c:choose>
                  <c:when test="${loginMember.memberGrade == 1}">관리자</c:when>
                  <c:when test="${loginMember.memberGrade == 2}">우수회원</c:when>
                  <c:when test="${loginMember.memberGrade == 3}">정회원</c:when>
                  <c:when test="${loginMember.memberGrade == 4}">준회원</c:when>
                  <c:otherwise>알 수 없음</c:otherwise>
                </c:choose>
              </td>
            </tr>
            <tr>
              <th>가입일</th>
              <td>${loginMember.memberJoinDate}</td>
            </tr>
          </table>
          <br>
          <button type="submit" class="login-btn">수정하기</button>
        </form>
      </div>
    </div>

    <!-- 사이드 로그인 박스 -->
    <div class="sidebar">
      <jsp:include page="/WEB-INF/views/common/loginbar.jsp" />
    </div>

  </div>

  <!-- 푸터 포함 -->
  <footer>
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
  </footer>

</body>
</html>
