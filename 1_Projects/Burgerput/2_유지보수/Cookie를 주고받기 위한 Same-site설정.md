---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress:
  - end
업로드할까?: false
created: 2024-06-27T18:05:00
updated: 2024-09-01T00:23
---
# OBJECT: 서로다른 도메인이 쿠키를 주고받기 위해 필요한 설정

# ANALYSIS:

Spring의 response쿠키를 사용해서 쿠키를 만든다. 서로 다른 도메인에서 쿠키를 주고받기 위한 설정을 수행한다.

  

## 서로다른 도메인에서 쿠키를 주고받기 위해 필요한 설정

1. SSL이 적용된 상태에서 데이터를 주고 받아야 한다.
2. httpOnly설정이 필요하다. → true로 설정하면 JavaScript를 통해 쿠키에 접근할 수 없도록 한다.
3. SameSite속성은 쿠키가 요청과 함께 전송될 때, 동일 사이트 여부에 따라서 전송 제어를 하는데 사용한다.

  

# HOW TO:

> [!important]  
> LoadingController  

```Java
     //설정시에만 Srping에서 제공하는 ResponseCookie사용
            ResponseCookie refreshTokenCookie = ResponseCookie.from(REFRESH_TOKEN_COOKIE_NAME, refreshToken)
                    //쿠키의 경로 설정, / 경로는 도메인 내 모든 경로에서 쿠키에 접근할 수 있다.
                    .path("/")
                    //크로스 사이트 요청에서도 전송될 수 있도록 None으로 설정
                    .sameSite("None")
                    //httpOnly를 true로 설정해 자바스크립트에서 접근할 수 없도록 지정
                    //Secure옵션을 통해 SSL이 적용된 사이트만 쿠키가 전송되도록 함
                    //maxAge를 통해 쿠키의 유효기간 설정
                    .httpOnly(true).secure(true).maxAge(refreshTokenValidityInSeconds)
                    //쿠키의 도메일을 설정한다. 해당 도메인 및 하위 도메인에 쿠키에서 접근할 수 있도록 함
                    .domain(".burback.shop")
                    //위에 설정한 속성을 기반으로 빌드한다.
                    .build();
						//응답 헤더에 Set-Cookie헤더를 추가하고 문자열로 변환해 헤더의 값으로 지정한다.
            response.addHeader("Set-Cookie", refreshTokenCookie.toString());
```

  

# CONCLUSION:

이제 서로 다른 도메인을 갖는 front-end단과 back-end단이 쿠키를 주고받을 수 있게 되었다!