---
created: 2024-09-20 21:54
updated: 2024-09-20T21:58
tags:
  - 실전서비스런칭프로젝트
출처: 
---
# OAuth로 로그인하고 세션 유지하기
## 프로세스

### 1.클라이언트(프론트) 에서 로그인 요청
스프링 Security로 지정한 http://localhost:8080/oauth2/authorization/kakao 이 링크로 리다이렉션 됨

Spring Seuciryt는 Application.properties에 있다.

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
