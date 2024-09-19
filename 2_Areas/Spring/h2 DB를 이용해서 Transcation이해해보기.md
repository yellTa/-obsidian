---
created: 2024-09-19 00:26
updated: 2024-09-19T22:34
tags:
  - develop
  - study
  - transaction
  - database
  - backend
Progress:
  - end
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

```sql
set autocommit false; //수동커밋으로 바꿔주기
insert into member(member_id, money) values ('data3',10000); insert into member(member_id, money) values ('data4',10000);
```
해당 명렁어를 수행하면 

![[Pasted image 20240919014120.png]]
첫번 째 세션 창의 결과이다. 
그렇다면 두 번째 DB창에서 확인하면 어떻게 될까?

![[Pasted image 20240919014211.png]]
두 번째 창에서는 저장 저장이 되지 않았다. 이는 수동 커밋으로 전환하고(Transaction이 시작되고) commit이 되지 않았기 때문이다.

첫 번째 창에서 commit을 입력해주고
![[Pasted image 20240919014314.png]]
두 번째 창에서 다시 조회를 수행하면
![[Pasted image 20240919014340.png]]
이런 그림이 나오게된다.


즉 Transaction이 시작되고 commit이 되지 않은 상태에서는 DB에 완전 적용하지 않은 임시데이터이기 때문에 변경 사항이 적용되지 않은 것이다.
Transaction을 적용하면(commit) DB에 완전 적용이 되어 다른 세션에서도 값을 확인할 수 있다.

## Rollback을 하는 경우
계좌이체를 하는 경우를 생각해보자

data2가 data1에게 돈을 보내려고 한다.

![[Pasted image 20240919015106.png]]

전송할 SQL쿼리는

```sql
set autocommit false;
update member set money=10000+ 2000  where member_id = 'date1';
update member set money=10000 -2000  where member_id = 'date2';

select * from member

```

![[Pasted image 20240919015142.png]]
쿼리를 실행한 두 번째 세션에서는 data2가 data1에서 2000원을 송금한 것을 알 수 있다.

그런데?!!!!

만약 AutoCommit True상태였다면?...

``` sql
update member set money=10000+ 2000  where member_id = 'date1';
update member set money=10000 -2000  where member_id = 'date2';
```
두 번째 구문을 수행할때 에러가 났다고 해보자 그러면 10000원에서 2000뺀 값이 아닌 원래 값인 10000원이 되어야 한다.

그래서 date2의 값이 10000원으로 돌아갔다고 하자 

그렇다면 data1의 돈은?... 
data2가 이체 수행중 오류가 발생해서 10000원의 값 그대로 가지고 있는데 data1는 출처가 어딘지 모른 2000원이 생기게 된 것이다!!!

이를 방지하기 위해서 
``` sql
set autocommit false;
update member set money=10000+ 2000  where member_id = 'date1';
update member set money=10000 -2000  where member_id = 'date2';

select * from member
```
set autocommit (Transaction을 시작)을 false로 두는 것이다. 

그렇다면 data2의 금액에서 2000원이 빠지는  작업에서 에러가 발생하면 발생하기 전으로 돌려주면 된다.

바로 rollback이다.

![[Pasted image 20240919015555.png]]
위의 사진은 rollback을 수행한 후의 사진이다. (rollback하고 찍는걸 까먹음)

이렇게 문제없이 되돌릴 수 있따!

# REVIEW
오늘은 간단하게 H2 DB를 통해서 트랜잭션의 개념에 대해서 알아보았따! 

---
# 참고:
[스프링 DB 1편 데이터 접근 핵심 원리](https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-db-1/dashboard)

