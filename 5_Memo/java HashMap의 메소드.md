---
created: 2024-07-27 01:15
updated: 2024-07-28T02:30
tags:
  - develop
  - java
  - algorithm
  - 자료구조
---
# Java HashMap의 메소드들

# 설명
## put(key, value)
## get(key)
키에 해당하는 value 리턴

## containsKey(key)
key가 있는지 check

## contains.Value(value)
value가 있는지 check
## remove(key)
key에 해당하는 값 삭제

## size()
맵 크기 반환

## isEmpty()
비어있는지 체크한다.

## keySet()
모든 키를 갖는 Set반환
```
Set<String> set = Map.values();
```

## values()
모든 값 또는 Collection 반환

```
Collection<?> c = map.values();
```

## entrySet()
키 값 매칭 포함해서 Set<Map<K, V>>반환한다.
```
for(Map.Entry<K,V> ent : map.entrySet()){
	K key = entry.getKey();
	V value = entry.getValue();
}

```


# 출처/참고

# 연결 문서
[[java  Map]]
