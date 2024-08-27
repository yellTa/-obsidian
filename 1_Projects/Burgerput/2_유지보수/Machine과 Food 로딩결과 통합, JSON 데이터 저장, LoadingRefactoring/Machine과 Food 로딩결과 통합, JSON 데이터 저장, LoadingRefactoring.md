---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress:
  - end
업로드할까?: true
created: 2024-05-13T14:37:00
updated: 2024-08-27T18:02
---
# OBJECT

Machine과 Food의 로딩 결과를 하나의 JSON ARRAY로 반환한다.

# ANALYSIS

현재 Map<machine/Food, ArrayData> → JsonArray로 변경한다.

### 1. getinfo()

getInfo를 통해서 데이터를 가져온다.

### 2. AlertLoading

AlertLoading.add/edit/del() 메서드를 통해서 각각 add, edit,del된 값을 가져온다.

### 3. processAlert

AlertLoading.processAlert를 통해서 add/edit/del로 뽑아낸 데이터를 Map<Map<string,string>>의 형태로 ArrayList에 넣는다.

  

---

위의 순서로 가공된 ArrayList<Map<Map<string,string>>>의 값을 JsonArray에 넣는다.

  

Machine/Food 각각 한 번씩 수행된다.

  

```Kotlin
 @Test
    @DisplayName("unitLoading")
    public void unitLoading(){
	      //데이터의 값이 들어갈 부분
        JSONArray jsonArray = new JSONArray();
        
        
        //machine Loading logic start
        try{

            Map<Integer, Machine> info = machineLoadingAndEnterZenput.getInfo();

            ArrayList<Map> add = alertLoading.addMachine(info);
            ArrayList<Map> edit = alertLoading.editMachine(info);
            ArrayList<Map> del = alertLoading.delMachine(info);

            //반환값
            ArrayList<Map<String, String>> maps = processAlert.alertInfo(add, del, edit);

            for (Map<String, String> map : maps) {
                jsonArray.put(map);
            }
        }catch(Exception e){

        }

				//Food Loading Logic Start
        try{

            Map<Integer, Food> info = foodLoadingAndEnterZenput.getInfo();

            ArrayList<Map> add = alertLoading.addFood(info);
            ArrayList<Map> edit = alertLoading.editFood(info);
            ArrayList<Map> del = alertLoading.delFood(info);

            ArrayList<Map<String, String>> maps = processAlert.alertInfo(add, del, edit);
            log.info(maps.toString());

            log.info("add result = {}", add.toString());
            log.info("edit result ={}", edit.toString());
            log.info("del result ={}", del.toString());

            for (Map<String, String> map : maps) {
                jsonArray.put(map);
            }
        }catch(Exception e){

        }

        // Map -> JSON
        //최종 결과값 반환

//        JSONObject jsonObject = new JSONObject(result);
        log.info(jsonArray.toString());

    }
```

# CONCLUSION

  

```Kotlin
[
  {
    "name": "탐탐이",
    "diff": "[{name=[탐탐이,  온도계(탐침1)]}]",
    "id": "2",
    "code": "edit"
  },
  {
    "name": "PHU내제품온도1",
    "diff": "[{min=[185,  190]}, {max=[185,  190]}]",
    "id": "44",
    "code": "edit"
  },
  {
    "name": "PHU내제품온도2",
    "diff": "[{min=[185,  190]}, {max=[185,  190]}]",
    "id": "46",
    "code": "edit"
  },
  {
    "name": "PHU내제품온도3",
    "diff": "[{min=[185,  190]}, {max=[185,  190]}]",
    "id": "48",
    "code": "edit"
  },
  {
    "name": "PHU내제품온도4",
    "diff": "[{min=[185,  190]}, {max=[185,  190]}]",
    "id": "50",
    "code": "edit"
  },
  {
    "name": "통모짜 패티 (Tong Mozza Patty) ",
    "id": "1266",
    "min": "155",
    "code": "add",
    "max": "190"
  },
  {
    "name": "큐브 스테이크 (Cube Steak) ",
    "id": "1252",
    "min": "140",
    "code": "del",
    "max": "190"
  }
]
```

  

Machine과 Food가 통합된 결과를 얻을 수 있었다.

# Refactoring

해당 코드를 그대로 Loading에 옮기게 되면 LoadingContoller가 너무 많은 역할을 수행하게 된다.

  

## LoadingController → getInfo Data만 제공

로딩 컨트롤러는 getInfoData만 제공하도록 하고

제공 받은 데이터를 가공하는 작업은 AlertLoadingV2로 이식하도록 하겠다.

  

이는 SOLID원칙 중 하나인 단일 책임 원칙(Single Responsibility Principle)에 따른다.

  

## LoadingController는 로딩작업만 수행하도록 하나의 역할만 부여하는 것

  

따라서 DB에 적용하는 부분은 AlertLoading 즉 Service Layer로 옮기기로 결정했다.

  

1. **Controller Layer (LoadingController)**: HTTP 요청을 받고, 필요한 데이터를 로딩하는 메소드를 서비스 레이어에서 호출합니다.
2. **Service Layer**: 비즈니스 로직을 처리하고, 데이터베이스 작업을 리포지토리 레이어에 요청합니다.
3. **Repository Layer**: 실제로 데이터베이스에 접근하여 CRUD 작업을 수행합니다.

  

이런식으로 계층을 나눠 각 컴포넌트의 역할을 명확하게 하고, 시스템의 유연성과 확장성을 향상시킨다.

![[Untitled 31.png|Untitled 31.png]]

  

# SOLVE

위에서 도식화한 구성대로 변경해보자

일단 AlertLoading의 기능 통합이다.

  

# AlertLoading의 기능 통합

## 목표 : AlertLoading2에 add, del, edit의 값 통합하기

## 1. AlertLoading2 Interface생성하기

```Kotlin
public interface AlertLoading2 {
    public ArrayList<Map> editMachine(Map<Integer, Machine> zenputMachineData);
    public ArrayList<Map> editFood(Map<Integer, Food> zenputFoodData);

    public ArrayList<Map> addMachine(Map<Integer, Machine> zenputMachineData);
    public ArrayList<Map> addFood(Map<Integer, Food> zenputFoodData);

    public ArrayList<Map> delMachine(Map<Integer, Machine> zenputMachineData);
    public ArrayList<Map> delFood(Map<Integer, Food> zenputFoodData);


//============추가됨======================
    //Machine getInfo data를 받아서 jsonArray로 반환
    public void MachineJsonMaker(Map<Integer, Machine> info, JSONArray jsonArray);

    //Food getInfo data를 받아서 jsonArray로 반환
    public void FoodJsonMaker(Map<Integer, Food> info, JSONArray jsonArray);

    //기존 ProcessAlert로 분리되어 있던 기능을 통합
    //add, del, edit을 추출해서 API형태로 변환해주는 역할
    public ArrayList<Map<String, String>> alertInfo(ArrayList<Map> addMap, ArrayList<Map> delMap, ArrayList<Map> editMap);


}
```

현재 AlertLaoding에는 6가지의 메소드들이 있다.

Machine/Food 의 add.edit,del의 정보를 추출하는 것

  

우리는 getInfo의 데이터와 JsonArray의 값을 받아서 add,del,edit이 통합된 상태로 반환할 것이다.

  

Machine/Food 각각 따로 수행되며 값을 저장할 JsonArray는 공유한다.

  

## LoadingController

```Kotlin
  @Test
    @DisplayName("unitLoading V2(Refactoring Version)")
    public void unitLoading2(){
        JSONArray jsonArray = new JSONArray();
        try{
            Map<Integer, Machine> infoMachine = machineLoadingAndEnterZenput.getInfo();
            //반환값
            Map<Integer, Food> infoFood = foodLoadingAndEnterZenput.getInfo();

            alertLoading.MachineJsonMaker(infoMachine, jsonArray);
            alertLoading.FoodJsonMaker(infoFood,jsonArray);

        }catch(Exception e){

        }

       //JSONObject jsonObject = new JSONObject(result);
        log.info(jsonArray.toString());

    }
```

로딩컨트롤러의 모습이다. DB에 값을 저장하는 로직은 아직 구현하지 않았다.

기존보다 훨씬 간결해졌다.

  

# AlertLoading DB업데이트 로직 추가

AlertLoading과 ProcessAlert기능을 통합했다. 이제 DB를 통합할 차례이다.

  

DB에 적용하는 방식은

delMap을 customTable에 저장한다.

Machine의 테이블을 모두 비웠다가 새롭게 로딩한 값으로 다시 재저장한다.

  

위의 형식을 따르고 있다.

  

해당 로직도 나중에는 달라진 값만 update하는 방식으로 변경이 되면 좋을 것 같다. 일단 우선은 기존의 로직을 지키면서 기능을 통합하는데 집중한다.

  

## AlertLoading

```Kotlin
  @Override
    public void FoodJsonMakerandDBSet(Map<Integer, Food> info, JSONArray jsonArray) {
        //Food의 add, del, edti의 정보를  추출한다.
        ArrayList<Map> add = addFood(info);
        ArrayList<Map> edit =editFood(info);
        ArrayList<Map> del =delFood(info);

        //추출한 데이터를 alertInfo를 이용해 통합한다.
        ArrayList<Map<String, String>> maps = alertInfo(add, edit, del);

        //뽑혀진 데이터List를 전달받은 JSONArray에 저장한다.
        for (Map<String, String> map : maps) {
            jsonArray.put(map.toString());
        }

        //Custom DB에 del 데이터 적용(del에 있는 값을 똑같이 지운다.)
        for (Map<String, String> map : del) {
            customFoodRepository.deleteById(Integer.parseInt(map.get("id")));
            log.info("deleted Food data ={}", map);
        }

        //전체 변환 값을 DB에 추가(DB 컨텐츠를 모두 지웠다가 저장한다.)
        saveData.foodZenputDataSave(info);
    }
```

Machine/Food jsonMakerandDBSet에 json데이터를 전달받은 인자 값에 저장한 후 DB에 값을 세팅하도록 설정했다.

참고로 이름은 DB구성이 들어간다는 것을 알리기 위해 JsonMaker → JsonMakerandDBSet으로 변경했다.

  

## LoadingController의 변화

## before :

```Kotlin
@GetMapping
    public Map<String,String> loading(HttpServletRequest request, HttpServletResponse response) throws IOException {

        log.info("Loading Logic Start  ={}", LocalDateTime.now());
        //Start Loading Logic
        //loading zenput Page's Data first
        Map<String, String> resultMap = new LinkedHashMap<>();
        resultMap.put("result", "true");

        try{
            log.info("MACHINE DATA GET STASRT");
            Map<Integer, Machine> machineInfo = machineLoadingAndEnterZenput.getInfo();
            log.info("loaded Machine Map info : {}", machineInfo);

            if (machineInfo.size() == 1) {
                //page loading fail case
                //false
                log.info("Machine Enter Page = false");
                resultMap.put("result", "false");

                return resultMap;
            }

            ArrayList<Map> addMap = alertLoading.addMachine(machineInfo);
            ArrayList<Map> delMap = alertLoading.delMachine(machineInfo);
            ArrayList<Map> editMap = alertLoading.editMachine(machineInfo);

            log.info("Machine DB set-up ");
            alertMachineInfoToDb(delMap);
            saveData.machinezenputdatasave(machineInfo);

        }catch(Exception e){
            log.info("Machine getInfo logic False");
            log.info(e.toString());
            resultMap.put("result", "false");

            return resultMap;
        }

        try {
            log.info("FOOD DATA GET STASRT");
            Map<Integer, Food> foodInfo = foodLoadingAndEnterZenput.getInfo();
            log.info("Loaded Food Map info : {}", foodInfo);

            if (foodInfo.size() ==1) {
                //false
                log.info("Food Enter Page = false");
                resultMap.put("result", "false");

                return resultMap;
            }

            ArrayList<Map> addFoodMap = alertLoading.addFood(foodInfo);
            ArrayList<Map> delFoodMap = alertLoading.delFood(foodInfo);
            ArrayList<Map> editFoodMap = alertLoading.editFood(foodInfo);

            log.info("Food DB set-up ");

            alertFoodInfoToDb(delFoodMap);
            saveData.foodZenputDataSave(foodInfo);

        } catch (Exception e) {
            resultMap.put("result", "false");
            log.info("Food getInfo logic false");
            log.info(e.toString());

            return resultMap;
        }

        log.info("return value ={}", resultMap.get("result"));
        return resultMap;
    }
    
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

## After:임시로 테스트파일에 작성

```Java
    @Test
    @Transactional
    @DisplayName("unitLoadingV2")
    public void unitLoadingV2(){

/*        //서버에서 아침 8:35분에 요청해서 가져오는 값


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
        log.info(jsonArray.toString());
        //로딩의 성공 여부
        return resultMap;
    }
```

LoadingController는 Loading의 결과가 true인지 false인지 판단한다.

기존의 데이터를 처리하고 DB에 업데이트하는 역할은 하지 않게 되었다.

위는 테스트 파일에 작성한 것이지만 실제 LoadingController에 들어가는 로직과 같다.

  

## JsonArray의 결과값을 file로 저장하기

## testcode

```Java
  @Test
    @DisplayName("file save test")
    public void fileJsonSaveTest() {
        String path = ConstT.JSONPATH;

        Date now = Calendar.getInstance().getTime();

        // 현재 날짜/시간 출력
        System.out.println(now); // Thu May 03 14:50:24 KST 2022

        // 포맷팅 정의
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        // 포맷팅 적용
        String formatedNow = formatter.format(now);

        // 포맷팅 현재 날짜/시간 출력
        log.info(formatedNow.toString());

        JSONArray jsonArray = new JSONArray();
        if(!jsonArray.isEmpty()){
            try {
                FileWriter file = new FileWriter(path + formatedNow + ".json");
                file.write(jsonArray.toString());
                file.flush();
                file.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }
```

yyyy/mm/dd.json형식으로 파일을 저장하기로 했다. 또한 jsonArray의 값이 비어있다면 파일은 작성하지 않았다.(해당 날짜는 변경된 값이 없었다는 것을 의미한다.)

  

## AlertLoading2 - interface

해당 로직을 추가하도록 하겠다.

```Java
    //loading을 통해 추출한 데이터를 Json파일로 만드는 메소드
    public void jsonMaker(JSONArray jsonArray, String path);
```

  

## AlertLoadingV2

```Java
 @Override
    public void jsonMaker(JSONArray jsonArray, String path) {
        Date now = Calendar.getInstance().getTime();
        // 현재 날짜/시간 출력
        System.out.println(now); // Thu May 03 14:50:24 KST 2022
        // 포맷팅 정의
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        // 포맷팅 적용
        String formatedNow = formatter.format(now);

        // 포맷팅 현재 날짜/시간 출력
        log.info(formatedNow.toString());

        if(!jsonArray.isEmpty()){
            try {
                FileWriter file = new FileWriter(path + formatedNow + ".json");
                file.write(jsonArray.toString());
                file.flush();
                file.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }
```

값을 저장할 jsonArray와 경로가 될 path를 받는다. 파일을 저장한다.

## Test

MachineDB에서 값 두가지를 지웠다.

```Java

    @Test
//    @Transactional //Transactional을 붙이면 DB에 실제 적용되지 않는다.
    @DisplayName("unitLoadingV2")
    public void unitLoadingV2() {
/*        //서버에서 아침 8:35분에 요청해서 가져오는 값
        //로딩의 결과를 저장할 JSONArray 객체*/
        Map<String, String> resultMap = new LinkedHashMap<>();
        resultMap.put("result", "true");
        JSONArray jsonArray = new JSONArray();

        try {
            //getInfo로 데이터 가져오기
            Map<Integer, Machine> infoMachine = machineLoadingAndEnterZenput.getInfo();

            //반환값을 jsonArray를 인자로 보내 저장
            alertLoading.MachineJsonMakerandDBSet(infoMachine, jsonArray);

        } catch (Exception e) {
            log.info("Machine getInfo logic False");
            log.info(e.toString());
            resultMap.put("result", "false");

//            return resultMap;
        }

        try {
            //getinfo로 food데이터 가져오기 시작
            Map<Integer, Food> infoFood = foodLoadingAndEnterZenput.getInfo();

            //결과값을 인자로 보낸 jsonArray에 저장
            alertLoading.FoodJsonMakerandDBSet(infoFood, jsonArray);

        } catch (Exception e) {
            resultMap.put("result", "false");
            log.info("Food getInfo logic false");
            log.info(e.toString());

//            return resultMap;
        }

        //최종 로딩의 결과 파일에 저장되는 값의 결과
        log.info("json ArrayResult = {}", jsonArray.toString());
        alertLoading.jsonMaker(jsonArray, ConstT.JSONPATH);
        //로딩의 성공 여부
        log.info("result Map = {}", resultMap);
//        return resultMap;
    }
```

loading controller Test파일의 모습이다. 실제 LoadingController와 로직을 동일하게 구성했다. return값만 없을 뿐이다.

  

## Result

```Java
2024-05-15.json

["{id=72, name=딜리버리픽업스테이션1, min=165, max=185, code=add}","{id=74, name=딜리버리픽업스테이션2, min=165, max=185, code=add}"]
```

파일이 지정한 Path에 만들어졌고 파일 안에는 loading의 결과 값이 있는 것을 확인 할 수 있었다.

  

  

## LoadingController에서 읽어오기

파일로 저장하는 것을 맞췄으니 이제 최종적으로 읽어오는 로직을 수행하면 된다.

사이트 링크는 /loading/result 에서 결과값을 가져온다.

## testfile

```Java
    @Test
    @DisplayName("json readingTest")
    public void jsonReading(){
        // JSON 파일 읽기
        String path = ConstT.JSONPATH;
        Date now = Calendar.getInstance().getTime();
        // 현재 날짜/시간 출력
        System.out.println(now); // Thu May 03 14:50:24 KST 2022
        // 포맷팅 정의
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        // 포맷팅 적용
        String formatedNow = formatter.format(now);

        String finalPath = path + formatedNow + ".json";
        String result = "";
        try {
            result = new String(Files.readAllBytes(Paths.get(finalPath)));

        } catch (IOException e) {
            //파일이 없경우
            //result값을 return해주면 된다.
            log.info(result);
            
        }
        log.info(result);
    }
```

file을 그대로 읽어와 String으로 뿌려준다.

만약에 파일이 없는 경우에는 에러가 발생하므로 try catch를 통해서 잡아준다.

파일이 없는 경우는 해당 날짜에 edit, add, del된 값이 없다는 것을 의미한다.

## LoadingController

```Java

    @GetMapping("/result")
    @ResponseBody
    public String readResult(){
        // JSON 파일 읽기
        String path = Const.JSONPATH;
        Date now = Calendar.getInstance().getTime();
        // 현재 날짜/시간 출력
        System.out.println(now); // Thu May 03 14:50:24 KST 2022
        // 포맷팅 정의
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        // 포맷팅 적용
        String formatedNow = formatter.format(now);


        String finalPath = path + formatedNow + ".json";
        String result = "";
        try {
            result = new String(Files.readAllBytes(Paths.get(finalPath)));
        } catch (IOException e) {
            return result;
        }

        return result;
    }
```

  

  

  

---

# Review:

## 역할 분리에 대해서 중요성을 느끼게 되었다.(SOLID의 단일책임 원칙)

  

각각의 레이어들이 하는 일들을 분리해서 코드를 훨씬 간결하게 만들었다.

컨트롤러단에서는 컨트롤러가 하는 역할만 중시하게 되고

Service Layer단에서 비지니스 로직을 처리하니 유지보수가 쉬운 코드로 변경된 것 같다.

## 테스트 코드?

이상하게도 테스트를 수행할 때

public void가 아닌 return값을 주게 되면 No tests were found가 뜨게 되었다.

사실상 Assert를 사용하거나 log로 전체 값을 확인해보면 되기 때문에 큰 문제는 아니였지만

Spring Test를 수행할 때는 일단 void형식을 사용해야겠다.