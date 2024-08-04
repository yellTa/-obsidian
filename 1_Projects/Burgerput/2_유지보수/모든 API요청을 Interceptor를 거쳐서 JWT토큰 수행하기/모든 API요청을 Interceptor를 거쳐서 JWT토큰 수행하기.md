---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress: end
업로드할까?: false
created: 2024-08-03T14:37
updated: 2024-08-04T22:42
---
# SUBJECT: 모든 API요청을 Interceptor를 거쳐서 JWT토큰을 검증해보자!

# ANALYSIS:

## Spring Interceptor

HTTP 요청을 처리하기 전 후에 특정 로직을 실행할 수 있도록 한다. 주로 로깅, 인증 권한 검사, 요청 데이터 변환 등의 작업을 수행하는데 사용한다.

  

이 문서의 경우에는 인증 권한 검사를 수행할 것이다.

## Interceptor의 주요 기능

### preHandle():

요청이 컨트롤러에 도달하기 전에 호출된다.

true를 반환하면 다음 인터셉터, 컨트롤러 전달된다

false는 위의 과정을 거치지 않지만 응답을 직접 처리할 수 있다.

### postHandle():

컨트롤러가 요청을 처리한 후, 뷰가 렌더링 되기 전에 호출(뷰가 보여지기 전에 호출)

모델 데이터를 조작, 응답을 수정하는데 사용

### afterCompletion():

뷰가 랜더링 된 후 호출

요청 완료 후 리소스 정리, 로그 기록에 사용

  

## 사용시 고려 사항

### 순서:

여러 개의 인터셉터를 등록할 수 있고 순서에 따라서 수행할 수 있다.

공통로직을 먼저 처리하고 세부로직을 나중에 처리한다.

### 성능 :

모든 요청에 인터셉터가 실행되므로, 복잡한 로직을 처리할 경우 성능에 영향을 미칠 수 있다.

### 예외 처리 :

인터셉터 내부에서 예외가 발생하면 요청처리가 중단될 가능성이 있다. 따라서 적절한 예외 처리가 필요하다.

---

  

![[Untitled 34.png|Untitled 34.png]]

오늘 수행할 작업의 내용이다.

# CONCLUSION:

## Spring Interceptor를 사용해서 모든 요청 JWT토큰 인증하기

### TokenInterceptor

**preHandle()**

컨트롤러에 도달하기 전에 수행된다. 즉 컨트롤러에 도달하기전 front-end단이 보낸 헤더에서 Access Token을 뽑아내서 유효한지 확인한다.

유효하면 요청 Controller로 리다이렉트를 수행한다.

유효하지 않으면 401에러를 리턴한다.

```Java
InvalidToken - 토큰 유효하지 않음 => 로그아웃
TokenExpired - 토큰 만료됨 => refresh
```

이때 요청 메세지 body에 위와 같은 메세지를 포함하도록 한다.

# HOW TO:

> [!important]  
> JwtTokenProvider  

```Java
//JWT토큰의 유효시간이 만료되었는지 확인하는 코드 추가
   //refresh-token의 만료 시간을 반환
    public long getRefreshValidityInMilliseconds() {
        return refreshValidityInMilliseconds;
    }
    
    public boolean isTokenExpired(String token) {
        try {
        //JWT 토큰 파싱 서명 검증
            JwtParser parser = Jwts.parser().setSigningKey(secretKey);
            Jws<Claims> claimsJws = parser.parseClaimsJws(token);
            Claims claims = claimsJws.getBody();
            //토큰의 만료시간 가져오기
            Date expiration = claims.getExpiration();
            return expiration.before(new Date());
        } catch (Exception e) {
            return true; // 유효하지 않은 토큰은 만료된 것으로 간주
        }
    }
    
    만료된 경우에는 true를 반환한다.
```

  

> [!important]  
> TokenInterceptor  

```Java
package burgerput.project.zenput.intercepter;

import burgerput.project.zenput.Services.jwtLogin.JwtTokenProvider;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@Component// Spring bean 주입을
public class TokenInterceptor implements HandlerInterceptor {

    //스프링 빈 수동 주입
    private final JwtTokenProvider jwt;

    @Autowired
    public TokenInterceptor(JwtTokenProvider jwt) {
        this.jwt = jwt;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
               String requestUri = request.getRequestURI();
        String authorizationHeader = request.getHeader("Authorization");

				//singin과 refres-token경로는 검사하지 않는다. 
        if (requestUri.startsWith("/signin") || requestUri.startsWith("/refresh-token")) {
            return true; // 특정 경로는 제외
        }

        // Bearer는 OAuth2.0 및 인증 스키마에서 사용하는 인증 토큰 유형을 나타낸다.
        //우리는 JWT토큰이라서 OAuth를 사용함
        //Bearer키워드는 토큰의 유형을 지정하고 이 키워드 뒤에 오는 문자열은 실제 인증 토큰임
        //Bearer토큰은 액세스 토큰의 한 유형이다.

        //토큰이 먼저 존재하는 지확인
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            //이후의 토큰을 가져온다. 즉 AccessToken부분을 가져온다.
            String token = authorizationHeader.substring(7);
            if (jwt.validateToken(token)) {
                //token이 유효한경우
                if (!jwt.isTokenExpired(token)) {
                    //토큰이 만료되지 않은 경우
                    //API수행
                    return true;
                } else {
                    //Token의 만료시간이 지난경우
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "TokenExpired ");
                    return false;
                }
            } else {
                //token이 유효하지 않은 경우
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "InvalidToken");
                return false;
            }
        } else {
            //no AccessToken
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "InvalidToken");
            return false;
        }

    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        String authorizationHeader = request.getHeader("Authorization");

        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            String token = authorizationHeader.substring(7);
            if (jwt.validateToken(token)) {
                if (!jwt.isTokenExpired(token)) {
                    log.info("JWT Token is valid and not expired: " + token);
                } else {
                    log.warn("JWT Token is expired: " + token);
                }
            } else {
                log.warn("JWT Token is invalid: " + token);
            }
        } else {
            log.warn("No JWT Token found in request headers.");
        }

        HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
    }

}
```

aftercompletion에서는 JWT의 검증 결과를 반환한다. 하지만 모든 요청에 해당 코드가 실행되는 만큼 afterCompletion을 비워두는 것도 성능 저하를 막기위한 하나의 방법이라고 볼 수 있다.

  

> [!important]  
> Spring web Config 파일에 등록  

```Java
    //JWT Token Interceptor Bean 설정
    private final JwtTokenProvider jwtTokenProvider;

    @Autowired
    public Config(JwtTokenProvider jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new TokenInterceptor(jwtTokenProvider))
                .addPathPatterns("/**")
                //제외 경로 설정
                .excludePathPatterns("/signin", "/signin/**", 
                "/refresh-token", "/refresh-token/**");
    }
```

스프링 빈 주입을 위해서 위와 같은 설정을 WebConfig(@Configuration 애노테이션이붙은 클래스)에 추가해준다.