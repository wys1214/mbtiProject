<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>커뮤니티 갤러리</title>
  <link rel="stylesheet" href="/resources/css/default.css"> <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="/resources/js/sweetalert.min.js"></script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Pretendard', sans-serif;
      background-color: #fafafa;
      color: #333;
    }

    /* 상단 헤더 */
    .header_top {
      background: white;
      padding: 15px 380px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    /* 하단 헤더 */
    .header_bottom {
      background: #f5f3f3;
      padding: 5px 380px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .logo {
      font-size: 42px;
      font-weight: bold;
      color: #333;
    }


    .signup-btn, .login-btn {
      background: #ff3366;
      color: white;
      padding: 8px 16px;
      margin: 3px;
      border: none;
      border-radius: 5px;
      font-size: 14px;
      cursor: pointer;
      display: inline-block;
    }

    .signup-btn:hover, .login-btn:hover {
      background: #ff3366da;
      color: white;
      padding: 8px 16px;
      margin: 3px;
      border: none;
      border-radius: 5px;
      font-size: 14px;
      cursor: pointer;
      display: inline-block;
      transition: color 0.3s ease;
    }


    /* 하단 메뉴바 */
    .menubar {
      display: flex;
      justify-content: center;
      gap: 40px;
      padding: 12px 0;
    }

    .menubar a {
      text-decoration: none;
      color: #333;
      font-size: 15px;
      height: 20px;
      text-align: left;
    }

    .menubar a:hover {
      text-decoration: none;
      color:#ff3366;
      transition: color 0.3s ease;
    }

    
    /* 하단 footer */

    footer {
      display: inline-block;

    }

    footer>div {
      background: #353940;
      width: 100%;
      height: 140px;
      display: flex;
      justify-content: center;
      gap: 30px;
      align-items: center;
    }

    footer>div a {
      text-decoration: none;
      color: white;
      font-size: 15px;
      height: 20px;
      text-align: left;
    }

/*-----------------------------------------------------------------------------------------------*/
    /* 전체 레이아웃 */
    .container {
      display: flex;
      max-width: 1200px;
      margin: 30px auto;
      gap: 20px;
    }

    .main {
      flex: 3;
    }

    .sidebar {
      flex: 1;
    }

    h2 {
      font-size: 22px;
      margin-bottom: 20px;
    }

    /* 랭킹 박스 */
    .ranking-boxes {
      display: flex;
      gap: 20px;
      margin-bottom: 30px;
    }

    .ranking-box {
      background: white;
      border: 1px solid #ccc;
      border-radius: 10px;
      flex: 1;
      padding: 15px;
      font-size: 14px;
    }

    /*추천게시판 이미지*/
    .ranking-box img {
      height: 140px;
      width: 140px;
      border-radius: 20px;
      margin-right: 5px;
    }
    .ranking-box img:hover {
      height: 160px;
      width: 160px;
      border-radius: 20px;
      margin-right: 5px;
    }


    .ranking-box button {
      background: #f1f1f1;
      border: none;
      padding: 8px 15px;
      margin-right: 8px;
      border-radius: 20px;
      font-size: 14px;
      cursor: pointer;
    }

    .ranking-boxes2 {
      display: flex;
      gap: 20px;
      margin-bottom: 30px;
      /*width: 250px;*/
      height: 300px;
    }
    
  

    .ranking-box2 {
      background: white;
      border: 1px solid #ccc;
      border-radius: 10px;
      flex: 1;
      padding: 15px;
      font-size: 14px;
      margin: 5px;
      margin-left: 5px;

    }
    

    .ranking-box h3 {
      font-size: 16px;
      margin-bottom: 10px;
      color: #ff3366;
    }

    .ranking-box ol {
      list-style: none;
    }

    .ranking-box li {
      padding: 6px 0;
      border-bottom: 1px dotted #eee;
    }

    .ranking-box2 h3 {
      font-size: 16px;
      margin-bottom: 10px;
      color: #ff3366;
    }

    .ranking-box2 ol {
      list-style: none;
    }

    .ranking-box2 li {
      padding: 6px 0;
      border-bottom: 1px dotted #eee;
    }

    /* 카테고리 버튼 */
    .categories {
      margin: 20px 0;
    }

    .categories button {
      background: #f1f1f1;
      border: none;
      padding: 8px 15px;
      margin-right: 8px;
      border-radius: 20px;
      font-size: 14px;
      cursor: pointer;
    }

    .categories button.active {
      background: #ff3366;
      color: white;
    }

    /* 썸네일 게시글 */
    .thumbnail-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
    }

    .thumbnail {
      background: white;
      border: 1px solid #ddd;
      border-radius: 8px;
      width: calc(25% - 12px);
      height: 130px;
      padding: 10px;
      text-align: center;
    }

    /* 사이드바 */
    .login-box, .point-box {
      background: white;
      border: 1px solid #ccc;
      border-radius: 10px;
      padding: 15px;
      margin-bottom: 20px;
    }

    .login-box input {
      width: 100%;
      padding: 8px;
      margin-bottom: 8px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    .login-box button {
      width: 100%;
      padding: 8px;
      background: #ff3366;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    .point-box h3 {
      font-size: 16px;
      margin-bottom: 10px;
    }

    .point-box ol {
      list-style: none;
      font-size: 14px;
    }

    .point-box li {
      padding: 6px 0;
      border-bottom: 1px dashed #eee;
    }
  </style>
</head>
<body>

<!-- 상단 헤더 -->
<header>
    <div class="header_top">
        <div class="logo">성격봐라</div>
    </div>
      <!-- 가로 메뉴바 -->
    
    <div class="header_bottom">
        <div class="menubar">
            <a href="/board/noticeGetList?reqPage=1">공지사항</a>
            <a href="#">자유게시판</a>
            <a href="#">고민있어요</a>
            <a href="#">추천합니다</a>
            <a href="#">베스트게시글</a>
            <a href="#">가입인사</a>
            <a href="#">테스트할래요</a>
        </div>
        <div>
            <button class="login-btn">로그인</button>
            <button class="signup-btn">회원가입</button>
        </div>
    </div>

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
          
         
          <img src="rock.jpg">
          <img src="rock.jpg">
          <img src="rock.jpg">
          <img src="rock.jpg">
          <img src="rock.jpg">
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
        <h3> 최신 글</h3>
        <ol>
          <li>게시글 제목 A</li>
          <li>게시글 제목 B</li>
          <li>게시글 제목 C</li>
        </ol>
        
      </div>
      <div class="ranking-box2">
        <h3> 공지사항</h3>
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
        <a>무엇을 좋아하시나요</a>
        <br>
        <button>답변1</button>
        <button>답변2</button>
        <button>답변3</button>
      </div>
    </div>
  
  
  
      
    </div>
  
    <div class="sidebar">
      <div class="login-box">
        <h3>로그인</h3>
        <input type="text" placeholder="아이디">
        <input type="password" placeholder="비밀번호">
        <button>로그인</button>
      </div>
  
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
  <div class="footer_left">
    <pre>팀명 : 너티야 | 팀원: 김유진 덕 왕윤식 윤서진 정다은</pre>
  </div>
  <div class="footer_right">
    <a href="#">사이트 소개</a>
    <a href="#">이용약관</a>
    <a href="#">개인정보처리방침</a>
    <a href="#">고객센터</a>
  </div>
</footer>

</body>
</html>