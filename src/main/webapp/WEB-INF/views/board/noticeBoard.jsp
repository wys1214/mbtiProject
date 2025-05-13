<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>    
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>커뮤니티 갤러리 - 공지사항</title>
  <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/default.css"> --%>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/sweetalert.min.js"></script> 
  
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

  <style>
    /* === 통합 CSS 시작 (두 JSP 파일 동일 적용) === */
    * { 
      box-sizing: border-box; 
      margin: 0; 
      padding: 0; 
    }
    html, body {
      height: 100%;
    }
    body {
      display: flex;
      flex-direction: column;
      min-height: 100vh; 
      font-family: 'Pretendard', sans-serif;
      background-color: #fafafa;
      color: #333;
    }

    /* 헤더 스타일 */
    .header_top_outer { background: white; padding: 15px 0; border-bottom: 1px solid #f0f0f0; }
    .header_bottom_outer { background: #f5f3f3; padding: 5px 0; border-bottom: 1px solid #e0e0e0; }
    .header_top_inner, .header_bottom_inner { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
    .logo { font-size: 42px; font-weight: bold; color: #333; text-decoration: none; }
    .logo a { text-decoration: none; color: inherit; }
    .menubar { display: flex; gap: 40px; padding: 12px 0; }
    .menubar a { text-decoration: none; color: #333; font-size: 16px; font-weight: 500; }
    .menubar a:hover { color:#ff3366; transition: color 0.3s ease; }
    .header-actions .signup-btn, 
    .header-actions .login-btn { background: #ff3366; color: white; padding: 8px 16px; margin-left: 10px; border: none; border-radius: 5px; font-size: 14px; cursor: pointer; text-decoration: none; display: inline-block; }
    .header-actions .signup-btn:hover, 
    .header-actions .login-btn:hover { background: #ff3366da; transition: background-color 0.3s ease; }
    
    /* 전체 레이아웃 */
    .container { display: flex; max-width: 1200px; margin: 30px auto; gap: 20px; flex-grow: 1; }
    .main { flex: 3; }
    .sidebar { flex: 1; }
    h2 { font-size: 22px; margin-bottom: 20px; color: #333; }
    
    /* 사이드바 */
    .login-box, .point-box { background: white; border: 1px solid #ccc; border-radius: 10px; padding: 15px; margin-bottom: 20px; }
    .login-box input[type="text"], .login-box input[type="password"] { width: 100%; padding: 8px; margin-bottom: 8px; border: 1px solid #ccc; border-radius: 5px; }
    .login-box button { width: 100%; padding: 8px; background: #ff3366; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; }
    .login-box button:hover { background: #ff3366da; }
    .point-box h3 { font-size: 16px; margin-bottom: 10px; color: #333; }
    .point-box ol { list-style: none; font-size: 14px; padding-left: 0; }
    .point-box li { padding: 6px 0; border-bottom: 1px dashed #eee; }

    /* 게시판 목록 스타일 */
    .board-container { background-color: white; padding: 15px; border-radius: 10px; border: 1px solid #ccc; font-family: 'Pretendard', sans-serif; }
    .board-header { display: flex; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
    .board-header h2 { font-size: 22px; color: #333; margin-bottom: 0; }
    .board-icon { color: #ff3366; margin-right: 10px; font-size: 22px; }
    .board-filters-and-write { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; }
    .mbti-filters { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; }
    .mbti-filter-btn { background: #f1f1f1; border: none; padding: 8px 12px; border-radius: 20px; font-size: 14px; cursor: pointer; color: #333; font-weight: 500; }
    .mbti-filter-btn.active, .mbti-filter-btn:hover { background: #ff3366; color: white; }
    .write-post-btn { background: #ff3366; color: white !important; padding: 8px 16px; border: none; border-radius: 5px; font-size: 14px; cursor: pointer; margin-left: auto; white-space: nowrap; text-decoration: none; display: inline-block; }
    .write-post-btn:hover { background: #ff3366da; }
    .post-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 14px; }
    .post-table th, .post-table td { border-bottom: 1px dotted #eee; padding: 12px 8px; text-align: left; color: #333; vertical-align: middle;}
    .post-table th { background-color: #f9f9f9; font-weight: bold; text-align: center; color: #333; }
    .post-table td.post-title { text-align: left; }
    .post-table td:not(.post-title) { text-align: center; font-size: 13px; color: #555; }
    .post-table td a { color: #333; text-decoration: none; font-weight: normal; }
    .post-table td a:hover { color: #ff3366; text-decoration: underline; }
    
	    /* 페이지네이션 스타일 (스크린샷과 유사하게) */
	.pagination { 
	    display: flex; 
	    justify-content: center; 
	    margin-top: 30px; /* 테이블과의 간격 */
	    margin-bottom: 20px; 
	    padding-left: 0; 
	}
	.pagination ul.circle-style { /* Java 코드에서 생성된 ul 태그 대상 */
	    list-style: none; 
	    padding: 0; 
	    margin: 0; 
	    display: flex; 
	    align-items: center; /* 수직 중앙 정렬 */
	} 
	.pagination ul.circle-style li { 
	    display: inline-block; 
	    margin: 0 4px; /* 버튼 간 간격 */
	}
	.pagination ul.circle-style li a.page-item,
	.pagination ul.circle-style li span.page-item { /* 현재 페이지가 링크가 아닌 span일 경우도 고려 */
	    color: #333;
	    padding: 8px 12px; 
	    text-decoration: none;
	    border: 1px solid #ddd;
	    border-radius: 4px; /* 약간 둥근 사각형 */
	    font-size: 14px;
	    line-height: 1.5; 
	    display: inline-block; 
	    background-color: white; /* 기본 배경 흰색 */
	    transition: background-color 0.2s ease, color 0.2s ease, border-color 0.2s ease;
	}
	.pagination ul.circle-style li a.page-item:hover {
	    background-color: #f1f1f1; 
	    border-color: #ccc;
	    color: #333;
	}
	.pagination ul.circle-style li a.page-item.active-page,
	.pagination ul.circle-style li span.page-item.active-page { /* 활성 페이지 스타일 */
	    background-color: #ff3366; /* 스크린샷의 핑크색 배경 */
	    color: white;
	    border-color: #ff3366;
	    font-weight: bold;
	}
	.pagination ul.circle-style li a.page-item .material-icons,
	.pagination ul.circle-style li span.page-item .material-icons { /* 이전/다음 아이콘 */
	    font-size: 20px; 
	    vertical-align: middle; 
	}
	/* "..." 생략 표시에 대한 스타일 (만약 span 태그 등으로 생성된다면) */
	.pagination ul.circle-style li span.ellipsis {
	    padding: 8px 6px;
	    color: #777;
	}

    .board-search { display: flex; justify-content: center; align-items: center; gap: 8px; margin-bottom: 20px; padding: 15px; background-color: #f5f3f3; border-radius: 8px; }
    .search-type-select, .board-search .search-input { padding: 8px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; font-family: 'Pretendard', sans-serif; }
    .board-search .search-input { width: 250px; }
    .search-btn { padding: 8px 15px; background: #ff3366; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; }
    .search-btn:hover { background: #ff3366da; }

    /* 글쓰기 폼에만 적용되는 스타일 */
    .post-write-form-container { width: 100%; background-color: white; padding: 25px 30px; border: 1px solid #ccc; border-radius: 10px; } 
    .form-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
    .form-title { font-size: 22px; color: #333; margin-bottom: 0; }
    .form-title-icon { color: #ff3366; margin-right: 10px; font-size: 22px; }
    .form-actions button { padding: 8px 16px; margin-left: 10px; border-radius: 5px; font-size: 14px; cursor: pointer; border: 1px solid #ccc; }
    .form-btn-primary { background-color: #ff3366; color: white; border-color: #ff3366; }
    .form-btn-primary:hover { background-color: #ff3366da; }
    .form-btn-secondary { background-color: #f1f1f1; color: #333; }
    .form-btn-secondary:hover { background-color: #e0e0e0; }
    .form-row { margin-bottom: 15px; }
    .form-row-inline { display: flex; align-items: center; gap: 10px; }
    .post-category-select-inline { padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 15px; font-family: 'Pretendard', sans-serif; color: #333; width: auto; min-width: 180px; flex-shrink: 0; }
    .post-title-input-inline { padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 15px; font-family: 'Pretendard', sans-serif; color: #333; flex-grow: 1; width: auto; }
    .post-title-input-inline::placeholder { color: #999; }
    .editor-section { margin-top: 20px; }
    .note-editor.note-frame { border-radius: 5px; border: 1px solid #ccc; width: 100%; box-sizing: border-box; }
    .note-toolbar { background-color: #f9f9f9; border-bottom: 1px solid #ccc; border-radius: 4px 4px 0 0; }
    .note-editable { font-family: 'Pretendard', sans-serif; font-size: 15px; line-height: 1.7; min-height: 350px; padding: 15px; }
    .form-footer-note { margin-top: 20px; padding-top: 15px; border-top: 1px solid #eee; font-size: 12px; color: #777; text-align: right; }
    .form-input-file { padding: 8px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; width: 100%;}

    /* 하단 footer */
    footer { width: 100%; background: #353940; color: white; flex-shrink: 0; }
    .footer-content-wrapper { max-width: 1200px; margin: 0 auto; padding: 20px 0; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; }
    .footer_left pre { font-family: 'Pretendard', sans-serif; font-size: 14px; margin: 10px 0; color: white; }
    .footer_right { display: flex; gap: 20px; }
    .footer_right a { text-decoration: none; color: white; font-size: 15px; }
    .footer_right a:hover { text-decoration: underline; }
    /* === 통합 CSS 끝 === */
  </style>
</head>
<body>

<header>
    <div class="header_top_outer">
        <div class="header_top_inner">
            <div class="logo"><a href="${pageContext.request.contextPath}/">성격봐라</a></div>
        </div>
    </div>
    <div class="header_bottom_outer">
        <div class="header_bottom_inner">
            <div class="menubar">
                <a href="${pageContext.request.contextPath}/notice/getList?reqPage=1">공지사항</a>
                <a href="#">자유게시판</a>
                <a href="#">고민있어요</a>
                <a href="#">추천합니다</a>
                <a href="#">베스트게시글</a>
                <a href="#">가입인사</a>
                <a href="#">테스트할래요</a>
            </div>
            <div class="header-actions"> 
                <c:choose>
                    <c:when test="${empty sessionScope.loginMember}">
                        <button class="login-btn" onclick="location.href='${pageContext.request.contextPath}/member/loginFrm'">로그인</button>
                        <button class="signup-btn" onclick="location.href='${pageContext.request.contextPath}/member/joinFrm'">회원가입</button>
                    </c:when>
                    <c:otherwise>
                        <button class="login-btn" onclick="location.href='${pageContext.request.contextPath}/member/myPage'">마이페이지</button> 
                        <button class="signup-btn" onclick="location.href='${pageContext.request.contextPath}/member/logout'">로그아웃</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</header>

<div class="container">
    <div class="main">
        <div class="board-container">
            <div class="board-header">
                <h2><span class="board-icon">&#10004;</span> 
                    <c:choose>
                        <c:when test="${not empty boardTitle}">${boardTitle}</c:when>
                        <c:otherwise>공지사항</c:otherwise>
                    </c:choose>
                </h2> 
            </div>

            <div class="board-filters-and-write">
                <div class="mbti-filters">
                    <button class="mbti-filter-btn active">ALL</button> 
                    <button class="mbti-filter-btn">I</button>
                    <button class="mbti-filter-btn">E</button>
                    <button class="mbti-filter-btn">N</button>
                    <button class="mbti-filter-btn">S</button>
                    <button class="mbti-filter-btn">F</button>
                    <button class="mbti-filter-btn">T</button>
                    <button class="mbti-filter-btn">J</button>
                    <button class="mbti-filter-btn">P</button>
                </div>
                <c:if test="${not empty sessionScope.loginMember}">
                  <div class='list-header'>
                    <a href="${pageContext.request.contextPath}/notice/writeFrm" class="write-post-btn">글쓰기</a> 
                  </div>
                </c:if>
            </div>

            <table class="post-table">
                <thead>
                    <tr>
                        <th>글번호</th>
                        <th style="width: 40%;">제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>조회수</th>
                        <th>좋아요</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty noticeList}">
                            <tr>
                                <td colspan="6" style="text-align:center; padding: 50px 0;">등록된 게시글이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="n" items="${noticeList}">
                                <tr>
                                    <td>${n.noticeNo}</td>
                                    <td class="post-title">
                                        <%-- 현재 페이지 번호(param.reqPage 또는 requestScope.reqPage)를 상세 보기 후 목록으로 돌아올 때 사용하기 위해 전달 --%>
                                        <a href="${pageContext.request.contextPath}/notice/view?noticeNo=${n.noticeNo}&reqPage=${not empty param.reqPage ? param.reqPage : requestScope.reqPage}">${n.noticeTitle}</a> 
                                    </td>
                                    <td>${n.noticeWriter}</td> 
                                    <td>${n.noticeDate}</td>
                                    <td>${n.readCount}</td>
                                    <td>-</td> 
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="board-footer">
                <div class="pagination">
                    <%-- HTML 태그가 포함된 pageNavi를 올바르게 출력 --%>
                    <c:out value="${pageNavi}" escapeXml="false" />
                </div>
            </div>

            <div class="board-search">
                <form action="${pageContext.request.contextPath}/notice/search"> 
                    <input type="hidden" name="reqPage" value="1">
                    <select name="searchType" class="search-type-select">
                        <option value="title">제목</option>
                        <option value="content">내용</option>
                        <option value="writer">작성자</option>
                    </select>
                    <input type="text" name="keyword" class="search-input" placeholder="검색어 입력">
                    <button type="submit" class="search-btn">검색</button>
                </form>
            </div>
        </div>
    </div>

    <div class="sidebar">
        <div class="login-box">
            <h3>로그인</h3>
            <c:choose>
                <c:when test="${empty sessionScope.loginMember}">
                    <form action="${pageContext.request.contextPath}/member/login" method="post">
                        <input type="text" name="memberId" placeholder="아이디" required>
                        <input type="password" name="memberPw" placeholder="비밀번호" required>
                        <button type="submit">로그인</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <%-- 
                        PropertyNotFoundException: [memberNickname] 오류 발생 시:
                        1. kr.or.iei.member.model.vo.Member 클래스에 public String getMemberNickname() 메소드가 있는지 확인하세요.
                        2. 필드명이나 getter 메소드명이 다르다면 ${sessionScope.loginMember.실제필드명} 으로 수정하세요.
                           (예: ${sessionScope.loginMember.nickname} 또는 ${sessionScope.loginMember.memberId})
                    --%>
                    <p><c:out value="${sessionScope.loginMember.memberNickname}"/>님, 환영합니다.</p> 
                    <button onclick="location.href='${pageContext.request.contextPath}/member/myPage'">마이페이지</button>
                    <button style="margin-top:5px;" onclick="location.href='${pageContext.request.contextPath}/member/logout'">로그아웃</button>
                </c:otherwise>
            </c:choose>
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
  <div class="footer-content-wrapper">
    <div class="footer_left">
      <pre>팀명 : 너티야 | 팀원: 김유진 성덕 왕윤식 윤서진 정다은</pre> 
    </div>
    <div class="footer_right">
      <a href="#">사이트 소개</a>
      <a href="#">이용약관</a>
      <a href="#">개인정보처리방침</a>
      <a href="#">고객센터</a>
    </div>
  </div>
</footer>

</body>
</html>