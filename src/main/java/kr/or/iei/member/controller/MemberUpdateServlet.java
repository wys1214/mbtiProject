package kr.or.iei.member.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.Member;

/**
 * Servlet implementation class MemberUpdateServlet
 */
@WebServlet("/member/update")
public class MemberUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberUpdateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//가져올건 유저의 번호, mbti, id, 이름,이메일,전화번호.
		String memberNo = request.getParameter("memberNo");
		String memberMbti = request.getParameter("memberMbti");
		String memberId = request.getParameter("memberId");
		String memberNickname = request.getParameter("memberNickname");
		String memberEmail = request.getParameter("memberEmail");
		String memberPhone = request.getParameter("memberPhone");
		
		Member a = new Member();
		a.setMemberNo(memberNo);
		a.setMemberMbti(memberMbti);
		a.setMemberId(memberId);
		a.setMemberNickname(memberNickname);
		a.setMemberEmail(memberEmail);
		a.setMemberPhone(memberPhone);
		
		MemberService service = new MemberService();
		int result = service.updateMember(a);
		
		RequestDispatcher view = null;
		
		if(result > 0) {//정보수정 성공
			view = request.getRequestDispatcher("WEB-INF/views/member/myPage.jsp");
			
			request.setAttribute("title", "알림");
			request.setAttribute("msg", "회원정보 수정됨");
			request.setAttribute("icon", "success");
			request.setAttribute("loc", "/member/myPage");
			
			HttpSession session = request.getSession(false);//세션이 있으면 존재하는 세션, 없으면 null
			if(session != null) {
				Member loginMember = (Member)session.getAttribute("loginMember");//로그인 했을 때, 등록한 회원 정보
				
				//세션 정보 업데이트
				 loginMember.setMemberMbti(memberMbti);
				 loginMember.setMemberId(memberId);
				 loginMember.setMemberNickname(memberNickname);
				 loginMember.setMemberEmail(memberEmail);
				 loginMember.setMemberPhone(memberPhone);
			}
			
			
			
		}else {
			request.setAttribute("title", "알림");
			request.setAttribute("msg", "회원정보 수정중 오류 발생");
			request.setAttribute("icon", "error");
			request.setAttribute("loc", "/member/myPage");
		}
		view.forward(request, response);
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
