---
created: 2024-09-12 15:33
updated: 2024-09-12T20:20
tags:
  - develop
  - SOLID
Progress:
  - ongoing
post할까?: false
post됨: false
---
# SOLID원칙
## SRP(Single Responsibility Principle)
- 클래스는 단 하나의 책임(기능)만 가져야 한다.
- 하나의 클래스는 하나의 기능을 담당하여 하나의 책임을 수행한다.


## OCP(Open Closed Princlple)
- 확장은 열려있고 수정에는 닫혀있어야 한다.
- 클래스를 확장을 통해 손쉽게 구현하면서, 확장에 따른 클래스 수정은 최소화한다.

스프링은 해당 원칙을 지키기 위해서 Spring Container를 사용한다.


## LSP(Liskov Substitution Principle)
- 서브 타입은 언제나 기반(부모) 타입으로 교체할 수 있어야 한다.
- 다형성 원리를 이용하기 위한 원칙이다.

## ISP(Interface Segregation Principle)
- 인터페이스를 각각 사용에 맞게 잘게 분리하는 것
- SRP가 클래스의 단일 책임 원칙을 강조하면, ISP는 인터페이스의 단일 책임 원칙을 강조한다.
- 사용하는 클라이언트를 기준으로 분리해, 클라이언트의 목적과 용도에 적합한 인터페이스를 제공하는 것

## DIP(Dependency Inversion Principle)
- 어떤 클래스를 참조해서 사용해야하는 상황이 생기면, 그 Class를 직접 참조하는 것이 아니라 상위 요소인 추상 클래스, 인터페이스로 참조하는 것
- 즉 구현에 의존하지 않고 인터페이스에 의존하라는 뜻이다.


---
간략하게 SOLID를 알아보았으니 구현해보자!

# 요구사항
주문 시스템을 만들어보자(근데 진짜 주문 가격만 보여주는 시스템임)
## 필요기능
- 주문기능
- 결제기능
## SRP지키기
단 하나의 역할 자기만의 역할을 수행하는 클래스를 만들자

### CreditCardPayment

``` java
public class CreditCardPayment implements PaymentMethod{  
    @Override  
    public void processPayment(double amount) {  
        System.out.println("카드 결제 되었읍니다 + "+ amount);  
    }  
}
```
인터페이스를 implements한 이유는 조금 나중에 알아보자!


### OrderService
``` java
public class OrderService {  
  
    private final PaymentMethod paymentMethod;  
  
    //외부에서 주입받기  
    public OrderService(PaymentMethod paymentMethod){  
        this.paymentMethod = paymentMethod;  
    }  
  
    public void placeOrder(double amount){  
        System.out.println("주문되었다" + amount);  
        paymentMethod.processPayment(amount);  
    }  
  
}

```


CreditCardPayment -> 카드로 결제가 되고 결제 금액을 뿌려줌
OrderService -> 고객이 주문을 수행함, 주문하고 결제 서비스를 이용해 결제함(CreditCardPayment)



## OCP지키기 
``` java
public interface PaymentMethod {  
    void processPayment(double amount);  
  
}
```
PaymentMethod를 사용해 인터페이스를 생성했다.

```java
public class CreditCardPayment implements PaymentMethod{  
    @Override  
    public void processPayment(double amount) {  
        System.out.println("카드 결제 되었읍니다 + "+ amount);  
    }  
}
```
CreditCardPayment는 PayMentMethod를 Implement해서 생성된다. 

확장에는 열려있게 된다.

즉 PaymentMethod를 이용해서 Credit카드, 혹은 PointPayment 등 다양한 결제 시스템을 구현할 수 있다.
이때 interface를 상속 받는 클래스는 processPayment 메소드를 필수로 구현해야하는데 이는 변경에는 닫혀있다는 것을 의미한다.(무조건 구현해야하는 사항이니까 최소로 가지고 있어야 되는 거임 변하지 않는 기능)

## LSP지키기




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
