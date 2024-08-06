---
created: 2024-07-21T16:55
updated: 2024-08-06T12:06
tags:
  - develop
progresses:
  - in_progress
post할까?: false
post됨: false
---
# OBJECT/SUBJECT: 
버거킹 분평점을 위한 첫번 째 서버 세팅 

- 1. 도메인을 옮기자 (테스트 서버에서 사용중인 도메인을 테스트 서버 3으로 가져오자!)
- 2. 도메인을 cron을 설정하자 아침 8 :34분에 청터와 똑같이 로딩 로직 수행 대신 메일 기능은 보류 할 예정!

일단 cron을 통해서 분평점의 데이터를 잘 긁어오는지 체크하자!

# ANALYSIS:
## 순서
1. burgerput서버 1의 도메인 해제
2. burgerput 서버 3에 도메인 적용(1에서 해제한 도메인을 적용하기)
3. java application 띄우기
4. mysql 정보 분평점 정보로 바꿔놓기
5. cron 설정해놓기- 일단 메일 시스템은 구축하지 않는 방향으로 설정
## 1. burgerput서버 1의 도메인 해제
![[Pasted image 20240806115503.png]]

레코드를 삭제한다. NS와 SOA는 남아있는 것이 정상이다. 
![[Pasted image 20240806115630.png]]

호스팅 영역 선택 후 삭제를 수행한다.

## burgerput 서버 3에 도메인 적용(1에서 해제한 도메인을 적용하기)
![[Pasted image 20240806120139.png]]

해제한 도메인 burback2.shop등록

> 현재 AWS에서 burback2.shop이 사용이 불가하다... shop을 사용할 수 없기 때문 ㅋ 그래서 다른거로 구매해서 설정해야할 듯 하다...




## 3. java application 띄우기
## 4. mysql 정보 분평점 정보로 바꿔놓기
## 5. cron 설정해놓기- 일단 메일 시스템은 구축하지 않는 방향으로 설정



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
