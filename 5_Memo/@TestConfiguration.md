---
created: 2024-07-24 23:54
updated: 2024-07-25T00:21
tags:
  - develop
  - study
  - Spring
  - java
출처:
  - chatgpt
---
# @TestConfiguration이란?

# 설명

`@TestConfiguration`으로 구성된 클래스는 컴포넌트 스캔에서 제외된다. 소프트웨어 개발 및 테스트 과정에서 사용하는 개념이다.  @Configuratino과 유사하지만 테스트환경에서만 사용한다는 특징이 있다.
## TestConfiguration의 목적
1. **환경설정** : 테스트가 실행될 환경을 정의한다. (브라우저, DB, 운영체제의 정보를 포함할 수 있다.)
2. **테스트 데이터** : 테스트 중 사용할 데이터 셋을 지정한다.
3. **설정관리** : 다양한 테스트 환경을 관리하고, 특정 환경에서 발생하는 문제를 신속하게 재현할 수 있다.
## 사용 예시
```
@org.springframework.boot.test.context.TestConfiguration  
@EnableJpaRepositories(basePackages = "burgerput.project.zenput.repository")  
  
class TestConfiguration {  
    @Bean  
    public MachineLoadingAndEnterZenputV2T machineLoadingAndEnterZenput() {  
        return new MachineLoadingAndEnterZenputV2T();  
    }  
  
    @Bean  
    public FoodLoadingAndEnterZenputV2T foodLoadingAndEnterZenput() {  
        return new FoodLoadingAndEnterZenputV2T();  
    }  
  
  
}

```
# 참고

# 연결 문서
[[Spring @Configuration]]
