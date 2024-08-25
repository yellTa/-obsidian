---
created: 2024-07-21T16:55
updated: 2024-08-25T23:47
tags:
  - develop
Progress:
  - ongoing
post할까?: false
post됨: false
---
# OBJECT/SUBJECT:
다른 서버에서 프로젝트를 돌렸을 때  Loading Save가 되지 않는 현상 발생

# ANALYSIS:

```shell
2024-08-24T23:37:14.641Z  INFO 410561 --- [nio-8080-exec-7] b.p.z.S.l.alertCheck.AlertLoadingV2      : editMachine start AlertLoadingV2
Hibernate: select m1_0.id,m1_0.max,m1_0.min,m1_0.name,m1_0.num from machine m1_0
Hibernate: select m1_0.id,m1_0.max,m1_0.min,m1_0.name,m1_0.num from machine m1_0
2024-08-24T23:37:14.832Z  INFO 410561 --- [nio-8080-exec-7] b.p.z.S.l.alertCheck.AlertLoadingV2      : addMap Result= []
2024-08-24T23:37:15.257Z  INFO 410561 --- [nio-8080-exec-7] b.p.z.web.altPages.LoadingController     : Machine getInfo logic False
2024-08-24T23:37:15.259Z  INFO 410561 --- [nio-8080-exec-7] b.p.z.web.altPages.LoadingController     : org.springframework.dao.InvalidDataAccessApiUsageException: Executing an update/delete query

```

![[Pasted image 20240825170538.png]]

위와 같은 에러가 발생했다. 


## 서버의 조건
서버의 조건은 모두 동일하다 DB설정 정보도 동일하다. 심지어 쓰는 파일도 같다.


## 문제점
지금은 @Transaction메소드가 Repository에 작성이 되어있다.(전혀 권장하지 않는 방법)
서비스 중인 서버에서 에러가 나타나지 않고 있지만 두 번째 서비스 하려는 곳에서는 문제가 일어나고 있으니 뭔가 잘못된 것이 맞다. 

@Transactino Annotation을 서비스 단으로 옮기는 리팩토링 작업이 필요하다. 
## 트랜잭션의 로그를 확인해보기
그래도 Repository에 트랜잭션을 적용했어도 정상적으로 작동했었다. 그렇다면 왜 지금 서버에서 작동이 되지 않는지 확인해보자 






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
