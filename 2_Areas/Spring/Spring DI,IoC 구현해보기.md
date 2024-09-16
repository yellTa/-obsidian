---
created: 2024-09-16 23:23
updated: 2024-09-17T00:08
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
여기에 추가로 getter랑 setter까지

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
@Service
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
  
    @Autowired  
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
# 결론
## IoC
위의 코드를 작성하면서 나는 IoC에 대한 설명을 따로 하지 않았다. 그 이유는 
바로 @Service나 @Repository처럼 Sprign bean으로 등록하는 행위가 객체의 관리를 Spring에게 전가? 한다는 의미이다.



# REVIEW


---
# 참고

## 도메인 설계의 의미
- 도메인을 설계한다는 것은 애플리케이션의 핵심 비즈니스 로직과 문제 영역을 정의하는 것이다.

### 도메인 모델링
- 도메인 설계시 시스템에서 중요한 개념을 도메인 모델로 정한다.(고객, 상품, 주문)
- 각 도메인 모델은 해당 시스템에서 필요한 "객체" "속성" "행동 메서드"을 포함한다.

# 연결문서