---
created: 2024-10-04 17:50
updated: 2024-10-04T21:27
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

#### DTO, DAO, Servlet만들기
데이터 베이스 스키마에 맞춰서 DTO 생성하기

##### DAO에 들어가야하는 기능
###### 데이터 읽어오기
1. 드라이버 로드
2. Conection 객체생성
3. PreparedStatement 객체 생성
4. SQL결과를 담을 ResultSet생성

ResultSet에 담긴 결과를 하나씩 읽어서 `List<Tasks>`형태로 반환

###### 데이터 저장하기




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
