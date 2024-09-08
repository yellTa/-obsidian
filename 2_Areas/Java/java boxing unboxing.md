---
created: 2024-09-08 17:56
updated: 2024-09-08T18:24
tags:
  - java
출처: 
---
# boxing과 unboxing의 개념
Boxing과 Unboxing은 기본 타입과 참조 타입 간의 변환 과정을 의미한다. 

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






# 결론

# REVIEW


---
# 참고
https://f-lab.kr/insight/understanding-java-boxing-and-unboxing

# 연결문서