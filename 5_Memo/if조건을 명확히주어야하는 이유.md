---
created: 2024-08-17 12:17
updated: 2024-08-17T12:24
tags: 
출처: 
---
# if조건을 명확히 주어야하는 이유
```java
//오늘 날짜랑 비교하기        
if(year<toyear)return 1;//파기
if ( year==toyear &&month<tomonth)return 1;
if(year==toyear && month==tomonth&&days<toda)return;
```

```java
if(year<toyear)return 1;//파기 
//year이 toyear이랑 같거나 크면 넘어감
if(month<tomonth)return 1;
//여기서 month가 작으면 return1을 해버림 year이 큰 상황에도 불구하고
//그러니까 문제의 조건은 year이 같이 month가 작을때 return1을 해야하는 것임
if(days<toda)return 1;
```

두 코드의 차이점은 fi문의 차이이다. 
if문을 사용할때 조건을 정확하게 주고 사용하자 
## 설명

## 출처/참고
[개인정보 수집 유효기간](https://school.programmers.co.kr/learn/courses/30/lessons/150370#)
## 연결 문서