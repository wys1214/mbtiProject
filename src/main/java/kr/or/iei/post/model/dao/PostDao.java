package kr.or.iei.post.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.post.model.vo.Post;
import kr.or.iei.post.model.vo.PostFile;
//import kr.or.iei.post.model.vo.CommentVO; // 댓글 VO 임포트 (경로 확인 필요)

public class PostDao {

    public ArrayList<Post> selectPostList(Connection conn, int start, int end, String boardCode) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        ArrayList<Post> list = new ArrayList<Post>();
        String query = "select * from ("
                     + "    select rownum as rnum, p_aliased.* from ("
                     + "        select "
                     + "            p.post_no, p.board_code, p.post_title, "
                     + "            m.member_nickname as post_writer_nickname, "
                     + "            p.member_no as post_writer_member_no, " // Post VO에 memberNo를 저장하기 위함
                     + "            to_char(p.post_date, 'yyyy-mm-dd') as post_date, "
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
                p.setPostWriterNickname(rset.getString("post_writer_nickname")); // Post VO에 setPostWriterNickname 가정
                p.setPostMemberNo(rset.getString("post_writer_member_no")); 
                p.setPostDate(rset.getString("post_date")); 
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

    public String generateNewPostNo(Connection conn, String boardCode) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        String postNo = "";
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

    public int insertPost(Connection conn, Post p) {
        PreparedStatement pstmt = null;
        int result = 0;
        String query = "insert into tbl_post (post_no, board_code, member_no, post_title, post_content, post_date, post_update_date, post_view_count) " +
                       "values (?, ?, ?, ?, ?, sysdate, null, default)";
        try {
            pstmt = conn.prepareStatement(query);
            int i = 1;
            pstmt.setString(i++, p.getPostNo());
            pstmt.setString(i++, p.getBoardCode());    
            pstmt.setString(i++, p.getPostMemberNo());        
            pstmt.setString(i++, p.getPostTitle());
            pstmt.setString(i++, p.getPostContent());
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }
        return result;
    }

    public int insertPostFile(Connection conn, PostFile pf) {
        PreparedStatement pstmt = null;
        int result = 0;
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

    public Post selectOnePost(Connection conn, String postNo) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        Post p = null; 
        String query = "select " +
                       "    p.post_no, p.board_code, p.member_no, m.member_nickname as post_writer_nickname, " +
                       "    p.post_title, p.post_content, " +
                       "    to_char(p.post_date, 'yyyy-mm-dd hh24:mi:ss') as post_date, " + 
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
                p.setPostMemberNo(rset.getString("member_no")); 
                p.setPostWriterNickname(rset.getString("post_writer_nickname")); 
                p.setPostTitle(rset.getString("post_title"));
                p.setPostContent(rset.getString("post_content"));
                p.setPostDate(rset.getString("post_date")); 
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
/*
    // 댓글 목록 조회를 위한 메소드 (tbl_post_comment 와 tbl_member 조인)
    public ArrayList<CommentVO> selectCommentList(Connection conn, String postNo) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        ArrayList<CommentVO> list = new ArrayList<>();
        String query = "select c.comment_no, c.post_no, c.parent_comment_no, c.member_no, " +
                       "m.member_nickname as comment_writer_nickname, c.comment_content, " +
                       "to_char(c.comment_creation_date, 'yyyy-mm-dd hh24:mi') as comment_creation_date, " +
                       "to_char(c.comment_update_date, 'yyyy-mm-dd hh24:mi') as comment_update_date " +
                       "from tbl_post_comment c " +
                       "join tbl_member m on (c.member_no = m.member_no) " +
                       "where c.post_no = ? " +
                       "order by nvl(c.parent_comment_no, c.comment_no), c.comment_creation_date asc"; 
                       // 부모댓글 그룹으로 묶고, 그 안에서 시간순 정렬 (대댓글 계층 표현에 도움)
        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, postNo);
            rset = pstmt.executeQuery();
            while (rset.next()) {
                CommentVO comment = new CommentVO();
                comment.setCommentNo(rset.getInt("comment_no"));
                comment.setPostNo(rset.getString("post_no"));
                // parent_comment_no는 숫자이므로 getInt 사용, null 가능성 있으므로 wrapper 타입(Integer)이 VO에 좋음
                int parentNo = rset.getInt("parent_comment_no");
                if (!rset.wasNull()) { 
                    comment.setParentCommentNo(parentNo);
                } else {
                    comment.setParentCommentNo(null);
                }
                comment.setMemberNo(rset.getInt("member_no"));
                comment.setCommentWriterNickname(rset.getString("comment_writer_nickname"));
                comment.setCommentContent(rset.getString("comment_content"));
                comment.setCommentCreationDate(rset.getString("comment_creation_date"));
                comment.setCommentUpdateDate(rset.getString("comment_update_date"));
                list.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }
        return list;
    }
    */
}