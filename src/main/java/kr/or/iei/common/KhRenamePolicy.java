package kr.or.iei.common;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import com.oreilly.servlet.multipart.FileRenamePolicy;

public class KhRenamePolicy implements FileRenamePolicy{

	@Override
	public File rename(File originalFile) {
		/*
		 * 서버에 저장된 파일 명칭
		 * 
		 * yyyyMMddHHmmssSSS_랜덤숫자5개.확장자
		 * */
		
		int ranNum = new Random().nextInt(10000)+1;	//1~10000중 랜덤 숫자
		
		String str = "_" + String.format("%05d", ranNum); //"_랜덤숫자 5자리"
		
		String name = originalFile.getName();	//사용자가 업로드한 파일 명칭 => test.jpg
		String ext = null;	//확장자를 저장할 변수
		
		int dot = name.lastIndexOf(".");	//파일명 뒤에서부터 마침표 위치 반환 (반환은 앞자리부터), 없으면 -1리턴
		
		if(dot != -1) {	//파일에 마침표가 있을 때
			ext = name.substring(dot);	//확장자 문자열 ex).jpg
		} else {
			ext = "";	//마침표가 없으면 빈 문자열 반환
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		String serverFileName = sdf.format(new Date(System.currentTimeMillis())) + str + ext;	//test.jpg->202505091217213543_13579.jpg
		
		//서블릿에서 생성한 오늘 날짜 폴더 하위에 새로이 생성한 명칭으로 업로드
		File newFile = new File(originalFile.getParent(), serverFileName);
		
		return newFile;
	}

}
