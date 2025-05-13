<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>성격봐라 - 회원가입</title>
<style>
.join-wrap {
  padding: 30px;
  margin: 50px auto;
  max-width: 600px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.08);
  font-family: 'Pretendard', sans-serif;
}

.join-wrap .page-title {
  font-size: 22px;
  font-weight: bold;
  text-align: center;
  margin-bottom: 25px;
}

.join-wrap .input-wrap {
  margin-bottom: 20px;
}

.join-wrap .input-title {
  font-weight: 600;
  margin-bottom: 6px;
  font-size: 15px;
}

.join-wrap .input-item {
  display: flex;
  gap: 10px;
}

.join-wrap .input-item input {
  flex: 1;
  padding: 10px;
  font-size: 14px;
  border: 1px solid #ccc;
  border-radius: 5px;
}

.join-wrap .input-item button {
  white-space: nowrap;
  padding: 10px 14px;
  font-size: 13px;
  background-color: #d9d9d9; /* 연회색으로 변경 */
  color: #333;
  border: none;
  border-radius: 5px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.2s;
}

.join-wrap .input-item button:hover {
  background-color: #bfbfbf; /* hover 시 진한 회색 */
}

.join-wrap .input-msg {
  font-size: 13px;
  margin-top: 5px;
}

.join-wrap .input-msg.valid {
  color: #2ecc71;
}

.join-wrap .input-msg.invalid {
  color: #e74c3c;
}

.join-wrap .join-button-box {
  margin-top: 30px;
}

.join-wrap .btn-primary.lg {
  width: 100%;
  padding: 14px;
  font-size: 16px;
  font-weight: bold;
  background-color: #f85a88;
  color: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.2s;
}

.join-wrap .btn-primary.lg:hover {
  background-color: #e14b76;
}

</style>
<script src="/resources/js/sweetalert.min.js"></script>
<script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<main class="content">
			<section class="section join-wrap">
				<div class="page-title">회원가입</div>
				
				<form action='/member/join' 
				      method="post" 
				      autocomplete="off"
				  	
				  	  onsubmit="return validateForm()">
					   
					   <div class="input-wrap">				      	
						      	<div class="input-title">
						      		<label for="memberMbti">MBTI</label>	
						      	</div>
						      	<div class="input-item">
						      		<input type="text" id="memberMbti" name="memberMbti" placeholder="대문자 4글자로" maxlength="4">
						      		<button type="button" class="btn-primary" id="mbtiTest">MBTI 테스트 해보기</button>
						      	</div>
						      	<p id="mbtiMessage" class="input-msg"></p>
					      </div>
				        
				        <div class="input-wrap">				      	
					      	<div class="input-title">
					      		<label for="memberId">아이디</label>	
					      	</div>
					      	<div class="input-item">
					      		<input type="text" id="memberId" name="memberId" placeholder="영어, 숫자 8~20글자" maxlength="20">
					      		<%-- 아이디 중복체크 버튼! form 태그 내에서 button 태그 타입 미지정 시, submit 기능을 가짐 --%>
					      		<button type="button" class="btn-primary" id="idDuplChkBtn">아이디 중복체크</button>
					      	</div>
					      	<p id="idMessage" class="input-msg"></p>					      	
				      </div>
				      
				      <div class="input-wrap">				      	
					      	<div class="input-title">
					      		<label for="memberNickname">닉네임</label>	
					      	</div>
					      	<div class="input-item">
					      		<input type="text" id="memberNickname" name="memberNickname" placeholder="한글, 영어, 숫자 15글자까지" maxlength="15">
					      		<button type="button" class="btn-primary" id="nicknameDuplChkBtn">닉네임 중복체크</button>
					      	</div>
					      	<p id="nicknameMessage" class="input-msg"></p>
				      </div>
				      
				        <div class="input-wrap">				      	
					      	<div class="input-title">
					      		<label for="memberPw">비밀번호</label>	
					      	</div>
					      	<div class="input-item">
					      		<input type="password" id="memberPw" name="memberPw" placeholder="영어, 숫자, 특수문자(!@#$) 6~30글자" maxlength="30">
					      	</div>
					      	
				      </div>
				      

				        <div class="input-wrap">				      	
					      	<div class="input-title">
					      		<label for="memberPwRe">비밀번호 확인</label>	
					      	</div>
					      	<div class="input-item">
					      		<input type="password" id="memberPwRe" maxlength="30">
					      	</div>
					      	<p id="pwMessage" class="input-msg"></p>
				      </div>
				       <div class="input-wrap">				      	
					      	<div class="input-title">
					      		<label for="memberName">이름</label>	
					      	</div>
					      	<div class="input-item">
					      		<input type="text" id="memberName" name="memberName" placeholder="본인인증으로 자동기입" readonly>
					      		<button type="button" onclick="certificationReq()">본인 인증</button>
					      	</div>
					      	<p id="nameMessage" class="input-msg"></p>
				      </div>
				      
						<div class="input-wrap">				      	
						 	<div class="input-title">
						    	<label for="memberPhone">전화번호</label>	
						  	</div>
						  	<div class="input-item">
						    	<input type="text" id="memberPhone" name="memberPhone" placeholder="본인인증으로 자동기입" readonly>			    
						  	</div>
						  	<p id="phoneMessage" class="input-msg"></p>
						</div>
				      
				        <div class="input-wrap">				      	
					      	<div class="input-title">
					      		<label for="memberEmail">이메일</label>	
					      	</div>
					      	<div class="input-item">
					      		<input type="email" id="memberEmail" name="memberEmail">
					      	</div>
					      	<p id="emailMessage" class="input-msg"></p>
					     </div>
				
				        <div class="join-button-box">				      	
							<button type="submit" class="btn-primary lg">회원가입</button>
				      </div>
				</form>
			</section>
		</main>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>	
	
	
	
	<script>
	
	//사용자 입력한 값 유효성 검증 결과를 저장할 객체	
		const checkObj = {
			"memberMbti" : false,
			"memberId" : false, //기본값은 false, 통과할때 true 로 변경시켜주기. 전부 다 true 일때만 서버에 요청 submit 보내주기로 
			"memberNickname" : false,
			"memberPw" : false,
			"memberPwRe" : false,
			"identityVerification" : false, //본인인증성공시 true
			"memberEmail" : false,
			"idDuplChk" : false,
			"nicknameDuplChk" : false
		};
		
		const memberMbti = $('#memberMbti'); 
		const mbtiMessage = $('#mbtiMessage'); 
		
		$(memberMbti).on('input', function() {
			checkObj.memberMbti = false;
			$(mbtiMessage).removeClass('valid');
			$(mbtiMessage).removeClass('invalid');
			
			const regExp = /^[IE][NS][FT][PJ]$/;
			if(regExp.test($(this).val())) {
				$(mbtiMessage).text('완료');
				checkObj.memberMbti = true;
				$(mbtiMessage).addClass('valid');
			}else {
				$(mbtiMessage).text('MBTI 형식에 맞게 기입해주세요.');
				$(mbtiMessage).addClass('invalid');
				checkObj.memberMbti = false;
			}
		});
	
		const memberId = $('#memberId'); 
		const idMessage = $('#idMessage');
		
		
		$(memberId).on('input', function() {
			checkObj.idDuplChk = false;
	
			$(idMessage).removeClass('valid');
			$(idMessage).removeClass('invalid');
			
			//아이디 정규 표현식 -> 영어, 숫자 8~20글자
			const regExp = /^[a-zA-Z0-9]{8,20}$/; 
			
			
			if(regExp.test($(this).val())) { 	
				$(idMessage).text('완료');
				checkObj.memberId = true;
				$(idMessage).addClass('valid'); 
			}else {
		
				$(idMessage).text('영어, 숫자 8~20글자 사이로 입력하세요');
				$(idMessage).addClass('invalid'); 
				checkObj.memberId = false;
			}
		});
		
		//아이디 중복체크
		const idDuplChkBtn = $('#idDuplChkBtn'); 
		
		$(idDuplChkBtn).on('click', function() {	
		
			$(idMessage).removeClass('valid');
			$(idMessage).removeClass('invalid');
			
			if(!checkObj.memberId) { 
				swal({
					title : "알림",
					text : "유효한 ID를 입력하고, 중복체크를 진행하세요.",
					icon : "warning"
				});
			
				return;
			}
		
			$.ajax({
				url : "/idDuplChk",							//요청 URL
				data : {'memberId' : $(memberId).val()}, 	//서버로 전송할 데이터
				type : "get",								//데이터 전송 방식
				success : function(res) {					
					
					if(res==0) { //중복 없음, 즉 회원가입 가능
						
						swal({
							title : "알림",
							text : "사용 가능한 ID입니다.",
							icon : "success"
						}).then(function(){
						    $('#memberNickname').focus(); // 닉네임 입력창으로 커서 이동
						});
					
					checkObj.idDuplChk = true;
					$(idMessage).addClass('valid');
					
					}else {

						swal({
							title : "알림",
							text : "이미 사용중인 ID 입니다.",
							icon : "warning"
						});

					
					checkObj.idDuplChk = false;
					
					}
				},
				
				error : function() {						//비동기 통신에서 에러가 발생했을때 호출되는 함수. 
					
				}
			});			
			
		});

		
		
		//닉네임유효성검사
		
		const memberNickname = $('#memberNickname'); 
		const nicknameMessage = $('#nicknameMessage'); 
		
		$(memberNickname).on('input', function() {
			checkObj.memberNickname = false;
			$(nicknameMessage).removeClass('valid');
			$(nicknameMessage).removeClass('invalid');
			
			//닉네임 유효성 검사
			const regExp = /^[가-힣a-zA-Z0-9]{1,15}$/;

			
			if(regExp.test($(this).val())) {
				$(nicknameMessage).text('완료');
				checkObj.memberNickname = true;
				$(nicknameMessage).addClass('valid');
			}else {
				$(nicknameMessage).text('최대15자 한글, 영문 숫자 조합으로 기입해주세요.');
				$(nicknameMessage).addClass('invalid');
				checkObj.memberNickname = false;
			}
		});
		
		
		const nicknameDuplChkBtn = $('#nicknameDuplChkBtn'); //중복체크 버튼 요소
		
		$(nicknameDuplChkBtn).on('click', function() {	
		
			$(nicknameMessage).removeClass('valid');
			$(nicknameMessage).removeClass('invalid');
			
			if(!checkObj.memberNickname) { //id 유효성 검증 결과가 false 일 떄 
				swal({
					title : "알림",
					text : "닉네임 형식에 맞춰서 입력하시고, 중복체크를 진행하세요.",
					icon : "warning"
				});
			
				return;
			}
		
		
			$.ajax({
				url : "/nicknameDuplChk",							
				data : {'memberNickname' : $(memberNickname).val()}, 	
				type : "get",								
				success : function(res) {					
					
					if(res==0) { //중복 없음, 즉 회원가입 가능
						
						swal({
							title : "알림",
							text : "사용 가능한 닉네임입니다.",
							icon : "success"
						}).then(function(){
						    $('#memberPw').focus(); // 비밀번호 입력창으로 커서 이동
						});
					
					checkObj.nicknameDuplChk = true;
					$(nicknameMessage).addClass('valid');
					
					}else {

						swal({
							title : "알림",
							text : "이미 사용중인 닉네임 입니다.",
							icon : "warning"
						});

					
					checkObj.nicknameDuplChk = false;
					
					}
				},
				
				error : function() {						//비동기 통신에서 에러가 발생했을때 호출되는 함수. 
					
				}
			});			
			
		});
		
	

		//비밀번호 유효성 검사
		const memberPw = $('#memberPw');
		const pwMessage = $('#pwMessage');
		//비밀번호 확인 유효성 검사 변수
		const memberPwRe = $('#memberPwRe');
		
		$(memberPw).on('input', function() {
			$(pwMessage).removeClass('invalid');
			$(pwMessage).removeClass('valid');
			
			const regExp = /^[a-zA-Z0-9!@#$]{6,30}$/; //영어, 숫자, 특수문자(!@#$) 6~30글자
			
			if(regExp.test($(this).val())) { 
				checkObj.memberPw = true;
				
			
				//비밀번호 확인 값이 입력이 되었을 때
				if($(memberPwRe).val().length>0) {
					
					checkPw();
				}else {
					$(pwMessage).text('');
					$(pwMessage).addClass('valid');
				}
				
			}else {
				checkObj.memberPw = false;
				$(pwMessage).text('비밀번호 형식이 유효하지 않습니다.');
				$(pwMessage).addClass('invalid');
			}
			
		});
		
		//비밀번호 확인 유효성 검사
		$(memberPwRe).on('input', checkPw);
		
		
		//선언적 함수로 별도의 함수로 분리해냄
		function checkPw() {
			$(pwMessage).removeClass('invalid');
			$(pwMessage).removeClass('valid');
			
			//입력한 비밀번호가 유효하고! 값도 같을때
			if(checkObj.memberPw && $(memberPw).val() == $(memberPwRe).val()) {
				$(pwMessage).text('');
				$(pwMessage).addClass('valid');
				checkObj.memberPwRe = true;
			
			//입력한 비밀번호가 유효하지 않을 때
			}else if(!checkObj.memberPw) {
				$(pwMessage).text('비밀번호가 형식이 유효하지 않습니다.');
				$(pwMessage).addClass('invalid');
				checkObj.memberPwRe = false;
			
			} else {
				$(pwMessage).text('비밀번호가 일치하지 않습니다.');
				$(pwMessage).addClass('invalid');
				checkObj.memberPwRe = false;
			}
		}
		
		//이메일 유효성 검사
		const memberEmail = $('#memberEmail');
		const emailMessage = $('#emailMessage');
		
		$(memberEmail).on('input', function(){
			$(emailMessage).removeClass('invalid');
			$(emailMessage).removeClass('valid');
			
			const regExp = /^[0-9a-zA-Z]([-_]?[0-9a-zA-Z])*@[a-zA-Z]([-_.]?[0-9a-zA-Z])+(\.[a-z]{2,3})$/; //이메일 시작은 숫자거나 영문자이다. - _이 포함될수 있다. 이후에 숫자나 영문자 반복될수 있다. @고정 이후에 영문자 올수있고 반복될수있음. 그리고 .마침표 고정. 이후에 영문자 소문자 2자리 3자리로 끝난다. +로 1회이상 반복될수있도록 지정.
			//맨 마지막 .은 모든문자 의미하는 메타문자로 인식할 수 있기때문에, 기입 바로 전에 \로 escape 시켜준다.
			
			if(regExp.test($(this).val())) {
				$(emailMessage).text('');
				$(emailMessage).addClass('valid');
				checkObj.memberEmail = true;
			}else {
				$(emailMessage).text('이메일 형식이 올바르지 않습니다.');
				$(emailMessage).addClass('invalid');
				checkObj.memberEmail = false;
			}
		});
		
		//핸드폰형식 010-0000-0000으로 바꿔줄 함수.
		function formatPhoneNumber(phone) {
			  return phone.replace(/^(\d{3})(\d{3,4})(\d{4})$/, '$1-$2-$3');
		}
	
		//본인인증 -- 이름과 전화번호 자동기입 후 수정불가 상태로 변경 readonly
		async function certificationReq() {
			let response = {};	//요청 결과
			let identityId = '';//각 요청을 구분하기 위한 식별값
			
			//본인 인증 요청
			
			while(true){
				identityId = 'identity-verification-' + Math.random();
				
				try {
					response = await PortOne.requestIdentityVerification({
					  storeId: "store-c8e99481-9811-4fe6-a73f-8f61fa0268ef",			//관리자 콘솔 우측 상단 대표 상점아이디
					  identityVerificationId: identityId,								//요청 식별값
					  channelKey: "channel-key-d0d7978f-11a8-4d13-890b-a58752713790",	//사전 작업 (2)에서 채널 추가 시, 발급되는 Key
					});
					
				}catch(e){
					//본인인증 성공 시, 동일한 identityVerificationId로 인증 요청 불가로, 다시 identityId 발급받아 요청 보낼 수 있도록
					if(e.transactionType === "IDENTITY_VERIFICATION"){
						continue;
					}else {
						console.log('기타 오류');
						console.dir(e);
					}
					
				}
				
				break;
			}
			
			
			//인증 도중, 인증 팝업을 닫으면 code값 없음.
			if (response.code !== undefined) {
			  return swal({
				  title : "알림",
				  text : response.message,
				  icon : "warning"
			  });
			  
			}else {
				
				
				//요청 결과 조회
				try {
				   // 포트원 본인인증 내역 단건조회 API 호출
				   const verificationResponse = await $.ajax({
				     url: 'https://api.portone.io/identity-verifications/' + encodeURIComponent(identityId), //위에서 요청 시, 생성한 식별값으로 조회
				     headers: { Authorization: 'PortOne DJsHE6j9ut575YwuAIxIKZJCOv4XLqC3vOQcWLqrjSGBJOyxxirR0HJLPtXIKX5wNMKT3Aax4OZjnQNo'}, //사전 작업 (3)에서 발급받은 API Secret Key
				   });
				   
				   console.log('verificationResponse');
				   console.dir(verificationResponse);
				   
				   //요청 결과 조회 통신 자체에서 오류 발생한경우
				   if (verificationResponse.ok != undefined  && !verificationResponse.ok) {
				     throw new Error({
				       verificationResponse: '인증 결과 조회 오류'
				     });
				   }
				   
				   //요청 결과 조회 통신은 정상. 이후, 결과 status가 실패인경우
				   console.log('identityVerification');
				   console.dir(verificationResponse);
				   const identityVerification = await verificationResponse;
				   
				   //인증 실패
				   if (identityVerification.status !== "VERIFIED") {
				      return swal({
				    	  title : "인증결과",
				    	  text : "본인인증에 실패하였습니다.",
				    	  icon : "error"
				      });
				   }else {
					  
					   swal({
					    	  title : "인증결과",
					    	  text : "본인인증에 성공하였습니다.",
					    	  icon : "success"
					      });
					   
					   
					   checkObj.identityVerification = true;
					   
					   // 인증 성공 시 전화번호 자동 입력 + 유효성 처리
					    	
					   const name = identityVerification.verifiedCustomer?.name;
					   const phone = identityVerification.verifiedCustomer?.phoneNumber;

					   if (phone) {
						 const formattedPhone = formatPhoneNumber(phone);
					     $('#memberPhone').val(formattedPhone);
					     $('#phoneMessage').text('인증 완료').removeClass('invalid').addClass('valid');
					    
					   	}

					   if (name) {
					     $('#memberName').val(name);
					     $('#nameMessage').text('인증된 이름 자동 입력').removeClass('invalid').addClass('valid');
					   	}
	
					}  
					
				   
				} catch (e) {
				   console.error(e);
				}
			}
			
			
		}
		
		
		function validateForm() {
			  let str = ""; // 실패 메시지

			  for (let key in checkObj) {
			    if (!checkObj[key]) {
			      // 속성별 메시지 지정
			      switch (key) {
			        case "memberMbti":
			          str = "MBTI를 입력해주세요.";
			          break;
			        case "memberId":
			          str = "아이디 형식이 유효하지 않습니다.";
			          break;
			        case "memberPw":
			          str = "비밀번호 형식이 유효하지 않습니다.";
			          break;
			        case "memberPwRe":
			          str = "비밀번호 확인이 일치하지 않습니다.";
			          break;
			        case "memberEmail":
			          str = "이메일 형식이 유효하지 않습니다.";
			          break;
			        case "idDuplChk":
			          str = "아이디 중복체크를 진행하세요.";
			          break;
			        case "nicknameDuplChk":
			          str = "닉네임 중복체크를 진행하세요.";
			          break;
			        case "identityVerification":
			          str = "본인인증을 완료해주세요.";
			          break;
			        default:
			          str = "입력 형식이 유효하지 않습니다.";
			      }

			      swal({
			        title: "회원가입 실패",
			        text: str,
			        icon: "warning"
			      });

			      return false;
			    }
			  }

			  // 모든 항목 true인 경우 통과
			  return true;
			}
	</script>
</body>
</html>