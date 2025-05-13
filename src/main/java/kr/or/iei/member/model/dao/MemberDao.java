package kr.or.iei.member.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.member.model.vo.Member;

public class MemberDao {
	
	
	public int idDuplChk(Connection conn, String memberId) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		int cnt = 0; //초기화
		
		String query = "select count(*) cnt from tbl_member where member_id = ?"; //여기서 cnt 는 count(*)의 별칭.
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, memberId);
			
			rset = pstmt.executeQuery();//여기서 결과가 1 아니면 2 로 나올것. 처음 컬럼을 가르키니 rset.next() 을 사용하여 행 갯수 받기.
			
			if (rset.next()) {
				cnt = rset.getInt("cnt"); //여기에 위에 지정해놓은 별칭 cnt 작성
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		return cnt;
	}
	
	public int nicknameDuplChk(Connection conn, String memberNickname) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		int cnt = 0; //초기화
		
		String query = "select count(*) cnt from tbl_member where member_nickname = ?"; //여기서 cnt 는 count(*)의 별칭.
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, memberNickname);
			
			rset = pstmt.executeQuery();//여기서 결과가 1 아니면 2 로 나올것. 처음 컬럼을 가르키니 rset.next() 을 사용하여 행 갯수 받기.
			
			if (rset.next()) {
				cnt = rset.getInt("cnt"); //여기에 위에 지정해놓은 별칭 cnt 작성
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		return cnt;
	}
	
	//회원가입
	public int memberJoin(Connection conn, Member newMember) {
		PreparedStatement pstmt = null;
		int result = 0;
		
		String query = "insert into tbl_member (member_id, member_pw, member_nickname, member_name, member_email, member_phone, member_mbti values(to_char(sysdate, 'yymmdd') || lpad(seq_member.nextval, 4, '0'), ?, ?, ?, ?, ?, ?, ?, default, sysdate, default, default, default, default, default)";
		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, newMember.getMemberId());
			pstmt.setString(2, newMember.getMemberPw());
			pstmt.setString(3, newMember.getMemberNickname());
			pstmt.setString(4, newMember.getMemberName());
			pstmt.setString(5, newMember.getMemberEmail());
			pstmt.setString(6, newMember.getMemberPhone());
			pstmt.setString(7, newMember.getMemberMbti());
															
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			JDBCTemplate.close(pstmt);
		}
		return result;

	}

	
	
/*
	public int memberJoin(Connection conn, Member member) {
		PreparedStatement pstmt = null;	//반환객체
		
		int joinResult = 0;
		
		String query = "insert into tbl_member values (to_char(sysdate, 'yymmdd') || lpad(seq_member.nextval, 4,'0'),?,?,?,?,?,?,default,sysdate)";
		
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, member.getMemberId());
			pstmt.setString(2, member.getMemberPw());
			pstmt.setString(3, member.getMemberName());
			pstmt.setString(4, member.getMemberEmail());
			pstmt.setString(5, member.getMemberPhone());
			pstmt.setString(6, member.getMemberAdd());
			
			joinResult = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return joinResult;
	}

	public int idDuplChk(Connection conn, String memberId) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;	//select이므로 result도 생성
		int cnt = 0;
		
		//멤버id를 이용해 해당 id를 가진 멤버의 수를 확인하는 쿼리 : 0또는 1만 나옴
		String query = "select count(*) cnt from tbl_member where member_id = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, memberId);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				cnt = rset.getInt("cnt");	//0 또는 1
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(conn);
			JDBCTemplate.close(pstmt);
		}
		
		return cnt;
	}
*/
	public Member memberLogin(Connection conn, String loginId, String loginPw) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		Member loginMember = null;
		
		String query = "select * from tbl_member where member_id = ? and member_pw = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, loginId);
			pstmt.setString(2, loginPw);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				loginMember = new Member();
				
				loginMember.setMemberId(loginId);
				loginMember.setMemberPw(loginPw);
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(conn);
			JDBCTemplate.close(pstmt);
		}
		
		return loginMember;
	}
/*
	public int updateMember(Connection conn, Member updMember) {
		PreparedStatement pstmt = null;
		
		int updResult = 0;
		
		String query = "update tbl_member set member_name = ?, member_phone = ?, member_email = ?, member_addr = ? where member_no = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, updMember.getMemberName());
			pstmt.setString(2, updMember.getMemberPhone());
			pstmt.setString(3, updMember.getMemberEmail());
			pstmt.setString(4, updMember.getMemberAddr());
			pstmt.setString(5, updMember.getMemberNo());
			
			updResult = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return updResult;
	}

	public int deleteMember(Connection conn, String memberNo) {
		PreparedStatement pstmt = null;
		
		int delResult = 0;
		
		String query = "delete from tbl_member where member_no = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, memberNo);
			
			delResult = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return delResult;
	}

	public int updateMemberPw(Connection conn, String memberNo, String newMemberPw) {
		PreparedStatement pstmt = null;
		
		int pwResult = 0;
		
		String query = "update tbl_member set member_pw = ? where member_no = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, newMemberPw);
			pstmt.setString(2, memberNo);
			
			pwResult = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return pwResult;
	}

	public ArrayList<Member> selectAllMember(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		ArrayList<Member> list = new ArrayList<Member>();
		
		//관리자를 제외한 회원 조회
		String query = "select * from tbl_member where member_level != 1 order by member_id";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			rset = pstmt.executeQuery();
			
			while (rset.next()) {
				Member m = new Member();
				m.setMemberNo(rset.getString("member_no"));
				m.setMemberId(rset.getString("member_id"));
				m.setMemberName(rset.getString("member_name"));
				m.setMemberPhone(rset.getString("member_phone"));
				m.setMemberAddr(rset.getString("member_Addr"));
				m.setMemberEmail(rset.getString("member_Email"));
				m.setMemberLevel(rset.getInt("member_level"));
				m.setEnrollDate(rset.getString("enroll_date"));
				list.add(m);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
			JDBCTemplate.close(rset);
		}
		
		return list;
	}

	public int chgLevel(Connection conn, String memberNo, String chgLevel) {
		PreparedStatement pstmt = null;

		int result = 0;
		
		String query = "update tbl_member set member_level = ? where member_no = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, chgLevel);
			pstmt.setString(2, memberNo);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}
*/


	public int updateMember(Connection conn, Member a) {
		PreparedStatement pstmt = null; 
		int result = 0;
		
		String query ="update tbl_member set member_mbti = ?, member_id = ?, member_nickname = ?, member_email = ?, member_phone = ? where member_no = ?";
				
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, a.getMemberMbti());
			pstmt.setString(2, a.getMemberId());
			pstmt.setString(3, a.getMemberNickname());
			pstmt.setString(4, a.getMemberEmail());
			pstmt.setString(5, a.getMemberPhone());
			pstmt.setString(6, a.getMemberNo());
			
			result = pstmt.executeUpdate();
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			JDBCTemplate.close(pstmt);
		}
		
		
		
		
		return result;
	}



	

}
