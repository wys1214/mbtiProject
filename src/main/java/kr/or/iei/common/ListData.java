package kr.or.iei.common;

import java.util.ArrayList;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ListData <T>{
	//제네릭 타입 : 미리 타입을 지정하는 것이 아니라 객체를 생성할 때 지정됨
	//게시글 목록으로 한다면 게시글인 notice, 회원으로 한다면 회원정보인 member가 됨
	ArrayList<T> list;
	String pageNavi;
}
