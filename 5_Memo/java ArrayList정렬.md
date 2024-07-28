---
created: 2024-07-29 01:01
updated: 2024-07-29T01:02
tags:
  - java
  - algorithm
---
# java ArrayList정렬

## 설명
코테 문제 풀다가 나온 정렬부분 
[과제 진행하기](https://school.programmers.co.kr/learn/courses/30/lessons/176962)

```

        // 시간 순으로 정렬하기
        Arrays.sort(plans, (a, b) -> {
            int timeA = Integer.parseInt(a[1].replace(":", ""));
            int timeB = Integer.parseInt(b[1].replace(":", ""));
            return Integer.compare(timeA, timeB);
        });

```
위의 방법도 잊지말고 알아두자...
## 출처/참고
chatgpt
## 연결 문서

