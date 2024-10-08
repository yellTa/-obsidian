---
created: 2024-08-29T18:09
updated: 2024-08-30T00:29
---


# Heap자료구조
추가 삭제가 빈번한 동적인 자료에서 최대값/최소값을 빠르게 찾기 위해 고안된 <span style="color:rgb(255, 128, 128)">완전이진트리</span> 

## 최대힙과 최소힙
루트 노드가 가장 큰 값
![[Pasted image 20240829181329.png]]

값을 뽑아내는건 O(1) 
값을 넣을때 마다 정렬이 되기 때문에 값을 넣을 떄 O(logN)연산이 발생한다.

최소힙은 최대힙의 반대 즉 root가 가장 큰 값으로 정렬되는 현상을 말한다.
#### heap인덱스의 규칙
![[Pasted image 20240829182605.png]]

자식의 노드 = `(왼쪽 자식)부모의 노드*2`,` (오른쪽 자식) 부모의 노드 *2+1`
부모의 노드  = `왼쪽자식/2`, `오른쪽자식/2`

위와 같은 규칙을 가지게 된다.
## 최대힙에 값이 삽이되는 과정
![[Pasted image 20240829181706.png]]
위와 같은 힙이 있다고 가정하자. 빨간색은 인덱스의 번호이다.

heap의 0번 인덱스는 무한대의 값이 들어가게 된다. 
그리고 우리는 저 heap에 20이라는 숫자를 넣을 예정이다.

### 1. 말단에 값을 넣기
![[Pasted image 20240829181944.png]]
힙에서 숫자는 가장 말단에 들어가게 된다. 
20이라는 숫자가 추가되었다. heap이 사용하는 index는 7까지 늘어났고 값은 20이 되었다. 


### 2. 힙 정렬하기 (upHeap)
말단에 값을 넣었으면 정렬하는 넣은<span style="color:rgb(255, 128, 128)"> </span>값이 최적의 장소를 찾아가는 과정이 필요하다. 

![[Pasted image 20240829182228.png]]

20의 부모 12와 비교를 해보자.
부모의 노드< 들어간 말단의 노드 값 인 현상이다. 
그렇다면 우리는 부모와 삽입한 값의 위치를 변경해주면 된다.


![[Pasted image 20240829182935.png]]

위와 과정에서 삽인한 위치를 변경했다. 이때 tmp의 값에 20이라는 값을 넣어주고 3번 부모의 값을 7번으로 내려 끌어와주면 된다. 

그 후 다시 3번 자식과 1번 부모를 비교할 예정이기 때문에 부모의 자식의 인덱스 기준은

자식 : 7->3(7/2)
부모: 3->1(3/2)

이렇게 변하게 된다. 

즉 처음에 7번 인덱스 총 heap배열의 size에서부터 시작해서 size/2 size/2/2 size/2/2/2... 이런식으로 0이 될 때까지 이동해주면 된다. 

![[Pasted image 20240829183257.png]]

이때 0번 인덱스까지 도달하게 되면 무조건 tmp가 1번 0번의 자식이라고 임시로 생각해도 좋다. 
1번의 위치하게 되면서 종료하게 되는 것이다.

즉 종료의 조건은

`heap[부모노드] > tmp`일때 종료하게 되는 것
이때 자식노드와 부모노의 관계는
자식노드 : pos
부모노드 :pos/2  가 된다. 
## 코드로 확인하기

```java
  public void insert(int num){  
    heap[++size] = num;//말단에 값넣기  
    upHeap(size);//말단의 값 보내기  
  
}

public void upHeap(int pos){//현재 위치  처음은 말단으로 옴
    int tmp = heap[pos];  //임시 저장소에 저장
  
    while(heap[pos/2]< tmp){//부모가 tmp보다 작으면 바꿀거임  
        heap[pos] = heap[pos/2]; //부모를 자식위치로 내려줌  
        //다음 부모의 위치를 설정한다.
        pos = pos/2;  //한 계층 더 올라가기 위한 작업
        
    }  
    heap[pos] =tmp;  
}
```
insert가 되는 순간 heap의 사이즈가 증가하고 말단의 인덱스와 함께 upHeap로직이 시작된다.

즉 부모의 위치를 기준으로 tmp와 비교하면서 upHeap을 수행한다. 


## 힙에서 값 빼기
이제 값이 들어갈때 정렬이 되는 것은 알았다. 그렇다면 어떻게 값을 뺄때 어떤 식으로 정렬이 되는 걸까?

### 말단의 값을 최상단으로 옮겨주기
![[Pasted image 20240829234144.png]]

위의 구조에서 20을 뺀다고 가정해보자 

![[Pasted image 20240829234304.png]]

우선 말단의 값을 copy해온다. 그리고 값 하나를 제거했으니 size --을 수행해준다. 최종적인 결과는 

![[Pasted image 20240829234406.png]]

위 그림 처럼된다. 그렇다면 downHeap과정으로 넘어간다.

### downHeap수행하기
![[Pasted image 20240829234557.png]]

pos가 1인 경우 
pos의 자식들은 왼쪽, 오른쪽으로 나뉘게 되는데 이때 index의 값이

child (왼) = pos*2
child(오) = pos*2+1이 된다.

두 자식 중에서 가장 큰 값과 부모의 값을 비교하면 된다. 
위의 그림 경우에서는 10<15이니 15와 12를 비교해주면 된다.

![[Pasted image 20240829235016.png]]
위에서 결정한 child(child중에서 큰 값)을 지정하고 `heap[pos]`와 비교한다.
이때 pos에 위치한 값이 더 작다면 child와 위치를 바꿔준다.
부모 위치와 자식의 위치를 바꾼다고 생각하면 된다. 

그리고 다음 위치는 child의 위치가된다. 이번엔 child가 부모가 되어서 child 아래의 자식들과 또 비교를 해야한다는 뜻이다. 이걸 반복하면 된다.

여기서 문제가 하나 발생하는데 
child의 범위이다. 

![[Pasted image 20240829235753.png]]

위 그림에서 pos가 3일때 child는 6,7이 된다. 하지만 7은 없는 상황

이럴 땐 child 두 개를 비교하면 안된다.

즉 child의 범위가 size보다 작거나 같아야하는 경우이다. 
만약에 크게 되는 순간 위 그림처럼 에러가 발생한다.

## 코드
지금까지 작성한 주의사항을 토대로 값을 꺼내는 get메서드와 DownHeap을 구현해보자

```java
public void downHeap(int pos){//제일 위의 상단의 값  
    int tmp = heap[pos];//최 상단의 값 넣어줌  
     while(pos/2<=size){// 끝점의 outof bounds에러를 방지하기 위함  
         int child = pos*2;  
         if(child<size && heap[child]< heap[child+1])child++;  
         if(heap[pos]> heap[child])break;  
         heap[pos] = heap[child];  
         pos = child;  
     }  
     heap[pos] = tmp;  
}  
  
  
public int get(){//  
    //맨 앞단의 값을 빼고 정렬하기  
    if(size >=1){  
        int result = heap[1];  
        heap[1] = heap[size--];//말단을 1로 옮겨주고 size-1해주기  
        downHeap(1);  
        return result;  
    }else return -1;  
}
```


# 최종코드 
```java
public class MaxHeap{  
    public int[] heap;  
    public int size;  
  
    public MaxHeap(int length){  
        heap = new int[length];  
        heap[0] = 1000000000;  
        size = 0;  
    }  
  
    public void upHeap(int pos){//현재 위치  
        int tmp = heap[pos];  
  
        while(heap[pos/2]< tmp){//브모가 tmp보다 작으면 바꿀거임  
            heap[pos] = heap[pos/2]; //부모를 자식위치로 내려줌  
            pos = pos/2;  
        }  
        heap[pos] =tmp;  
    }  
  
  
    public void insert(int num){  
        heap[++size] = num;//말단에 값넣기  
        upHeap(size);//말단의 값 보내기  
  
    }  
    public void downHeap(int pos){//제일 위의 상단의 값  
        int tmp = heap[pos];//최 상단의 값 넣어줌  
         while(pos/2<=size){// 끝점의 outof bounds에러를 방지하기 위함  
             int child = pos*2;  
             if(child<size && heap[child]< heap[child+1])child++;  
             if(heap[pos]> heap[child])break;  
             heap[pos] = heap[child];  
             pos = child;  
         }  
         heap[pos] = tmp;  
    }  
  
  
    public int get(){//  
        //맨 앞단의 값을 빼고 정렬하기  
        if(size >=1){  
            int result = heap[1];  
            heap[1] = heap[size--];//말단을 1로 옮겨주고 size-1해주기  
            downHeap(1);  
            return result;  
        }else return -1;  
    }  
  
    public static void main(String[] args) {  
        MaxHeap mh = new MaxHeap(100);  
        mh.insert(10);  
        mh.insert(5);  
        mh.insert(8);  
        mh.insert(15);  
        mh.insert(3);  
        mh.insert(12);  
  
        for(int i = 1; i <= mh.size; i++){  
            System.out.print(mh.heap[i] + " ");  
        }  
        System.out.println();  
  
        mh.insert(20);  
        for(int i = 1; i <= mh.size; i++){  
            System.out.print(mh.heap[i] + " ");  
        }  
        System.out.println();  
        System.out.println(mh.get());  
        for(int i = 1; i <= mh.size; i++){  
            System.out.print(mh.heap[i] + " ");  
        }  
        System.out.println();  
        System.out.println("asdf");  
    }  
}
```



위와 같은 코드가 나오게 된다. 

MinHeap도 같은 방식으로 작성하면 된다.

```java
public class MinHeap {  
    public int[] heap;  
    public int size;  
  
  
    public MinHeap(int len){  
        this.heap = new int[len];  
        this.size = 0;  
        this.heap[0] = -100000000;  
    }  
  
    public void downHeap(int pos){  
        int tmp = heap[pos];  
  
        while(pos*2<=size){//부노까지 구하기  
            int child = pos*2;  
            if(child<size && heap[child]> heap[child+1])child++;  
            if(tmp<heap[child])break;  
            heap[pos] = heap[child];  
            pos = child;  
        }  
        heap[pos] =tmp;  
    }  
  
    public int get(){  
        if(size<1)return 10000000;  
  
        int result = heap[1];  
  
        heap[1] = heap[size--];//말단의 값을 제일 위로  
        downHeap(1);  
        return result;  
    }  
    public void upHeap(int pos){//제일 작은 값을 위로 올려야됨  
        int tmp = heap[pos];  
        while(heap[pos/2] >tmp){//값이 부모보다 크면 stop            heap[pos] = heap[pos/2];  
            pos = pos/2;  
        }  
        heap[pos] = tmp;  
    }  
    public void insert(int x){  
        heap[++size] = x;  
        upHeap(size);  
    }  
  
    public static void main(String[] args) {  
        MinHeap mh = new MinHeap(100);  
        mh.insert(10);  
        mh.insert(5);  
        mh.insert(8);  
        mh.insert(15);  
        mh.insert(3);  
        mh.insert(12);  
  
        for(int i = 1; i <= mh.size; i++){  
            System.out.print(mh.heap[i] + " ");  
        }  
        System.out.println();  
  
        mh.insert(20);  
        for(int i = 1; i <= mh.size; i++){  
            System.out.print(mh.heap[i] + " ");  
        }  
        System.out.println();  
        System.out.println(mh.get());  
        for(int i = 1; i <= mh.size; i++){  
            System.out.print(mh.heap[i] + " ");  
        }  
        System.out.println();  
        System.out.println("asdf");  
    }  
}
```









