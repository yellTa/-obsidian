---
created: 2024-09-03T13:27:00
updated: 2024-09-03T14:41
tags:
  - develop
Progress:
  - ongoing
post할까?: false
post됨: false
---
# OBJECT/SUBJECT:
프로젝트에서 Controller에 DB를 사용한다던가 하는 있다. 
이는 단일책임 원칙을 지키지 않은 형태로 유지보수를 위해 변경해줄 필요가 있다.
# ANALYSIS:
시스템의 흐름을 파악하고 단일책임 원칙이 지켜지지 않은 부분을 찾아내자

## 1. 기능의 시작점이 되는 Controller를 분석해보자
![[Pasted image 20240903133320.png]]

프로젝트 패키지의 구성의 위 처럼 되어있다. Web 패키지에 Controller들이 들어있다. 하나씩 확인해보자
![[Pasted image 20240903143233.png]]
Controller의 구성은 위의 그림과 같다. 여기서 불필요한 Controller을 우선 먼저 제거해주자 

- AltPages
	- APITestController
	  API테스트를 위해 구성한 컨트롤러 삭제하자.
	- LoadingController
	  아침 로딩이 구동되는 컨트롤러 중요한 컨트롤러이다.
	
- cheat
	- CheatController
	  치트기능을 사용하는 컨트롤러 사용자가 온도를 입력하는게 아닌 랜덤으로 지정된 입력값을 사용할 때 필요하다.
- error
	- ErrorController
	  뭔가 예전에 에러처리를 위해 만들었는데 사용하지 않는듯 하다. 테스트 용으로 썻었다.
- Manager
	- food
		- EnterFoodController
		  식품을 제출할 때 사용한다. 
		  
		- SelectFoodController
		  식품을 선택할 때 사용하는 컨트롤러
		  
		- SubmitFoodController.java
		  과거에 테스트 용도로 사용한 컨트롤러 삭제가 필요하다.
	- machine
		- EnterMachineController
		  기기를 제출할 때 사용하는 컨트롤러
		  
		- SelectMachineController
		  기기를 선택할 때 사용하는 컨트롤러
		  
		- SubmitMachineController.java
		  과거에 테스트 용도로 사용한 컨트롤러...
	- mgrList
		- MgrListController
		  매니저 리스트관련 컨트롤러 리스트를 보여주거나 업데이트할 때 사용한다.
		  
	- ZenputAccounts
		- ZenputAccountsController
		  Zenput계정을 업데이트, 조회할 때 사용한다. 사용하는 계정은 단 하나이다.
		  
- InitController
  처음에 DB에 값을 넣기 위해 필요한 컨트롤러 마찬가지로 테스트용도로 사용했었다.
  
- MasterLoginController
	JWT토큰을 통해 로그인할 때 사용하는 계정 지금은 DB에 직접 값을 넣는 방식을 사용해서 필요가 없다. 나중에 변경 예정이지만 지금은 사용하지 않는다.


## 필요없는 컨트롤러 제거
SubmitFoodController.java
SubmitMachineController.java
InitController
MasterLoginController
ErrorController
APITestController



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
