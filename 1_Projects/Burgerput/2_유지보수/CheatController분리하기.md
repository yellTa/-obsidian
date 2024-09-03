---
created: 2024-09-03 17:56
updated: 2024-09-03T18:14
tags:
  - develop
Progress:
  - ongoing
post할까?: false
post됨: false
---
# OBJECT/SUBJECT:
CheatController에서 리팩토링을 수행해보자!

## 확인할 사항
1. 불필요한 Annotaion옵션 사용 여부
2. 단일 책임 원칙을 지키고 있는지 여부

# ANALYSIS:
## 불필요한 Annotation옵션 사용 여부
``` java
@Slf4j  
@RestController  
@RequiredArgsConstructor  
@Transactional  
public class CheatController {
```
현재 Controller에서 @Transational을 사용하고 있다.

### SOC위반
Controller단은 HTTP요청을 처리하거나 응답하는데 사용되어야 한다. 따라서 @Transactional같은 비지니스단에서 처리되어야 하는 요소는 필요가 없다. 

### 트랜잭션 관리
트랜잭션은 비지니스 로직이 들어있는 Service레이어에서 관리되어야 한다. 
서비스 단에 트랜잭션을 주게된다면 서비스 메소드 단에 실행되는 CURD는 같은 트랜잭션 상에서 존재하게 된다. 

따라서 트랜잭션은 서비스단으로 옮겨줘야한다. 

## 단일 책임 원칙을 지키고 있는지 여부
``` java
private final PrintData printData;  
private final SaveData saveData;  
  
@GetMapping("back/cheatFood")  
public Map<String, ArrayList<Map>> showCheatFood() {  
  
    ArrayList<Map> maps = printData.customCheatFood();  
    ArrayList<Map> mgrMap = printData.mgrList();  
  
    Map<String, ArrayList<Map>> tempMap = new LinkedHashMap<>();  
  
    tempMap.put("customCheatFood", maps);  
    tempMap.put("mgrList", mgrMap);  
  
    return tempMap;  
}  
@PostMapping("back/cheatFood")  
public void saveCheatFood(@RequestBody ArrayList<Map> param) {  
    saveData.customCheatFoodDataSave(param);  
  
}  
@GetMapping("back/cheatMachine")  
public Map<String, ArrayList<Map>> showCheatMachine() {  
  
    ArrayList<Map> maps = printData.customCheatMachine();  
    ArrayList<Map> mgrMap = printData.mgrList();  
  
    Map<String, ArrayList<Map>> tempMap = new LinkedHashMap<>();  
  
    tempMap.put("customCheatMachine", maps);  
    tempMap.put("mgrList", mgrMap);  
  
    return tempMap;  
}  
@PostMapping("back/cheatMachine")  
public void saveCheatMachine(@RequestBody ArrayList<Map> param) {  
    saveData.customCheatMachineDataSave(param);  
  
}
```
Controller의 총 로직이다. 

PrintData, SaveData를  통해서 처리하고 있다. 다른 의존성은 보이지 않는다.

PrintData는 DB에 있는 값을 출력한다. 
SaveData를 통해서 값을 저장한다. 

하지만 PrintData에서 가져온 값을 가공하는 과정이 Controller에 속해있는데 이는 옳지 않은 방향이다. 

``` java
@RestController
@RequiredArgsConstructor
public class CheatFoodController {

    private final CheatFoodService cheatFoodService;

    @GetMapping("back/cheatFood")
    public Map<String, ArrayList<Map>> showCheatFood() {
        return cheatFoodService.getCheatFoodData();
    }

    @PostMapping("back/cheatFood")
    public void saveCheatFood(@RequestBody ArrayList<Map> param) {
        cheatFoodService.saveCheatFoodData(param);
    }

    @GetMapping("back/cheatMachine")
    public Map<String, ArrayList<Map>> showCheatMachine() {
        return cheatFoodService.getCheatMachineData();
    }

    @PostMapping("back/cheatMachine")
    public void saveCheatMachine(@RequestBody ArrayList<Map> param) {
        cheatFoodService.saveCheatMachineData(param);
    }
}

```
아래와 같이 CheatFoodService라는 서비스 레이어를 만들고 처리하는 것이 좋다.

> [!info]
> 여기부터 다시 쓰세요 

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
