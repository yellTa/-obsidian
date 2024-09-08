---
created: 2024-09-08 19:01
updated: 2024-09-08T20:34
tags:
  - java
  - cpp
출처: 
---
# 제네릭이란?

``` java
ArrayList<Integer> list1 = new ArrayList<Integer>();
ArrayList<String> list2 = new ArrayList<Integer>();
 
LinkedList<Double> list3 = new LinkedList<Double>():
LinkedList<Character> list4 = new LinkedList<Character>();
```

<>안에 있는게 제네릭스다.

메서드나 컬렉션 클래스에 컴파일 시 타입 채크를 해주는 기능이다. 
객체의 타입을 컴파일 시에 체크하기 대문에 객체의 타입 안정성을 높이고 형변환의 번거로움이 줄어든다.

## 제네릭의 장점
1. 타입 안정성을 제공한다.
2. 타입 체크와 형변환을 생략할  수 있으므로 코드가 간결해진다.

즉 다룰 객체의 타입을 미리 명시해서 번거로운 형 변환을 줄여준다.


## 제네릭스가 컴파일 될 때 처리되는 과정
- 타입 소거를 수행하여 제네릭 타입의 정보를 지우고ㅓ, 그 자리에 Object 또는 조건에 맞는 특정 타입을 사용한다.


``` java
public class Box<T> {
    private T item;

    public void setItem(T item) {
        this.item = item;
    }

    public T getItem() {
        return item;
    }
}

```

```java
Box<String> stringBox = new Box<>();
stringBox.setItem("Hello");
String str = stringBox.getItem();

```
컴파일 시 위의 Box 클래스에서 제네릭 타입 T는 String형태로 치환된다. 
실행 시점에는 타입의 정보가 소거된다. 이를 타입 소거라고 한다.

## 타입 소거?
컴파일 후 타입 소거로 인해 삭제된다.

즉, 런타임 시에는 제네릭스가 존재하는 않고, 대신 Object로 처리되거나 해당 제약에 맞는 상위 타입으로 변환된다.

```java
//컴파일된 코드
public class Box {
    private Object item;

    public void setItem(Object item) {
        this.item = item;
    }

    public Object getItem() {
        return item;
    }
}

```



# 결론

# REVIEW


---
# 참고

# 연결문서