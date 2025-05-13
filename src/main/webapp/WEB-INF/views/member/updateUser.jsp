<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <link rel="stylesheet" href="/resource/css/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/resources/js/sweetalert.min.js"></script>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 헤더부분 -->
	<header>
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	</header>
	
	<!-- 수정할 정보 입력 페이지 -->
	<div>
		회원정보 수정
	</div>
	<div>
		<form action="/member/update" method="post">
			<!-- 맴버번호 -->
			<input type="hiden" name="memberNo" value="${loginMember.memberNo}">
			<table>
				<tr>
					<th>mbti</th>
					<td>
						<div>
							<input type="text" id="memberMbti" name="memberMbti" value="${loginMember.memberMbti}">
						</div>
					</td>
				</tr>
				<tr>
					<th>ID</th>
					<td>
						<div>
							<input type="text" id="memberId" name="memberId" value="${loginMember.memberId}">
						</div>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<div>
							<button type="button" onclick="chgPassword()">비밀번호 변경</button>
						</div>
					</td>
				</tr>
				<tr>
					<th>이름</th>
					<td>
						<div>
							<input type="text" id="memberNickname" name="memberNickname" value="${loginMember.memberNickname}">
						</div>
					</td>
				</tr> 
				<tr>
					<th>이메일</th>
					<td>
						<div>
							<input type="text" id="memberEmail" name="memberEmail" value="${loginMember.memberEmail}">
						</div>
					</td>
				</tr> 
				<tr>
					<th>전화번호</th>
					<td>
						<div>
							<input type="text" id="memberPhone" name="memberPhone" value="${loginMember.memberPhone}">
						</div>
					</td>
				</tr> 
				<tr>
					<th>등급</th>
					<td>
						<div>
							<c:if test="${loginMember.memberLevel eq 1 }">
							관리자
							</c:if>
							<c:if test="${loginMember.memberLevel eq 2 }">
							우수회원
							</c:if>
							<c:if test="${loginMember.memberLevel eq 3 }">
							정회원
							</c:if>
							<c:if test="${loginMember.memberLevel eq 4 }">
							준회원
							</c:if>
						</div>
					</td>
				</tr> 
				<tr>
					<th>가입일</th>
					<td>
						<div>
							${loginMember.memberJoinDate}
						</div>
					</td>
				</tr> 
			</table>
		</form>
	</div>
	
	
	<!-- 풋터부분 -->
	<footer>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</footer>
</body>
</html>