---
created: 2024-07-24 20:11
updated: 2024-07-24T23:54
tags:
  - study
  - Spring
  - develop
출처:
  - chatgpt
---
# @Configuration이란?


# 설명
클래스가 하나 이상의 `@Bean` 메서드를 포함하고 있을 때 사용한다. 스프링 빈들을 클래스 파일 하나에 정의하고 관리할 수 있다. 

## @Configuration의 풀 프로세싱
`@Configuratino` 클래스는 CGLIB 바이트코드 생성 라이브러리를 사용해서 프록시 객체를 생성한다.
이를 통해 `@Configuration` 클래스의 메서드 호출이 빈 정의랑 연결되고, 애플리케이션 컨텍스트에서 관리되는 빈들이 올바르게 생성되고 주입된다.
# 참고
chatgpt

# 연결 문서

