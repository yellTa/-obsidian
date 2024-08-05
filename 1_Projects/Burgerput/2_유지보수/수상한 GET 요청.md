---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress: in progress
업로드할까?: false
created: 2024-08-03T14:37
updated: 2024-08-05T23:40
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
의도치 않은 
  

## 작업 :

  

## 결과 :

  

  

# REVIEW:

내가 이 문제를 통해서 깨닫고 배운 것들

원초적인 내용일 수록 좋다.(이론적인 내용들 기본지식들)

  

---

# References

[https://user-agents.net/string/mozilla-5-0-zgrab-0-x](https://user-agents.net/string/mozilla-5-0-zgrab-0-x)