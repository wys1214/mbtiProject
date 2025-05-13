package kr.or.iei.post.model.service; // 패키지명은 실제 프로젝트에 맞게 수정

import java.sql.Connection;
import java.util.ArrayList;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.common.ListData;
import kr.or.iei.post.model.dao.PostDao;
import kr.or.iei.post.model.vo.Post;
import kr.or.iei.post.model.vo.PostFile;
//import kr.or.iei.post.model.vo.CommentVO; // 댓글 VO 임포트

public class PostService {

     private PostDao dao;
     
     public PostService() {
         super(); // 상속받는 클래스가 없다면 super()는 생략 가능
         dao = new PostDao();
     }

  // In PostService.java
  // public ListData<Post> selectPostList(int reqPage, String boardCode) { // 이전 시그니처
  public ListData<Post> selectPostList(int reqPage, String boardCode, String boardType) { // 수정된 시그니처
      Connection conn = JDBCTemplate.getConnection();
      int numPerPage = 10; 
      int end = reqPage * numPerPage;
      int start = end - numPerPage + 1;
      
      ArrayList<Post> list = dao.selectPostList(conn, start, end, boardCode);
      int totalCount = dao.selectTotalPostCount(conn, boardCode);
      
      int totalPage = 0;
      if (totalCount == 0) {
          totalPage = 1; // 게시글이 없을 때도 1페이지는 있도록
      } else if (totalCount % numPerPage == 0) {
          totalPage = totalCount / numPerPage;
      } else {
          totalPage = totalCount / numPerPage + 1;
      }
      
      int pageNaviSize = 5;
      int pageNo = ((reqPage - 1) / pageNaviSize) * pageNaviSize + 1;
      
      String pageNavi = "<ul class='pagination circle-style'>";
	   // URL 생성 시 contextPath 없이 절대 경로 및 type 파라미터 사용
	   String baseUrl = "/board?type=" + boardType + "&reqPage="; 
	
	   // 이전 버튼
	   if (pageNo != 1) {
	       pageNavi += "<li><a class='page-item' href='" + baseUrl + (pageNo - 1) + "'>";
	       pageNavi += "<span class='material-icons'>chevron_left</span></a></li>";
	   }
	   // 페이지 숫자
	   for (int i = 0; i < pageNaviSize; i++) {
	       if (pageNo == reqPage) {
	           pageNavi += "<li><a class='page-item active-page' href='" + baseUrl + pageNo + "'>" + pageNo + "</a></li>";
	       } else {
	           pageNavi += "<li><a class='page-item' href='" + baseUrl + pageNo + "'>" + pageNo + "</a></li>";
	       }
	       pageNo++;
	       if (pageNo > totalPage) {
	           break;
	       }
	   }
	   // 다음 버튼
	   if (pageNo <= totalPage) { 
	       pageNavi += "<li><a class='page-item' href='" + baseUrl + pageNo + "'>";
	       pageNavi += "<span class='material-icons'>chevron_right</span></a></li>";
	   }
	   pageNavi += "</ul>";
      
      ListData<Post> ld = new ListData<Post>();
      ld.setList(list);
      ld.setPageNavi(pageNavi);
      
      JDBCTemplate.close(conn);
      return ld;
  }
    

    public int insertPost(Post post, ArrayList<PostFile> fileList) {
        Connection conn = JDBCTemplate.getConnection();
        // 게시글 번호 생성 시 boardCode 전달
        String postNo = dao.generateNewPostNo(conn, post.getBoardCode());
        post.setPostNo(postNo);
        
        int result = dao.insertPost(conn, post);
        
        if (result > 0) {
            for (PostFile file : fileList) {
                file.setPostNo(postNo); 
                result = dao.insertPostFile(conn, file);
                if (result < 1) {
                    JDBCTemplate.rollback(conn);
                    JDBCTemplate.close(conn);
                    return 0; // 파일 삽입 실패 시 전체 롤백 및 실패 반환
                }
            }
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }
        JDBCTemplate.close(conn);
        return result;
    }
    
    public Post selectPostDetail(String postNo, boolean isIncrementRequired) {
        Connection conn = JDBCTemplate.getConnection();
        Post post = null; 
    
        if (isIncrementRequired) {
            int result = dao.updateReadCount(conn, postNo);
            if (result > 0) {
                JDBCTemplate.commit(conn);
            } else {
                JDBCTemplate.rollback(conn);
            }
        }
    
        post = dao.selectOnePost(conn, postNo); 
    
        if (post != null) {
            // 게시글 상세 조회 시 첨부파일 목록과 댓글 목록도 함께 조회하여 설정
            ArrayList<PostFile> fileList = dao.selectPostFiles(conn, postNo);
            //post.setFileList(fileList); // Post VO에 setFileList 메소드 필요

            //ArrayList<CommentVO> commentList = dao.selectCommentList(conn, postNo); // DAO에 해당 메소드 구현 필요
            //post.setCommentList(commentList); // Post VO에 setCommentList 메소드 필요
        }
    
        JDBCTemplate.close(conn);
        return post;
    }
}