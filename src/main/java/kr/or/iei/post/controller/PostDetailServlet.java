package kr.or.iei.post.controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.member.model.vo.Member; // MemberVO 경로 확인
import kr.or.iei.post.model.service.PostService;
import kr.or.iei.post.model.vo.Post;
// CommentVO, PostFileVO 등 필요에 따라 import

@WebServlet("/post/view") // URL 매핑 (board_list.jsp의 게시글 제목 링크와 일치해야 함)
public class PostDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public PostDetailServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String postNo = request.getParameter("postNo"); // 링크의 파라미터 이름과 일치
        String reqPageFromList = request.getParameter("reqPage"); // 목록으로 돌아갈 때 사용할 페이지 번호

        if (postNo == null || postNo.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/post/list?reqPage=1"); // 기본 목록으로
            return;
        }

        boolean isIncrementRequired = false;
        HttpSession session = request.getSession();
        ArrayList<String> viewedPosts = (ArrayList<String>) session.getAttribute("viewedPosts");
        if (viewedPosts == null) {
            viewedPosts = new ArrayList<>();
        }
        
        PostService service = new PostService();
        Post postForAuthorCheck = service.selectPostDetail(postNo, false); // 조회수 증가 없이 작성자 정보만 먼저 확인

        if (postForAuthorCheck != null) {
            Member loginMember = (Member) session.getAttribute("loginMember");
            if (loginMember == null || loginMember.getMemberNo() != postForAuthorCheck.getMemberNo()) {
                // 로그인하지 않았거나, 로그인했지만 작성자가 아닌 경우 조회수 증가 로직 적용
                if (!viewedPosts.contains(postNo)) {
                    viewedPosts.add(postNo);
                    session.setAttribute("viewedPosts", viewedPosts);
                    isIncrementRequired = true;
                }
            }
        } else { // 게시글 자체가 없는 경우
             request.setAttribute("title", "조회 실패");
            request.setAttribute("msg", "해당 게시글을 찾을 수 없거나 삭제되었습니다.");
            request.setAttribute("icon", "error");
            request.setAttribute("loc", request.getContextPath() + "/post/list?reqPage=1&boardCode=N"); // 기본 게시판 목록으로
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
            view.forward(request, response);
            return;
        }
        
        Post post = service.selectPostDetail(postNo, isIncrementRequired); 

        if (post != null) {
            request.setAttribute("post", post); 
            request.setAttribute("reqPage", reqPageFromList); 
            
            // 게시판 이름 설정 (PostVO에 boardName이 없다면 boardCode로 분기)
            String boardName = "";
            if("N".equals(post.getBoardCode())) boardName = "공지사항";
            else if("F".equals(post.getBoardCode())) boardName = "자유게시판";
            // ...
            request.setAttribute("boardTitle", boardName);


            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/post/post_detail.jsp"); // 상세 보기 JSP 경로
            view.forward(request, response);
        } else {
            request.setAttribute("title", "조회 실패");
            request.setAttribute("msg", "해당 게시글을 찾을 수 없거나 삭제되었습니다.");
            request.setAttribute("icon", "error");
            request.setAttribute("loc", request.getContextPath() + "/post/list?reqPage=1&boardCode=N"); // 기본 게시판 목록으로
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
            view.forward(request, response);
        }
    }
}