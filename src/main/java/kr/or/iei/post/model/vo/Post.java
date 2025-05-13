package kr.or.iei.post.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Post {
    private String postNo;            // varchar2(20) - 게시글 번호 (PK)
    private String boardCode;         // char(1) - 게시판 코드 (FK)
    private int memberNo;             // number(10) - 작성자 회원 번호 (FK)
    private String postTitle;         // varchar2(100) - 게시글 제목
    private String postContent;       // varchar2(4000) - 게시글 내용
    private String postDate;          // date - 게시글 작성일 (DDL 상 이름은 post_date, 주석의 post_creation_date는 의도)
    private String postUpdateDate;    // date - 게시글 수정일 (nullable)
    private int postViewCount;        // number(10) - 조회수
}
