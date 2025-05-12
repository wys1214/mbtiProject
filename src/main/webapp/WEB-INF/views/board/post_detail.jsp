<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> <%-- fn:length 사용을 위해 추가 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>커뮤니티 - <c:out value="${post.postTitle}" default="게시글 상세 보기"/> </title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/default.css"> 
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/sweetalert.min.js"></script> 
  
  <%-- Summernote는 글쓰기/수정 시 필요. 보기 페이지에는 필수는 아님. 필요시 유지. --%>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

  <style>
    /* === 통합 CSS 시작 (board_list.jsp의 CSS와 동일한 내용 + 아래 상세 보기 스타일 추가) === */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body { height: 100%; }
    body { display: flex; flex-direction: column; min-height: 100vh; font-family: 'Pretendard', sans-serif; background-color: #fafafa; color: #333; }

    /* 헤더 스타일 (board_list.jsp와 동일) */
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
    
    /* 전체 레이아웃 (board_list.jsp와 동일) */
    .container { display: flex; max-width: 1200px; margin: 30px auto; gap: 20px; flex-grow: 1; }
    .main { flex: 3; }
    .sidebar { flex: 1; }
    h2 { font-size: 22px; margin-bottom: 20px; color: #333; }
    
    /* 사이드바 (board_list.jsp와 동일) */
    .login-box, .point-box { background: white; border: 1px solid #ccc; border-radius: 10px; padding: 15px; margin-bottom: 20px; }
    .login-box input[type="text"], .login-box input[type="password"] { width: 100%; padding: 8px; margin-bottom: 8px; border: 1px solid #ccc; border-radius: 5px; }
    .login-box button { width: 100%; padding: 8px; background: #ff3366; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; }
    .login-box button:hover { background: #ff3366da; }
    .point-box h3 { font-size: 16px; margin-bottom: 10px; color: #333; }
    .point-box ol { list-style: none; font-size: 14px; padding-left: 0; }
    .point-box li { padding: 6px 0; border-bottom: 1px dashed #eee; }

    /* ===== 게시글 상세 보기 스타일 시작 ===== */
    .post-detail-container { background-color: white; padding: 25px 30px; border: 1px solid #ccc; border-radius: 10px; }
    .post-view-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
    .board-title { font-size: 22px; color: #333; margin-bottom: 0; display: flex; align-items: center; }
    .board-icon { color: #ff3366; margin-right: 8px; font-size: 20px; } /* board_list.jsp와 아이콘 크기 등 통일 */
    .post-navigation button, .post-navigation a.btn-list { /* 목록 버튼 클래스명 변경 */
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
    .post-content-area table { width: auto !important; max-width:100%; border-collapse: collapse !important; margin: 1em 0 !important; } /* Summernote 테이블 스타일 오버라이드 예시 */
    .post-content-area table td, .post-content-area table th { border: 1px solid #ccc !important; padding: 5px !important; }

    .post-files-area { padding: 15px 0; border-top: 1px solid #eee; border-bottom: 1px solid #eee; margin: 20px 0; }
    .post-files-area h4 { font-size: 16px; margin-bottom: 10px; }
    .post-files-area ul { list-style: none; padding-left: 0; }
    .post-files-area li { margin-bottom: 5px; }
    .post-files-area li a { text-decoration: none; color: #007bff; font-size: 14px; }
    .post-files-area li a:hover { text-decoration: underline; }

    .comment-section { margin-top: 30px; padding-top: 20px; border-top: 2px solid #ddd; }
    .comment-section > h4 { font-size: 18px; margin-bottom: 20px; color: #333; } /* 댓글 전체 개수 표시용 h4 */
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
    .comment-form-container.new-comment-form { margin-bottom: 20px; } /* 새 댓글 폼 하단 마진 */
    .comment-form-container h5 { font-size: 16px; margin-bottom: 10px; }
    .comment-form-container textarea { width: 100%; min-height: 70px; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; font-family: 'Pretendard', sans-serif; resize: vertical; margin-bottom: 10px; }
    .btn-submit-comment { background: #5cb85c; color: white; padding: 8px 15px; border: none; border-radius: 4px; font-size: 14px; cursor: pointer; float: right; }
    .btn-submit-comment:hover { background: #4cae4c; }
    .login-prompt-for-comment { clear:both; text-align: center; padding: 20px 0; font-size: 14px; color: #777; }
    .login-prompt-for-comment a { color: #ff3366; font-weight: bold; }
    /* ===== 게시글 상세 보기 스타일 끝 ===== */

    /* 하단 footer (board_list.jsp와 동일) */
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
        <div class="post-detail-container">
            <div class="post-view-header">
                <h2 class="board-title">
                    <span class="board-icon">
                        <c:choose>
                            <c:when test="${post.boardCode == 'N'}">&#128226;</c:when> <%-- 공지 아이콘 예시 --%>
                            <c:when test="${post.boardCode == 'F'}">&#128172;</c:when> <%-- 자유 아이콘 예시 --%>
                            <c:otherwise>&#128221;</c:otherwise> <%-- 기본 아이콘 예시 --%>
                        </c:choose>
                    </span> 
                    <c:choose>
                        <c:when test="${post.boardCode == 'N'}">공지사항</c:when>
                        <c:when test="${post.boardCode == 'F'}">자유게시판</c:when>
                        <%-- 다른 boardCode에 따른 게시판 이름 추가 --%>
                        <c:otherwise>게시판</c:otherwise>
                    </c:choose>
                </h2>
                <div class="post-navigation">
                    <%-- 이전/다음글 기능은 PostVO에 prevPostNo, nextPostNo, prevPostTitle, nextPostTitle 등을 포함시켜야 함 --%>
                    <button type="button" class="btn-grey" onclick="location.href='${pageContext.request.contextPath}/post/view?postNo=${post.prevPostNo}'" <c:if test="${empty post.prevPostNo}">disabled</c:if>>이전글</button>
                    <button type="button" class="btn-grey" onclick="location.href='${pageContext.request.contextPath}/post/view?postNo=${post.nextPostNo}'" <c:if test="${empty post.nextPostNo}">disabled</c:if>>다음글</button>
                    <a href="${pageContext.request.contextPath}/notice/getList?reqPage=${param.reqPage eq null ? 1 : param.reqPage}" class="btn-list">목록</a>
                </div>
            </div>

            <div class="post-title-area">
                <h3><c:out value="${post.postTitle}" /></h3>
            </div>

            <div class="post-meta-area">
                <div class="author-info">
                    <span class="author-name"><c:out value="${post.postWriterNickname}" /></span>
                    <span class="post-date">작성일: <c:out value="${post.postCreationDate}" /></span>
                    <c:if test="${not empty post.postUpdateDate && post.postUpdateDate != post.postCreationDate}">
                        <span class="post-date">(수정일: <c:out value="${post.postUpdateDate}" />)</span>
                    </c:if>
                    <span class="view-count">조회: <c:out value="${post.postViewCount}" /></span>
                </div>
                <div class="post-actions">
                    <c:if test="${not empty sessionScope.loginMember && sessionScope.loginMember.memberNo == post.memberNo}">
                        <a href="${pageContext.request.contextPath}/notice/updateFrm?noticeNo=${post.postNo}" class="btn-edit">수정</a>
                        <a href="${pageContext.request.contextPath}/notice/delete?noticeNo=${post.postNo}" class="btn-delete" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a>
                    </c:if>
                </div>
            </div>

            <div class="post-content-area">
                <%-- Summernote로 작성된 HTML 내용을 그대로 출력 --%>
                ${post.postContent}
            </div>

            <c:if test="${not empty post.fileList}">
                <div class="post-files-area">
                    <h4>첨부파일</h4>
                    <ul>
                        <c:forEach var="file" items="${post.fileList}">
                            <li>
                                <%-- 실제 파일 다운로드 서블릿 경로 및 파라미터로 수정 필요 --%>
                                <a href="${pageContext.request.contextPath}/download?fileNo=${file.fileNo}"><c:out value="${file.originalFileName}" /> 
                                    (<fmt:formatNumber value="${file.fileSize / 1024}" maxFractionDigits="2"/> KB) 
                                    <%-- 파일 크기를 KB 또는 MB로 표시하기 위해 fmt 태그 라이브러리 추가 또는 직접 계산 --%>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <div class="comment-section">
                <h4>댓글 <span id="comment-count">${fn:length(post.commentList)}</span>개</h4>
                
                <div class="comment-list">
                    <c:if test="${empty post.commentList}">
                        <p class="no-comments">등록된 댓글이 없습니다. 첫 댓글을 작성해보세요!</p>
                    </c:if>
                    <c:forEach var="comment" items="${post.commentList}">
                        <c:if test="${empty comment.parentCommentNo}"> <%-- 최상위 댓글만 먼저 루프 --%>
                            <div class="comment-item" id="comment-${comment.commentNo}">
                                <div class="comment-author-info">
                                    <strong class="comment-author"><c:out value="${comment.commentWriterNickname}" /></strong>
                                    <span class="comment-date"><c:out value="${comment.commentCreationDate}" /></span>
                                    <div style="margin-left:auto;"> <%-- 버튼들을 오른쪽으로 밀기 위한 div --%>
                                        <c:if test="${not empty sessionScope.loginMember && sessionScope.loginMember.memberNo == comment.memberNo}">
                                            <button type="button" class="comment-action edit-comment-btn" data-comment-no="${comment.commentNo}">수정</button>
                                            <button type="button" class="comment-action delete-comment-btn" data-comment-no="${comment.commentNo}">삭제</button>
                                        </c:if>
                                        <button type="button" class="comment-action reply-comment-btn" data-comment-no="${comment.commentNo}">답글</button>
                                    </div>
                                </div>
                                <div class="comment-content"><c:out value="${comment.commentContent}" escapeXml="false"/></div> <%-- 댓글 내용은 pre-wrap 등으로 줄바꿈 표시되므로 escapeXml false --%>
                                
                                <%-- 대댓글 표시 --%>
                                <c:forEach var="reply" items="${post.commentList}">
                                    <c:if test="${not empty reply.parentCommentNo && reply.parentCommentNo == comment.commentNo}">
                                        <div class="comment-item reply-item" id="comment-${reply.commentNo}">
                                            <div class="comment-author-info">
                                                <strong class="comment-author"><c:out value="${reply.commentWriterNickname}" /></strong>
                                                <span class="comment-date"><c:out value="${reply.commentCreationDate}" /></span>
                                                <div style="margin-left:auto;">
                                                    <c:if test="${not empty sessionScope.loginMember && sessionScope.loginMember.memberNo == reply.memberNo}">
                                                        <button type="button" class="comment-action edit-comment-btn" data-comment-no="${reply.commentNo}">수정</button>
                                                        <button type="button" class="comment-action delete-comment-btn" data-comment-no="${reply.commentNo}">삭제</button>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="comment-content"><c:out value="${reply.commentContent}" escapeXml="false"/></div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                 <div class="reply-form-container" id="reply-form-${comment.commentNo}" style="display:none; margin-left: 40px; margin-top:10px;">
                                    <form class="comment-form reply-form" action="${pageContext.request.contextPath}/comment/addReply" method="post">
                                        <input type="hidden" name="postNo" value="${post.postNo}">
                                        <input type="hidden" name="parentCommentNo" value="${comment.commentNo}">
                                        <c:if test="${not empty sessionScope.loginMember}">
                                            <input type="hidden" name="memberNo" value="${sessionScope.loginMember.memberNo}">
                                            <textarea name="commentContent" placeholder="답글을 입력하세요..." required rows="3"></textarea>
                                            <button type="submit" class="btn-submit-comment">답글 등록</button>
                                        </c:if>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>

                <c:if test="${not empty sessionScope.loginMember}">
                    <div class="comment-form-container new-comment-form">
                        <h5>댓글 쓰기</h5>
                        <form id="newCommentForm" action="${pageContext.request.contextPath}/comment/add" method="post">
                            <input type="hidden" name="postNo" value="${post.postNo}">
                            <input type="hidden" name="memberNo" value="${sessionScope.loginMember.memberNo}">
                            <textarea name="commentContent" placeholder="댓글을 입력하세요..." required rows="4"></textarea>
                            <button type="submit" class="btn-submit-comment">댓글 등록</button>
                        </form>
                    </div>
                </c:if>
                <c:if test="${empty sessionScope.loginMember}">
                    <p class="login-prompt-for-comment">댓글을 작성하려면 <a href="${pageContext.request.contextPath}/member/loginFrm?returnUrl=${pageContext.request.contextPath}/post/view?postNo=${post.postNo}">로그인</a>하세요.</p>
                </c:if>
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
<script>
    // 답글 폼 토글 스크립트 예시
    $(document).ready(function(){
        $('.reply-comment-btn').on('click', function(e){
            e.preventDefault();
            var commentNo = $(this).data('comment-no');
            $('#reply-form-' + commentNo).toggle();
        });
    });
</script>
</body>
</html>