---
created: 2024-09-03 17:56
updated: 2024-09-15T23:22
tags:
  - develop
Progress:
  - end
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

cheatService를 만들어서 cheatController가 비지니스 로직을 받아 요청을 response하는 방식으로 변경해주자!
## CheatServiceInterface준비하기
추후에 추가될 Service의 확장을 위해서 Interface를 준비하자.

### CheatServiceV1 인터페이스 만들기
```java
public interface CheatServiceV1 {  
    //CheatFood의 정보를 보여주는 로직  
    public Map<String, ArrayList<Map>> showCheatFood();  
    //cheatFood에 저장되는 서비스 로직  
    public void saveCheatFood(ArrayList<Map> param);  
          
//CheatMachine의 정보를 보여주는 로직  
    public Map<String, ArrayList<Map>> showCheatMachine();  
    //cheatMachine에 save되는 서비스 로직  
    public void saveCheatMachine(ArrayList<Map> param);  
    }
```

### CheatServiceController구현하기
``` java
@Service //Spring bean 등록  
@Slf4j//로그확인  
@RequiredArgsConstructor  
@Transactional //DB사용하니까 트랜잭션 붙여줌  
public class CheatServiceV1 implements CheatService {  
  
    //DB사용  
    private final PrintData printData;  
    private final SaveData saveData;  
  
    @Override  
    public Map<String, ArrayList<Map>> showCheatFood() {  
  
        ArrayList<Map> maps = printData.customCheatFood();  
        ArrayList<Map> mgrMap = printData.mgrList();  
  
        Map<String, ArrayList<Map>> tempMap = new LinkedHashMap<>();  
  
        tempMap.put("customCheatFood", maps);  
        tempMap.put("mgrList", mgrMap);  
  
        return tempMap;  
    }  
  
    @Override  
    public void saveCheatFood(ArrayList<Map> param) {  
        saveData.customCheatFoodDataSave(param);  
    }  
  
    @Override  
    public Map<String, ArrayList<Map>> showCheatMachine() {  
  
        ArrayList<Map> maps = printData.customCheatMachine();  
        ArrayList<Map> mgrMap = printData.mgrList();  
  
        Map<String, ArrayList<Map>> tempMap = new LinkedHashMap<>();  
  
        tempMap.put("customCheatMachine", maps);  
        tempMap.put("mgrList", mgrMap);  
  
        return tempMap;  
  
    }  
  
    @Override  
    public void saveCheatMachine(ArrayList<Map> param) {  
        saveData.customCheatMachineDataSave(param);  
    }  
}
```

크게 Controller에 있던 기능들을 전부 옮겨주었다!
### CheatController Refactoring하기!

``` java
@Slf4j  
@RestController  
@RequiredArgsConstructor  
public class CheatController {  
  
    private final CheatService cheatService;  
            @GetMapping("back/cheatFood")  
    public Map<String, ArrayList<Map>> showCheatFood() {  
        return cheatService.showCheatFood();  
  
    }  
  
    @PostMapping("back/cheatFood")  
    public void saveCheatFood(@RequestBody ArrayList<Map> param) {  
        cheatService.saveCheatFood(param);  
    }  
  
    @GetMapping("back/cheatMachine")  
    public Map<String, ArrayList<Map>> showCheatMachine() {  
        return cheatService.showCheatMachine();  
    }  
  
    @PostMapping("back/cheatMachine")  
    public void saveCheatMachine(@RequestBody ArrayList<Map> param) {  
        cheatService.saveCheatMachine(param);  
    }  
  
}
```

서비스 로직이 들어있던 부분을 전부 제거하고 
@Transactional 애노테이션도 옮겨주었다. 
## 회고

실수로 저번 과정에서 MasterLoginController를 지웠었다. 하지만 그건 JWT로그인 관련 Controller여서 지우면 안되는거였음... 
다시 되돌렸다.


---
# REVIEW:
이번에는 깃 커밋 메세지를 잘 써보려고 노력했다. 이번엔 잘 써서 다행이다...
# References

# 연결문서
