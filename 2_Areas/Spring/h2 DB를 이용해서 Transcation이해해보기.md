---
created: 2024-09-19 00:26
updated: 2024-09-19T01:37
tags:
  - develop
  - study
  - transaction
  - database
Progress:
  - ongoing
---
# h2 DB를 이용해서 트랜잭션을 이해해보자
트랜잭션을 h2 DB를 이용해서 이해해보자 

## 배경지식
### Transaction:
DB에 CRUD를 단위로 수행하게 해준다. 한 트랜잭션 안에서 CRUD가 일어나게 되는 것 

## 배경 : 서로 다른 세션에서 Transaction이 돌아가게 된다면 어떻게 될까요?
실험해봅시다

H2 DB를 켜줍니다. ~~초기 세팅법은 다른 곳에서 찾아서 하면 됩니다.~~

이때 2개를 띄워줍니다!
![[Pasted image 20240919004211.png]]

이렇게요 

해당 조건을 가지게 되면 두 개의 세션이 시작된 경우 입니다.
즉 트랜잭션이 2개라는 의미가 됩니다.

``` sql
drop table member if exists;
create table member(
member_id varchar(10),
money integer not null default 0,
primary key(member_id)
);
```

member테이블이 있따면 삭제해주고 member_id와 moeny속성을 갖는 간단한 member테이블을 만들어주자!!

###  자동 커밋과 수동 커밋
자동 커밋과 수동 커밋에 대해서 알아보자
#### 자동 커밋
커밋을 날리게되면 바로 SQL문 수행

#### 수동 커밋
커밋을 날리게 되면 기다렸다가 commit메세지를 마지막에 보내고 나서야 DB에 적용이 됨

수동 커밋이 Transaction이다. 확실하게 Transaction이라고 할 순 없지만 수동 커밋을 하게 된 순간 Transaction을 시작한다고 보면된다.


우선 자동 커밋으로 1번 세션에(첫 번째 H2 DB창) 값을 넣어주자

![[Pasted image 20240919013700.png]]

이런 데이터를 넣어줬다. 그렇다면 수동커밋으로 바꿔보자


# ANALYSIS:

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



---
# REVIEW:

내가 이 문제를 통해서 깨닫고 배운 것들

원초적인 내용일 수록 좋다.(이론적인 내용들 기본지식들)

# References

# 연결문서
