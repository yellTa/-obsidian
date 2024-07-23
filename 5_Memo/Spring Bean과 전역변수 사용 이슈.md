---
created: 2024-07-23 01:52
updated: 2024-07-23T01:59
tags:
  - study
  - Spring
  - develop
출처:
  - chatgpt
---
# Subject/Object 
Spring Bean으로 등록되면 전역변수 사용은 동시성 issue를 갖는다.
# 나의 생각
## 근거
싱글톤으로 객체를 관리하기 때문에 하나의 자원에 두 개의 사용자가 데이터를 요청할 수 있다. 즉 A가 자원 S를 쓰고 B도 자원 S를 사용할 수 있다는 뜻이다. 이런경우 데이터가 서로 같은 값을 사용하기 때문에 의도하지 않은 값을 return할 확률이 크다.

## 결론
해당 위험을 제거하기 위해서는 아래의 방법을 사용하면 된다.
### 1. `@Scope` 어노테이션 사용

빈의 범위를 변경하여 스레드 간에 인스턴스를 공유하지 않도록 할 수 있습니다. 예를 들어, `prototype` 범위를 사용하면 각 요청마다 새로운 빈 인스턴스가 생성됩니다.

```
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope("prototype")
public class PrototypeBean {
    private String value;

    // Getter and Setter
}

```

### 2. `@RequestScope` 또는 `@SessionScope` 사용

웹 애플리케이션에서는 요청(request) 또는 세션(session)마다 빈을 생성할 수 있습니다.

```
import org.springframework.web.context.annotation.RequestScope;
import org.springframework.stereotype.Component;

@Component
@RequestScope
public class RequestScopedBean {
    private String value;

    // Getter and Setter
}

```

### 3. 스레드 로컬(ThreadLocal) 사용

`ThreadLocal`을 사용하면 각 스레드마다 별도의 변수를 가질 수 있습니다. 이는 스레드 안전한 변수를 제공하므로 전역 변수 사용에 따른 동시성 문제를 해결할 수 있습니다.

```
public class ThreadLocalExample {
    private static final ThreadLocal<String> threadLocalValue = new ThreadLocal<>();

    public void setValue(String value) {
        threadLocalValue.set(value);
    }

    public String getValue() {
        return threadLocalValue.get();
    }
}

```

### 4. 지역 변수 사용

이미 알고 계신 방법으로, 메서드 내부에서만 변수를 사용하는 방식입니다. 이는 기본적으로 스레드 안전성을 보장합니다.

### 5. 상태 없는 빈 사용

빈을 상태 없이(stateless) 설계합니다. 즉, 모든 메서드가 인스턴스 변수를 사용하지 않도록 합니다. 이를 통해 동시성 문제를 피할 수 있습니다.
```
@Component
public class StatelessService {
    public String process(String input) {
        return "Processed: " + input;
    }
}

```

### 6. 빈 초기화 시 필요한 객체를 주입

각 메서드 호출 시 필요한 객체를 파라미터로 전달하거나, 메서드 호출 시 새로운 객체를 생성하여 사용합니다.

```
@Component
public class SomeService {

    public void process() {
        Helper helper = new Helper();
        helper.doSomething();
    }

    private static class Helper {
        public void doSomething() {
            // 작업 수행
        }
    }
}

```
### 예제: 프로토타입 빈을 주입받는 싱글톤 빈

싱글톤 빈이 프로토타입 빈을 필요로 할 때, 프로토타입 빈을 주입받아 사용하는 방법을 소개합니다.

#### 1. `@Lookup` 어노테이션 사용

```
@Component
public class SingletonService {
    
    @Lookup
    public PrototypeBean getPrototypeBean() {
        // Spring이 이 메서드를 오버라이드하여 프로토타입 빈을 반환합니다.
        return null;
    }

    public void execute() {
        PrototypeBean prototypeBean = getPrototypeBean();
        prototypeBean.setValue("value");
        // 비즈니스 로직 수행
    }
}

```
#### 2. `ObjectProvider` 사용

```
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SingletonService {
    
    @Autowired
    private ObjectProvider<PrototypeBean> prototypeBeanProvider;

    public void execute() {
        PrototypeBean prototypeBean = prototypeBeanProvider.getObject();
        prototypeBean.setValue("value");
        // 비즈니스 로직 수행
    }
}

```

### 결론

전역 변수로 인해 발생할 수 있는 동시성 문제를 해결하기 위해 다양한 방법을 사용할 수 있습니다. 스프링 빈의 범위를 변경하거나, `ThreadLocal`을 사용하는 등 상황에 맞는 적절한 방법을 선택하여 전역 변수 이슈를 해결할 수 있습니다.

# 참고 문헌
chat gpt
# 연결 문서

