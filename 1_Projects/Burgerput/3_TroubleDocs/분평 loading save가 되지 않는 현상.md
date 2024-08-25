---
created: 2024-07-21T16:55
updated: 2024-08-26T00:26
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

### 두 서버의 트랜잭션 격리수준 
```
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| REPEATABLE-READ         |
+-------------------------+

```

위처럼 똑같은 결과가 나왔다.

### REPEATBLE-READ
기본 트랜잭션 격리 수준이다. 트랜잭션 내에서 처음 읽은 데이터를 다른 트랜잭션이 수정하거나 삭제해도 같은 트랜잭션 내에서는 동일한 데이터를 읽을 수 있도록 보장한다.

트랜잭션 내에서 동일한 쿼리가 여러번 실행되도 동일한 결과를 반환하도록 보장하는 것이다. 하지만 다른 트랜잭션에서 데이터가 변경되어도 자신이 처음에 읽은 데이터를 기반으로 동작하게 된다.

처음에 읽고 수행한걸 그대로 쭉 유지해준다고 생각하면 된다. (중꺽마 비슷한 느낌)

## 데드락 체크해보기
데이터 베이스에서 두 개 이상의 트랜잭션이 서로가 잠금(Lock)한 자원을 기다려 무한 대기상태로 빠지는 현상이다. 데드락 로그를 확인했더니

출력결과에서 LATEST DETECTED DEADLOCK세션이 없다. 
없다는 뜻이다. 

## DB의 데드락, 트랙잭션 로그를 확인하고 드는 생각...
인프라 단에서는 아무런 문제가 없다. 같은 MySQL을 쓰고 있으며 심지어 AWS도 같은 사양의 AWS를 쓰고있다. 그렇다면 애플리케이션 단에서 문제가 일어나지 않았을까?

결정적으로 나는

>**<span style="color:rgb(255, 128, 128)">@Transactional 애노테이션을 Repository에 사용하고있다.</span>**

가장 큰 문제점이다. 

그렇다면 이걸 고쳐보면 어떻게 될까?

## @Transactional 리팩토링

### 문제점 
- 관심사의 분리
  Repository는 데이터 접근 계층(DAO) 역할만 해야한다. 비즈니스 로직이나 트랙잭션 관리는 서비스 계층에서 처리하는 것이다.
  트랜잭션은 비즈니스 로직 단위로 묶어야하므로, 서비스 계층에서 트랜잭션을 관리하는 것이 바람직하다.

- 복잡한 트랜잭션 관리 문제
  여러 Repository호출이 하나의 비즈니스 로직 안에서 이루어 진다면 <span style="color:rgb(255, 128, 128)">각 Repository에 트랜잭션이 있으면 서로 독립적인 트랜잭션으로 처리</span>된다. 이는 <span style="color:rgb(255, 128, 128)">부분적으로 처리된 트랙잭션이 발생할 가능성을 높힌다.</span>
  서비스 계층에서 트랜잭션을 관리하면 여러 Repsitory 호출을 하나의 트랜잭션으로 묶어 원자성을 보장할 수 있다.




현재 Repository에 Transactional이 적용되어 있다. 이를 메소드 단으로 전부 변경해 줄 예정이다.

## 이식 계획



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
# 추가로... 현 Controller 및 Transactional의 문제점

```java
@PostMapping("/back/accounts")  
@ResponseBody  
public void saveZenputAccounts(@RequestBody  Map<String,String>  param) {  
    Accounts account = new Accounts();  
  
    try {  
        Accounts byZenputId = zenputAccountRepository.findByZenputId(param.get("zenputId"));  
  
        //not empty!  
        byZenputId.setRbiId(param.get("rbiId"));  
        byZenputId.setRbiPw(param.get("rbiPw"));  
  
        zenputAccountRepository.save(byZenputId);  
  
    } catch (NullPointerException e) {  
        //empty!  
        account.setZenputId(param.get("zenputId"));  
        account.setRbiId(param.get("rbiId"));  
        account.setRbiPw(param.get("rbiPw"));  
  
        zenputAccountRepository.save(account);  
    }  
  
}
```

Controller에서 direct로 save를 진행하고 있는 끔찍한 모습이다.
이떄 ZenputAccountRepository에는 @Transactional이 붙어있지 않았고 Controller에도 붙어있지않다. 하지만 CURD가 정상적으로 수행되는 것을 확인할 수 있었는데

그 이유는

간단한 CRUD는 @Transactional없이도 Spring이 자동으로 관리해준다. 
복잡한 쿼리는 @Transactional을 사용해야하지만 간단한 것은 생략할 수 있다는 이야기

나중에 해야될 리팩토링 항목에 추가된 친구들...



---
# REVIEW:

내가 이 문제를 통해서 깨닫고 배운 것들

원초적인 내용일 수록 좋다.(이론적인 내용들 기본지식들)

# References

# 연결문서
