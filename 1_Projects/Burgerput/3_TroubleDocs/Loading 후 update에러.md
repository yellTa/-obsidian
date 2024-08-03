---
progress:
  - inprogress
Created time: Invalid date
Last edited time: Invalid date
Review여부: false
post됨: false
post할까?: false
---
# OBJECT/SUBJECT:

```Java
org.springframework.dao.InvalidDataAccessApiUsageException: Executing an update/delete query
```

서버에 정상적으로 진입이 되었으나 위와 같은 에러가 발생했다.

# ANALYSIS:

## Spring JPA사용시 주의점

Spring JPA를 사용할 때에는 @Transactional 애노테이션이 필수이다. 데이터 베이스 수정 작업이 이루어지기 때문이다.

@Transactional은 서비스단에서 사용이된다.

  

## 1. CRUD를 사용하는 SaveDataV1에 트랜잭션 적용하기

  

```Java
@Slf4j
@RequiredArgsConstructor
@Transactional
public class SaveDataV1 implements SaveData {
```

  

# CONCLUSION:

## Spring JPA사용시 Transcation을 사용해야한다.

Spring JPA에서 데이터를 수정, 삭제하는 작업을 수행할 시에는 트랜잭션을 사용해야한다. 이때 @Modifying과 @Query를 이용한 네이티브 쿼리 , JPQL도 마찬가지이다.

기본적으로 Spring JPA에서 사용하는 메소드쿼리는 트랜잭션이 적용되어 있지만 직접 설정한 네이티브쿼리와 JPQL은 아니다.

  

  

## 원인 : 트랜잭션을 사용하지 않고 DB수정 작업 진행

  

## 작업 : 수정작업을 수행하는 서비스 단에 트랜잭션 적용

  

## 결과 : 29일 아침에 확인해보자

  

# REVIEW:

이번 시간을 통해서 SPring Transacton에 대해서 공부하게 되었다. 왜 트랜잭션을 사용해야 하고 왜 내가 사용했던 방법에서는 에러가 났었는지 확실히 확인할 수 있었다!!