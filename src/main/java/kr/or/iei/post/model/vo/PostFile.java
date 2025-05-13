package kr.or.iei.post.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class PostFile {
	private int fileNo;         // number(10) - 파일 번호 (PK)
    private String postNo;      // varchar2(20) - 파일이 업로드된 게시글 번호 (FK)
    private String fileName;    // varchar2(300) - 사용자가 업로드한 원본 파일 명칭
    private String filePath;    // varchar2(300) - 서버 내에 업로드된 파일의 (고유한) 경로 또는 이름

}
