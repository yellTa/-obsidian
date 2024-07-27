---
created: 2024-07-28 02:43
updated: 2024-07-28T02:45
tags: 
---
# Java Map.EntrySet이란

# 설명
- Map interface메소드이다. 
- 키 -값 쌍을 Set형식으로 반환한다.
- Map의 모든 항복에 접근하고 수정할 수 있다.

## 반복작업
```

Map<String, Integer> map = new HashMap<>();
map.put("one", 1);
map.put("two", 2);

for (Map.Entry<String, Integer> entry : map.entrySet()) {
    System.out.println(entry.getKey() + " : " + entry.getValue());
}


```


## 수정 작업

```
for (Map.Entry<String, Integer> entry : map.entrySet()) {
    entry.setValue(entry.getValue() + 1);
}

```

- 반복 중에 값 수정이 가능하다.
## 정렬 작업
```
List<Map.Entry<String, Integer>> entries = new ArrayList<>(map.entrySet());
entries.sort(Map.Entry.comparingByValue());
```
(위의 코드는 value를 기준으로 정렬하는 방법이다.)

# 출처/참고

# 연결 문서

