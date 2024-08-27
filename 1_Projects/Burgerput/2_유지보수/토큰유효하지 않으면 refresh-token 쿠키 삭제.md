---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress:
  - end
업로드할까?: false
created: 2024-07-02T18:05:00
updated: 2024-08-27T18:05
---
# OBJECT/SUBJECT:

토큰이 유효하지 않은 경우 httponly쿠키를 삭제해서 쿠키가 쌓이는 현상을 방지하도록 하자

# ANALYSIS:

```Java
 else {
                    //token이 유효하지 않은 경우 // refresh-token도 함께 삭제
                    log.info("Interceptor :액세스 토큰 > 토큰 유효하지 않음");
                    //토큰이 유효하지 않을때에는 지워버려야 함
                    
                    sendError(response, HttpServletResponse.SC_UNAUTHORIZED, "InvalidToken");
                    return false;
                }
```

현재 코드는 token이 유효하지 않은 경우에는 401에러와 메세지만 보내고 있다.

# CONCLUSION:

쿠키를 삭제하는 로직을 낑겨넣어서 httpOnly 쿠키를 삭제하도록 하자!

  

# HOW TO:

```Java
else {
                    //token이 유효하지 않은 경우 // refresh-token도 함께 삭제
                    log.info("Interceptor :액세스 토큰 > 토큰 유효하지 않음");
                    //토큰이 유효하지 않을때에는 지워버려야 함

                     ResponseCookie refreshTokenCookie = ResponseCookie.from(REFRESH_TOKEN_COOKIE_NAME, "")
                            .path("/")
                            .sameSite("None")
                            .httpOnly(true)
                            .secure(true)
                            .maxAge(0) // 쿠키의 만료 시간 설정 (0으로 설정하여 즉시 삭제)
                            .domain(".burback.shop")
                            .build();
                    response.addHeader("Set-Cookie", refreshTokenCookie.toString()); // 응답에 쿠키 추가
                    sendError(response, HttpServletResponse.SC_UNAUTHORIZED, "InvalidToken");
                    return false;
                }
```

1. 쿠키 생성
2. 쿠키의 경로 설정
3. HttpOnly설정
4. 만료 시간 설정 - > 0으로 지정하면 삭제된다.
5. 응답에 쿠키를 추가

# SOLVE:

## 브라우저에 쿠키를 삭제하는 방법

- **쿠키를 생성**: `new Cookie("refresh-token", null)`를 통해 이름이 "refresh-token"인 쿠키를 생성합니다.
- **쿠키의 경로 설정**: `refreshTokenCookie.setPath("/")`를 통해 어플리케이션 전체에서 접근할 수 있도록 경로를 설정합니다.
- **HttpOnly 설정**: `refreshTokenCookie.setHttpOnly(true)`를 통해 쿠키가 클라이언트 측 JavaScript로부터 접근할 수 없도록 설정합니다.
- **만료 시간 설정**: `refreshTokenCookie.setMaxAge(0)`을 통해 쿠키를 즉시 만료시킵니다.
- **응답에 쿠키 추가**: `response.addCookie(refreshTokenCookie)`를 통해 응답에 쿠키를 추가하여 브라우저가 이를 처리하도록 합니다.

  

설정할 때 중요한 점은 쿠키의 경로와 도메인이 기존에 설정된 쿠키와 동일해야 한다!

### 삭제할 때 쿠키의 옵션은 기존에 생성한 쿠키의 옵션과 같아야 한다!

> 즉 쿠키를 설정할 때와 똑같은 옵션으로 설정하고 maxAge만 0으로 변경하는 것!!!! → 똑같은 옵션이어야한다!!!