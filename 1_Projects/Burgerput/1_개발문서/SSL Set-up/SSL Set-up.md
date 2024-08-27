---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - ongoing
on Naver: false
업로드할까?: false
created: 2024-03-06T14:37:00
updated: 2024-08-27T17:57
---
# Set-up free SSL for my Project

## ==Prerequisite==

- EC2 has to have domain

# SSL through Certbot

## Let’s encrypt

Free SSL Autority!

But It has to renew every three month.

  

Certbot is open source, renew the let’s encrypt ssl automatically.

Let’s encrypt recommend certbot for renew the SSL.

  

### Standalone

- Require server restart
- support auto renew SSL
- execute virtual standalone webserver with port 80.

  

  

### Webroot

- Server restart not required
- Support auto renew SSL
- Writing specific file running in the web server’s certain directory.

# 1. Create SSL through Certbot

## 1-1. Install Certbot

```Shell
sudo apt list --installed | grep certbot

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
# didn't Installed

 sudo snap install --classic certbot
```

  

## 1-2. Issue SSL with stanalone

```Shell
$ sudo certbot certonly --standalone
```

  > <span style="color:rgb(255, 71, 71)">The port 80 and 443 must be opened</span>

![[Untitled 2.png|Untitled 2.png]]

Follow the process and the SSL created!

```Shell
Certificate is saved at: /etc/letsencrypt/live/[=======]/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/[=======]/privkey.pem
```

  

  

# 2. Apply SSL to Spring Boot

## 2-1. Create PKC12 from pem file

Turn to root account

```Shell
openssl pkcs12 -export -in fullchain.pem -inkey privkey.pem \
 -out keystore.p12 -name tomcat -CAfile chain.pem  -caname root

EnterPassword: yourPassword

password:putBu13@9*
```

Copy the keystore.p12 file for SSL setup

  

  

## 2-2. [application.properties](http://application.properties) file

```Shell
server.ssl.key-store:file:[location]/keystore.p12
server.ssl.key-store-type=PKCS12
server.ssl.key-store-password=[Your password]
```

Add this line to [application.properties](http://application.properties) in the Spring boot for applying SSL

  

  

# 3. auto renew the SSL

Writing alskdfjlskdfjititi

  

---

> [!info] Spring boot SSL 인증서 적용하기  
> 요즘 웹사이트는 기본적으로 HTTPS를 바탕으로 동작한다.  
> [https://velog.io/@kirilocha/Spring-boot-SSL-인증서-적용하기](https://velog.io/@kirilocha/Spring-boot-SSL-인증서-적용하기)  

> [!info] Crontab을 이용한 Let's Encrypt SSL 인증서 Tomcat 자동 갱신.  
> 인증서 발급, certbot 설치, crontab설치는 생략함.  
> [https://blog.gizmo80.com/107](https://blog.gizmo80.com/107)