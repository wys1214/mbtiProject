package kr.or.iei.post.controller; // 패키지명 변경

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

@WebServlet("/post/list") // URL 매핑 변경 (예시)
public class PostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
        
    public PostServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int reqPage = 1;
        if (request.getParameter("reqPage") != null && !request.getParameter("reqPage").isEmpty()) {
            try {
                reqPage = Integer.parseInt(request.getParameter("reqPage"));
            } catch (NumberFormatException e) {
                // 기본값 사용 또는 오류 처리
            }
        }
        
        // 게시판 코드를 파라미터로 받음 (예: ?boardCode=N)
        String boardCode = request.getParameter("boardCode");
        if (boardCode == null || boardCode.isEmpty()) {
            boardCode = "N"; // 기본 게시판 코드를 'N'(공지사항)으로 가정
        }

        PostService service = new PostService();
        ListData<Post> ld = service.selectPostList(reqPage, boardCode); 
        
        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/post/board_list.jsp"); // JSP 경로 수정
        
        request.setAttribute("postList", ld.getList()); // "postList"로 이름 변경
        request.setAttribute("pageNavi", ld.getPageNavi());
        
        // 현재 게시판 정보 전달 (JSP에서 제목 등에 활용)
        String boardName = "";
        if("N".equals(boardCode)) boardName = "공지사항";
        else if("F".equals(boardCode)) boardName = "자유게시판"; // 예시
        // ... 기타 게시판 이름 설정 ...
        request.setAttribute("boardTitle", boardName);
        request.setAttribute("currentBoardCode", boardCode); // JSP에서 글쓰기 링크 등에 활용 가능
        
        view.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}