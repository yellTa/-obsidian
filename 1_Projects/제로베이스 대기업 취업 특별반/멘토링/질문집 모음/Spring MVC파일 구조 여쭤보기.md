---
created: 2024-09-06T23:42
updated: 2024-09-06T23:59
---
```java
public class CheatController {  
  
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
  
  
}
```

현재 컨트롤러 구조를 이렇게 쓰고있는데 저는!

```java 
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

이런식으로 바꾸려고 하는데요! 혹시 폴더 패키지 구조가
