---
created: 2024-08-01 01:32
updated: 2024-08-01T01:40
tags:
  - java
  - develop
  - algorithm
  - 자료구조
---
# java PriorityQueue 사용법

## 설명
- pq.add(값)
- pq.poll() -> 최솟값을 반환한다.  
- pq.size() -> 크기 리턴

### 내림차순 정렬
```java
PriorityQueue<Integer> pq = new PriorityQueue<>(Comparator.reverseOrder());

```

기본값은 오름차순 정렬이다. (맨 앞이 작은 수)
## 출처/참고
chatgpt
## 연결 문서

