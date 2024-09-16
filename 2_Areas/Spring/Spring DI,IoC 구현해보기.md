---
created: 2024-09-16 23:23
updated: 2024-09-16T23:42
tags:
  - Spring
  - java
출처: 
---
# Spring DI, IoC를 생각해보면서 구현해보자
## 서비스 요구사항
### 회원 서비스
- 회원은 가입을 할 수 있다.
- 회원 조회를 할 수 있다.
- 회원은 등급이 있다.VIP, FRIEND
- 회원의 정보를 DB에 넣는데 외부시스템 연동해서 넣을지, 아니면 DB에 넣을지, 메모리에 넣을지 아직 확실히 안정해짐 일단은 메모리에 넣을 거임

### 주문 서비스
- 주문에는 회원 아이디, 상품이름, 가격의 정보가 들어간다.
- 할인률은 회원의 등급에 따라 다르다. VIP회원의 경우 1000원을 할인해줄 예정이다.
- 할인 서비스는 금액할인 vs 정률할인 으로 되어있다. 금액이 10000원 이상이면서 VIP는 1000원 vs 10%할인으로 되어있다. 

# 요구사항에 맞춰 설계 수행
## 회원 도메인 설계
![[Pasted image 20240916233637.png]]
## 회원 클래스 다이어그램
![[Pasted image 20240916233708.png]]
외부시스템일지, MemoeryDB일지, DB를 사용할지 모르기 구현체를 각 역할에 맞게 여러개로 두었다.
## 회원 객체 다이어그램
![[Pasted image 20240916233729.png]]
실제 구현에서 사용할 구현체들이다. 


## 위 그림을 배경으로 코드를 짜보자!
### 회원객체 만들기
#### Grade(enum)
``` java
public enum Grade {  
    VIP,  
    FRIEND  
}
```

#### Member
``` java
package hello.core.useSpring;  
  
import hello.core.pureJava.member.Grade;  
  
public class Member {  
    private int id;  
    private String name;  
    private Grade grade;  
  
    public Member(int id, String name, Grade grade) {  
        this.id = id;  
        this.name = name;  
        this.grade = grade;  
    }  
}
```
여기에 추가로 getter랑 setter까지

### 회원 클래스 다이어그램을 기반으로  코드짜기
#### MemberService interface생성
``` java
package hello.core.useSpring;  
  
public interface MemberService {  
    public void register();  
    public Member findMemberById(int id);  
}
```
회원이 어떤 기능을 하는지 기억해보자
1. 회원 가입
2. 회원 조회이다.
이를 인터페이스 구현체로 지정해준다.
# 결론

# REVIEW


---
# 참고

## 도메인 설계의 의미
- 도메인을 설계한다는 것은 애플리케이션의 핵심 비즈니스 로직과 문제 영역을 정의하는 것이다.

### 도메인 모델링
- 도메인 설계시 시스템에서 중요한 개념을 도메인 모델로 정한다.(고객, 상품, 주문)
- 각 도메인 모델은 해당 시스템에서 필요한 "객체" "속성" "행동 메서드"을 포함한다.

# 연결문서