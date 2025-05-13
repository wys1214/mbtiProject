<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/resources/js/sweetalert.min.js"></script>
</head>
<body>
	<script>
		<%-- EL(Expression Language) 문법으로, ${변수명}을 통해 서버에서 request scope, session scope 등에 담겨있는 값을 출력하는 방식 --%>
		const title = '${title}'; //알림창제목
		const msg = '${msg}'; //본문 메시지
		const icon = '${icon}'; //아이콘
		const loc = '${loc}'; //알림창 출력 후, 요청 url
		const callback = '${callback}'; //콜백 함수 알림창 출력 후, 실행할 스크립트 함수
		
		swal({
			title : title,
			text : msg,
			icon : icon
		}).then(function() { //알림창 띄워졌을때 확인버튼 클릭할때 실행할 함수
			if(callback != '' && callback != null) { 
				eval(callback); 
			}
			
			if(loc != '' && loc != null) { //어디로 요청 보낼것인지 기입.
				location.href = loc;
			}
		});
	</script>
</body>
</html>