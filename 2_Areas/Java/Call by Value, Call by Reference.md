---
created: 2024-09-07 18:21
updated: 2024-09-08T01:52
tags:
  - java
  - study
출처: 
---
# Call by Value(값에 의한 호출)
- 값을 복사하여 처리한다.
- 변수의 복사본이 전달되며, 원래 값이 수정되지 않는다.
- 실제 인수는 다른 메모리 위치에 생성된다.
# Call by Reference(참조에 의한 호출)
- 값의 주소를 참조하여 직접 값에 영향을 준다.
- 변수 자체가 전달되며, 원래 값이 수정된다.
- 실제 인수는 같은 메모리 위치에 생성된다.

# 자바의 Call by Value 동작 방식
## 원시 타입 (Primitive type)
- Numeric Type(byte, short, int, float, long, double, char), Boolean
## 참조타입(reference type)
- Class Type, Interface, Array, Enum, 기타등등(String포함)

```java
public class CallByExampleTest {  
    @Test  
    void primitiveTest(){  
        int v = 10;  
  
        add(v);  
  
        assertThat(v).isEqualTo(10);  
    }  
    void add(int num){  
        num++;  
    }  
}
```

![[Pasted image 20240908015058.png]]
자바에서 변수를 선언하면 Stack메모리 영역에 할당한다.

Stack 영역안에서 PrimitiveTest메소드와 add 메소드의 영역이 따로 나뉘어져있고 변수도 각가 존재한다.
따라서 <span style="color:rgb(255, 128, 128)">원시타입의 전달은 값을 복사해서 전달하는 Call by Value 방식으로 동작한다.</span>


# 참조 타입 (reference type)전달 방식
변수는 stack에 있지만 객체는 Heap 영역에 위치한다. 
Stack에 있는 변수가 Heap영역에 있는 객체를 바라보고 있는 것이다.







# 결론

# REVIEW


---
# 참고
https://dev-coco.tistory.com/189

https://bcp0109.tistory.com/360

# 연결문서