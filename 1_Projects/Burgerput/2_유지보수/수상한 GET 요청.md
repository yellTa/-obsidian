---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress:
  - end
업로드할까?: false
created: 2024-08-02T14:37:00
updated: 2024-09-24T00:52
---
# OBJECT/SUBJECT:

## 1. URL : /

User-Agent : Expanse, a Palo Alto Networks company, searches across the global IPv4 space multipl e times per day to identify customers' presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloaltonetworks.com

  

## 2. URL : /, /api/v2/static/not.found, /remote/logincheck, /ab2g, /ab2h

Mozilla/5.0 zgrab/0.x

Mozilla/5.0

  

zgrab은 공격이라고 함 (알아보기)

## 3. URL : /, /fonts/ftnt-icons.woff

2024-07-24T20:33:15.648+09:00 INFO 754425 --- [nio-8080-exec-4] b.project.zenput.intercepter.CORSFilter : User-Agent : curl/7.29.0

  

/loading  
2024-07-26T08:34:49.413+09:00 INFO 754425 --- [nio-8080-exec-4] b.project.zenput.intercepter.CORSFilter : User-Agent : curl/7.81.0  


curl버전이 다름

## 3. URL : /

null

## 4. URL : /favicon.ico, /sitemap.xml , /robots.txt

Go-http-client/1.1

  

서버를 운영하면서 위와 같은 요청이 들어오는 것을 확인했다. front쪽에서 요청한 것은 아니고 분명 다른쪽에서 요청이 된 것 같았다.

  

# ANALYSIS:

## 의도하지 않은 GET요청이 들어오는 이유


### 1. 검색 엔진 크롤러

- 웹사이트의 내용을 인덱싱 하기 위해 요청을 보내는 경우


### 2. 봇 트래픽

- 악의적인 봇이 웹 사이트를 스캔하거나 공격을 시도하는 경우
### 3. DDoS공격

- 서버에 과부하를 일으키기 위해 대량의 요청을 보내는 공격


등과 같은 이유가 있었다.

  

# UserAgent분석

# 1. Mozilla/5.0 zgrab/0.x

- 봇/크롤러
- zgrab은 보안 연구 및 네트워크 매핑을 위한 도우 서버의 상태를 점검하거나 취약점을 찾기 위해 의도적으로 사용됨

  

**막아야 하는 것!!**

  

# 2. Palto Alto Networks

User-Agent : Expanse, a Palo Alto Networks company, searches across the global IPv4 space multipl e times per day to identify customers' presences on the Internet. If you would like to be excluded from our scans, please send IP addresses/domains to: scaninfo@paloaltonetworks.com

  

- Palo Alto Networks의 expanse스캐닝 도구가 서버를 스캔하고 있는 상황
- 스캔에서 벗어나기 위해서는 scaninfo@paloaltonetworks.com IP주소/도메인을 보내면 된다.

  

# 3. Go-http-client/1.1

구굴의 Go Lang으로 만들어진 봇이다.

# CONCLUSION:
## 원인 :
의도치 않은 GET요청은 웹 정보를 가져가는 구글, 야후 같은 인덱싱을 위해서 가져가는 경우가 있다. 하지만 이런 경우에는 robots.txt를 통해서 방지할 수 있다. 

## 작업 :
### 아마존 AWS WAF를 이용해서 막기
아마존에서 웹 방화벽을 이용해 막는 방법이다.

- 클라우드 인프라 레벨에서 작동
- 웹 애플리케이션에 대한 악의적인 트래픽을 필터링하고 DDoS공격을 방어한다.
- AWS WAF는 분산 인프라와 최적화된 네트워크에서 동작해 트래픽을 처리한다.
- 요청이 애플리케이션 서버에 도달전에 차단하므로 서버 자원을 거의 사용하지 않는다.


### Spring 애플리케이션 필터링을 통해서 막기
- 애플리케이션 레벨에서 작용한다.
- 세밀한 요청 검증, 애플리케이션 비즈니스 로직과 통합된 보안 검사를 수행한다.
- 모든 요청이 애플리케이션에 도달하므로 서버의 자원을 사용한다. 
- AWS WAF보다 더 복잡한 비즈니스 로직을 포함한 요청 검증을 수행할 수 있다.

## 결과 :
지민이랑 조금 더 회의를 해 봐야알겠지만 ... 
하루평균 6~10개의 GET요청이 들어오는 듯 하다.
그리고 지금은 JWT토큰을 사용해서 토큰이 없는 경우에는 이미 웹 컨텐츠에 접속할 수 없도록 차단을 하고 있다. 

즉 애플리케이션단에서 토큰으로 이미 정제되고 있다는 의미이다. 토큰이 없으면 로그인 페이지로 이동한다. 서버의 성능을 크게 해치지 않으니 일단은 두는 것이 나을까 아니면 AWS WAF를 이용해서 막는 것이 좋을까?
고민을 좀 해봐야 할듯 하다.
# REVIEW:
서버의 성능을 고려해서 방안을 선택해야하기 때문에 생각보다 신중하게 고르게 방안을 고르게 되었다. (실제로 회의하기 전까지는 어떤 방법을 택해야할지 고르지 않음)


---

# References

[https://user-agents.net/string/mozilla-5-0-zgrab-0-x](https://user-agents.net/string/mozilla-5-0-zgrab-0-x)