package kr.or.iei.post.controller; // 패키지명 변경

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/post/writeFrm") // URL 매핑 변경 (예시)
public class PostWriteFrmServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public PostWriteFrmServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 글쓰기 전 로그인 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginMember") == null) {
            request.setAttribute("title", "접근 제한");
            request.setAttribute("msg", "글쓰기는 로그인 후 이용 가능합니다.");
            request.setAttribute("icon", "warning");
            request.setAttribute("loc", request.getContextPath() + "/member/loginFrm"); // 로그인 페이지 경로
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
            view.forward(request, response);
            return;
        }

        // 어떤 게시판에 글을 쓰는지 파라미터로 받아서 JSP에 전달
        String boardCode = request.getParameter("boardCode");
        String boardName = "";
        if (boardCode == null || boardCode.isEmpty()) {
            boardCode = "N"; // 기본값 (또는 오류 처리)
            boardName = "공지사항";
        } else {
            if("N".equals(boardCode)) boardName = "공지사항";
            else if("F".equals(boardCode)) boardName = "자유게시판";
            // ... 기타 게시판 이름 설정 ...
        }
        request.setAttribute("currentBoardCode", boardCode);
        request.setAttribute("boardName", boardName);

        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/post/post_write_form.jsp"); // JSP 경로 수정
        view.forward(request, response);
    }
}