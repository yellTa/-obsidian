---
Created time: Invalid date
Last edited time: Invalid date
Review여부: false
post됨: false
post할까?: true
---
# SUBJECT: front-end단에서 body에 데이터를 보내고 Spring에서 처리하는 방법

현재 front-end단에서 데이터를

```Java
{"id":"werf","password":"asdf"}
```

위와 같은 JSON형태로 보내고 있다. 이는 URL에 데이터를 담아서 보내는 것이 아니다.

  

> [!important]  
> MasterLoginController  

```Java
@PostMapping("/signin")
    public ResponseEntity<String> jwtLogin
    (@RequestParam String id, @RequestParam String password) {
    ...
```

MasterLoginController는 위와 같은 형태로 되어 있는데 id파라미터를 찾지 못해서

  

```Java
: Resolved [org.springframework.web.bind.MissingServletRequestParameterException: 
Required request parameter 'id' for method parameter type String is not present]
```

위와 같은 에러를 보내고 있다.

  

# ANALYSIS:

## @RequestParam

일단 @RequestParam은 URL에 담긴 쿼리 파라미터 정보를 읽는다. 하지만 위처럼 front-end단에서 JSON으로 데이터를 뿌려주면 URL에 정보를 담는 것이 아니기때문에 @RequestParam으로 받을 수가 없는 것이다.

# CONCLUSION: @RequestBody를 사용하자

## @RequestBody

Spring MVC에서 HTTP body에 담긴 데이터를 자바 객체로 변환하는데 사용한다. 주로 JSON형식의 데이터를 java객체로 변환할 때 사용되며 Spring의 HttpMessageConverter에 의해 처리된다.

  

## 기능 및 특징

### 1. 데이터 바인딩

HTTP 요청 본문의 데이터를 자바 객체에 바인딩 한다. 주로 JSON, XML의 포맷을 사용한다.

### 2. 자동 변환

Spring의 HttpMessageConverter는 Jackson라이브러리를 사용해서 JSON데이터를 자바 객체로 자동으로 변환한다.

### 3. 유효성 검사

@Valid 애노테이션과 함께 사용해 요청 본문 데이터의 유효성을 검사할 수 있다.

  

  

## 단점

### 1. 큰 데이터 처리 부담

Body에 큰 데이터를 포함할 경우 서버의 메모리 사용량이 증가할 수 있다.

  

### 2. 에러 처리

요청 본문 데이터의 구조가 맞지 않거나 필수 값이 누락된 경우 예외가 발생할 수 있어 예외처리가 필요하다.

# HOW TO:

> [!important]  
> MasterLoginController  

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
    public ResponseEntity<String> jwtLogin(@RequestBody User user) {//@RequestBody를 이용해
    //본문의 JSON객체를 가져오도록 한다.

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
            String token = jwtTokenProvider.createToken(master.getMasterId());
            return new ResponseEntity<>(token, HttpStatus.OK);

        }catch(AuthenticationException e){
            return handleAuthenticationException(e);
        }
    }
//내부 정적 클래스 Jackson라이브러리는 비정적 내부 클래스를 인스턴스화 할 수 없다.
//그래서 정적 클래스로 선언해야 한다.
    
    @Data //@Getter와 Setter를 포함하는 @Data 애노테이션으로 붙여서 간단하게? 표현
    private static class User{
    //객체의 변수 이름은 JSON key값과 같아야 한다.
        private String id;
        private String password;

    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<String> handleAuthenticationException(AuthenticationException ex){
        log.info("Exception authentication");
        return new ResponseEntity<>(ex.getMessage(), HttpStatus.UNAUTHORIZED);
    }

}
```

놓칠 수 있던 부분은

Jackson 라이브러리는 비정적 클래스를 인스턴스화 할 수 없다. 따라서 static인 정적 클래스로 지정해줘야 한다.