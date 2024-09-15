---
created: 2024-09-15T21:43
updated: 2024-09-15T21:59
---
## SOLID원칙에 따라서 코드 작성하기 

구현할 서비스를 지정한다.
 - MemberService
   - 회원 가입
   - 회원 조회

- OrderService
	- 주문 하기

해당 기능을 가지고 Interface를 만든다.

MemberService
OrderService
인터페이스 하나씩 

그리고 그 밑에 구현체 하나씩

MemberService -> memberRepository(Memeory, DB)
MemberService 는 MemberRepository에 의존적이다. 대신? 구현체가 아닌 인터페이스에 의존해야한다.

그럼 인터페이스에 의존하려면 어떻게 해야할까?

MemberRepository = new MemoryRepository(); 의 형태가 아닌
<span style="color:rgb(255, 128, 128)">외부에서 주입받아야 하는 상황이 필요하다.</span> 

그걸 AppConfig를 통해서 외부에서 주입해주는 것! 


즉 이런 형태로 된다.

## Main

``` java
Appconfig appConfig = new Appconfig();  
MemberService memberService = appConfig.memberService();  
  
Member member = new Member(1L, "MemberA", Grade.VIP);  
  
//when  
memberService.join(member);  
  
Member findMember = memberService.findMember(1L);  
System.out.println("new member = " + member.getName());  
System.out.println("find Member = " + findMember.getName());

```


## MemberSercviceImpl
``` java
private final MemberRepository memberRepsitory;  
  
public MemberServiceImpl(MemberRepository memberRepsitory) {  
    this.memberRepsitory = memberRepsitory;  
}
```

위의 코드는 외부에서 주입받지 구현체에 의존하거나 절대 그러지 않는다.


## AppConfig
``` java

package hello.core;  
  
import hello.core.discount.FixDiscountPolicy;  
import hello.core.member.MemberService;  
import hello.core.member.MemberServiceImpl;  
import hello.core.member.MemoryMemberRepository;  
import hello.core.order.OrderService;  
import hello.core.order.OrderServiceImpl;  
  
  
//appliction환경 구성은 여기서 다 하는 거임  
public class Appconfig {  
    public MemberService memberService(){  
        return new MemberServiceImpl(new MemoryMemberRepository());  
    }  
  
    public OrderService orderService(){  
        return new OrderServiceImpl(new MemoryMemberRepository(), new FixDiscountPolicy());  
    }  
  
  
  
  
}
```

실제로 구현체를 작성하는 부분은 AppConfig에 있다.


java는 위와 같은 방법을 사용해서  SOLID원칙을 지킨다.

즉 
1. 서비스의 역할이 될 Interface생성 - ISP
2. 역할에 맞는 구현체들 생성 - SRP
3. 각 구현체를 필요로 하는 클라이언트(MemberService같은 곳)에서는 구현체가 아닌 Interface에 의존하도록 함 - DIP, OCP

LSP 리스코프 치환원칙은 각 역할에 맞는 구현체를 생성해야됨
만약에 
앞으로 달리는 기능인데 어떤 구현체에서는 뒤로 달리는 기능으로 바꿔버리면 안된다!

