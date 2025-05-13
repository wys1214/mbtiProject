<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>커뮤니티 갤러리</title>
<link rel="stylesheet" href="/resources/css/default.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/resources/js/sweetalert.min.js"></script>
</head>
<body>

	<!-- 상단 헤더 -->
	<header>
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	</header>


	<!-- 메인 콘텐츠 -->
	<div class="container">
		<div class="main">


			<div class="ranking-boxes">
				<div class="ranking-box">
					<h3>🔥 BEST 게시글</h3>
					<ol>
						<li>게시글 제목 1</li>
						<li>게시글 제목 2</li>
						<li>게시글 제목 3</li>
					</ol>
				</div>
			</div>

			<div class="ranking-boxes">
				<div class="ranking-box">
					<h3>추천게시판</h3>


					<img src="rock.jpg"> <img src="rock.jpg"> <img
						src="rock.jpg"> <img src="rock.jpg"> <img
						src="rock.jpg">
				</div>
			</div>

			<div class="ranking-boxes2">
				<div class="ranking-box2">
					<h3>❤️ 고민상담</h3>
					<ol>
						<li>게시글 제목 A</li>
						<li>게시글 제목 B</li>
						<li>게시글 제목 C</li>
					</ol>
				</div>
				<div class="ranking-box2">
					<h3>최신 글</h3>
					<ol>
						<li>게시글 제목 A</li>
						<li>게시글 제목 B</li>
						<li>게시글 제목 C</li>
					</ol>

				</div>
				<div class="ranking-box2">
					<h3>공지사항</h3>
					<ol>
						<li>게시글 제목 A</li>
						<li>게시글 제목 B</li>
						<li>게시글 제목 C</li>
					</ol>

				</div>

			</div>
			<div class="ranking-boxes">
				<div class="ranking-box">
					<h3>설문조사</h3>
					<a>무엇을 좋아하시나요</a> <br>
					<button>답변1</button>
					<button>답변2</button>
					<button>답변3</button>
				</div>
			</div>




		</div>

		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/common/loginbar.jsp"></jsp:include>
			<div class="point-box">
				<h3>포인트 랭킹</h3>
				<ol>
					<li>새우깡총아 - 12,000점</li>
					<li>허니버스 - 10,000점</li>
					<li>포탈네이아 - 7,000점</li>
				</ol>
			</div>
		</div>
	</div>

	<footer>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</footer>

</body>
</html>