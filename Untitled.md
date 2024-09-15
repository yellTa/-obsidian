---
created: 2024-09-15T21:43
updated: 2024-09-15T21:47
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