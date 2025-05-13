package kr.or.iei.member.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.Member;

/**
 * Servlet implementation class JoinServlet
 */
@WebServlet("/member/join")
public class JoinServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public JoinServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		// 값 추출
		String memberId = request.getParameter("memberId");
		String memberPw = request.getParameter("memberPw");
		String memberNickname = request.getParameter("memberNickname");
		String memberName = request.getParameter("memberName");
		String memberEmail = request.getParameter("memberEmail");
		String memberPhone = request.getParameter("memberPhone");
		String memberMbti = request.getParameter("memberMbti");
		
		Member newMember = new Member();
		newMember.setMemberId(memberId);
		newMember.setMemberPw(memberPw);
		newMember.setMemberNickname(memberNickname);
		newMember.setMemberName(memberName);
		newMember.setMemberEmail(memberEmail);
		newMember.setMemberPhone(memberPhone);
		newMember.setMemberMbti(memberMbti);
		
		MemberService service = new MemberService();
		int result = service.memberJoin(newMember);
		
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
		
		if(result>0) {
			request.setAttribute("title", "성공");
			request.setAttribute("msg", "회원가입이 완료되었습니다.");
			request.setAttribute("icon", "success");
			request.setAttribute("loc", "/member/loginFrm");			
		}else {
			request.setAttribute("title", "실패");
			request.setAttribute("msg", "회원가입 중, 오류가 발생하였습니다.");
			request.setAttribute("icon", "error");
			request.setAttribute("loc", "/");
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
