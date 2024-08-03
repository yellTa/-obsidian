---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: true
Progress: end
업로드할까?: true
---
  

Spring Frame work에서 JWT토큰을 통해서 front-end와 함꼐 통신할 예정이다.

  

# HOW TO:

> [!important]  
> build.gradlebuild.gradle의 dependencies에 추가한다.  

```Java
implementation 'io.jsonwebtoken:jjwt:0.9.1' // jwt token을 위한 라이브러리
testImplementation 'org.springframework.security:spring-security-test'
```

필요한 의존관계를 추가한다.

  

---

  

# Analysis :

1. id/pw 받기
2. id /pw의 값이 master_account의 값과 동일한지 확인하기
    
    1. 같은 경우
        1. JWT token 발급
    2. 다른 경우
        1. 401 error 출력
    
      
    

### 401Error?

> 클라이언트가 인증되지 않아서 정상적으로 요청을 처리할 수 없는 경우에 반환하는 에러코드

# 틀 만들기

일단 위의 분석에 따라서 가볍게 틀을 만들어보자

  

> [!important]  
> build.gradle의존성 추가 목록들  

```Java
 	  //JJWT API를 제공한다.
    implementation 'io.jsonwebtoken:jjwt-api:0.11.2'
    
    //JJWT API의 구현체
    implementation 'io.jsonwebtoken:jjwt-impl:0.11.2'
    
    //JJWT와 Jackson간의 통합 제공
    implementation 'io.jsonwebtoken:jjwt-jackson:0.11.2'
    
    //JAXB API를 제공. JWT 라이브러리의 XML 관련 기능을 위해 필요.
    implementation 'javax.xml.bind:jaxb-api:2.3.1'
    
    //JAXB API의 구현체
    implementation 'org.glassfish.jaxb:jaxb-runtime:2.3.1'
```

JAXB는 자바 객체와 XML 데이터간의 변환을 쉽게 하기 위한 프레임워크

  

> [!important]  
> MasterAccountRepositorymaster_account JPA이다.  

```Java
@Transactional
public interface MasterAccountRepository extends JpaRepository<MasterAccount, Integer> {
    
}
```

@Transactional 애노테이션을 사용해서 에러가 날 시에는 DB에 값을 적용하는 것이 아닌 Rollback을 수행하도록 했다.

  

> [!important]  
> MasterAccountMasterAccount객체  

```Java
@Data
@Entity
public class MasterAccount {

    @Id
    @JsonIgnore
    @Column(name="master_id")
    private String masterId;

    @Column(name="master_pw")
    private  String master_pw;

}
```

  

> [!important]  
> MasterLoginControllerid, pw를 받는 web Controller이다.  

```Java
    @PostMapping("/signin")
    public ResponseEntity<String> jwtLogin(@RequestParam String id, @RequestParam String password) {

        log.info("got id = {}", id);
        log.info("got password = {}", password);

        Optional<MasterAccount> foundAccount = masterAccountRepository.findById(id);

        try{
            if(foundAccount.isEmpty()){ //Account의 값을 찾을 수 없는 경우(인증 실패)
                //Account 계정이 없는경우
                throw new NoSuchElementException("Account not found");
            }

            if(!foundAccount.get().getMaster_pw().equals(password)){
                throw new AuthenticationException("Invalid username/password supplied") {};
            }
            
        }catch(NoSuchElementException e){
            return handleNoSuchElementException(e);
        }catch(AuthenticationException e){
            return handleAuthenticationException(e);
        }


        return null;
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<String> handleAuthenticationException(AuthenticationException ex){
        log.info("Exception authentication");
        return new ResponseEntity<>("Invalid username/password supplied", HttpStatus.UNAUTHORIZED);
    }
    
    @ExceptionHandler(NoSuchElementException.class)
    public ResponseEntity<String> handleNoSuchElementException(NoSuchElementException ex) {
        log.info("Exception no");
        return new ResponseEntity<>("Account not found", HttpStatus.UNAUTHORIZED);
    }
```

  

### @RequestParam?

> 쿼리 파라미터로 URL을 이용하여 ID와 PW를 받는다. 이떄 매개변수의 이름은 JSON Data의 key 값과 같아야 한다.

  

### @ExceptinoHandler

> 해당 메소드를 사용해서 예외가 터지면 해당 애노테이션이 있는 메소드에서 처리하도록 설정했다.

위의 예시에서는 계정이 없는 경우는 NoSuchElementExcpetino을 비밀번호가 틀린 상황에서는 AuthenticatinoException을 발생시켰다. 우리는 JWT토큰을 발급받을 때 유효하지 않거나 ID가 없는 경우에는 401 즉 AuthenticationException을 발생시킬 것이다. 따라서 최종 코드는

  

```Java
    @PostMapping("/signin")
    public ResponseEntity<String> jwtLogin(@RequestParam String id, @RequestParam String password) {

        log.info("got id = {}", id);
        log.info("got password = {}", password);

        Optional<MasterAccount> foundAccount = masterAccountRepository.findById(id);

        try{
            if(foundAccount.isEmpty()){ //Account의 값을 찾을 수 없는 경우(인증 실패)
                //Account 계정이 없는경우 ==ID가 다른 경우
                throw new AuthenticationException("Account not found");
            }

            if(!foundAccount.get().getMaster_pw().equals(password)){
            //비밀번호가 일치하지 않는경우
                throw new AuthenticationException("Invalid username/password supplied") {};
            }
        }catch(AuthenticationException e){
            return handleAuthenticationException(e);
        }

        return null;
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<String> handleAuthenticationException(AuthenticationException ex){
        log.info("Exception authentication");
        //전달받은 Exceptino인자에 getMessage()메소드를 통해 지정한 message를 가져온다. 
        return new ResponseEntity<>(ex.getMessage(), HttpStatus.UNAUTHORIZED);
    }
```

  

# JWT토큰 발급 수행하기

올바른 계정으로 접근했을 때 JWT토큰을 검증하거나 새로 발급해야한다. 해당 부분에 관한 내용이다.

> [!important]  
> JwtTokenProvider.class토큰을 발행하고 검증해주는 클래스이다.  

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

}
```

  

## 만들어 뒀던 틀에 JWT토큰 생성 로직 추가하기

> [!important]  
> MasterLoginControllerLogin web Controller이다.  

```Java
package burgerput.project.zenput.web;

//burgerput 첫 페이지진입시 API를 주고받는 컨트롤러

import burgerput.project.zenput.Services.jwtLogin.JwtTokenProvider;
import burgerput.project.zenput.domain.MasterAccount;
import burgerput.project.zenput.repository.masterAccountRepository.MasterAccountRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.security.sasl.AuthenticationException;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MasterLoginController {

    private final MasterAccountRepository masterAccountRepository;
    private final JwtTokenProvider jwtTokenProvider;
    @PostMapping("/signin")
    public ResponseEntity<String> jwtLogin(@RequestParam String id, @RequestParam String password) {

        Optional<MasterAccount> foundAccount = masterAccountRepository.findById(id);

        try{
            // ID 검사
            if(foundAccount.isEmpty()){ //Account의 값을 찾을 수 없는 경우(인증 실패)
                //Account 계정이 없는경우
                throw new AuthenticationException("Account not found");
            }
            MasterAccount master = foundAccount.get();
            //password 검사
            if(!master.getMaster_pw().equals(password)){
                throw new AuthenticationException("Invalid username/password supplied") {};
            }

            //JWT토큰 생성 및 반환 로직
            String token = jwtTokenProvider.createToken(master.getMasterId());
            return new ResponseEntity<>(token, HttpStatus.OK);

        }catch(AuthenticationException e){
            return handleAuthenticationException(e);
        }

    }

//예외 처리 Handler
    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<String> handleAuthenticationException(AuthenticationException ex){
        log.info("Exception authentication");
        return new ResponseEntity<>(ex.getMessage(), HttpStatus.UNAUTHORIZED);
    }

}
```

  

  

---