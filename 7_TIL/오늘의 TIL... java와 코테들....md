---
created: 2024-09-08 02:15
updated: 2024-09-08T02:22
tags:
  - TIL
출처: 
---
# Call by Value Call By Reference
간만에 공부하면서 c++생각이 새록새록 났던 친구
c++에서 Iter를 이용해서 참조자를 써가지고 포인터를 움직이는 기억이 새록새록 떠올랐다. 

이제는 Call by Value와 Call By Reference가 뭔지 조금 알겠다! (복습이 필요하겠지만)
[call by value, call by Reference](https://velog.io/@bbubboru22/Call-by-Value-Call-by-Reference)

# 오늘 풀었던 문제들 

## [백준 결혼식](https://www.acmicpc.net/problem/5567)
## [백준 바이러스](https://www.acmicpc.net/problem/2606)

백준에서 결혼식과 바이러스 문제를 풀었다. 참고로 나는 그래프 문제가 완전 쥐약이기 때문에 슬펐듬
링크는 치면 나오니까 안달아두고 싶은데 달아야겠지
## 알아낸 것
- 레벨 단위는 BFS가 풀기 편하다 단위로 쪼갤때는 BFS를 사용하도록 하자
- 인접 행렬과 인접 리스트는 목적이 다르다. 재귀로 탐색하게 될 때 인접 행렬을 사용하면 쓸데없는 연산이 이루어질 수도 있고 depth에 의도치 않은 문제가 생기기도 한다. 분명 vis배열을 잘 사용해도 말이다. 
- <span style="color:rgb(255, 128, 128)">  재귀를 사용할 때에는 모든 노드와 연결점을 찾지말고 연결리스트를 이용해 연결된 노드만 확인하도록 하자</span>

# 간만에 푼 기본?문제들
## [두 수의 합](https://www.acmicpc.net/problem/3273)
## [뒤큰수 찾ㄱㅣ](https://school.programmers.co.kr/learn/courses/30/lessons/154539?language=java#)
간만에 자료구조 문제 간만에 푸니까 다 막힘(ㅠ) 두 문제 푸는데 약 2시간 정도 걸렸다.  


---
# RE<span style="color:rgb(255, 128, 128)">VIEW</span>
할 것도 많고 해야할 일도 많고 했던 일도 요즘엔 너무 많습니다.
알아가서 좋긴하지만 갈리고있는기분이야ㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑㅑ
그래도 힘내야지 

---

# 연결문서
[[백준 결혼식]]
[[바이러스]]