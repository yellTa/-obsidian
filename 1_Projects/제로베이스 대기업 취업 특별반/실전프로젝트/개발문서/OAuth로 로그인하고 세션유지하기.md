---
created: 2024-09-20 21:54
updated: 2024-09-21T10:12
tags:
  - 실전서비스런칭프로젝트
출처: 
---
# OAuth로 로그인하고 세션 유지하기
## 프로세스
### 배경
1. 메인 페이지는 로그인, 상품등록 페이지로 이동할 수 있다.
2. 이때 로그인이 되지 않은 상태이면 로그인 페이지로 리다이렉트하는 기능이 있다.
3. 메인 페이지와 로그인페이지는 로그인 검사없이 진입 가능하다.
4. 상품 구성페이지는 무조건 로그인해야 가능하다.


1. kakao Developter Center설정
2. Spring boot 프로젝트 설정
3. 페이지 구성
   메인페이지
   로그인페이지
   상품등록페이지
   로그아웃페이지

Spring Filter가 자동으로 생성돼 인증된 사용자인지 확인하고 확인되지 않았으면 /?continue로 리다이렉트하고 있다.

따라서 우리가 필요한 Filter를 적용해야한다.
Spring Filter가 customFilter보다 우선순위를 가지므로 Spring Filter를 체크해야한다.
   




---


### 1.클라이언트(프론트) 에서 로그인 요청
스프링 Security로 지정한 http://localhost:8080/oauth2/authorization/kakao 이 링크로 리다이렉션 됨

Spring Seuciryt는 Application.properties에 있다. 
redirect-uri를 설정하고 그 uri에 맞는 셋업이 되어있어야됨


### 2. Spring Security에서 처리하기 
요청을 받으면 Spring Security가 카카오 인증서버에 다시 리디렉션 함. 카카오 로그인 페이지가 사용자에게 표시됨 

### 3. 카카오 인증 서버에서 로그인하기
사용자가 카카오 계정으로 로그인하고 권한을 부여
redirect-rui로 다시 사용자를 리디렉션함
  
http://localhost:8080/oauth
참고로 redirect-URI는 카카오 developers에서 지정하는 거임

### 4. 백엔드에서 받아서 처리하기
이 리디렉션 요청을 받아서 인증 코드를 처리하고 이를 통해 카카오 API에서 액세스토큰을 받아 사용자의 프로필 정보를 가져옴


# 결론

# REVIEW

---
# 참고
