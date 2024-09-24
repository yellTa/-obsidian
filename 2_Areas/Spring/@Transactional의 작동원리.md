---
created: 2024-09-24 23:57
updated: 2024-09-25T00:10
tags:
  - Spring
  - study
  - transaction
출처: 
---
# Spring @Transactional의 작동원리
스프링의 Transaction AOP는 이 @Transactional 애노테이션을 인식해 트랜잭션 프록시를 적용한다.

## @Transactional의 동작순서




1. 트랜잭션 시작 
2. 트랜잭션 매니저(스프링 컨테이너에 등록된 트랜잭션 매니저)획득 
3. 트랜잭션 메니저가 커넥션 생성 
4. 트랜잭션 동기화 매니저가 커넥션 보관 5. 
5. 데이터 접근 로직이 트랜잭션 동기화 커넥션 획득 
6. 데이터 작업 프록시 DB에 수행 
7. 에러 발생시 프록시 DB의 값을 진짜 DB에 commit하지 않음 에러가 발생하지 않을 시 트랜잭션 종료후 DB에 커밋
   
   


# 결론

# REVIEW


---
# 참고

# 연결문서