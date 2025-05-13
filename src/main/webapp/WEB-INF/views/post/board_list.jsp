<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>    
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>커뮤니티 갤러리 - <c:out value="${boardTitle}" default="게시판"/></title>
  <%-- <link rel="stylesheet" href="/resources/css/default.css"> --%> <%-- 사용자 요청에 따라 주석 유지 --%>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="/resources/js/sweetalert.min.js"></script> <%-- 컨텍스트 경로 불필요 가정 --%>
  
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

  <style>
    /* === 통합 CSS 시작 (이전 답변의 style.css 내용과 동일) === */
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
	    margin-top: 30px; 
	    margin-bottom: 20px; 
	    padding-left: 0; 
	}
	.pagination ul.circle-style { 
	    list-style: none; 
	    padding: 0; 
	    margin: 0; 
	    display: flex; 
	    align-items: center; 
	} 
	.pagination ul.circle-style li { 
	    display: inline-block; 
	    margin: 0 4px; 
	}
	.pagination ul.circle-style li a.page-item,
	.pagination ul.circle-style li span.page-item { 
	    color: #333;
	    padding: 8px 12px; 
	    text-decoration: none;
	    border: 1px solid #ddd;
	    border-radius: 4px; 
	    font-size: 14px;
	    line-height: 1.5; 
	    display: inline-block; 
	    background-color: white; 
	    transition: background-color 0.2s ease, color 0.2s ease, border-color 0.2s ease;
	}
	.pagination ul.circle-style li a.page-item:hover {
	    background-color: #f1f1f1; 
	    border-color: #ccc;
	    color: #333;
	}
	.pagination ul.circle-style li a.page-item.active-page,
	.pagination ul.circle-style li span.page-item.active-page { 
	    background-color: #ff3366; 
	    color: white;
	    border-color: #ff3366;
	    font-weight: bold;
	}
	.pagination ul.circle-style li a.page-item .material-icons,
	.pagination ul.circle-style li span.page-item .material-icons { 
	    font-size: 20px; 
	    vertical-align: middle; 
	}
	.pagination ul.circle-style li span.ellipsis {
	    padding: 8px 6px;
	    color: #777;
	}

    .board-search { display: flex; justify-content: center; align-items: center; gap: 8px; margin-bottom: 20px; padding: 15px; background-color: #f5f3f3; border-radius: 8px; }
    .search-type-select, .board-search .search-input { padding: 8px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; font-family: 'Pretendard', sans-serif; }
    .board-search .search-input { width: 250px; }
    .search-btn { padding: 8px 15px; background: #ff3366; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; }
    .search-btn:hover { background: #ff3366da; }

    /* 글쓰기 폼에만 적용되는 스타일 (post_write_form.jsp에서 사용) */
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

    /* 게시글 상세 보기 스타일 (post_detail.jsp에서 사용) */
    .post-detail-container { background-color: white; padding: 25px 30px; border: 1px solid #ccc; border-radius: 10px; }
    .post-view-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
    .board-title { font-size: 22px; color: #333; margin-bottom: 0; display: flex; align-items: center; }
    /* .board-icon 은 이미 정의됨 */
    .post-navigation button, .post-navigation a.btn-list {
        background-color: #f1f1f1; color: #333; border: 1px solid #ddd; padding: 6px 12px;
        margin-left: 8px; border-radius: 4px; font-size: 14px; cursor: pointer; text-decoration: none;
    }
    .post-navigation button:hover, .post-navigation a.btn-list:hover { background-color: #e0e0e0; }
    .post-navigation a.btn-list { background-color: #6c757d; color: white; border-color: #6c757d;}
    .post-navigation a.btn-list:hover { background-color: #5a6268; }
    .post-title-area { padding: 20px 0; border-bottom: 1px solid #eee; }
    .post-title-area h3 { font-size: 28px; font-weight: 600; margin: 0; color: #333; line-height: 1.4;}
    .post-meta-area { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; font-size: 14px; color: #555; border-bottom: 1px solid #eee; flex-wrap: wrap;}
    .author-info .author-name { font-weight: bold; color: #333; }
    .author-info .post-date, .author-info .view-count { margin-left: 15px; color: #777; }
    .post-actions a { color: #007bff; text-decoration: none; margin-left: 10px; font-size: 14px; }
    .post-actions a:hover { text-decoration: underline; }
    .post-actions .btn-delete { color: #dc3545; }
    .post-content-area { padding: 25px 5px; line-height: 1.8; font-size: 16px; min-height: 200px; word-wrap: break-word; white-space: pre-wrap; }
    .post-content-area img { max-width: 100%; height: auto; border-radius: 4px; margin: 10px 0; }
    .post-content-area table { width: auto !important; max-width:100%; border-collapse: collapse !important; margin: 1em 0 !important; }
    .post-content-area table td, .post-content-area table th { border: 1px solid #ccc !important; padding: 5px !important; }
    .post-files-area { padding: 15px 0; border-top: 1px solid #eee; border-bottom: 1px solid #eee; margin: 20px 0; }
    .post-files-area h4 { font-size: 16px; margin-bottom: 10px; }
    .post-files-area ul { list-style: none; padding-left: 0; }
    .post-files-area li { margin-bottom: 5px; }
    .post-files-area li a { text-decoration: none; color: #007bff; font-size: 14px; }
    .post-files-area li a:hover { text-decoration: underline; }
    .comment-section { margin-top: 30px; padding-top: 20px; border-top: 2px solid #ddd; }
    .comment-section > h4 { font-size: 18px; margin-bottom: 20px; color: #333; }
    .comment-list .no-comments { text-align: center; color: #777; padding: 20px; }
    .comment-item { padding: 15px 0; border-bottom: 1px dotted #eee; }
    .comment-item:last-child { border-bottom: none; }
    .comment-author-info { display: flex; align-items: center; margin-bottom: 8px; font-size: 13px; color: #777; }
    .comment-author-info .comment-author { font-weight: bold; color: #333; margin-right: 10px; }
    .comment-author-info .comment-date { margin-right: auto; }
    .comment-action { margin-left: 10px; color: #007bff; cursor: pointer; font-size: 12px; background: none; border: none; padding:0; }
    .comment-action:hover { text-decoration: underline; }
    .comment-action.delete-comment-btn { color: #dc3545; }
    .comment-content { font-size: 14px; line-height: 1.7; color: #444; padding-left: 5px; white-space: pre-wrap; word-wrap: break-word; }
    .comment-item.reply-item { margin-left: 40px; border-top: 1px dashed #f0f0f0; padding-top: 15px; margin-top: 10px; }
    .comment-form-container { margin-top: 25px; padding: 20px; background-color: #f9f9f9; border-radius: 8px; }
    .comment-form-container.new-comment-form { margin-bottom: 20px; }
    .comment-form-container h5 { font-size: 16px; margin-bottom: 10px; }
    .comment-form-container textarea { width: 100%; min-height: 70px; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; font-family: 'Pretendard', sans-serif; resize: vertical; margin-bottom: 10px; }
    .btn-submit-comment { background: #5cb85c; color: white; padding: 8px 15px; border: none; border-radius: 4px; font-size: 14px; cursor: pointer; float: right; }
    .btn-submit-comment:hover { background: #4cae4c; }
    .login-prompt-for-comment { clear:both; text-align: center; padding: 20px 0; font-size: 14px; color: #777; }
    .login-prompt-for-comment a { color: #ff3366; font-weight: bold; }
        
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

<%-- 헤더 Include --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="container">
    <div class="main">
        <div class="board-container">
            <div class="board-header">
                <h2><span class="board-icon">&#10004;</span> 
                    <c:out value="${boardTitle}" default="게시판"/>
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
                    <a href="/post/writeFrm?boardType=${currentBoardType}&boardCode=${currentBoardCode}" class="write-post-btn">글쓰기</a> 
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
                        <c:when test="${empty postList}"> 
                            <tr>
                                <td colspan="6" style="text-align:center; padding: 50px 0;">등록된 게시글이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${postList}"> 
                                <tr>
                                    <td>${p.postNo}</td> 
                                    <td class="post-title">
                                        <a href="/post/view?postNo=${p.postNo}&boardType=${currentBoardType}&reqPage=${reqPage}">${p.postTitle}</a> 
                                    </td>
                                    <td>${p.postWriterNickname}</td> 
                                    <td>${p.postDate}</td> 
                                    <td>${p.postViewCount}</td> 
                                    <td>-</td> 
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="board-footer">
                <div class="pagination">
                    <c:out value="${pageNavi}" escapeXml="false" />
                </div>
            </div>

            <div class="board-search">
                <form action="/board">  
                    <input type="hidden" name="type" value="${currentBoardType}"> 
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
        <%@ include file="/WEB-INF/views/common/loginbar.jsp" %>
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

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>