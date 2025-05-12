package kr.or.iei.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/* 싱글톤 패턴 : 프로그램 디자인 중 하나, 동일한 코드들을 사용할 때 하나의 클래스로 묶어 전역적으로 사용, 스태틱으로 사용
 * 단, 이 기능들이 자주 사용되어야 메모리 효율성 도모 가능
 * cf) mvc : 모델/뷰/컨트롤러로 계층화시키는 프로그램 디자인
 */

public class JDBCTemplate {

	public static Connection getConnection() {	//반환형을 Connection 으로 지정, 커넥션을 얻어오는 메소드를 생성
		Connection conn = null;
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","server_notice","1234");
			conn.setAutoCommit(false);	//자동 커밋 방지, 트랜잭션 관리는 Service에서 관리
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return conn;
	}
	
	public static void close(Connection conn) { //반환처리하는 메소드
		try {
			if (conn != null && !conn.isClosed()) { //conn이 null이 아니고 열려있는 상태일 때 작동
				conn.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void close(PreparedStatement pstmt) { //반환처리하는 메소드 오버로딩
		try {
			if (pstmt != null && !pstmt.isClosed()) { 
				pstmt.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void close(ResultSet rset) { //반환처리하는 메소드 오버로딩
		try {
			if (rset != null && !rset.isClosed()) { 
				rset.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void commit(Connection conn) {
		try {
			if (conn != null && !conn.isClosed()) {
				conn.commit();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void rollback(Connection conn) {
		try {
			if (conn != null && !conn.isClosed()) {
				conn.rollback();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
