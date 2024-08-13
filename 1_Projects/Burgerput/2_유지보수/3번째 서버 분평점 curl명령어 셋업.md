---
created: 2024-07-21T16:55
updated: 2024-08-13T12:15
tags:
  - develop
Progress:
  - ongoing
post할까?: false
post됨: false
---
# OBJECT/SUBJECT: 분평점 curl명령어 셋업
이제 분평점에서 쓸 수 있도록 curl명령어를 수행해서 아침 로딩을 수행해보자!

# ANALYSIS:
1. 도메인을 구매한다. Amazon에서 사용가능한 것을 골라야 함 - 가비아에서 새로 샀따...
2. Burgerput서비스를 띄운다.
3. 계정 정보를 분평점으로 변경한다.
4. curl명령어를 8시 34분에 수행되도록 설정한다.
5. 로딩의 결과를 다음날 아침에 확인한다!!!
## 1.도메인을 구매하자
가비아에서 burback2.store 라는 도메인을 550원에 구매했다.(부가세 10%포함)

### Amazon에 등록하기 
route53 호스팅 영역 생성하기
![[Pasted image 20240813014636.png]]
태그에는 아래의 EC2 정보를 넣어주면 된다.


![[Pasted image 20240813014616.png]]

자세한 과정은 아래의 문서에 있다!
[[AWS Domain Set-up]]

## Burgerput 서버를 띄워보자!
MySQL 정보를 체크해주고 넣어주자

jar파일을 만들어서 서버에 옮겨줬다.

## 4. curl명령어를 8시 34분에 수행되도록 설정하기
burgerput 기본 서버랑 똑같이 세팅을 마치자

## 4.1 잊고있었던 SSL세팅... 새롭게 받아서 세팅해주자
[[SSL Set-up]]

![[Pasted image 20240813121236.png]]
```shell
root@3rdBurger:/home/ubuntu# sudo certbot certonly --standalone
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Please enter the domain name(s) you would like on your certificate (comma and/or
space separated) (Enter 'c' to cancel): burback2.store
Requesting a certificate for burback2.store

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/burback2.store/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/burback2.store/privkey.pem
This certificate expires on 2024-11-11.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

```

/etc/letsencrypt/live/burback2.store/ 위치로 이동해서 명령어 쳐주기
```shell
openssl pkcs12 -export -in fullchain.pem -inkey privkey.pem \
 -out keystore.p12 -name tomcat -CAfile chain.pem  -caname root
```
password : putBu13@9*


## 5. 로딩의 결과를 다음날 아침에 확인한다!!!
# CONCLUSION:

## 원인 :

## 작업 :

## 결과 :

## 부제목

<aside> 🔽 code file name

</aside>

```bash
# codes
```

### 결론

> _**아 이렇게 이렇게 이렇게 하면 되는 구나**_

# REVIEW:

내가 이 문제를 통해서 깨닫고 배운 것들

원초적인 내용일 수록 좋다.(이론적인 내용들 기본지식들)

# References
[[AWS Domain Set-up]]
[[SSL Set-up]]