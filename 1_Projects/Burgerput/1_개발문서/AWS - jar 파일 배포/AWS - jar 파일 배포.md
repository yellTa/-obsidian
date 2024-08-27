---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - end
on Naver: false
업로드할까?: false
created: 2023-01-03T14:37:00
updated: 2024-08-27T18:19
---
# 준비

  

## mysql파일 옮기는 과정

1. linux에 java 설치
2. linux에 mysql 설치
3. mysql dump파일 생성
4. mysql dump파일 import
5. jar 파일 생성

  

![[burger.sql]]

![[burger_Custom.sql]]

  

> 리눅스에 java ,mysql 설치하는 법은 인터넷 뒤져보면 나오니까 생략

### 4. SQL dump import

```Shell
# mysql user 생성
mysql> create user 'burgerput'@'%' identified by 'burgerput123';

# mysql burgerputproto databases 생성
mysql> create database burgerputproto;

\#burgerput 계정에 burugerputproto 권한 부여
mysql>grant all privileges on burgerputproto.* to burgerput;

# 메모리에 반영
mysql> flush privilges;

# 권한이 부여되었는지 확인
mysql> show grants for burgurput;
```

![[Untitled 4.png|Untitled 4.png]]

```Shell
# dump import 
mysql -u root -p burgerputproto < burger.sql
```

  

### MySQL Password validation turn off

> [!info] How do I turn off the mysql password validation?  
> It seems that I may have inadvertently loaded the password validation plugin in MySQL 5.  
> [https://stackoverflow.com/questions/36301100/how-do-i-turn-off-the-mysql-password-validation](https://stackoverflow.com/questions/36301100/how-do-i-turn-off-the-mysql-password-validation)  

> mysql을 설치하면 Password validation이 켜져 있는 경우가 있다. 이를 끄는 방법 물론 추천하지는 않는다. 여기서 우리는 비밀번호를 validation 기준에 맞지않게 설정했기때문 (burgerput123)

### How to import MySQL Dump file

> [!info] MySQL Dump / Import 방법  
> MySQL 덤프 / 임포트 1.  
> [https://cloud-oky.tistory.com/327](https://cloud-oky.tistory.com/327)  

  

## Create jar file

```Shell
# test폴더를 제외하고 build실행
> gradlew.bat build -x test
# 폴더의 해당 위치에 들어가면 아래 jar파일이 생성된 것을 확인할 수 있다.
cd build\libs

#파일 실행
java -jar burgerputProject-0.0.1-SNAPSHOT.jar
```

## jar파일 옮기기- FTP이용

  

java -jar 어쩌구 저쩌구.jar

파일 실행해주기