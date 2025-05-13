package kr.or.iei.member.model.vo;
import java.sql.Date; // 만약 Date 타입을 사용한다면, 또는 String으로 처리 가능

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Member {

    private String memberNo;              // string으로 변경함
    private String memberId;              // varchar2(50)
    private String memberPw;              // varchar2(72)
    private String memberNickname;        // varchar2(50)
    private String memberName;            // varchar2(100)
    private String memberEmail;           // varchar2(254)
    private String memberPhone;           // varchar2(20)
    private String memberMbti;            // varchar2(4)
    private int memberGrade;              // number(1)
    private String memberJoinDate;        // date - String으로 처리 (예: "YYYY-MM-DD HH24:MI:SS")
    private int memberLoginDaysCount;     // number(5)
    private int memberSanctionCount;      // number(3)
    private int memberCommentLikeCount;   // number(10)
    private int memberPostLikeCount;      // number(10)
    private int memberPoint;              // number(10)
    
}
