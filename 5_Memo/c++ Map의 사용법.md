---
created: 2024-07-24 23:26
updated: 2024-07-24T23:34
tags:
  - develop
  - cpp
  - algorithm
  - 자료구조
출처: 
---
# Subject/Object 
c++ Map의 사용법

# 설명
map의 키는 이진검색 트리를 사용해 자동으로 정렬된다.
[[C++과 이진검색 트리]]

## map선언 및 초기화
```
int main() {
    // 키는 std::string 타입이고, 값은 int 타입인 map을 선언
    std::map<std::string, int> myMap;

    // 값 삽입
    myMap["apple"] = 1;
    myMap["banana"] = 2;
    myMap["orange"] = 3;

    // map의 내용을 출력
    for (const auto& pair : myMap) {
        std::cout << pair.first << ": " << pair.second << std::endl;
    }

    return 0;
}

```

## 요소 삽입
```
myMap["key값"] = "value값";

myMap.insert({1, "stst"});

```

## 요소 삽입
```
myMap.erase(2);
두 번째 요소를 삭제한다.

```


# 참고

# 연결 문서
[[C++과 이진검색 트리]]
