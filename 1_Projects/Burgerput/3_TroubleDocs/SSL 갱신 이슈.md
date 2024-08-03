---
progress:
  - end
Created time: Invalid date
Last edited time: Invalid date
Review여부: true
post됨: false
post할까?: false
---
# SUBJECT: SSL 만료

만료된 SSL을 사용해서 front-end단과 서버과 통신하지 못해 오류가 발생했다.

# CONCLUSION: SSL갱신 후 사용

SSL을 갱신해서 .p12파일을 생성해 만들었다.

  

### 인증서 남은 유효 기간 확인하기

```C++
sudo certbot certificates
```

### SSL 갱신하기

```C++
$ sudo certboat renew --dry-run //인증서 갱신하는데 문제가 없는지 판단
$ sudo certbot renew //실제 갱신 진행
```

### .p12파일생성하기

```C++
//갱신으로 만들어진 두 Certifivate Path와 PrivateKey Path


    Certificate Path: /etc/letsencrypt/live/burback.shop/fullchain.pem
    Private Key Path: /etc/letsencrypt/live/burback.shop/privkey.pem
    
$ openssl pkcs12 -export -in /etc/letsencrypt/live/burback.shop/fullchain.pem -inkey /etc/letsencrypt/live/burback.shop/privkey.pem -out /etc/letsencrypt/live/burback.shop/keystore.p12 -name tomcat -CAfile /etc/letsencrypt/live/burback.shop/fullchain.pem -caname root
//두 파일을 이용해서 .p12를 생성
```

비밀번호를 물어보는 창이 나타나면 비밀번호를 입력하면 된다.

  

### Spring application.properties에 .p12파일 경로 넣기

> [!important]  
> Spring Application.properties파일  

```Shell
#\#Test SSL Settings
\#server.port:8043

server.ssl.key-store:file:/home/ubuntu/burgerput/cicd/deploy/keystore.p12
server.ssl.key-store-type=PKCS12
server.ssl.key-store-password=putBu13@9*
```

  

# SOLVE:

정상적으로 사이트가 작동하는 것을 확인할 수 있다

# REVIEW:

서버를 돌릴때는 SSL관리도 확실하게 해야한다… 위처럼 만료된 SSL을 사용하면 front-end단과 통신을 할 수 없어 사용할 수 없는 상황이 발생한다.