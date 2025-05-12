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
 * Servlet implementation class LoginServlet
 */
@WebServlet("/member/Login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//인코딩 : 필터
		//값 추출
		String loginId = request.getParameter("loginId");
		String loginPw = request.getParameter("loginPw");
		
		//로직 : 로그인
		//입력한 아이디와 비밀번호가 일치하는 회원이 DB에 존재하는지
		//일치하는 회원의 컬럼 정보를 조회 : 정상 로그인 이후 마이페이지에 들어갔을 때 부가적인 정보들이 보여져야 함, 즉 객체로 반환
		//위에서 조회 후 받아온 정보들은 로그인 후 어느 jsp로 이동하든 회원정보를 사용할 수 있어야 함
		MemberService service = new MemberService();
		Member loginMember = service.memberLogin(loginId, loginPw);
		
		RequestDispatcher view = null;	//여러 if문 안에서 사용하기 위해 밖에서 선언
		
		//결과처리
		if(loginMember == null) {	//로그인 실패 시
			//이동할 페이지 설정
			view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
			
			//알림창 띄우기
			request.setAttribute("title", "알림");
			request.setAttribute("msg", "아이디 또는 비밀번호를 확인하세요");
			request.setAttribute("icon", "error");
			request.setAttribute("loc", "/member/loginFrm");
		} else {	//로그인 성공 시
			/*
			if(loginMember.getMemberLevel() == 3) {	//준회원은 로그인 불가
				//이동할 페이지 경로 지정
				view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
				
				//화면 구현에 필요한 데이터 등록
				request.setAttribute("title", "알림");
				request.setAttribute("msg", "로그인 권한이 없습니다. 관리자에게 문의하세요");
				request.setAttribute("icon", "error");
				request.setAttribute("loc", "/member/loginFrm");
				
				//페이지 이동
				view.forward(request, response);
				return;
			}*/
			//로그인 성공 시 + 정회원 이상일 시 이동할 페이지
			view = request.getRequestDispatcher("/index.jsp");
			
			//로그인한 정보 저장
			HttpSession session = request.getSession();	//모든 정보를 계속해서 유지해야 하므로 session으로 저장
			session.setAttribute("loginMember", loginMember);
			session.setMaxInactiveInterval(600);	//600초 후 세션 만료 : 재로그인 필요
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
