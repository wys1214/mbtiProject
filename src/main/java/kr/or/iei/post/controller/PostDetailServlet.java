package kr.or.iei.post.controller; // 패키지 경로는 실제 프로젝트에 맞게 수정

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.member.model.vo.Member; // MemberVO 실제 경로로 수정 필요
import kr.or.iei.post.model.service.PostService;
import kr.or.iei.post.model.vo.Post; 
// kr.or.iei.post.model.vo.PostFile; // PostVO에 포함되어 있다면 여기선 불필요
// kr.or.iei.post.model.vo.CommentVO; // PostVO에 포함되어 있다면 여기선 불필요

@WebServlet("/post/view") // board_list.jsp의 게시글 제목 링크와 일치
public class PostDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public PostDetailServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String postNo = request.getParameter("postNo");
        String reqPageFromList = request.getParameter("reqPage"); // 목록으로 돌아갈 때 사용할 페이지 번호
        String boardTypeFromList = request.getParameter("boardType"); // 목록으로 돌아갈 때 사용할 게시판 타입

        if (postNo == null || postNo.trim().isEmpty()) {
            // postNo가 없으면 기본 목록으로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/board?type=notice&reqPage=1"); // 기본 공지사항 목록으로
            return;
        }

        PostService service = new PostService();
        
        // 1. 먼저 게시글 작성자 정보를 포함한 기본 정보를 가져옴 (조회수 증가 없이)
        //    PostService의 selectPostDetail이 이를 지원하거나, 별도 메소드(예: getPostForViewCheck) 필요
        //    여기서는 selectPostDetail을 isIncrementRequired=false로 호출하여 작성자 정보 등을 우선 확인합니다.
        Post postDataForCheck = service.selectPostDetail(postNo, false);

        if (postDataForCheck == null) { // 게시글 자체가 없는 경우
            request.setAttribute("title", "조회 실패");
            request.setAttribute("msg", "해당 게시글을 찾을 수 없거나 삭제되었습니다.");
            request.setAttribute("icon", "error");
            // 이전 목록으로 돌아갈 수 있도록 boardType과 reqPage를 전달
            String loc = "/board?type=" + (boardTypeFromList != null ? boardTypeFromList : "notice") + 
                         "&reqPage=" + (reqPageFromList != null ? reqPageFromList : "1");
            request.setAttribute("loc", loc);
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
            view.forward(request, response);
            return;
        }

        // 2. 조회수 증가 여부 결정
        boolean isIncrementRequired = false;
        HttpSession session = request.getSession();
        Member loginMember = (Member) session.getAttribute("loginMember");
        
        ArrayList<String> viewedPosts = (ArrayList<String>) session.getAttribute("viewedPosts");
        if (viewedPosts == null) {
            viewedPosts = new ArrayList<>();
            session.setAttribute("viewedPosts", viewedPosts); // 세션에 viewedPosts 리스트가 없으면 새로 생성
        }

        // 로그인하지 않았거나, 로그인했지만 작성자가 아닌 경우에만 조회수 증가 로직 적용 대상
        if (loginMember == null || loginMember.getMemberNo() != postDataForCheck.getPostMemberNo()) {
            if (!viewedPosts.contains(postNo)) {
                // 아직 이 세션에서 해당 글을 보지 않았다면 조회수 증가 필요
                isIncrementRequired = true;
            }
        }
        
        // 3. 실제 게시글 정보 가져오기 (필요시 조회수 증가 포함)
        //    이때 PostService.selectPostDetail은 내부적으로 조회수 증가 처리 후,
        //    게시글 정보, 첨부파일 목록, 댓글 목록을 모두 포함한 Post 객체를 반환해야 함.
        Post post = service.selectPostDetail(postNo, isIncrementRequired); 

        if (post != null) {
            if (isIncrementRequired) { // 실제로 조회수가 증가되었다면 세션에 기록
                viewedPosts.add(postNo);
                // session.setAttribute("viewedPosts", viewedPosts); // 위에서 이미 setAttribute 했으므로 생략 가능
            }

            request.setAttribute("post", post); // JSP에서 사용할 이름 "post"
            request.setAttribute("reqPage", reqPageFromList); // 목록으로 돌아갈 때 사용할 reqPage
            request.setAttribute("currentBoardType", boardTypeFromList); // 목록으로 돌아갈 때 사용할 boardType

            // 게시판 이름 설정 (Post 객체에 boardCode가 있다고 가정)
            String boardName = "";
            if (post.getBoardCode() != null) {
                if("N".equals(post.getBoardCode())) boardName = "공지사항";
                else if("F".equals(post.getBoardCode())) boardName = "자유게시판";
                else if("W".equals(post.getBoardCode())) boardName = "고민있어요";
                else if("R".equals(post.getBoardCode())) boardName = "추천합니다";
                else if("B".equals(post.getBoardCode())) boardName = "베스트게시글";
                else if("I".equals(post.getBoardCode())) boardName = "가입인사";
                else if("T".equals(post.getBoardCode())) boardName = "테스트할래요";
                else boardName = "게시판"; // 기타
            }
            request.setAttribute("boardTitle", boardName);

            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/post/post_detail.jsp");
            view.forward(request, response);
        } else {
            // service.selectPostDetail(postNo, false)에서는 데이터를 찾았으나,
            // isIncrementRequired=true로 다시 호출했을 때 null이 되는 경우는 드물지만, 예외적으로 처리
            request.setAttribute("title", "오류 발생");
            request.setAttribute("msg", "게시글을 불러오는 중 문제가 발생했습니다.");
            request.setAttribute("icon", "error");
            String loc = "/board?type=" + (boardTypeFromList != null ? boardTypeFromList : "notice") + 
                         "&reqPage=" + (reqPageFromList != null ? reqPageFromList : "1");
            request.setAttribute("loc", loc);
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
            view.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}