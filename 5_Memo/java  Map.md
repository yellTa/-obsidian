---
created: 2024-07-26 01:31
updated: 2024-08-15T10:43
tags:
  - study
  - develop
  - java
  - 자료구조
출처:
  - chatgpt
---
# javaMap에 관해서

# 설명
## HashMap
 - [[HashTable]]로 구성되어 있다.
 - 키-쌍 구조로 되었있다.
 - 정렬되지 않는다.
## Tree Map
- 이진 검색 트리(Red-Black Tree)를 사용한다.
- 키 기준으로 정렬이 수행된다.
## LinkedHashMap
- 해시 Table을 이중 연결 리스트로 사용한다.
- 입력 순서를 보장한다.
## ConcurrentHashMap
- 해시 Table을 사용한다. (다중 [[세그먼트]]를 이용해서 동시성을 제어한다.)
- 높은 동시성을 위해 설계되었다.
- 정렬되지 않는다.

# 참고
[[C++과 이진검색 트리]]
# 연결 문서

