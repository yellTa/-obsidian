---
created: 2024-09-15 23:25
updated: 2024-09-15T23:39
tags:
  - develop
  - burgerput
Progress:
  - ongoing
---

# LoadingController분리하기:
cheatController를 수정했던 것과 마찬가지로 Service를 하나 두고 분리해보자~~~
잦은 연결고리가 생기지만 우리는 단일 서비스 사용자를 위한 거니까
# ANALYSIS:
## LoadingController에 필요한 기능
1. 프로그램 로딩 기능 - void형식
2. 로딩의 결과를 반환하는 result기능 - List<Map<String,Object>>로 리턴 

### LoadingControllerServiceImpl
```java

@Service  
@Slf4j  
@RequiredArgsConstructor  
@Transactional  
public class LoadingControllerServiceImpl implements LoadingControllerService{  
  
    private final AlertLoading2 alertLoading;  
    private final MachineLoadingAndEnterZenput machineLoadingAndEnterZenput;  
    private final FoodLoadingAndEnterZenput foodLoadingAndEnterZenput;  
    private final MyJsonParser myJsonParser;  
    /*  
     * /loading     * 1. getInfo를 통해서 data를 가져온다.  
     * 2. alertLoading을 통해 Macihne/Food의 add,del,edit 데이터를 갖는 JsonArray를 만든다.  
     * 3. JsonArray의 값을 /burgerput/loading의 경로에 jsonfile형식으로 저장한다.  
     */    @Override  
    public Map<String,String> loading() {  
  
/*      //서버에서 아침 8:35분에 요청해서 가져오는 값  
  
        //로딩의 결과를 저장할 JSONArray 객체*/  
        Map<String, String> resultMap = new LinkedHashMap<>();  
        resultMap.put("result", "true");  
        JSONArray jsonArray = new JSONArray();  
  
        try{  
            //getInfo로 데이터 가져오기  
            Map<Integer, Machine> infoMachine = machineLoadingAndEnterZenput.getInfo();  
  
            //반환값을 jsonArray를 인자로 보내 저장  
            alertLoading.MachineJsonMakerandDBSet(infoMachine, jsonArray);  
  
        }catch(Exception e){  
            log.info("Machine getInfo logic False");  
            log.info(e.toString());  
            resultMap.put("result", "false");  
  
            return resultMap;  
        }  
  
        try{  
            //getinfo로 food데이터 가져오기 시작  
            Map<Integer, Food> infoFood = foodLoadingAndEnterZenput.getInfo();  
  
            //결과값을 인자로 보낸 jsonArray에 저장  
            alertLoading.FoodJsonMakerandDBSet(infoFood,jsonArray);  
  
        }catch(Exception e){  
            resultMap.put("result", "false");  
            log.info("Food getInfo logic false");  
            log.info(e.toString());  
  
            return resultMap;  
        }  
  
        //최종 로딩의 결과 파일에 저장되는 값의 결과  
        log.info("Loading json ArrayResult = {}", jsonArray.toString());  
        alertLoading.jsonMaker(jsonArray, Const.JSONPATH);  
        //로딩의 성공 여부  
        log.info("result Map = {}", resultMap);  
//        return resultMap;  
  
        //로딩의 성공 여부  
        return resultMap;  
  
    }  
  
    @Override  
    public List<Map<String, Object>> readLoadingResult() {  
        // JSON 파일 읽기  
        String path = Const.JSONPATH;  
//        String path = "C:/Users/bbubb/Desktop/Burgerput/jsonFiles/";  
        Date now = Calendar.getInstance().getTime();  
        // 현재 날짜/시간 출력  
        System.out.println(now); // Thu May 03 14:50:24 KST 2022  
        // 포맷팅 정의  
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");  
  
        // 포맷팅 적용  
        String formatedNow = formatter.format(now);  
  
        String finalPath = path + formatedNow+ ".json";  
        String result = "";  
  
        List<Map<String, Object>> list = new ArrayList<>();  
        try {  
            result = new String(Files.readAllBytes(Paths.get(finalPath)));  
  
        } catch (IOException e) {  
            //에러인 경우  
            log.info("No file exist");  
            return list;  
        }  
        list = myJsonParser.stringToJSONArray(result);  
  
        log.info("result Arr  = {}", list.toString());  
        return list;  
    }  
}
```
기존에 Controller에 구현되어 있던 사항들을 Service로 옮겨주었다.

### 리팩토링이 완료된 LoadingController
``` java
@Slf4j  
@RequiredArgsConstructor  
@RestController  
@RequestMapping(value="/loading", method={RequestMethod.GET, RequestMethod.POST})  
public class LoadingController {  
    private final LoadingControllerService loadingControllerService;  
  
    @GetMapping  
    public Map<String,String> loading(){  
        return loadingControllerService.loading();  
    }  
  
    @GetMapping("/result")  
    @ResponseBody  
    public List<Map<String,Object>> readResult(){  
        return loadingControllerService.readLoadingResult();  
    }  
}
```
깔끔해짐 ㅎㅎ


---
# REVIEW:
SRP? 단일 책임 원칙을 지켜가면서 코드를 리팩토링하고있다. 깔끔해지는게 보기 좋다 ㅎㅎ
# References

# 연결문서
