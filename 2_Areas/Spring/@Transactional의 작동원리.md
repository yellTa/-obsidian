---
created: 2024-09-24 23:57
updated: 2024-09-25T01:03
tags:
  - Spring
  - study
  - transaction
출처: 
---
# Spring @Transactional의 작동원리
스프링의 Transaction AOP는 이 @Transactional 애노테이션을 인식해 트랜잭션 프록시를 적용한다.
## @Transactional의 동작순서
![[Pasted image 20240925001846.png]]
1. 트랜잭션 시작 
2. 트랜잭션 매니저(스프링 컨테이너에 등록된 트랜잭션 매니저)획득 
3. 트랜잭션 메니저가 datasource를 이용해 커넥션 생성 
4. 트랜잭션 동기화 매니저가 커넥션 보관
5. 데이터 접근 로직이 트랜잭션 동기화 커넥션 획득 
6. 데이터 작업 프록시 DB에 수행 
7. 에러 발생시 프록시 DB의 값을 진짜 DB에 commit하지 않음 에러가 발생하지 않을 시 트랜잭션 종료후 DB에 커밋

## @Transacional 동작순서(JPA사용시)
1. 트랜잭션 시작 
2. EntityManager가 영속성 컨텍스트 생성 혹은 기존의 컨텍스트가 있다면 그걸 재사용 
3. 트랜잭션 매니저를 Spring Container에서 획득 
4. 트랜잭션 매니저가 Datasource를 통해 JDBC커넥션 생성 
5. 영속성 컨텍스트 내의 엔티티에서 데이터 작업 수행 
6. 정상수행된다면 DB에 영속성 컨텍스트의 적용값이 flush됨, 에러발생시 롤백-> 영속성 컨텍스트의 변경사항은 DB에 적용되지 않음
# 결론
트랜잭션은 중간에 Proxy를 생성해 DB를 관리한다! 
그리고 작업이 정상 수행되면 proxy를 커밋해 실제 DB에 값을 적용한다!