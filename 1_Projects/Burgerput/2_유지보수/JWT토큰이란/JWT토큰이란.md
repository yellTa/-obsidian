---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: true
Progress: end
업로드할까?: true
---
# SUBJECT: JWT토큰이란?

JSON객체를 사용하여 두 개체 간의 정보를 안전하게 전송하기 위한 방법이다. JST는 주로 인증 및 정보 교환목적으로 사용한다.

  

# JWT토큰의 사용처

## Authorization(인증)

가장 흔히 사용되는 경우이다. user가 로그인하면 JWT를 갖고 있는지 확인한다. user가 인증된 토큰을 가지고 있으면 route, service, resources에 접근하도록 한다.

  

## 정보 교환(Information Exchange)

JSON Web 토큰은 안전하게 데이터를 주고받는데 사용할 수 있다.

  

# JSON Web Token 구조

- Header
- Payload
- Signature

JWT는 이 처럼 간단한 구조로 이루어져있다. 이 세개의 구조는 **.**으로 구분되며 이는!

> [!important]  
> xxxxx.yyyyy.zzzzz  

위와 같은 방식으로 쓰여질 수 있다.

  

## Header

헤더는 두 부분으로 구성되어 진다.

```Java
{
  "alg": "HS256",
  "typ": "JWT"
}
```

JSON은 Base64URL로 인코딩되어 JWT의 첫 번째 파트가 된다.

  

## Payload

두 번째 부분이다. 페이로드는 claims를 포함하고 있다. Claims는 객체 그리고 추가적인 정보들에 대한 상태를 의미한다.

  

Claims는 종 세 가지 종류가 있다.

### Registered claims:

강제로 사용하라고 정의된 것은 아니지만 어느정도 정해진 토큰 형태이다.

종류로는 : **iss**(issure), **exp**(expiration time), **sub**(subject) etc…

  

그 외의 종류는 아래에서 확인할 수 있다!

[https://datatracker.ietf.org/doc/html/rfc7519#section-4.1](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1)

  

### Public claims

JWT를 주고받을 때 충돌을 피하려면 조건이 필요하다.

1.  [IANA JSON Web Token Registry](https://www.iana.org/assignments/jwt/jwt.xhtml) 에 정의된 내용을 사용한다.
2. 충돌 방지 형태를 따르는 URL을 사용한다.

  

### Private claims

서로 주고받는 상대끼리 만든 custom claims이다.

  

```Java
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
```

payload의 형태는 위와 같다.

  

# Signature

signature부분을 만들기 위해서는 인코딩된 헤더가 필요하다. 이때 헤더는 인코딩된 payload, 자료들, algorithm이 들어있다. 해당 정보를 갖고 있는 헤더를 받으면 sign을 수행한다.

  

### ex) HMAC SHA256 algorithm을 사용하고 싶을떄?

```Java
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret)
```

위와 같은 방법으로 사용할 수 있다.

  

Szignature는 데이터의 무결성을 검증하며 이때 token이 private key로 sign되어 있는지 체크한다. 이는 JWT를 받는 사람에게 검증된 사용자라고 인증하는 격이다.

---

  

위의 세 가지 자료(header, payload, Signature)를 합치면 된다. 세 가지 항목은 Base-64 URL 형식이고 dot(.)으로 구분된다. XML기반 보다 훨씬 간단한 형태이다.

![[images/Untitled 33.png|Untitled 33.png]]

참고로 인코딩된 자료는  [jwt.io Debugger](https://jwt.io/#debugger-io) 에서 디코드 할 수 있다.

  

## JWT 생성과정

1. 헤더를 Base64URL로 인코딩합니다.
2. 페이로드 인코딩 : 페이로드를 Base64URL로 인코딩
3. 서명 생성 : 인코딩된 헤더와 페이로드를 합친 후 비밀 키(private key)를 사용하여 서명 생성
4. 토큰 생성 : 인코딩된 헤더, 페이로드, 서명을 dot(.)으로 구분하여 결합한다.

---

# JSON Web Token의 작동방식

## JWT토큰 생성

front-end 단에서 사용자가 로그인하면 서버는 JWT Token을 되돌려준다. 이때 Token이 인증받게 되면 보안상의 이슈때문에 중요한 정보는 절대 담으면 안된다. 따라서 요청시간보다 더 오랜시간 토큰을 가지고 있으면 안된다.

## 클라이언트 저장

클라이언트는 JWT를 로컬 스토리지나 세션 스토리지에 저장하고, 이후 요청시 HTTP헤더에 JWT를 포함시켜 서버에 전송한다.

  

## 서버검증

서버는 클라이언트로부터 받은 JWT를 검증한다.

### 검증 순서

1. 헤더와 페이로드 디코딩 : JWT를 dot(.)기준으로 분리하여 헤더와 페이로드를 base64URL로 디코딩한다.
2. 서명 검증 : 디코딩된 헤더와 페이로드를 사용하여 서명을 재생성한 후, 전달된 서명과 일치하는지 확인한다.
3. 클레임(claim) 검증 : 토큰의 만료 시간 등 클레임을 검증하여 유효성을 확인한다.

---

![[images/Untitled 1 10.png|Untitled 1 10.png]]

![[images/Untitled 2 7.png|Untitled 2 7.png]]

  

---

# REVIEW

우리가 자주 사용하는 one ID가 이렇게 복잡한 과정으로 검증이 되는지 전혀 눈치채지 못하고 있었다…(로그인은 그냥 DB에서 id, pw체크하면 되는줄 알았던 나…)