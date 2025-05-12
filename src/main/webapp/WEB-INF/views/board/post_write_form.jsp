<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>    
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>커뮤니티 - 글쓰기</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/default.css"> 
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/sweetalert.min.js"></script> 
  
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

  <style>
    /* === 통합 CSS 시작 (board_list.jsp와 동일한 내용) === */
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

    /* 게시판 목록 스타일 (글쓰기 페이지에서는 일부만 간접 적용) */
    .board-container { background-color: white; padding: 15px; border-radius: 10px; border: 1px solid #ccc; font-family: 'Pretendard', sans-serif; }
    .board-header { display: flex; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
    /* .board-header h2 ... */
    .board-icon { color: #ff3366; margin-right: 10px; font-size: 22px; }
    /* .board-filters-and-write, .mbti-filters, .mbti-filter-btn, .write-post-btn 등은 목록 페이지 전용 */
    
    /* 글쓰기 폼에만 적용되는 스타일 */
    .post-write-form-container { width: 100%; background-color: white; padding: 25px 30px; border: 1px solid #ccc; border-radius: 10px; } 
    .form-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
    .form-title { font-size: 22px; color: #333; margin-bottom: 0; } /* board-header h2 와 유사 */
    .form-title-icon { color: #ff3366; margin-right: 10px; font-size: 22px; } /* board-icon 과 유사 */
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
        <div class="post-write-form-container">
            <form id="writeForm" method="post" action="${pageContext.request.contextPath}/notice/write" enctype="multipart/form-data">
                <c:if test="${not empty sessionScope.loginMember}">
                    <input type="hidden" name="noticeWriter" value="${sessionScope.loginMember.memberNo}"> 
                </c:if>
                <input type="hidden" name="boardCode" value="N"> {/* 예시: 현재 글쓰는 게시판의 코드 (동적으로 설정 필요) */}

                <div class="form-header">
                    <h2 class="form-title"><span class="form-title-icon">&#10004;</span> 
                        <c:out value="${param.boardName eq null ? '공지사항' : param.boardName}"/> 글쓰기 <%-- URL 파라미터 등으로 게시판 이름 전달받아 표시 --%>
                    </h2>
                    <div class="form-actions">
                        <button type="button" class="form-btn-secondary">임시저장</button>
                        <button type="submit" class="form-btn-primary">등록</button> 
                    </div>
                </div>

                <div class="form-row form-row-inline">
                    <select name="noticeCategory" class="post-category-select-inline">  
                        <option value="">말머리 선택</option>
                        <%-- 실제 말머리는 해당 게시판(boardCode)에 따라 동적으로 로드 필요 --%>
                        <option value="GENERAL">일반</option> 
                        <option value="EVENT">이벤트</option>
                        <option value="IMPORTANT">중요</option>
                    </select>
                    <input type="text" name="noticeTitle" class="post-title-input-inline" placeholder="글 제목을 입력해주세요." required> 
                </div>

                <div class="form-row editor-section">
                    <textarea id="summernote_editor" name="noticeContent"></textarea> 
                </div>
                
                <div class="form-row">
                    <label for="file1">첨부파일 1:</label>
                    <input type="file" name="file1" id="file1" class="form-input-file">
                </div>
                <div class="form-row">
                    <label for="file2">첨부파일 2:</label>
                    <input type="file" name="file2" id="file2" class="form-input-file">
                </div>
                
                <div class="form-footer-note">
                    <p>Summernote 에디터가 적용되었습니다. 이미지 업로드 등은 서버 설정이 필요합니다.</p>
                </div>
            </form>
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
                        MemberVO 클래스에 public String getMemberNickname() 메소드가 있는지,
                        또는 필드명이 memberNickname인지 확인하고 EL을 ${sessionScope.loginMember.필드명}으로 수정하세요.
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

<script>
$(document).ready(function() {
    $('#summernote_editor').summernote({
        height: 350,                 
        minHeight: null,             
        maxHeight: null,             
        focus: true,                 
        lang: "ko-KR",               
        placeholder: '내용을 입력해주세요.',
        fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', '맑은 고딕', '궁서', '굴림체', '굴림', '돋움체', '돋움', 'Pretendard', 'sans-serif'],
        fontNamesIgnoreCheck: ['Pretendard'],
        fontSizes: ['8', '9', '10', '11', '12', '14', '16', '18', '20', '22', '24', '28', '30', '36', '50', '72'],
        toolbar: [ 
            ['fontname', ['fontname']],
            ['fontsize', ['fontsize']],
            ['style', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph', 'height']],
            // ['table', ['table']], 
            ['insert', ['link', 'picture', 'video']], 
            ['view', ['fullscreen', 'codeview']]
        ],
        callbacks: {
            onImageUpload: function(files) {
                alert('Summernote 이미지 업로드 기능은 실제 서버 연동 및 AJAX 로직 구현이 필요합니다.');
            }
        }
    });
});
</script>

</body>
</html>