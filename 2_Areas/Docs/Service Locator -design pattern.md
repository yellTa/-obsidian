---
created: 2024-09-17 23:24
updated: 2024-09-18T00:47
tags: 
출처: 
---
# Service Locator
안티패턴이다 안티패턴

Service Locator의 문제는 클래스의 의존성을 숨겨 컴파일에러가 아닌 런타임 에러가 나게 만든다는 것이다. 

## Service Locator를 사용했을 때 문제점
 - 클래스가 어떤 의존성을 사용하는지 코드상에서 명확하게 보이지 않는다.
   의존성을 외부에서 주입받는 것이 아니라, 클래스 안에서 서비스 로케이터를 통해 피요할때 직접 요청한다. 이때문에 어떤 객체가 필요로 하는 다른 객체(의존성)이 무엇인지 코드만 보고 알 수 없다.

# Service Locator를 구현해보자
## 요구사항
주문처리 서비스는 주문이 유효하면 주문을 배송한다.

### IOrderProcessor(Interface)주문 처리
```java
package hello.core.serviceLocator;  
  
public interface IOrderProcessor {  
    void process(Order order);  
  
  
}
```

### OrderProcessor
``` java
package hello.core.serviceLocator;  
  
public class OrderProcessor implements IOrderProcessor {  
    @Override  
    public void process(Order order) {  
        //주문이 맞는지 체크하고 보내준다고 가정하자  
        //이러면 에러가 난다.  
  
  
        //resolve를 통해서 동적으로 의존성을 해결한다.  
        //아래의 코드는 IOrderValidator클래스에 해당하는 서비스를 찾는 메소드이다.  
        IOrderValidator validator = Locator.resolve(IOrderValidator.class);  
  
        if (validator.validate(order)) {// 주문이 유효한 경우(다 유효하게 일단 짜놓음)  
  
            //IOrderShipper에 해당하는 서비스 객체를 Locator를 이용해 뽑아온다.  
            IOrderShipper shipper = Locator.resolve(IOrderShipper.class);  
            shipper.ship(order);  
        }  
    }  
}
```

주문을 처리하는 로직이다. 
주문이 맞는지 IOrderValidator를 통해 확인하고 주문이 유효한 주문이면 IOrderShipper를 통해서 주문을 배송한다.

>[!information]
>편의상 IOrderService의 인터페이스를 만들지 않고 무조건 true를 리턴하도록 설계했다. 
>마찬가지로 IOrderShipper는 ship메소드를 사용하면 배송한다는 문자열을 리턴하도록 설계했다.


### Locator설정
``` java
package hello.core.serviceLocator;  
  
import java.util.HashMap;  
import java.util.Map;  
import java.util.function.Supplier;  
  
public class Locator {  
    private static final Map<Class<?>, Supplier<?>> services = new HashMap<>();  
  
    // 서비스 등록  
    public static <T> void register(Class<T> type, Supplier<T> resolver) {  
        services.put(type, resolver);  
        //미리 등록된 서비스를 HashMap에서 찾아서 반환한다.  
        //객체를 요청할 때마다 Supplier가 등록된 로직에 따라 객체를 생성해 의존성을  
        //동적으로 해결하는 방식이다.  
        //이 방식으로 여러 클래스의 인스턴스를 상황에 맞게 생성할 수 있다.  
    }  
  
    // 서비스 해제  
    @SuppressWarnings("unchecked")  
    public static <T> T resolve(Class<T> type){  
        /*resolve 메서드는 호출할 때 원하는 클래스 타입을 인자로 받아서 return함*/  
        //Services 맵에서 해당 타입의 Supplier<?> 객체를 찾는다.  
        Supplier<?> supplier = services.get(type);  
        //만약에 null이 아니다?  
        if (supplier != null) {  
            //supplier에서 객체를 return            //여러개 등록된 경우 가장 마지막으로 등록된 서비스를 반환한다.  
            //HashMap이라서 마지막으로 등록된 상태를 먼저씀 왜냐? Map형태니까  
            //ex) OrderService : A -> put이 됨  
            // OrderServie : B - > A가 B로 바뀜  
            // OrderService를 리턴할땐 B서비스로 리턴함  
            return (T) supplier.get();  
        }  
        //null이면 맞는 서비스를 찾아서 return할 수 없음 에러발생  
        throw new IllegalArgumentException("Service not registered: " + type.getName());  
    }  
  
    // 모든 서비스 초기화  
    public static void reset() {  
        services.clear();  
    }  
}
```

객체를 동적으로 주입해주는 Locator를 만들었다. 각 기능에 대한 설명은 주석으로 자세히 달아놨으니 SKIP


### OrderApp을 통해서 확인해보기
```  java
public class OrderApp {  
    public static void main(String[] args) {  
  
        // 필요한 서비스 등록  
        //서비스릉 등록하지 않으면 Locator 맵에 저장된 서비스가 없어서 에러가 남  
        //왜? 해당하는 객체에 맞는 서비스를 리턴할 수 없으니까  
//        Locator.register(IOrderValidator.class, () -> new IOrderValidator());  
//        Locator.register(IOrderShipper.class, () -> new IOrderShipper());  
  
        Order order = new Order(1, "오오오",1234);  
        OrderProcessor orderProcessor = new OrderProcessor();  
  
        orderProcessor.process(order);  
    }  
}
```

OrderApp을 실행하면 에러가난다.
그 이유는 객체에 맞는 서비스를 리턴할 수 없기 때문이다.

주석을 해제하면? 에러가 나지 않는다.
필요한 서비스를 Locator에 등록했기 때문이다!

## 무한 메소드
``` java
public class Main {
    public static void main(String[] args) {
        Locator serviceLocator = new Locator();

        // 서비스 등록
        serviceLocator.register(IFoo.class, Foo::new);
        serviceLocator.register(IBar.class, Bar::new);
        serviceLocator.register(IBaz.class, Baz::new);

        // 서비스 생성 및 사용
        IFoo foo = serviceLocator.resolve(IFoo.class);
        IBar bar = serviceLocator.resolve(IBar.class);
        IBaz baz = serviceLocator.resolve(IBaz.class);

        foo.doSomething();
        bar.doSomethingElse();
        baz.performAction();
    }
}

// 예시 인터페이스 및 클래스들
interface IFoo {
    void doSomething();
}

class Foo implements IFoo {
    public void doSomething() {
        System.out.println("Foo is doing something");
    }
}

interface IBar {
    void doSomethingElse();
}

class Bar implements IBar {
    public void doSomethingElse() {
        System.out.println("Bar is doing something else");
    }
}

interface IBaz {
    void performAction();
}

class Baz implements IBaz {
    public void performAction() {
        System.out.println("Baz is performing an action");
    }
}

```

예제 코드를 보자





## Service Locator의 문제점
### 캡슐화 위반
클래스 내부에서 필요한 서비스나 의존성을 동적으로 조회하여 사용한다. 이를 위해 Locator.resolve()를 사용해 필요한 객체를 얻었다.

코드가 특정 위치에서 Locator를 사용해 의존성을 해결하기 때문에, 의존성이 명시적으로 드러나지 않고 코드 내에서 숨김 쳐리된다.
```java 
IOrderValidator validator = Locator.resolve(IOrderValidator.class);  
//위는 특정 위치에서 의존성을 Locator로 주입받고 있다. 여기서 IOrderValidator는 추상클래스라고 가정한다.
  
if (validator.validate(order)) { 
  
    IOrderShipper shipper = Locator.resolve(IOrderShipper.class);  
    shipper.ship(order);  
}
```

의존성이 생성자나 필드에서  명확하게 나타나지 않아 유지보수가 어려워진다.
즉 해당 추상클래스에 대해서 어떤 객체를 리턴해야하는지 개발자가 정확히 알 수가 없다는 의미이다. 

이는 DI 의존성을 외부에서 주입받는 것 과는 반대이다. 
DI는 Spring Container에서 객체의 의존성을 주입해 클래스는 자신의 의존성에 대해 알지 않고, 오직 인터페이스나 추상화에만 의존한다.
# 결론
서비스 Locator는 DI를 지키지 못하는 안티패턴이다.
- 추상클래스가 가르키는 객체를 명확하게 개발자가 알 수 없다.
- 의존성을 특정 위치에서 주입받기 때문에 유지보수가 힘들다
# REVIEW
하나하나 뜯어보는게 생각보다 재미가 있었네요


---
# 참고
https://blog.ploeh.dk/2010/02/03/ServiceLocatorisanAnti-Pattern/
https://blog.ploeh.dk/2014/05/15/service-locator-violates-solid/

# 연결문서
