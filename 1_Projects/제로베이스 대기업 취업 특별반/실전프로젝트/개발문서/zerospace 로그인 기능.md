---
created: 2024-09-28 17:54
updated: 2024-10-03T00:42
tags:
  - 실전서비스런칭프로젝트
회의: false
Progress:
  - in progress
---
# 로그인 기능
## 요구사항

### 1.  OAuth를 이용해 카카오 로그인을 수행할 것
이때 
1. 메인페이지 /
2. login
3. 랜딩페이지 (랜딩페이지 URI는 아직 안정해짐) 

위의 세 가지 URI의 접근은 OAuth로 체크하지 않을 것
### 2. 로그인이 수행되고 EMAIL을 가져와서 DB에 저장할것 
DB에 저장할 때 RandomString ID값을 만들기 그에 대응하도록 만들어줄 것

### 3. 로그인 후 서버에서 JWT토큰을 만들것
accessToken은 헤더에
refreshToken은 HTTPOnly Cookie에 담아서 보낼 것
### 4. 들어오는 모든 요청에 JWT토큰을 검사할 것
1. 제외 페이지는 검사하지 않는다.
2. 들어오는 모든 요청에 JWT토큰 검사 로직이 있어야한다. 
#### JWT토큰이 유효한경우 
요청에 응답을 하도록 비지니스로직 수행
#### JWT토큰이 유효하지 않은 경우(시간 만료)
시간이 만료된 경우 403 에러를 줄 것 이때 message를 담아서 줘야함(accessToken expired)
#### JWT토큰이 유효하지 않은 경우(인증되지 않은 사용자)
403에러를 줄 것
이때 뒤에 message등록(인증되지 않은 사용자 - Unauthorized user)

---
# 요구사항을 토대로 만들 기능 쪼개보기

1. 환경설정 셋업하기
2. Spring Security Filter OAuth 수행하기(카카오 로그인) - 이메일 닉네임 가져오기
3. JWT토큰 발급, 생성 관리 객체 만들기 - JWT Const파일에 넣기
4. 로그인이 완료되면 JWT토큰 생성하기(accessToken은 헤더에, refreshToken은 HTTPonly쿠키에)


## 환경설정 셋업하기 -함
- Spring Security 의존성넣기
- Database 의존성 넣기 8.0.39임
- 테스트 Sl4fj넣기

## 카카오 로그인 설정하기(성공 경우)
OAuth Filter지정 
카카오 로그인 성공 후 JWT토큰 발급하기
카카오 로그인 실패시 에러메시지 + 403응답 코드 보내기

성공시 핸들러 만들어서 처리하기

1. filter만들기
2. filter에서 로그인 성공핸들러, 실패 핸들러 만들기

#### 로그인 성공 핸들러
DB에 사용자 이메일 있나 check하기
있으면 randomString값 가져오기 없으면 새로 만들어서 DB에 넣기


JWT토큰 생성하기

---
# 코드짜기(Github 커밋 코드 보면 됨)
# branch feat/login

## Spring Security(로그인 성공시 핸들러 진입)
Spring Security Filter설정
1. /oauth2/authorization/kakao 경로로 로그인 시도
2. 로그인 성공시 successHandler로 진입

OAuthSuccessHandler
로그인 성공시 카카오 로그인 성공 정보 추출

<파일에 추가해야 하는 기능>
[ ] DB에 저장된 사용자인지 확인하는 기능
[ ] JWT토큰 만들어서 통신에 추가하는 기능

OAuthTest.java
파일 만들어서 mock데이터로 OAuth로그인 여부 확인하려 했으나
test로는 확인 불가

  
commit e92cf896b3b116435d0e9f86e0b8cc60fb71b7c3

## DB에 저장된 사용자인지 확인하는 기능 추가

Member
Member 객체 생성
pk userId(랜덤생성키) 보안을 위해
Secure random을 사용해서 보안이 강화된 문자열 생성

MemberRepository
-> Member를 Email로 찾는 메소드 쿼리 생성

MemberService
-> 가져야하는 기능 정의
-회원가입(join)
-DB에 저장된 멤버인지 확인(hasMember)
- 회원 조회(findMember);

MemberServiceImpl
MemberService의 구현체

OauthSuccessHandler
MemberService의존성 추가
DB에 Member가 있으면 true없으면 false반환
false인경우는 새롭게 userId 생성후 DB에 저장해야 됨
  
commit 5d40dbfcfa259677e2e7e2f2b889db7149341b23

## join시 userId로 파라미터 받아 저장하기
refact: join시 userId도 파라미터로 받아 저장하기

join시 parameter로 userId, email, nickName받아서 저장하는 방식으로 지정

userId를 create하는 부분은 OAuthSucessHandler의 private method로 지정-> userId create는 회원 가입시에만 이루어지기 떄문
그리고 회원 가입은 OAuthSuccessHandler에만 이루어진다.


commit cd956b12c15a276037613e17969dbf9e950c8e39

## JWT토큰 발급 기능 (로그인 성공 시)
JWT토큰을 발급 기능 구현

Const.java
토큰 발급을 위한 상수
accessTokend의 상수
RefreshToken의 상수
SecretKey의 정보가 담겨있다

JWTTokenService.java
JWT토큰 발급 및 검증 로직
검증로직은 아직 구현하지 않음

MemberService.java
Member를 userId로 찾는 메소드쿼리 추가

MemberServiceImp
findMember를 통해서 멤버를 찾고 UserId를 가져온다.

OAuthSuccessHandler
결과를 담아 JSON 파일 형식으로 리턴한다.
AcessToken은 헤더에
RefreshToken은 HTTPonly쿠키에 담겨있다

  
commit 55e21acbced9a278ac1060b44357f560aef01523

## JWT토큰 검사기능

### return message
403에러 메세지와 함께 return할 것  body에 넣어서 보내기
그리고 accessToken expired되면 다시 재발급 해줘야함
 
Invalid accessToken
Invalid refreshToken
No accessToken

---

refreshToken expired
Invalid refreshToken token signature
Invalid refreshToken token

no tokens -> 토큰이 없는 경우