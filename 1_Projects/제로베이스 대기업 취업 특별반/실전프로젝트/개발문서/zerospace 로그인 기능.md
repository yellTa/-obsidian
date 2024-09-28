---
created: 2024-09-28 17:54
updated: 2024-09-28T18:49
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
- 
