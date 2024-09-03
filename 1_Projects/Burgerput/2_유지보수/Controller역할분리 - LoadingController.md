---
created: 2024-09-03T13:27:00
updated: 2024-09-03T14:56
tags:
  - burgerput
Progress:
  - end
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

## 최종 패키지의 모습
![[Pasted image 20240903144241.png]]

사용하지 않는 컨트롤러는 모두 지웠다.


## LoadingController 정리하기

### LoadingController
LoadingController의 패키지 이름은 Loading으로 변경했다. 
#### 사용하지 않는 로직들
```java
private void alertFoodInfoToDb (ArrayList < Map > delMap) {  
  
    for (Map<String, String> map : delMap) {  
        customFoodRepository.deleteBymineId(map.get("id"));  
        log.info("deleted Food data ={}", map);  
    }  
}  
private void alertMachineInfoToDb(ArrayList<Map> delMap) {  
  
    for (Map<String, String> map : delMap) {  
        customMachineRepository.deleteBymineId(map.get("id"));  
        log.info("deleted Machine data ={}", map);  
    }  
}
```

예전에 사용했던 로직이다. DB에 값을 삭제하는 로직이고 이때 JPQL을 사용했었다. 제거해야한다.

#### 사용하지 않는 GetMapping
```java
  
    @ResponseBody  
    @GetMapping("/test")  
    public Map<String,String> loadingTest(HttpServletRequest request, HttpServletResponse response) throws IOException {  
//        Map<Integer, Machine> machineInfo = machineLoadingAndEnterZenput.getInfo();  
        log.info("LoadingTest Logic Start(only Food)  ={}", LocalDateTime.now());  
  
        Map<String, String> resultMap = new LinkedHashMap<>();  
        resultMap.put("result", "true");  
//  
//        Map<Integer, Food> foodInfo = foodLoadingAndEnterZenput.getInfo();  
//        log.info("Loaded Food Map info : {}", foodInfo);  
//  
//        if ( foodInfo.size() ==1) {  
//            //false  
//            log.info("FALSE RESULT RETURN = false");  
//            resultMap.put("result", "false");  
//  
//            return resultMap;  
//        }  
//  
        return resultMap;  
    }
```
현재 /loading/test는 사용하지 않는다. 아마도 로딩 실험을 해보려고 만든 것 같은데 제거하자

#### 과거에 작성했던 로직 
```java
etMapping  
//    public Map<String,String> loading(HttpServletRequest request, HttpServletResponse response) throws IOException {  
//  
//        log.info("Loading Logic Start  ={}", LocalDateTime.now());  
//        //Start Loading Logic  
//        //loading zenput Page's Data first  
//        Map<String, String> resultMap = new LinkedHashMap<>();  
//        resultMap.put("result", "true");  
//  
//        try{  
//            log.info("MACHINE DATA GET STASRT");  
//            Map<Integer, Machine> machineInfo = machineLoadingAndEnterZenput.getInfo();  
//            log.info("loaded Machine Map info : {}", machineInfo);  
//  
//            if (machineInfo.size() == 1) {  
//                //page loading fail case  
//                //false  
//                log.info("Machine Enter Page
```

과거에 만든 로직을 주석처리해놨다. 사용하지 않는 로직이니 삭제하자 그리고 어짜피 git에서 확인할 수 있다.

#### DB사용제거
```java
blic class LoadingController {  
    private final AlertLoading2 alertLoading;  
    private final MachineLoadingAndEnterZenput machineLoadingAndEnterZenput;  
    private final CustomMachineRepository customMachineRepository;  
    private final FoodLoadingAndEnterZenput foodLoadingAndEnterZenput;  
    private final CustomFoodRepository customFoodRepository;  
    private final MyJsonParser myJsonParser;
```

현재 로직은 Controller에서 DB와 통신하기위한 Repository를 사용하지 않는 것으로 변경되었다.  따라서 Repository주입은 받을 필요가 없다. 제거하자!


#### 애노테이션 정리
``` java
@Controller  
@Slf4j  
@RequiredArgsConstructor  
@RestController
```

RestController는 Controller를 포함하고 있다. 제거하자!!

#### 정리 :
##### 사용하지 않는 메서드 삭제
alertFoodInfoDb
alertMachineIntoDb 

##### 사용하지 않는 GetMapping 제거
/loading/test는 사용하지 않는다. 제거하자

##### 주석제거
사용하지 않는 로직의 주석처리를 제거하자.

##### DB와 통신시 사용되는 Repository의존성 제거

##### Controller애노테이션 제거 (RestController를 사용중이라서 )

# CONCLUSION:
## 작업 :
사용하지 않는 Controller와 LoadingController안 필요없는 메서드, 사용하지 않는 API주소, 필요없는 주석 제거를 수행했다.

## 결과 :
코드가 짧고 간결해졌다. 
첫 시작 부분에 주석을 달아놓아서 어떤 로직을 수행하는지 깔끔하게 정리했다.
### 결론
코드를 깔끔하게 짜자... 

---
# REVIEW:
과거에 이렇게 지저분하게 짠줄 몰랐다... 이리저리 테스트파일이 돌아다니고 사용하지도 않는데 저장하고 있거나 애노테이션을 중복해서 사용하는 문제가 발생했다. 
리팩토링을 통해서 코드를 깔끔하게 수정하고 유지보수가 좋게 하자... 
# References

# 연결문서
