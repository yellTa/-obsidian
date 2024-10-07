---
created: 2024-10-04 17:50
updated: 2024-10-07T18:30
tags:
  - develop
Progress:
  - ongoing
---
# OBJECT/SUBJECT
작성한 기술명세와 API 문서를 보고 먼저 만들자
일단 더미데이터를 생성하고 view를 먼저 구성할 예정이다.

그 다음 backend와 결합시키도록 구성하자
# ANALYSIS:
html + javascript 로 구성된 front 
tomcat + maven 프로젝트로 구성한 backend
로 프로젝트를 구성하자

![[Pasted image 20241004195014.png]]

---

## 수행하기 - backend 부분
### 설계 
1. Backend 먼서 구성해보자! API를 return하는 WebProject를 시작하자!
![[Pasted image 20241004200820.png]]
DB 스키마 정의
### 수행할 작업 단위
## 데이터 저장하기
feat/saveTask

## 데이터 조회하기 - task에 get요청으로 JSON 데이터 가져오기
feat/getTasks
![[Pasted image 20241007175229.png]]
두 가지 방법이 존재한다. 
### 1. DB에서 progress마다 가져오기 
-> Progress별로 가져와서 pick하기 

1. DB에서 progress마다 객체 가져오기
2. todo, done, doing progress에 따라서 SQL문을 따로 날려 개별로 JSON객체 담아주기
### 2. DB에서 전체값 가져오기
-> DB에서 전체값을 가져오고 java 연산을 통해서 progress별로 따로 json 객체를 만들기

1. DB에서 전체 값 가져오기
2. List에서 progress가 todo done doing인걸 구분해서 json 객체로 만들기








## 수행하기 - front 부분


---

# CONCLUSION:

## 원인 :

## 작업 :

## 결과 :

# 결론:
>[!important]


# REVIEW:


---
# References

# 연결문서
