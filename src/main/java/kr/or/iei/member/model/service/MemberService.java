package kr.or.iei.member.model.service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.StringTokenizer;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.member.model.dao.MemberDao;
import kr.or.iei.member.model.vo.Member;

public class MemberService {

	private MemberDao dao;
	
	public MemberService() {
		dao = new MemberDao();
	}
/*
	public int memberJoin(Member member) {
		Connection conn = JDBCTemplate.getConnection();
		int joinResult = dao.memberJoin(conn, member);
		
		if (joinResult > 0) {
			JDBCTemplate.commit(conn);
		} else {
			JDBCTemplate.rollback(conn);
		}
		JDBCTemplate.close(conn);
		
		return joinResult;
	}

	public int idDuplChk(String memberId) {
		Connection conn = JDBCTemplate.getConnection();
		int cnt = dao.idDuplChk(conn, memberId);
		
		//단순 확인 작업이므로 커밋/롤백 작업 필요없음
		JDBCTemplate.close(conn);
		
		return cnt;
	}
*/
	public Member memberLogin(String loginId, String loginPw) {
		Connection conn = JDBCTemplate.getConnection();
		Member loginMember = dao.memberLogin(conn, loginId, loginPw);
		JDBCTemplate.close(conn);
		
		return loginMember;
	}
/*
	public int updateMember(Member updMember) {
		Connection conn = JDBCTemplate.getConnection();
		int updResult = dao.updateMember(conn, updMember);
		
		if (updResult > 0) {
			JDBCTemplate.commit(conn);
		} else {
			JDBCTemplate.rollback(conn);
		}
		JDBCTemplate.close(conn);
		
		return updResult;
		
	}

	public int deleteMember(String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		int delResult = dao.deleteMember(conn, memberNo);
		
		if (delResult > 0) {
			JDBCTemplate.commit(conn);
		} else {
			JDBCTemplate.rollback(conn);
		}
		JDBCTemplate.close(conn);
		
		return delResult;
	}

	public int updateMemberPw(String memberNo, String newMemberPw) {
		Connection conn = JDBCTemplate.getConnection();
		int pwResult = dao.updateMemberPw(conn, memberNo, newMemberPw);
		
		if (pwResult > 0) {
			JDBCTemplate.commit(conn);
		} else {
			JDBCTemplate.rollback(conn);
		}
		JDBCTemplate.close(conn);
		
		return pwResult;
	}

	public ArrayList<Member> selectAllMember() {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Member> list = dao.selectAllMember(conn);
		JDBCTemplate.close(conn);
		
		return list;
	}

	public int chgLevel(String memberNo, String chgLevel) {
		Connection conn = JDBCTemplate.getConnection();
		int result = dao.chgLevel(conn, memberNo, chgLevel);
		if(result > 0) {
			JDBCTemplate.commit(conn);
		} else {
			JDBCTemplate.rollback(conn);
		}
		return result;
	}

	public boolean chgAllLevel(String memberNoList, String chgLevelList) {
		Connection conn = JDBCTemplate.getConnection();
		
		//문자열과 구분자 입력 : 해당 문자열을 구분자를 기준으로 잘라 토큰 형식으로 저장
		StringTokenizer st1 = new StringTokenizer(memberNoList, "/");
		StringTokenizer st2 = new StringTokenizer(chgLevelList, "/");
		
		boolean result = true;
		
		while(st1.hasMoreTokens()) {
			String memberNo = st1.nextToken();	//회원번호 토큰을 추출해 변수에 저장
			String chgLevel = st2.nextToken();
			
			//각 개인별로 나눴으므로 회원등급 변경 메소드 재사용 가능
			int res = dao.chgLevel(conn, memberNo, chgLevel);
			
			//등급변경에 실패했을 경우 작업을 중지하고 반복문 탈출, result를 false로 만들어 롤백 실행
			if(res<1 ) {
				result = false;
				break;
			}
		}
		
		if(result) {
			JDBCTemplate.commit(conn);
		} else {
			JDBCTemplate.rollback(conn);
		}
		
		
		return result;
		
		
	}
	*/
	public int updateMember(Member a) {
		Connection conn = JDBCTemplate.getConnection();
		int result = dao.updateMember(conn, a);
		if(result >0) {
			JDBCTemplate.commit(conn);
		}else {
			JDBCTemplate.rollback(conn);
		}
		
		JDBCTemplate.close(conn);
		return result;
		
	}
	
}
