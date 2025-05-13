package kr.or.iei.post.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class PostComment {
	private int commentNo;
	private String postNo;
	private String parentCommentNo;
	private String commentMemberNo;
	private String commentContent;
	private String commentDate;
	private String commentUpdateDate;
	
}
