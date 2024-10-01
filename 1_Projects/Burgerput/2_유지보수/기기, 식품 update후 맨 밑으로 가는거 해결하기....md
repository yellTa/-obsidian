---
created: 2024-09-30 22:28
updated: 2024-10-01T11:51
tags:
  - develop
Progress:
  - ongoing
---
# OBJECT/SUBJECT:
![[Pasted image 20240930223157.png]]

리치인 쿨러를 기기선택에서 추가하고 오전 기기로 들어갔을 때 보이는 창이다.

![[Pasted image 20240930223328.png]]

리치인 쿨러의 원래 위치이다.  

## 문제점
1. 기기선택에서 기기를 선택한다.
2. 원래 index위치가 아닌 가장 밑에 추가된 항목이 보이게된다.

# ANALYSIS:

## 원인 파악하기

문제를 해결하기 위해 분석을 수행해보자

![[Pasted image 20240930224456.png]]
가장 큰 문제점은 num이 pk로 지정되어 있는 것이다.
이때 num은 딱히 큰 의미를 가진 데이터가 아니다. 그냥 자동 증가로 준것임

DB에 데이터가 저장되는 순서를 의미한다. 
즉 우리는 출력할 때 저 번호 순서로 순서롤 조장할 필요가 있다. 

### 로직 확인해보기
#### Controller
- EnterFood
- EnterMachine
- Cheat

이렇게 세 가지에서 Custom_machine/ food의 정보를 가져오는데 순서를 지키지 않고 있다. 
### 문제점
#### 1. num이 현재 pk로 지정되어 있다.
num은 자동증가 index이다. 현재 pk로 지정되어 있다. 
문제는 이걸 고치면 어느 범위부터 얼마나 고쳐야할지 고려할 것이 너무나도 많다는 것이다. 즉 단순히 PK를 바꾸는것 만으로도 문제가 발생할 수 있다.


---

## 가설 세우기

### 해결안
#### 1. num은 그대로 두되, index 열을 따로 만들도록 하자
현재 개발에 참여할 수 있는 시간도 그렇고 기존에 있는 PK값을 함부로 바꿔서 이리저리 만져보다가는 돌이킬 수 없는 결과를 낳을 수도 있을 것 같다는 생각이 든다.
그리고 애초에 변경에는 닫혀있고 확장에는 열려있어야 한다... 즉 코드가 변경되는 것 자체가 좋지 못하다는 의미이다. 
그리고 이건 잘못된 설계의 예시이다... 어떻게 고쳐야할지 감도 안오고 차라리 새로 구현하는게 나을것 같기 때문^^...
## 수행하기

### 설계
작업을 수행하기 위해서 설계를 먼저 시작해보자

![[Pasted image 20241001111927.png]]
Machine과 CustomMachine에는 num이라는 자동증가 열이 있다.
이때 Machine에서는 항목의 순서대로 num이 생기게 되지만 CustomMachine에서는 **들어온 순서대로  num을 생성하고 있다.**

그래 DB에 값을 가져올 때 index가 없었던 경우네느 ACDFB의 순서로 가져왔던 것이다.
이제 index 열을 추가하고 숫자를 부여한 다음 index를 기준으로 오름차순으로 정렬하면 문제를 해결할 수 있다.
### 수행할 작업 단위
#### 1. index 열 추가하기
- Custom Food
- CustomMachine
- Food
- Machine
위의 테이블에 index열을 추가하도록 하자

#### 2. Loading되고 Machine, Food에 데이터가 추가될 때 index의 값도 저장하기
Machine,Food에 데이터가 추가될 때 index의 값도 추가하자!

#### 3.Custom Table에 값을 넣을 때 index도 함께 넣도록 설정하기
저장하는 비지니스 로직에서 customTable에 값을 저장할 때 index도 함께 넣도록 설정하자

#### 4. CustomTable에 값을 출력할 때 index를 기준으로 오름차순하고 결과를 front에 return하기
customTable에 index의 값도 들어갔고 이제는 뽑을 때 index를 기준으로 오름차순을 진행하자!!

---









# CONCLUSION:

## 원인 :

## 작업 :

## 결과 :

# 결론

# REVIEW:


---
# References

# 연결문서
