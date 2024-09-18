---
created: 2024-09-18 17:49
updated: 2024-09-18T17:54
tags:
  - develop
Progress:
  - ongoing
---
# Spring @Transactional을 뜯어봅시다
스프링의 트랜잭션을 관리하는 @Transactional
코드를 뜯어서 확인해봅시다


## 트랜잭션의 프름을 확인하기 위해 핵심 클래스를 추척해보자
Spring Transaction의 프록시 객체 생성, 트랜잭션 관리까지 모든 단계를 담당하는 클래스를 한 번 따라가보자

## 임시 체크 - 지울것
1. ProxyTransactionManagementConfiguration
2. `ProxyFactory` 혹은 AopProxyFactory
3. AnnotationTransactionAttributeSource
4. TransactionInterceptor
5. PlatformTransactionManager
### 1. 트랜잭션 관리 활성화
@EnableTransactionManagement 또는 XML설정을 사용해 트랜잭션 관리가 활성화 된다. 
이때 트랜잭션 어드바바이저와 관련 설정이 등록된다.




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
