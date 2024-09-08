---
created: 2024-09-08 17:56
updated: 2024-09-08T19:07
tags:
  - java
출처: 
---
# boxing과 unboxing의 개념
Boxing과 Unboxing은 기본 타입과 참조 타입 간의  
## Boxing
기본타입의 데이터(primitve type) -> 참조타입으로

## Unboxing
참조타입의 데이터(Reference type) -> 기본타입으로

---
기본타입은 Stack메모리 참조타입은 Heap 메모리에 저장된다. 

즉
## boxing 은 Stack의 데이터를 heap으로

## unboxing은 Heap의 데이터를 Stack으로
옮기는 과정이 이루어진다. 

# Boxing과 Unboxing의 사용 예시
`ArrayList<int>`는 없다.
`ArrayList<Integer>`만 가능하다.
이처럼 컬렉션 프레임워크가 참조자료형만 저장할 수 있기 때문에 primitive type을 Reference타입으로 변환해야 한다.

즉 ArrayList에 int 를 넣으려면 Integer같은 wrapper클래스를 사용하는 것이다. 

반대로 컬렉션에서 데이터를 꺼내 사용할 때는 Unboxing을 거쳐 기본 타입으로 변환해야 한다.
하지만 명시적으로 작성해야 할 때도 있다.


박싱 언박싱은 AutoBoxing과 AutoUnboxing의 기능을 통해서 간소화될 수 있다. 
이 기능은 컴파일러가 자동으로 기본 타입과 참조 타입간의 변환 코드를 삽입해주는 기능이다.


# Boxing과 Unboxing이 빈번하게 일어나는 경우
- Boxing과 Unboxing이 일어나는 과정에서 추가적인 객체 생성과 메모리 할당이 발생하게 된다. 
- 빈번한 Boxing Unboxing이 일어나는 경우 성능저하가  일어날 수 있다.
- 성능이 중요한 애플리케이션에서는 이런 과정을 최소화하는 것이 좋다.

## 예시
- 반복문 안에서 Integer같은 래퍼 클래스 대신 int같은 기본 타입을 사용한다.


# Boxing과 Unboxing의 최적화 방안
## 기본 타입을 사용해 불필요한 객체 생성 피하기
## 컬렉션 프레임워크를 사용할 때 기본 타입 전용 컬렉션 라이브러리 활용하기
기본타입을 직접 관리해 Boxing Unboxing 과정없이 성능을 향상 시킨다. 대신 라이브러리를 사용해야한다.
## 코드 최적화
루프안에서 반복적으로 박싱 언박싱이 일어날 수 있다.

``` java
List<Integer> list = new ArrayList<>();
for (int i = 0; i < 1000; i++) {
    list.add(i); // 박싱 발생
}

```

```java
IntStream.range(0, 1000).forEach(list::add); // 박싱/언박싱 없음

```


## 캐싱을 통한 최적화

``` java
Integer a = 100;
Integer b = 100;

System.out.println(a == b);  // true (같은 객체)

```

``` java
Integer a = 1000;
Integer b = 1000;
//Integer의 범위가 -128에서 127을 넘겨서 캐싱된 데이터 안쓰고 다른데이터 써서 그럼
System.out.println(a == b);  // false (서로 다른 객체)

```


java에서 Integer같은 래퍼 클래스는 캐싱을 사용한다.
특정 범위 내의 값을 재사용하도록 설계되어 있다. 이 범위는 -128~ 127의 정수 값이다. 

이 범위 안의 값을 자주 사용되기 때문에, 이런 값들을 미리 캐싱해서 새로운 객체를 생성하는 대신, 동일한 객체를 재사용한다.

이를 통해 메모리 사용량을 줄인다.


# 결론
기본 타입과 참조 타입 간의 변환을 쉽게 할 수 있지만 성능적인 측면에서 주의를 요한다.
- Boxing UnBoxing이 성능에 미치는 영향을 이해하고 효율적인 메모리 사용과 높은 성능의 애플리케이션 개발이 가능해짐
- Boxing과 Unboxing의 최적화 방안에는
  1. 기본 타입을 이용하기
  2. 기본타입 전용 컬렉션프레임워크 라이브러리 사용하기
  3. 루프안에서 박싱 언박싱이 많이 일어나면 Stream을 대신 사용하는 방안으로 생각해보기
  4. 캐싱 기법 사용해보기


# 참고
https://f-lab.kr/insight/understanding-java-boxing-and-unboxing

# 연결문서