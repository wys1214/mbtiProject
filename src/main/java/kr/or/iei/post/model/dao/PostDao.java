package kr.or.iei.post.model.dao; // 실제 프로젝트의 패키지 경로로 수정해주세요.

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.post.model.vo.Post;     // VO 클래스 이름을 Post로 가정
import kr.or.iei.post.model.vo.PostFile; // VO 클래스 이름을 PostFile로 가정
import kr.or.iei.member.model.vo.Member;

public class PostDao {

    /**
     * 특정 게시판의 게시글 목록을 조회합니다. (페이지네이션 적용)
     * @param conn Connection 객체
     * @param start 조회 시작 행 번호
     * @param end 조회 끝 행 번호
     * @param boardCode 조회할 게시판 코드
     * @return 해당 페이지의 게시글 목록 (ArrayList<Post>)
     */
    public ArrayList<Post> selectPostList(Connection conn, int start, int end, String boardCode) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        ArrayList<Post> list = new ArrayList<Post>();
        // post_like_count 컬럼 관련 내용 제거
        String query = "select * from ("
                     + "    select rownum as rnum, p_aliased.* from ("
                     + "        select "
                     + "            p.post_no, p.board_code, p.post_title, "
                     + "            m.member_nickname as post_writer_nickname, "
                     + "            p.member_no as post_writer_member_no, "
                     + "            to_char(p.post_date, 'yyyy-mm-dd') as post_creation_date, "
                     + "            p.post_view_count "
                     + "        from tbl_post p "
                     + "        join tbl_member m on (p.member_no = m.member_no) "
                     + "        where p.board_code = ? "
                     + "        order by p.post_no desc "
                     + "    ) p_aliased "
                     + ") where rnum between ? and ?";
        
        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, boardCode);
            pstmt.setInt(2, start);
            pstmt.setInt(3, end);
            rset = pstmt.executeQuery();
            
            while(rset.next()) {
                Post p = new Post();
                p.setPostNo(rset.getString("post_no"));
                p.setBoardCode(rset.getString("board_code")); 
                p.setPostTitle(rset.getString("post_title"));
                p.setMemberNickname(rset.getString("post_writer_nickname")); 
                p.setMemberNo(rset.getInt("post_writer_member_no")); 
                p.setPostDate(rset.getString("post_creation_date")); // DDL상 post_date, VO필드명은 postDate 또는 postCreationDate
                p.setPostViewCount(rset.getInt("post_view_count"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }
        return list;
    }

    /**
     * 특정 게시판의 전체 게시글 수를 조회합니다.
     * @param conn Connection 객체
     * @param boardCode 조회할 게시판 코드
     * @return 해당 게시판의 전체 게시글 수
     */
    public int selectTotalPostCount(Connection conn, String boardCode) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        int totalCount = 0;
        String query = "select count(*) as cnt from tbl_post where board_code = ?";
        
        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, boardCode);
            rset = pstmt.executeQuery();
            if(rset.next()) {
                totalCount = rset.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }
        return totalCount;
    }

    /**
     * 새로운 게시글 번호를 생성합니다. (게시판코드_날짜_시퀀스 형식)
     * @param conn Connection 객체
     * @param boardCode 게시판 코드 (예: 'N', 'F')
     * @return 생성된 게시글 번호 (예: N_2505120001)
     */
    public String generateNewPostNo(Connection conn, String boardCode) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        String postNo = "";
        // 시퀀스 이름은 seq_post_suffix 또는 프로젝트 규칙에 맞게 사용
        String query = "select ? || '_' || to_char(sysdate,'yymmdd') || lpad(seq_post_suffix.nextval, 4,'0') as new_post_no from dual";
        
        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, boardCode.toUpperCase()); 
            rset = pstmt.executeQuery();
            if(rset.next()) {
                postNo = rset.getString("new_post_no");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }
        return postNo;
    }

    /**
     * 새로운 게시글을 등록합니다.
     * @param conn Connection 객체
     * @param p 등록할 게시글 정보 (Post)
     * @return 실행 결과 (1: 성공, 0: 실패)
     */
    public int insertPost(Connection conn, Post p) {
        PreparedStatement pstmt = null;
        int result = 0;
        // tbl_post 컬럼: post_no, board_code, member_no, post_title, post_content, post_date, post_update_date, post_view_count
        // post_like_count 컬럼이 없으므로 INSERT 문에서 제외
        String query = "insert into tbl_post (post_no, board_code, member_no, post_title, post_content, post_date, post_update_date, post_view_count) " +
                       "values (?, ?, ?, ?, ?, sysdate, null, default)";
        
        try {
            pstmt = conn.prepareStatement(query);
            int i = 1;
            pstmt.setString(i++, p.getPostNo());
            pstmt.setString(i++, p.getBoardCode());    
            pstmt.setInt(i++, p.getMemberNo());        
            pstmt.setString(i++, p.getPostTitle());
            pstmt.setString(i++, p.getPostContent());
            // post_date는 sysdate, post_update_date는 null, post_view_count는 default(0)
            
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }
        return result;
    }

    /**
     * 게시글 첨부파일 정보를 등록합니다.
     * @param conn Connection 객체
     * @param pf 등록할 파일 정보 (PostFile)
     * @return 실행 결과 (1: 성공, 0: 실패)
     */
    public int insertPostFile(Connection conn, PostFile pf) {
        PreparedStatement pstmt = null;
        int result = 0;
        // tbl_post_file DDL: file_no, post_no, file_name, file_path
        String query = "insert into tbl_post_file (file_no, post_no, file_name, file_path) values (seq_post_file.nextval, ?, ?, ?)";
        
        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, pf.getPostNo()); 
            pstmt.setString(2, pf.getFileName());     
            pstmt.setString(3, pf.getFilePath());     
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }
        return result;
    }

    /**
     * 게시글 조회수를 1 증가시킵니다.
     * @param conn Connection 객체
     * @param postNo 조회수를 증가시킬 게시글 번호
     * @return 실행 결과 (1: 성공, 0: 실패)
     */
    public int updateReadCount(Connection conn, String postNo) {
        PreparedStatement pstmt = null;
        int result = 0;
        String query = "update tbl_post set post_view_count = post_view_count + 1 where post_no = ?";
        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, postNo);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }
        return result;
    }

    /**
     * 특정 게시글의 상세 정보를 조회합니다.
     * @param conn Connection 객체
     * @param postNo 조회할 게시글 번호
     * @return 조회된 게시글 정보 (Post), 없을 경우 null
     */
    public Post selectOnePost(Connection conn, String postNo) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        Post p = null; 
        // post_like_count 컬럼 조회 부분 삭제
        String query = "select " +
                       "    p.post_no, p.board_code, p.member_no, m.member_nickname as post_writer_nickname, " +
                       "    p.post_title, p.post_content, " +
                       "    to_char(p.post_date, 'yyyy-mm-dd hh24:mi:ss') as post_creation_date, " + 
                       "    to_char(p.post_update_date, 'yyyy-mm-dd hh24:mi:ss') as post_update_date, " +
                       "    p.post_view_count " +
                       "from tbl_post p " +
                       "join tbl_member m on (p.member_no = m.member_no) " +
                       "where p.post_no = ?";
        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, postNo);
            rset = pstmt.executeQuery();

            if (rset.next()) {
                p = new Post(); 
                p.setPostNo(rset.getString("post_no"));
                p.setBoardCode(rset.getString("board_code"));
                p.setMemberNo(rset.getInt("member_no")); 
                p.setPostWriterNickname(rset.getString("post_writer_nickname")); 
                p.setPostTitle(rset.getString("post_title"));
                p.setPostContent(rset.getString("post_content"));
                p.setPostDate(rset.getString("post_creation_date")); 
                p.setPostUpdateDate(rset.getString("post_update_date")); 
                p.setPostViewCount(rset.getInt("post_view_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }
        return p;
    }

    /**
     * 특정 게시글의 첨부파일 목록을 조회합니다.
     * @param conn Connection 객체
     * @param postNo 첨부파일을 조회할 게시글 번호
     * @return 해당 게시글의 첨부파일 목록 (ArrayList<PostFile>)
     */
    public ArrayList<PostFile> selectPostFiles(Connection conn, String postNo) { 
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        ArrayList<PostFile> fileList = new ArrayList<>(); 
        String query = "select file_no, post_no, file_name, file_path from tbl_post_file where post_no = ?";
        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, postNo);
            rset = pstmt.executeQuery();
            while(rset.next()) {
                PostFile pf = new PostFile(); 
                pf.setFileNo(rset.getInt("file_no"));
                pf.setPostNo(rset.getString("post_no"));
                pf.setFileName(rset.getString("file_name")); 
                pf.setFilePath(rset.getString("file_path")); 
                fileList.add(pf);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }
        return fileList;
    }
}