---
created: 2024-08-07 16:28
updated: 2024-08-07T16:34
tags:
  - algorithm
  - 이분탐색
출처: https://www.youtube.com/watch?v=3TkaOKHxHnI&list=PLtqbFd2VIQv4O6D6l9HcD732hdrnYb6CY&index=20
---
# Parametric Search

## 설명
- 조건을 만족하는 최소/ 최대를 구하는 문제를 <span style="color:rgb(0, 112, 192)">결정문제</span>로 변환해 이분탐색 수행

https://www.acmicpc.net/problem/1654
최적화 : N개를 만들 수 있는 랜선의 최대길이
<span style="color:rgb(0, 112, 192)">결정</span> : 랜선의 길이가 X일때 랜선이 <span style="color:rgb(255, 71, 71)">N개 이상</span>인가?

이분탐색의 함수 -> 감소 or 증가형식이다.
감소 증가가 섞여 있는 경우 이분탐색으로 탐색할 수 없음
이분탐색은 정렬된 자료에서 값을 빨리 찾을 수 있는 방법이기 때문

최소값을 결정으로 바꿀 수 있는지 check한다.
최소/최대가 있고 범위가 크거나, log로 떨구면 풀 수 있을 것 같을 때 사용한다. 
## 출처/참고
[바킹독의 실전알고리즘](https://www.youtube.com/watch?v=3TkaOKHxHnI&list=PLtqbFd2VIQv4O6D6l9HcD732hdrnYb6CY&index=20)
[랜선자르기](https://www.acmicpc.net/problem/1654)
[세수의 합](https://www.acmicpc.net/problem/2295)

## 연결 문서

