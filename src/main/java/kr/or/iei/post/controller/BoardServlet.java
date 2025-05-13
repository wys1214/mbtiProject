package kr.or.iei.post.controller; // 또는 kr.or.iei.post.controller 등 적절한 패키지

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.common.ListData;
import kr.or.iei.post.model.service.PostService; // PostService 사용
import kr.or.iei.post.model.vo.Post;          // Post VO 사용

@WebServlet("/board") // 단일 URL 매핑으로 통합
public class BoardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public BoardServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. 요청 파라미터 추출
        String boardTypeParam = request.getParameter("type"); // "notice", "free" 등
        int reqPage = 1;
        String reqPageParam = request.getParameter("reqPage");
        if (reqPageParam != null && !reqPageParam.isEmpty()) {
            try {
                reqPage = Integer.parseInt(reqPageParam);
            } catch (NumberFormatException e) {
                // reqPage 형식이 숫자가 아니면 기본값 1 사용
                System.out.println("BoardServlet: 잘못된 reqPage 파라미터 [" + reqPageParam + "], 기본값 1 사용.");
            }
        }

        // 2. boardTypeParam에 따른 boardCode 및 boardTitle 설정
        String boardCode = "";  // 실제 DB의 tbl_board.board_code 값
        String boardTitle = "";   // JSP에 표시될 게시판 제목

        if ("notice".equals(boardTypeParam)) {
            boardCode = "N"; boardTitle = "공지사항";
        } else if ("free".equals(boardTypeParam)) {
            boardCode = "F"; boardTitle = "자유게시판";
        } else if ("worry".equals(boardTypeParam)) {
            boardCode = "W"; boardTitle = "고민있어요";
        } else if ("recommend".equals(boardTypeParam)) {
            boardCode = "R"; boardTitle = "추천합니다";
        } else if ("best".equals(boardTypeParam)) {
            boardCode = "B"; boardTitle = "베스트게시글";
        } else if ("intro".equals(boardTypeParam)) {
            boardCode = "I"; boardTitle = "가입인사";
        } else if ("test".equals(boardTypeParam)) {
            boardCode = "T"; boardTitle = "테스트할래요";
        } else {
            // 유효하지 않거나 없는 type 파라미터 처리 (예: 기본 공지사항으로)
            boardCode = "N"; 
            boardTitle = "공지사항";
            System.out.println("BoardServlet: 알 수 없거나 누락된 board type [" + boardTypeParam + "], 기본 '공지사항'으로 설정.");
        }

        System.out.println("BoardServlet: boardTypeParam=" + boardTypeParam + ", boardCode=" + boardCode + ", reqPage=" + reqPage);


        // 3. PostService를 통해 게시글 목록 및 페이지네이션 정보 조회
        PostService service = new PostService();
        // PostService의 selectPostList는 boardType 파라미터도 받아 pageNavi 링크를 올바르게 생성해야 함
        ListData<Post> ld = service.selectPostList(reqPage, boardCode, boardTypeParam); // contextPath는 서비스에서 더 이상 필요 없음 (상대 경로 사용 가정)

        System.out.println("BoardServlet: Service로부터 받은 postList 크기: " + (ld != null && ld.getList() != null ? ld.getList().size() : "null 또는 비었음"));
        System.out.println("BoardServlet: Service로부터 받은 pageNavi: " + (ld != null ? ld.getPageNavi() : "null"));


        // 4. JSP로 전달할 데이터 설정
        request.setAttribute("postList", ld.getList());
        request.setAttribute("pageNavi", ld.getPageNavi());
        request.setAttribute("boardTitle", boardTitle);         // 현재 게시판 제목
        request.setAttribute("currentBoardCode", boardCode);     // 현재 게시판 코드 (글쓰기 등에서 사용)
        request.setAttribute("currentBoardType", boardTypeParam); // 현재 게시판 타입 (페이지네이션 링크, 글쓰기 등에 사용)
        request.setAttribute("reqPage", reqPage); // 현재 페이지 번호 (상세보기 후 목록으로 돌아올 때 사용)


        // 5. 게시판 목록 JSP로 포워딩
        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/post/board_list.jsp"); // 실제 JSP 경로
        view.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // POST 요청이 올 경우 GET으로 넘겨서 동일하게 처리 (검색 등)
        doGet(request, response);
    }
}