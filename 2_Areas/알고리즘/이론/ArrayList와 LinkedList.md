---
created: 2024-08-16T13:28
updated: 2024-08-16T13:43
---

# ArrayList와 LinkedList의 차이
![[Pasted image 20240816132943.png]]
첫 번째는 ArrayList이고 두 번째가 LinkedList이다.

## ArrayList의 특징
- 메모리에 연속으로 할당되어 있다. 
- 사이즈를 선언하지 않아도 된다.(배열과 다른점)

## LinkedList의 특징
- 연결리스트로 구현이 되어있다.
- 각각 다른 위치에 존재한다. 노드가 존재해서 이전 노드, 다음 노드에대한 포인터를 가지고 있다.


## 삽입, 삭제 연산의 차이
![[Pasted image 20240816133601.png]]
ArrayList의 연산방식이다. 

## ArrayList
### 삽입과 삭제
ArrayList는 배열과 같다고 했기 때문에 중간이나 앞쪽에 연산이 들어가면 O(N)의 연산이 발생하게 된다.
위 그림처럼 <span style="color:rgb(255, 128, 128)">새로운 공간을 끼워넣기 위해서 새롭게 할당 후 저장</span>해야하기 때문이다. 

반대로 맨 끝을 지운다던가, 맨 끝에 값을 넣는 것은 딱히 새로운 공간을 만들 필요가 없기 떄문에 O(1)이다. 
### 조회
배열의 큰 특징은 바로 메모리에 저장된 값을 빠르게 불러올 수 있는 것이다.
마찬가지로 <span style="color:rgb(255, 128, 128)">ArrayList또한 메모리에 저장된 값을 빠르게 불러올 수 있다. O(1)의 연산</span>

## LinkedList


### 삽입과 삭제
LinkedList는 노드로 이루어져 있다.




---
# 참고
[자바 컬렉션](https://minhamina.tistory.com/14)
# 연결문서
