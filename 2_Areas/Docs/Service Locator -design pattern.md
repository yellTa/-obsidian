---
created: 2024-09-17 23:24
updated: 2024-09-18T00:14
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

# 결론

# REVIEW


---
# 참고

# 연결문서