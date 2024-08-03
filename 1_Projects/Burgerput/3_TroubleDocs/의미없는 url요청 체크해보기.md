---
progress:
  - inprogress
Created time: Invalid date
Last edited time: Invalid date
Review여부: false
post됨: false
post할까?: false
---
# OBJECT/SUBJECT:

```Java
2024-07-21T09:13:37.095+09:00  INFO 734261 --- [io-8080-exec-10] b.project.zenput.intercepter.CORSFilter  : /
2024-07-21T09:13:37.328+09:00  INFO 734261 --- [io-8080-exec-10] b.p.zenput.intercepter.TokenInterceptor  : Request URI: /
2024-07-21T09:13:37.329+09:00  INFO 734261 --- [io-8080-exec-10] b.p.zenput.intercepter.TokenInterceptor  : TOKEN CONTENTS = NULL
2024-07-21T09:13:37.334+09:00  INFO 734261 --- [io-8080-exec-10] b.p.zenput.intercepter.TokenInterceptor  : Interceptor : 액세스 토큰 > 토큰 없음
```

  

/ab2g

/sitemap.xml  
/api/v2/static/not.found  

/ab2g  
/ab2h  
/fonts/ftnt-icons.woff  

/api/v2/static/not.found

/remote/logincheck

/

위의 링크들이 의미없이 요청? 되는중… 참고로 front-end단에서 요청하고 있지 않은데도 이쪽으로 요청이 들어온다.

# ANALYSIS:

왜 그런지 이유를 알아보자

## User Agent

유저단에서 돌아가는 software agent이다! 쉽게 설명하자면 크롬, 파이어폭스, 사파리, 엣지같은 웹 브라우저를 의미한다. 또한 eamil eclients를 의미하거나 봇을 의미하기도 한다.

  

클라이언트가(user agent)가 서버에 요청을 하면 User-Agent 문자열을 HTTP request header에 넣어서 보내게 된다. 이때 헤더에는

software, browser name, version, os 같은 것들이 들어가게 된다.

  

> [!important]  
> 유저 에이전트 예시  

```Java
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36
```

  

## User Agent String의 사용처

### 1. 콘텐츠 최적화

특정 브라우저나, 기기에서 요청을 보냈을 때 user-Agent를 이용해서 콘텐츠를 최적화 할 수 있다. 예를 들면 휴대폰에서 보는 브라우저의 크기를 작게 맞춘다던가 하는 설정들이 있다.

  

### 2. 분석과 로깅

관리자가 어떤 브라우저나 시스템이 서버에 접근하는지 알 수 있도록 한다. 이러한 데이터는 유저 통계 그리고 유저 경험을 이해하는데 도움이 된다.

  

### 3. 접근 제한

user-Agent를 이용해서 특정 이용자에만 접근할 수 있도록 접근을 제한할 수 있다.

  

이제 내 프로젝트에서 유저에이전트를 사용해서 왜 저런 요청이 들어오는지 확인해보자!!

  

> [!important]  
> CORSFilter.java  

```Java
        String userAgent = request.getHeader("User-Agent");
        log.info("User-Agent : {}", userAgent);
```

코스필터 부분에 user-Agent 부분을 추가해서 넣어줬다!!

# CONCLUSION:

  

## 원인 : 7월21일 기준 찾는중

  

## 작업 : user-Agent를 통한 로깅

헤더에 담긴 User-Agent 정보를 통해서 어떤 client가 서버에 요청을 하는지 확인해보도록 했다.

  

## 결과 :

  

  

## 부제목

> [!important]  
> code file name  

```Shell
# codes
```

  

### 결론

  

# REVIEW: