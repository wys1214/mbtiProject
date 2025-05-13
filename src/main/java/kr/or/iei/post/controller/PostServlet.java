package kr.or.iei.post.controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import kr.or.iei.common.ListData;
import kr.or.iei.post.model.service.PostService;
import kr.or.iei.post.model.vo.Post;

@WebServlet("/board/noticeGetList")
public class PostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
        
    public PostServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int reqPage = 1;
        if (request.getParameter("reqPage") != null) {
            try {
                reqPage = Integer.parseInt(request.getParameter("reqPage"));
            } catch (NumberFormatException e) {
                // 기본값 사용
            }
        }
        
        // 어떤 게시판의 목록을 보여줄지 결정 (예: 파라미터로 boardCode 받기)
        // String boardCode = request.getParameter("boardCode");
        // if (boardCode == null || boardCode.isEmpty()) {
        //     boardCode = "N"; // 기본값: 공지사항 게시판 코드 'N'이라고 가정
        // }

        PostService service = new PostService();
        // TODO: NoticeService의 selectNoticeList가 boardCode를 인자로 받도록 수정 필요
        // ListData<Notice> listData = service.selectNoticeList(reqPage, boardCode); 
        ListData<Post> listData = service.selectPostList(reqPage); // 현재는 boardCode 없이 호출

        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/board/noticeBoard.jsp");
        
        request.setAttribute("postList", listData.getList());
        request.setAttribute("pageNavi", listData.getPageNavi());
        
        // 현재 게시판 정보 전달 (JSP에서 제목 등에 활용)
        // String boardName = "";
        // if("N".equals(boardCode)) boardName = "공지사항";
        // else if("F".equals(boardCode)) boardName = "자유게시판"; // 예시
        // request.setAttribute("boardTitle", boardName);
        // request.setAttribute("currentBoardCode", boardCode);
        
        view.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}