---
created: 2024-07-28 02:31
updated: 2024-08-13T23:37
tags:
  - java
  - study
  - algorithm
  - 자료구조
---
# Java HashMap을 정렬하는 방법

# 설명
## 1. Map.Entry<K,V>를 리스트로 반환한다.
```java

        // Map.Entry 리스트로 변환
List<Map.Entry<String, Integer>> list = new ArrayList<>(map.entrySet());

```

## 2. Compare함수를 구현해서 값으로 비교한다.
```java

// 값으로 정렬 collections하면서 override하는 방법
        Collections.sort(list, new Comparator<Map.Entry<String, Integer>>() {
            @Override
            public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
                return o1.getValue().compareTo(o2.getValue());
            }
        });



//이 방법을 더 선호할 듯 하다.

        // Comparator를 사용하여 값으로 비교
        Comparator<Map.Entry<String, Integer>> valueComparator = new Comparator<Map.Entry<String, Integer>>() {
            @Override
            public int compare(Map.Entry<String, Integer> e1, Map.Entry<String, Integer> e2) {
                return e1.getValue().compareTo(e2.getValue());
            }
        };

```

## 3. Collections.sort함수를 이용해서 정렬한다.
```java 
// 정렬된 리스트를 LinkedHashMap에 삽입
        LinkedHashMap<String, Integer> sortedMap = new LinkedHashMap<>();
        //결과 확인
        for (Map.Entry<String, Integer> entry : list) {
            sortedMap.put(entry.getKey(), entry.getValue());
        }

```

# 출처/참고
chatgpt


# 연결 문서

