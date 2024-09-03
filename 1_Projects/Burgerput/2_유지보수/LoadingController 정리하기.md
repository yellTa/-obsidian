---
created: 2024-09-03 15:00
updated: 2024-09-03T15:02
tags:
  - develop
Progress:
  - ongoing
post할까?: false
post됨: false
---
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