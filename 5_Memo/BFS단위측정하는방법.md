---
created: 2024-08-23 01:25
updated: 2024-08-23T01:29
tags:
  - 99클럽
  - algorithm
  - bfs
출처: 
---
# 윤지원 클럽장님이 알려주신 BFS단위 측정하는 방법

```java
 //여기를 잘 보렴
        // 단위 시간 혹은 단위 거리 만큼만 BFS 돌리는 방법
        while(!q.isEmpty()) {     
        //큐 사이즈 만큼 뽑아부기
            var size = q.size();
			//그 사이즈만큼 돌리기!!!! 단위가 되는거임
            while(size-- > 0) {
                var cur = q.poll();
                
                ... 아랫 부분은 우리가 잘 아는 통상적인 BFS로직
```
![[Pasted image 20240823012915.png]]


## 설명

## 출처/참고

## 연결 문서

