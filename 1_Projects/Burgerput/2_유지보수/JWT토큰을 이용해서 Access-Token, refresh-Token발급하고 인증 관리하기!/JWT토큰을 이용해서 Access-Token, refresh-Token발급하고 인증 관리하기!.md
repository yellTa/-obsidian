---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress:
  - end
업로드할까?: false
created: 2024-06-18T14:37:00
updated: 2024-08-27T18:10
---
# SUBJECT: JWT토큰을 이용해서 Access-Token, refresh-Token발급하고 인증 관리하기!

저번에 JWT토큰을 Access Token만 발급했다면 이번에는 refresh-token도 함께 발급해보자!

# ANALYSIS:

우선 로직은 아래의 그림과 같다.

![[Untitled 29.png|Untitled 29.png]]

  

### 요약

1. signin POST를 통해서 사용자 요청을 한다.
2. DB에 있는 정보와 일치하는 사용자인 경우에 JWT Access-token, refresh-token을 발급한다. 이때 refresh-token은 HttpOnly 쿠키에 담도록 한다.
3. 클라이언트는 해당 토큰을 가지고 있다가 access-token이 만료하는 시점에 새로운 발급을 위해 refresh-token POST 메소드를 통해서 갱신 요청을 보낸다. 이는 Access-token이 만료될 떄 refresh-token을 통해서 새로운 Access-token을 발급받는 일반적인 방법이다. 반대로 refresh-token이 만료되면 사용자는 다시 로그인을 수행해서 accesss-token과 refresh-token을 발급받는다. 어찌보
4. 서버는 refresh-token이 유효한 경우에 새로운 access-token을 만들어서 보내준다.

  

### refresh-token이 만료되는 순간

refresh-token은 우리가 흔히아는 로그아웃 혹은 2시간 뒤에 로그아웃됩니다. 같이 로그아웃 순간에 만료된다. 즉 refresh-token의 시간은 access-token의 시간보다 조금 더 길게 주어지는 것이다.

  

> refresh-token이 만료되는 순간 = 로그아웃 이라고 봐도 무방하다.

  

# HOW TO:

  

## 부제목

> [!important]  
> JwtTokenProvider  

```Java
package burgerput.project.zenput.Services.jwtLogin;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Base64;
import java.util.Date;


@Component
public class JwtTokenProvider {
    //Application.properties에서 설정한 값을 가져와서 사용한다.
    @Value("${security.jwt.token.secret-key:secret}")
    private String secretKey;

    @Value("${security.jwt.token.expire-length:3600000}")
    private long validityInMilliseconds = 3600000; // 1h

    @Value("${security.jwt.token.refresh-expire-length:7200000}") // 2 hours
    private long refreshValidityInMilliseconds = 7200000;


    @PostConstruct
    protected void init() {
        //secretKey의 길이가 32이하인 경우 weakKey Exception이 발생할 수있다.
        if(secretKey.length() < 32){
            //키의 길이가 짧은 경우 새로운 키를 생성한다.
            secretKey = Base64.getEncoder().encodeToString(Keys.secretKeyFor(SignatureAlgorithm.HS256).getEncoded());
        }else{
            //키의 길이가 충분하면 해당  키로 생성한다.
            secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
        }

    }

    public String createToken(String username){
        //Claims객체를 생성하고 주어진 username을 주제로 설정한다.
        //Claims는 JWT 페이로드에 저장되는 데이터이다. subSubject 메서도로 클리엠 설정
        Claims claims = Jwts.claims().setSubject(username);
        //현재 시간- 토큰 발급 시간 및 만료시간 계산을 위해서
        Date now = new Date();
        //토큰의 만료시간을 계산해서 Date객체로 만든다.
        Date validity = new Date(now.getTime() + validityInMilliseconds);

        //
        return Jwts.builder().setClaims(claims)//JWT빌더 생성 setClaims으로 페이로드에 claims을 설정한다.
                .setIssuedAt(now) // 현재 발행시간
                .setExpiration(validity) // 만료 시간
                .signWith(SignatureAlgorithm.HS256, secretKey)//토큰에 서명 HS256알고리즘을 사용하고 secretKey를 비밀키로 사용한다.
                .compact();// JWT문자열을 생성하고 반환한다. dot(.)으로 구분 되는 헤더, 페이로드, 시그니처로 나뉨
    }
\
    //refresh-token을 만드는 과정
    public String createRefreshToken(String username) {
        Claims claims = Jwts.claims().setSubject(username);
        Date now = new Date();
        Date validity = new Date(now.getTime() + refreshValidityInMilliseconds);

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(validity)
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    //토큰에서 subject를 추출하여 반환한다.
    public String getUsername(String token){
        return Jwts.parser().setSigningKey(secretKey)//JWT파서를 생성하고 서명검증에 사용할 비밀키를 설정한다.
                .parseClaimsJws(token)//주어진 토큰을 파싱하여 claim 추출
                .getBody().getSubject();// 파싱된 JWT페이로드를 가져온다.(getBody) 주제 클레임을 반환ㄴ한다.(getSubject()0

    }
    //만들어진 JWT토큰이 유효한지 검증한다.
    public boolean validateToken(String token){
        try{
            //JWT파서를 생성한후 서명검증에 secretKey를 사용한다.
            // 주어진 토큰을 파싱하여 서명을 검증한다.
            Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
            return true;//유효하면 true를 리턴한다.
        }catch(Exception e){
            //유효하지 않으면 false를 리턴한다.
            return false;
        }
    }

    //refresh-token의 만료 시간을 반환
    public long getRefreshValidityInMilliseconds() {
        return refreshValidityInMilliseconds;
    }

}
```

기존의 Access-Token을 만드는 코드에서 refresh-token을 만드는 코드가 추가되었다.

둘이 큰 차이는 나지 않지만 토큰의 유효시간이 다르다.

  

> [!important]  
> MasterLoginController  

```Java
package burgerput.project.zenput.web;

//burgerput 첫 페이지진입시 API를 주고받는 컨트롤러

import burgerput.project.zenput.Services.jwtLogin.JwtTokenProvider;
import burgerput.project.zenput.domain.MasterAccount;
import burgerput.project.zenput.repository.masterAccountRepository.MasterAccountRepository;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

//Spring 2.대는 javax를 사용하지만 현재  Spring3.0에는 jakarta를 사용한다.
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.security.sasl.AuthenticationException;
import java.util.Optional;

import static burgerput.project.zenput.Const.REFRESH_TOKEN_COOKIE_NAME;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MasterLoginController {


    private final MasterAccountRepository masterAccountRepository;
    private final JwtTokenProvider jwtTokenProvider;
    @PostMapping("/signin")
    public ResponseEntity<?> jwtLogin(@RequestBody User user, HttpServletResponse response) {

        Optional<MasterAccount> foundAccount = masterAccountRepository.findById(user.getId());
        try{
            // ID 검사
            if(foundAccount.isEmpty()){ //Account의 값을 찾을 수 없는 경우(인증 실패)
                //Account 계정이 없는경우
                throw new AuthenticationException("Account not found");
            }
            MasterAccount master = foundAccount.get();
            //password 검사

            if(!master.getMaster_pw().equals(user.getPassword())){
                throw new AuthenticationException("Invalid username/password supplied") {};
            }
            //JWT토큰 생성 및 반환 로직
            String accessToken = jwtTokenProvider.createToken(master.getMasterId());
            // refresh-token 생성하기
            String refreshToken = jwtTokenProvider.createRefreshToken(master.getMasterId());

            //refresh-token을 HttpOnly에 넣기 위한 설정
            Cookie refreshTokenCookie = new Cookie(REFRESH_TOKEN_COOKIE_NAME, refreshToken);
            //HttpOnly속성을 이용해 javascript에서 접근할 수 없도록 지정한다.
            //xss공격으로부터 쿠키를 보호하기 위함이다.
            refreshTokenCookie.setHttpOnly(true);
            //SSL을 사용하는 경우에만 전송하도록 한다.
            //네트워크상에서 쿠키의 도청을 방지한다.
            refreshTokenCookie.setSecure(true); // HTTPS에서만 사용 가능하게 설정
            //같은 도메인의 모든 URL에서 이 쿠키를 사용할 수 있다. 쿠키의 사용 경로를 지정하는 것이다.
            refreshTokenCookie.setPath("/");
            //쿠키의 유효기간을 설정한다.
            //여기서는 refresh token과 똑같은 시간(2시간)동안 유효하다.
            refreshTokenCookie.setMaxAge((int) jwtTokenProvider.getRefreshValidityInMilliseconds() / 1000);
            //결과값을 response에 담아서 보낸다.
            response.addCookie(refreshTokenCookie);

            //JWT를 반환할 때 응답메세지를 JSON으로하는 것이 좋다.
            return ResponseEntity.ok(new TokenResponse(accessToken));

        }catch(AuthenticationException e){
            return handleAuthenticationException(e);
        }
    }
    @PostMapping("/refresh-token")
    public ResponseEntity<String> refreshToken(HttpServletRequest request) {
        //쿠키 목록에서 쿠키가져오기
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {//쿠키에 값이 있는 경우 수행하기
            for (Cookie cookie : cookies) { //쿠키들의 값 꺼내기
                if ("refreshToken".equals(cookie.getName())) { //refreshToken인경우 로직 수행
                    String refreshToken = cookie.getValue();//value를 가져온다 토큰의 값을 가져오는 것
                    if (jwtTokenProvider.validateToken(refreshToken)) {//유효한 토큰인지 확인한다.
                        //토큰에서 유저의 정보를 뽑아낸다.
                        String username = jwtTokenProvider.getUsername(refreshToken);
                        //해당 이름으로 다시 accessToken을 만든다.
                        String newAccessToken = jwtTokenProvider.createToken(username);
                        //토큰을 반환하고 상태를 200으로 반환한다.
                        return new ResponseEntity<>(newAccessToken, HttpStatus.OK);
                    }
                }
            }
        }
        //refresh-token으로 요청이 왔으나 refresh-token이 없는 경우에는 401에러메세지를 출력한다.
        return new ResponseEntity<>("Invalid refresh token", HttpStatus.UNAUTHORIZED);
    }


    @Data
    private static class User{
        private String id;
        private String password;

    }

    //JSON 형태로 return값을 반환하기 위해 만든 객체
    //유지보수성 가독성을 위해서 JSON객체 형태로 응답한다.
    @Data
    private static class TokenResponse {
        private final String accessToken;

        public TokenResponse(String accessToken) {
            this.accessToken = accessToken;
        }
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<String> handleAuthenticationException(AuthenticationException ex){
        log.info("Error message = {}", ex.getMessage());
        return new ResponseEntity<>(ex.getMessage(), HttpStatus.UNAUTHORIZED);
    }

}
```

## 쿠키이름을 상수로 사용하는 것이 좋은 이유

동일한 쿠키 이름을 여러 곳에서 사용할 경우, 상수로 정의하면 오타, 일관성 문제를 줄일 수 있다.

  

ex) 쿠키이름을 여러 곳에서 하드코딩하면 어느 한 곳에서 잘못된 이름을 입력하는 실수를 할 수 있다.

  

### 유지 보수 용이성

쿠키이름을 변경해야 하는 상황이 되면 상수 하나만 고치면 된다. 하드코딩을 했다면 여러 군데에서 고쳐야 하기 때문

  

### 가독성 향상

코드의 가독성이 향상된다. 상수 이름을 통해 해당 쿠키의 역학을 쉽게 이해할 수 있기 때문이다.

  

지금 코드에서는 해당 class에 private하게 적어놓았지만 실제로는 상수를 정의해놓은 Const파일에 따로 정의해놓았다!

## JWT를 반환할때 JSON타입으로 반환하는 것이 좋은 이유

  

### 표준화된 데이터 형식

JSON은 웹에서 데이터를 주고받을 때 가장 널리 사용되는 표준 형식이다.

대부분의 클라이언트와 서버 측 프레임워크에서 JSON을 지원한다.

  

### 확장성

JSON은 쉽게 데이터를 추가할 수 있다. 즉 accessToken 외에 다른 key: value값들을 넣을 수 있다는 의미이다.

  

### 가독성

디버깅이나 로그 분석 시 JSON형식의 응답은 쉽게 이해할 수 있다.

  

### 유연성

다양한 데이터 타입을 표현할 수 있어, 복잡한 데이터 구조를 쉽게 전달할 수 있다.

  

### 일관된 API 디자인

API응답을 일관되게 JSON형식으로 반환하면 API 사용자가 응답을 처리하는 방식을 표준화 할 수 있다.

front-end단에서도 일관되게 JSON파싱 로직을 적용할 수 있어 코드의 복잡성을 줄일 수 있다.

  

# CONCLUSION:

## JWT토큰의 작동 원리

1. 로그인을 수행하고 유효한 사용자면 Access-Token ,refresh-Token을 서버에서 둘 다 발급한다. 이떄 refresh-Token은 cookie에 담아서 보낸다.
2. Access-Token이 만료되었을 때 refresh-Token을 서버에서 POST로 보내서 새로 갱신 요청을 수행한다.
3. 서버는 POST로 받은 refresh-Token의 유효성을 확인한다. 여기서 유효한 토큰인 경우에는 Access-Token을 새로 발급해서 건네주고 유효하지 않다면 401(유효하지 않은 사용자 에러코드)에러를 반환한다.
4. refresh-token이 만료한 경우는 로그아웃의 경우이다. 즉 refresh-token이 만료하면 사용자는 다시 로그인 요청을 해서 Access-Token과 refresh-Token을 발급받아야한다.

# REVIEW:

Acess-Token과 refresh-Token에 대해서 알게된 하루였다. 그 전에는 Access-Token에 대해서만 좀 작성했었는데 그때 당시 조사한 자료의 부족함 때문인지 refresh-Token을 빼먹은 결과를 작성했었다. 오늘은 짐인씨의 도움으로 refresh-Token 의 존재 그리고 어떤식으로 사용되는지 알게되었다!