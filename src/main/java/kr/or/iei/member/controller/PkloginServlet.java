package kr.or.iei.member.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.member.model.vo.Member;

/**
 * Servlet implementation class PkloginServlet
 */
@WebServlet("/pklogin")
public class PkloginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PkloginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 Member testMember = new Member();
	        testMember.setMemberNo("250513001");
	        testMember.setMemberId("admin");
	        testMember.setMemberPw("1234");  
	        testMember.setMemberNickname("관리자");
	        testMember.setMemberName("관리자 계정");
	        testMember.setMemberEmail("admin@example.com");
	        testMember.setMemberPhone("010-0000-0000");
	        testMember.setMemberMbti("INTJ");
	        testMember.setMemberGrade(1);
	        testMember.setMemberJoinDate("2025-05-13 10:00:00"); 
	        testMember.setMemberLoginDaysCount(0);
	        testMember.setMemberSanctionCount(0);
	        testMember.setMemberCommentLikeCount(0);
	        testMember.setMemberPostLikeCount(0);
	        testMember.setMemberPoint(0);

	        // 세션에 로그인 사용자 정보 저장
	        HttpSession session = request.getSession();
	        session.setAttribute("loginMember", testMember);

	        // 로그인 후 이동할 페이지로 리디렉션
	        response.sendRedirect(request.getContextPath() + "/index.jsp");
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
