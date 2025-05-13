package kr.or.iei.post.model.service;

import java.sql.Connection;
import java.util.ArrayList;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.common.ListData;
import kr.or.iei.post.model.dao.PostDao;
import kr.or.iei.post.model.vo.Post;
import kr.or.iei.post.model.vo.PostFile;

public class PostService {

	 private PostDao dao;
	 
	 public PostService() {
		 dao = new PostDao();
	 }

	public ListData<Post> selectPostList(int reqPage) {
		Connection conn = JDBCTemplate.getConnection();

		//한 페이지에서 보여줄 게시글의 갯수
		int viewPostCnt = 10;
		
		//시작 행 번호(strat)와 끝 행 번호(end)를 요청 페이지 번호(reqPage)에 따라 연산
		
		/* reqPage == 1 : start == 1, end == 10
		 * reqPage == 2 : start == 11, end == 20
		 * reqPage == 3 : start == 21, end == 30
		 * 
		 * */
		
		int end = reqPage*viewPostCnt;
		int start = end-viewPostCnt+1;
		
		ArrayList<Post> list = dao.selectPostList(conn, start, end);
		
		//페이지네이션 작업 < 1 2 3 4 5 6 7>
		
		//전체 게시글 갯수 조회 (totCnt)
		int totCnt = dao.selectTotalCount(conn);
		
		//전체 페이지 갯수
		/*
		 * totCnt == 23개 : 3개 페이지
		 * totCnt == 52개 : 6개 페이지
		 * totCnt == 100개 : 10개 페이지
		 * 
		 * */
		int totPage = 0;
		
		if(totCnt%viewPostCnt > 0) {
			totPage = totCnt / viewPostCnt + 1;	//나머지가 있으면 1씩 더해주기
		} else {
			totPage = totCnt / viewPostCnt;	//나누어 떨어질 때는 그대로
		};
		
		//페이지 네비게이션 사이즈 : 5
		int pageNaviSize = 5;
		
		//페이지네이션 시작 번호 : 1~5 그룹이면 1, 6~10 그룹이면 6, 11~15 그룹이면 6
		int pageNo = ((reqPage-1) / pageNaviSize) * pageNaviSize + 1;
		
		//페이지 하단에 보여줄 페이지네이션 html코드
		String pageNavi = "<ul class='pagination circle-style'>";
		
		//이전 버튼 생성
		if(pageNo != 1) {	//현재 페이지가 1일 경우 생성하지 않음
			pageNavi += "<li>";
			pageNavi += "<a class='page-item' href='/Post/getList?reqPage=" + (pageNo-1) +"'>";
			pageNavi += "<span class='material-icons'>chevron_left</span>";
			pageNavi += "</a></li>";
		}
		
		for(int i=0; i<pageNaviSize; i++) {
			pageNavi += "<li>";
			
			//페이지번호 작성 : 사용자가 요청한 페이지 클래스를 다르게 지정하겨 시각적 효과 부여
			if(pageNo == reqPage) {
				pageNavi += "<a class='page-item active-page' href='/Post/getList?reqPage=" + pageNo +"'>";
			} else {
				pageNavi += "<a class='page-item' href='/Post/getList?reqPage=" + pageNo +"'>";
			}
			
			pageNavi += pageNo; //시작태그와 종료태그 사이에 작성되는 값
			pageNavi += "</a><li>";
			
			pageNo++;
			
			//설정한 pageNaviSize보다 적은 값에서 페이지 번호가 끝났다면 더 이상 생성하지 않고 종료 : 13에서 끝났다면 15가 아닌 13에서 종료
			if(pageNo > totPage) {
				break;
			}
		}
		
		//다음 버튼
		if(pageNo <= totPage) {
			pageNavi += "<li>";
			pageNavi += "<a class='page-item' href='/Post/getList?reqPage="+pageNo+"'>";
			pageNavi += "<span class='material-icons'>chevron_right</span>";
			pageNavi += "</a></li>";
		}
		
		pageNavi += "</ul>";
		
		
		/*
		 * 서블릿으로 전달해야 하는 값은 list와 pageNavi 인데, 자바 메소드에서의 리턴값은 1개뿐임
		 * 따라서 두 값을 모두 저장할 수 있는 클래스 객체 ListData를 생성 후 객체를 전달
		 * */
		ListData<Post> listData = new ListData<Post>();
		listData.setList(list);
		listData.setPageNavi(pageNavi);
		
		JDBCTemplate.close(conn);
		return listData;
	}

	public int insertPost(Post post, ArrayList<PostFile> fileList) {
		Connection conn = JDBCTemplate.getConnection();
		
		/* 현재 기능은 등록 == insert
		 * 대상 테이블은 tbl_Post (게시판 테이블), tbl_Post_file(게시판 파일 테이블)
		 * 부모 테이블의 데이터가 존재해야 자식 테이블에 insert 가능 (참조키 때문) : tbl_Post에 먼저 insert 수행
		 * 
		 * 1) 게시글 번호 조회 select query : 두 insert에서 Post_no를 같게 해주기 위한 조치
		 * 
		 * 2) tbl_Post의 insert query : 
		 * insert into tbl_Post values (?, ?, ?, ?, sysdate, default);
		 * 
		 * 3) tbl_Post_file의 insert query : 
		 * insert into tbl_Post_file values (seq_Post_file.nextval, 조회해온 Post_no , ?, ?, ?, sysdate, default);
		 * 
		 * */
		
		//1) 게시글 번호 조회
		String postNo = dao.selectNextPostNo(conn);
		
		//조회해온 게시글 번호를 Post(게시판 정보)에 저장
		post.setPostNo(postNo);
		
		//2) tbl_Post에 insert (게시글 정보 등록)
		int result = dao.insertPost(conn, post);
		
		//3) 2)가 정상적으로 수행되었을 때 tbl_Post_file에 insert : 여러 개의 파일일 수 있으니 반복문 처리
		if (result > 0){
			for (PostFile file : fileList) {
				file.setPostNo(postNo);	//1)에서 조회한 게시글 번호 입력
				
				result = dao.insertPostFile(conn, file);
				
				//파일 정보 등록 중 정상 수행되지 않았을 경우 모두 롤백처리 후 메소드 종료
				if(result < 1) {
					JDBCTemplate.rollback(conn);
					JDBCTemplate.close(conn);
					return 0;
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
	    System.out.println("--- [PostService] ---");
	    System.out.println("selectPostDetail 호출됨, PostNo: " + postNo + ", 조회수증가: " + isIncrementRequired);
	    Connection conn = JDBCTemplate.getConnection();
	    Post Post = null; // PostVO 사용

	    if (isIncrementRequired) {
	        int result = dao.updateReadCount(conn, postNo); // PostDao 사용
	        if (result > 0) {
	            JDBCTemplate.commit(conn);
	            System.out.println("조회수 증가 성공");
	        } else {
	            JDBCTemplate.rollback(conn);
	            System.out.println("조회수 증가 실패 또는 해당 게시글 없음 (updateReadCount 결과 0)");
	        }
	    }

	    Post = dao.selectOnePost(conn, postNo); // PostDao의 selectOnePost 사용

	    if (Post == null) {
	         System.out.println("PostDao.selectOnePost 가 PostNo '" + postNo + "'에 대해 null을 반환했습니다.");
	    } else {
	        System.out.println("DAO에서 가져온 Post 제목: " + Post.getPostTitle());
	        // 댓글 목록, 파일 목록 등 추가 로딩 로직
	        // ArrayList<CommentVO> commentList = PostDao.selectCommentList(conn, PostNo);
	        // Post.setCommentList(commentList); // PostVO에 댓글 리스트를 담는 필드와 setter가 있다고 가정
	    }

	    JDBCTemplate.close(conn);
	    return Post;
	}
	
	
}
