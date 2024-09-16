---
created: 2024-09-16 23:23
updated: 2024-09-17T00:43
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
여기에 추가로 getter랑 setter까지 넣어주면 된다.

### 회원 클래스 다이어그램을 기반으로  코드짜기
#### MemberService interface생성
``` java
package hello.core.useSpring;  
  
public interface MemberService {  
    public void register(Member member);  
    public Member findMemberById(int id);  
}
```
회원이 어떤 기능을 하는지 기억해보자
1. 회원 가입을 수행하는 기능
2. 회원 조회를 수행하는 기능
이를 인터페이스 구현체로 지정해준다.


#### MemeberRepository interface생성
``` java
package hello.core.useSpring.member;  
  
public interface MemberRepository {  
    public void save(Member member);  
    public Member findMember(int id);  
}

```
저장소 역할의 DB를 만든다. 
DB에서 수행되는 내용은
1. 회원 저장하기
2. DB에 저장된 회원 찾아서 조회하기

이 기능은 MemberService의 역할과는 다르다.
회원을 가입하는 기능을 제공하는 거고 위의 MemberRepository는 회원을 DB에 저장하는 행위를 의미한다.
#### MemoryMemberRepository (MemberRepository 상속)
``` java
@Repository
public class MemoryMemberRepository implements MemberRepository{  
    Map<Integer, Member> store = new HashMap<>();  
    @Override  
    public void save(Member member) {  
        store.put(member.getId(), member);  
    }  
  
    @Override  
    public Member findMember(int id) {  
        return store.get(id);  
    }  
}
```
MemberRepository를 상속받는 MemoryMemberRepository를 작성한다. 

이때 @Repository 애노테이션을 이용해 스프링빈으로 등록한다. 즉 해당 구현체는 스프링 컨테이너에 들어가게 된다.

#### MemberServiceImpl (MemberService 구현체)
```  java
package hello.core.useSpring.member;  
  
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.stereotype.Service;  
  
@Service  
public class MemberServiceImpl implements MemberService{  
//AutoWired를 사용한 생성자 주입  
  
    @Autowired  //생성자가 한 개일 때는 생략 가능
    final MemberRepository memberRepository;  
  
    public MemberServiceImpl(MemberRepository memberRepository) {  
        this.memberRepository = memberRepository;  
    }  
    @Override  
    public void register(Member member) {  
        memberRepository.save(member);  
    }  
  
    @Override  
    public Member findMemberById(int id) {  
        return memberRepository.findMember(id);  
    }  
}
```
마찬가지로 @Service애노테이션을 통해 Spring 빈으로 등록한다.
MemberService는 다이어그램에서 보면 알 수있듯 MemberRepository에 의존적인데 
이를 <span style="color:rgb(255, 128, 128)">@Autowired를 이용핸 생성자 주입을 통해서 주입해준다.</span>
이것이 Dependency Injection이다!

## 회원가입 테스트해보기
이제 회원 가입을 설계한 도메인대로 작성을 완료했다. 한번 테스트해보자!

``` java
package hello.core.useSpring.member;  
  
import org.junit.jupiter.api.Test;  
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.boot.test.context.SpringBootTest;  
  
import static org.junit.jupiter.api.Assertions.assertEquals;  
  
@SpringBootTest // Spring 컨테이너를 불러오는 설정  
class MemberServiceImplTest {  
    @Autowired  
    private MemberService memberService;   //필드주입
  
    @Test  
    public void register(){  
        Member member = new Member(1, "member1", Grade.VIP);  
  
        memberService.register(member);  
  
        Member findMember = memberService.findMemberById(1);  
  
        assertEquals(member, findMember);  
    }  
  
}
```

성공!!

# 위의 작성한 코드를 기반으로 IoC DI에 대해서 알아보자

## IoC
위의 코드를 작성하면서 나는 IoC에 대한 설명을 따로 하지 않았다. 그 이유는 
바로 @Service나 @Repository처럼 Sprign bean으로 등록하는 행위가 객체의 관리를 Spring에게 전가? 한다는 의미이다.

기존의 순수 자바 코드에서는 AppConfig를 만들고 거기서 객체를 사용자가 갈아끼워줬는데 이제는 더 간편하게 애노테이션 하나로 Spring bean으로 등록하는 것이다. 
이 과정에 대해서는 조금 더 자세하게 알아보자

### MemberServiceImpl은 MemberRepository에 의존한다. 근데 구현체에 의존을 안하는데 어떻게 MemoryMemberRepository의 기능을 하는 걸까?

그 이유는 Spring Container에 있다.
![[Pasted image 20240917002236.png]]

MemberServiceImpl은 확실하게 MemberRepository에 의존한다. 그렇다면 MemberRepository의 구현체는 도대체 어디서 가져오는 걸까?
그건 바로 Spring Container다. @Repository, @Service가 붙은 것들은 Spring Container로 향하게 된다. 이때 @Repository애노테이션을 갖는 MemoryMemberRepository는 MemberRepository를 상속받았기 때문에 스프링은 MemberRepository를 의존하게 되면 이를 상속하는 객체를 꺼내와서 주입해준다.

그래서 제어의 역전이라고 부르는 것이다.
순수 자바 코드에서 AppConfig를 생각해보자

```java
 
//appliction환경 구성은 여기서 다 하는 거임  
  
@Configuration //Spring 옵션  
public class Appconfig {  
    //역할들이 나오고 역할들이 어떤 구현체를 갖는 지 확인할 수 있다.  
    //역할과 구현 클래스가 한눈에 들어온다.  
  
  
    //bean을 쓰면 Spring Container에 저장이 된다.  

    public MemberService memberService() {  
        return new MemberServiceImpl(memberRepository());  
    }  

    public OrderService orderService() {  
        return new OrderServiceImpl(  
                memberRepository(), discountPolicy());  
    }  

    public MemberRepository memberRepository() {  
        return new MemoryMemberRepository();  
    }  
  

    public DiscountPolicy discountPolicy() {  
        return new FixDiscountPolicy();  
    }  
  
  
  
}
```

이렇게 구현되어 있고 구현체에서는 

``` java
AppConfig app = new AppConfig();

MemberService memberRe = app.memberService();

```
의 형태로 가져오게 된다. 
DIP, OCP를 지키기는 하지만 그래도 개발자들이 AppConfig에서 객체를 갈아 끼워줘야하는 상황이 발생한다.

Spring Container를 사용하면 그럴 필요가 없다는 의미이다.
추상화를 만들고 그 추상화를 상속받는 친구들만 만들고 @Bean으로 등록만 해주면 Spring이 알아서 객체를 관리해주는 것이다. 

그리고 또한!... IoC는 조금 더 넓은 의미를 가지고 있는데
IoC는 객체의 생성, 생명주기, 의존성 관리(여기에 DI가 속함)을 관리해준다.
## DI
직역하면 외부에서 주입해준다는 뜻이다. 
그럼 Spring에서 DI는 어떻게 이루어 지는지 보자


SOLID 원칙을 지키기위해서는 다형성을 지키기위해 추상화에 의존해야한다고 했다.
이제 추상화에 의존하는 건 알겠는데... 문제는 추상화에 의존받으면 객체를 주입해주는 과정이 필요하다.

그러기 위해서 순수 자바코드에서는 AppConfig를 사용했다. 그렇다면 Spring에서는 어떻게 사용할까?

``` java
  
@Autowired  
final MemberRepository memberRepository;  

public MemberServiceImpl(MemberRepository memberRepository) {  
    this.memberRepository = memberRepository;  
}
```
ServiceImpl의 일부분이다. 

@Autowired를 통해서 스프링이 생성자 주입 방식으로 MemberRepository를 스프링 컨테이너에서 찾아서 주입해준다. 

스프링은 인터페이스를 확인하고, 그 인터페이스를 구현한 구현체를 찾아서 주입하게된다. 이 과정을 DI라고 한다. 


# 결론
## Spring IoC
- 객체의 생성, 생명주기 관리, 의존성 관리 를 담당한다. DI가 가진 개념보다 좀 더 넓게 봐야한다.

### 객체의 생성
스프링 컨테이너가 애플리케이션에서 필요한 객체를 자동으로 생성하고 관리한다.
@Service, @Repository, @controller, @Compnent등의 애노테이션이 이런 작업을 수행한다.

1. 애플리케이션이 시작될 때 스프링 컨테이너가 생성되고 , @Component, @Service, @Reository, Controller등이 부은 애노테이션을 가진 클래스를 스캔한다.
2. 빈을 생성하고 등록한다.
   위의 클래스들을 기반으로 빈을 생성하고 스프링 컨테이너에 등록한다. 이때 개발자가 객체를 직접 만들지 않고 스프링이 만든다.
3. 의존성 주입(DI)
   빈을 관리하는 동시에 객체 간의 의존성을 주입한다. @Autowired 롬복의 @RequiredArgsConstuctor를 사용하는 것과 같다.
4. 빈을 사용할때 스프링이 자동으로 해당 객체를 제공해준다.
   
어떤 식으로 제공하는지는 위에 그림으로 그려놓았다.

## Spring DI
IoC보다 조금 좁은 개념
Spring Container에 등록된 빈 중  추상화에 알맞는 구현체를 찾아 객체를 주입해준다. 자세한 개념은 앞쪽에서 설명이 되었으니 pass

---
# 참고

## 도메인 설계의 의미
- 도메인을 설계한다는 것은 애플리케이션의 핵심 비즈니스 로직과 문제 영역을 정의하는 것이다.

### 도메인 모델링
- 도메인 설계시 시스템에서 중요한 개념을 도메인 모델로 정한다.(고객, 상품, 주문)
- 각 도메인 모델은 해당 시스템에서 필요한 "객체" "속성" "행동 메서드"을 포함한다.
