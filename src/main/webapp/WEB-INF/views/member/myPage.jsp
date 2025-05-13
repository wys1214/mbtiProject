<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="/resource/css/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/resources/js/sweetalert.min.js"></script>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }

        .mypage-container {
            max-width: 700px;
            margin: 0 auto;
            background-color: #fff;
            border: 1px solid #ddd;
            padding: 30px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }

        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .nickname {
            font-size: 24px;
            font-weight: bold;
        }

        .userid {
            color: #777;
            font-size: 14px;
        }

        .counts {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin: 20px 0;
        }

        .count-item {
            text-align: center;
        }

        .count-item span {
            display: block;
            font-weight: bold;
            font-size: 18px;
        }

        .edit-btn {
            padding: 8px 16px;
            background-color: #eee;
            border: 1px solid #ccc;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .tabs {
            display: flex;
            justify-content: space-around;
            margin: 30px 0 20px;
        }

        .tab {
            flex: 1;
            padding: 10px;
            text-align: center;
            border: 1px solid #ccc;
            cursor: pointer;
            background-color: #f0f0f0;
        }

        .posts {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .post-item {
            background-color: #eee;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
        }
    </style>
</head>
<!-- 헤더부분 -->
	<header>
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	</header>
<body>
<!-- 회원 정보 표시 -->
    <div class="mypage-container">
        <div class="profile-header">
            <div class="nickname">닉네임</div>
            <div class="userid">아이디</div>

            <div class="counts">
                <div class="count-item">
                    <span>1</span>
                    작성글
                </div>
            </div>

            <a href="/member/updateFrm">회원정보 수정</a>
        </div>

        <div class="tabs">
            <div class="tab">작성글</div>
            <div class="tab">작성댓글</div>
            <div class="tab">스크랩</div>
        </div>

        <div class="posts">
            <div class="post-item">게시물1</div>
            <div class="post-item">게시물2</div>
            <div class="post-item">게시물3</div>
        </div>
    </div>
   <footer>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</footer>
</body>
</html>
