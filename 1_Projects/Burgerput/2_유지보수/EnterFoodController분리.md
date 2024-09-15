---
created: 2024-09-15 23:52
updated: 2024-09-16T00:01
tags:
  - burgerput
Progress:
  - ongoing
---

# EnterFoodController를 분리하자
마찬가지로 Interface를 만들고 Service 구현체를 만들어서 분리하자...

# ANALYSIS:
## 필요 기능 정의하기

### EnterFoodController - > 식품을 입력할때 사용
1. `Map<String, ArrayList<Map>> showFood()` -> 선택한 식품의 리스트를 보여주는 페이지
2. `Map<String,String> submitZenputFood` -> post로 통해 받은 정보로 식품을 입력하는 로직

### SelectFoodController -> 식품을 선택할때 사용
1. `ArrayList<Map>` showFood-> 전체 식품의 리스트를 보여준다.  
2. void Selected saveFood-> 선택한 식품의 값을 저장한다.


# CONCLUSION:

## 원인 :

## 작업 :

## 결과 :

## 부제목

<aside> 🔽 code file name

</aside>

```bash
# codes
```

### 결론

> _**아 이렇게 이렇게 이렇게 하면 되는 구나**_



---
# REVIEW:

내가 이 문제를 통해서 깨닫고 배운 것들

원초적인 내용일 수록 좋다.(이론적인 내용들 기본지식들)

# References

# 연결문서
