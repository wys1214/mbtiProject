package kr.or.iei.post.controller; // 패키지명 변경

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;

import kr.or.iei.common.KhRenamePolicy;
import kr.or.iei.member.model.vo.Member;       // MemberVO 임포트
import kr.or.iei.post.model.service.PostService; // PostService 사용
import kr.or.iei.post.model.vo.Post;          // Post VO 사용
import kr.or.iei.post.model.vo.PostFile;      // PostFile VO 사용

@WebServlet("/post/write") // URL 매핑 변경 (예시)
public class PostWriteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
        
    public PostWriteServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginMember") == null) {
            request.setAttribute("title", "접근 제한");
            request.setAttribute("msg", "글쓰기는 로그인 후 이용 가능합니다.");
            request.setAttribute("icon", "warning");
            request.setAttribute("loc", request.getContextPath() + "/member/loginFrm");
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
            view.forward(request, response);
            return;
        }
        Member loginMember = (Member) session.getAttribute("loginMember");
        String memberNo = loginMember.getMemberNo(); // 세션에서 실제 회원번호 가져오기

        String rootPath = getServletContext().getRealPath("/"); 
        String today = new SimpleDateFormat("yyyyMMdd").format(new Date());
        // 폼에서 전달된 boardCode를 경로에 포함 가능
        String boardCodeFromForm = request.getParameter("boardCode"); // Multipart 전에 읽어야 함 (일반 request에서)
                                                                   // 또는 MultipartRequest 생성 후 mRequest.getParameter로 읽기
        
        // MultipartRequest 처리 전에 boardCode를 먼저 읽거나, 생성 후 읽어야 합니다.
        // 파일 업로드 경로 구성
        String saveDirectory = rootPath + "resources/upload/post/" + (boardCodeFromForm != null ? boardCodeFromForm : "unknown_board") + "/" + today + "/";

        File dir = new File(saveDirectory);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        int maxSize = 10 * 1024 * 1024; // 10MB

        MultipartRequest mRequest = new MultipartRequest(request, saveDirectory, maxSize, "UTF-8", new KhRenamePolicy());

        String postTitle = mRequest.getParameter("postTitle"); // JSP의 name="postTitle"
        String postContent = mRequest.getParameter("postContent"); // JSP의 name="postContent"
        String boardCode = mRequest.getParameter("boardCode"); // JSP의 hidden input name="boardCode"

        // String postCategory = mRequest.getParameter("postCategory"); // JSP의 select name="postCategory" (말머리)
                                                                  // 필요시 Post VO에 추가 및 저장 로직 구현

        ArrayList<PostFile> fileList = new ArrayList<>();
        Enumeration<?> files = mRequest.getFileNames(); 
        while (files.hasMoreElements()) {
            String formInputName = (String) files.nextElement(); 
            if (formInputName.startsWith("file")) { // name이 "file1", "file2" 등인 파일 입력 처리
                String originalFileName = mRequest.getOriginalFileName(formInputName);
                String filesystemName = mRequest.getFilesystemName(formInputName);

                if (originalFileName != null && filesystemName != null) {
                    PostFile pf = new PostFile();
                    pf.setFileName(originalFileName); 
                    pf.setFilePath(filesystemName); // DAO에서 이 값을 tbl_post_file.file_path에 저장
                                                    // 실제 서비스/뷰에서는 saveDirectory + filesystemName 으로 전체 경로 구성
                    fileList.add(pf);
                }
            }
        }

        Post p = new Post();
        p.setBoardCode(boardCode); // 게시판 코드 설정
        p.setPostTitle(postTitle);
        p.setPostContent(postContent);
        p.setPostMemberNo(memberNo); // 세션에서 가져온 회원번호 사용
        // p.setPostCategory(postCategory); // 말머리 저장 필요시

        PostService service = new PostService();
        int result = service.insertPost(p, fileList); 

        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
        if (result > 0) {
            request.setAttribute("title", "성공");
            request.setAttribute("msg", "게시글이 등록되었습니다.");
            request.setAttribute("icon", "success");
            request.setAttribute("loc", request.getContextPath() + "/post/list?reqPage=1&boardCode=" + boardCode); 
        } else {
            request.setAttribute("title", "실패");
            request.setAttribute("msg", "게시글 등록 중 오류가 발생했습니다.");
            request.setAttribute("icon", "error");
            request.setAttribute("loc", request.getContextPath() + "/post/writeFrm?boardCode=" + boardCode);
        }
        view.forward(request, response);
    }
}