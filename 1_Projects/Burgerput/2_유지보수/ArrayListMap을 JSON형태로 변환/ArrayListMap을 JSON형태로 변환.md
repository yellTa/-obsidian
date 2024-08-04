---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress: end
업로드할까?: false
created: 2024-08-03T14:37
updated: 2024-08-04T22:42
---
# OBJECT:

로딩한 데이터를 날짜.json파일로 만들었었다.

하지만 ArrayList<Map>형태로 저장돼 있었고 프론트단에서 API로 사용할 수 없는 값이다.

해당 자료구조를 JSON으로 변경한다.

  

# ANALYSIS:

## Spring이 Data를 반환하는 방식

  

### 1. JSON형태로 생긴 String을 반환

기존까지는 Controller에 뿌려줬었다.

즉 Spring에서는 @RestController를 사용하면 @Controller + @ResponseBody가 붙게되고

  

@ResponseBody는

**String 데이터를 브라우저에 반환하고 싶을 때 사용한다.**

  

### 2. Java객체로 만들어서 변환

자동으로 Java의 객체를 JSON으로 변환해준다.

java객체 → JSON으로 자동 변환

  

# CONCLUSION:

  

## 가설1 : String을 객체로 변환한다면

위의 내용으로 객체로 변환해서 내보내면 JSON형태로 자동 변환해준다는 것을 알게되었다.

String으로 불러온 .json파일을 JSONArray<Map<string,string>>으로 변환한다.

해당 결과는 String이 아닌 객체이니까 Controller에서 자동으로 JSON형태로 변환해줄 것이다.

  

  

## 해당 리스트부분을 직접 파싱해주자…

이건 가설이 아니고 확실한 부분이다.

확실하게 답을 얻을 수 있는 방법

  

---

# 가설 1 시도

# 현재 .json파일의 구조

```Java
[{"name":"롱치킨 패티 (Long Chicken patty FULLY)","id":"34","min":"140","code":"add","max":"190"},{"name":"너겟킹 (Nugget King FULLY)","diff":"[{min=[-100, 140]}]","id":"351","code":"edit"},{"name":"탄산음료 (SOFT DRINK) ","diff":"[{min=[-10, 32]}]","id":"1168","code":"edit"}]
```

애초에 저장할 떄 JSONArray에 map<String,String>형태를 저장하도록 했다.

저렇게 보면 문제가 없는 것 같지만 문제는

```Java
{"name":"너겟킹 (Nugget King FULLY)","diff":"[{min=[-100, 140]},"id":"351","code":"edit"]"
```

다른 값이 들어가 있는 경우이다. 이 경우는

diff : List<Map<int,int>>형태로 들어가있다. 해당부분은 JSON으로 파싱이 되지 않은 것

다행히도 code가 edit으로 되어있는 부분만 해당이다.

# SOLVE:

## Way 1: String을 List<JSONObjet>로 변환해보자

과정은 String to List<JSONObjet>형태로 반환이다.

  

### **Interface 설정**

```Java

public interface MyJsonParser {
    public ArrayList<Map> jsonStringToArrayList(String param);

    //added 2024/05/21
      public List<JSONObject> stringToJSONArray(String param);
}
```

MyJsonParser를 이용해서 만들기로 정했다.

새로 기능이 추가된 만큼 V2로 만들어야했지만 많은 기능이 추가되는 것이 아니니 주석으로 추가사항을 달았다.

  

### Bean 주입

```Java
@Controller
@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value="loading", method={RequestMethod.GET, RequestMethod.POST})
public class LoadingController {
    private final AlertLoading2 alertLoading;
    private final MachineLoadingAndEnterZenput machineLoadingAndEnterZenput;
    private final CustomMachineRepository customMachineRepository;
    private final FoodLoadingAndEnterZenput foodLoadingAndEnterZenput;
    private final CustomFoodRepository customFoodRepository;
    private final MyJsonParser myJsonParser;

    @GetMapping
```

사용할 컨트롤러에 스프링 빈(MyJsonParser)을 주입해준다.

  

### MyJsonParser.stringToJSONArray구현

```Java
    @Override
    public List<JSONObject> stringToJSONArray(String param) {

        //Object를 Map으로 변경하기 위해 선언
        ObjectMapper objectMapper = new ObjectMapper();

        //param의 값을 JAONArray로 불러온다.
        JSONArray jsonArr = new JSONArray(param);

        //결과를 담을 resultArr를 생성
        List<JSONObject> resultArr = new ArrayList<>();

        //param을 통해서 받은 JSONArray를 한 차례씩 돌아준다.
        for (int i = 0; i < jsonArr.length(); i++) {
            JSONObject tempMap = (JSONObject) jsonArr.get(i);
            //JSONArray에서 꺼낸 객체를 뽑아서 map으로 변경해준다.
            resultArr.add(tempMap);

        }
        return resultArr;
    }
```

1. String형식의 배열을 JSONArray로 가져온다.
2. JSONObject로 해당 결과를 꺼내주고 List형식의 Array에 추가해준다.

  

```Java
  @GetMapping("/result")
    @ResponseBody
    public List<JSONObject> readResult(){
        //... .json파일 가져오는 부분
        try {
						//파일을 읽는 경우
            result = new String(Files.readAllBytes(Paths.get(finalPath)));

        } catch (IOException e) {
            //에러인 경우(파일이 존재하지 않음 = 변경된 값이 없음)
//            return resultArr;
        }
        
        List<JSONObject> list = myJsonParser.stringToJSONArray(result);

        log.info("result Arr  = {}", list.toString());

        return list;
    }
```

# 결과

```Java

MockHttpServletResponse:
           Status = 200
    Error message = null
          Headers = [Vary:"Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers", Content-Type:"application/json"]
     Content type = application/json
             Body = [{"empty":false},{"empty":false},{"empty":false}]
    Forwarded URL = null
   Redirected URL = null
          Cookies = []
```

  

실패 ㅋ

## 사유

### Spring boot는 jackson라이브러리를 사용한다!!! 그리고 얘는 Map을 JSON으로 바꾸지 JSONObject를 어떻게 serialize하는지 모른다!!!

위에서 Spring이 리턴할 때 자동 형변환해준다는 것을 기억할 것이다. Spring은 jacson라이브러리를 사용하는데 JSONObject를 리턴하면 시리얼라이즈하는 방법을 몰라서 empty :false값이 뜨게 됐다. ㅠ

# 가설 1 : 시도 2

## List<Map<String,Object>>형태로 반환해보자…

바꿔야할 것

1. MyJsonParser Inferface리턴타입을 List<Map<String,Object>>
2. MyJsonParserV1에서 JSONObject를 map<String,Object>형태로 반환
3. Controller에서 데이터를 List<Map<String,Object>>형태로 반환

  

### myJsonParser

```Java
    @Override
    public List<Map<String,Object>> stringToJSONArray(String param) {

        //Object를 Map으로 변경하기 위해 선언
        ObjectMapper objectMapper = new ObjectMapper();

        //param의 값을 JAONArray로 불러온다.
        JSONArray jsonArr = new JSONArray(param);

        //결과를 담을 resultArr를 생성
        List<Map<String,Object>> resultArr = new ArrayList<>();

        //param을 통해서 받은 JSONArray를 한 차례씩 돌아준다.
        for (int i = 0; i < jsonArr.length(); i++) {
        //JSONObject를 Map<String,Object>로 변경하는 방법
            Map<String,Object> map = null;
            JSONObject tempMap = (JSONObject) jsonArr.get(i);
            try {
                map = new ObjectMapper().readValue(tempMap.toString(), Map.class);

            } catch (JsonProcessingException e) {
                throw new RuntimeException(e);
            }
            //JSONArray에서 꺼낸 객체를 뽑아서 map으로 변경해준다.
            resultArr.add(map);

        }
        return resultArr;
    }
```

  

JsonObject를 map<String,Object>로 반환하도록 설정

  

나머지는 리턴값만 바꾸면 된다.

  

```Java
{"code":"edit","name":"탄산음료 (SOFT DRINK) ","diff":"[{min=[-10, 32]}]","id":"1168"}]
```

또 다시 보이는 악마의 JSON인척 하지만 JSON이 아닌 배열이 들어간 구조이다. 여기서 String형태로 넣은 것 같은데 이때는 어쩔 수 없이 직접 파싱해야 할 것 같다.

## 결론 : map<String,String(ArrayList형태)>

이 부분에서 파싱이 일어나지 못하고 있다. 이미정해진 API구조를 front단에서 이미 구현을 끝내버려서 고치기 힘들다.

Map<String,Map<String,String>>으로 변경하면 쉽겠지만 map의 형태일 때 자동으로 형변환 해주기 때문에 편하겠지만 지금은 그럴 수 없는 상황이다.

  

---

  

# 직접 파싱하기

가설이 먹히지 않았으니 다른 방법을 선택하면 된다.

해당 List부분을 직접 파싱하자

  

## 분석하기

```Java
{"code":"edit","name":"탄산음료 (SOFT DRINK) ","diff":"[{min=[-10, 32]}]","id":"1168"}]
```

Map<String,String(ArrayList)>인 경우이다.

여기서 키포인트는 **==code==**이다. ==**code가 edit인 경우**==에만 해당 문제가 발생한다.

  

1. code가 edit인 경우 map데이터를 가져온다.
2. map에서 diff를 꺼내 List형태의 String을 가져온다.
3. String을 JSONObject로 파싱한 후 String형태로 변환해 diff에 넣는다.

  

를 시도해보았지만 생각보다 과정도 너무 복잡하고 diff의 값이 한 개가 아닌경우 즉

min, max, name이 존재하는 경우도 생각했어야했었다.

  

따라서 그냥 처음에 저장할 떄 JSON형태로 저장하도록 설정했다.

### AlertLoadingV2

```Java
//check the name
                if (name.contains("[")) { //arrayList so it has diff value
                    String pid = "name";
                    //기존의 이름을 넣어주는 작업
                    String[] temp = name.substring(1, name.length() - 1).split(",");
                    String beforename = temp[0];
                    tempMap.put("name", beforename);

                    diffList.add(makeArray(name, pid));
                }

                if (min.contains("[")) {
                    String pid = "min";
                    diffList.add(makeArray(min, pid));
                }

                if (max.contains("[")) {
                    String pid = "max";
                    diffList.add(makeArray(max, pid));
                }
```

저장할 때 diff값이 있으면 넣는 부분이다. diffList에 makeArray의 리턴값을 넣어준다.

  

```Java
    private static Map<String, List<String>> makeArray(String diffString, String pid) {
        String[] temp = diffString.substring(1, diffString.length() - 1).split(",");
        //temp 0 : before값
        //temp 1 : after값
        //온도를 새롭게 저장할 ArrayList
        List<String> temperList = new ArrayList<>();

        temperList.add(temp[0].trim());
        temperList.add(temp[1].trim());

        // { key : [ temp1 ,temp2  ]} 의 구조에서 가장 바깥 Map
        Map<String, List<String>> tempMap = new LinkedHashMap<>();

        tempMap.put(pid, temperList);//temperList.toString();

//        log.info("tempMap ={} ", tempMap.toString());

        return tempMap;
    }
```

temperList를 String으로 형변환해서 넣어줬었다. 이를 제거하고 List형식으로 넣도록 변경했다.

해당 리턴은 Map<String,List<String>>형식이었다.

하지만 Map의 값에는 <String,String>값도 있었기 떄문에 이를 Map<String,Object(String도 되고 List도 들어갈 수 있게)> 변경해줬다.

  

## AlertLoadingV2실행해보기

이제 아침에 로딩이 됐다고 가정하고 수행해보았다.

![[Untitled 36.png|Untitled 36.png]]

변경된 값이 드디어 잘 들어갔다. ㅠㅠㅠ

  

## JSON파일 읽어오기

만들어놓은 Test파일을 활용해서 /loading/result 의 get메소드 확인도 해보았다.

![[Untitled 1 12.png|Untitled 1 12.png]]

성공이다. 어엉엉엉

  

  

# 최종 코드

## MyJsonParser

```Java
    @Override
    public List<Map<String, Object>> stringToJSONArray(String param) {
        //param의 값을 JAONArray로 불러온다.
        JSONArray jsonArr = new JSONArray(param);

        //결과를 담을 resultArr를 생성
        List<Map<String, Object>> resultArr = new ArrayList<>();
        //Object를 Map으로 변경하기 위해 선언
        ObjectMapper objectMapper = new ObjectMapper();

        //param을 통해서 받은 JSONArray를 한 차례씩 돌아준다.
        for (int i = 0; i < jsonArr.length(); i++) {
            Map<String, Object> map = null;

            JSONObject tempMap = (JSONObject) jsonArr.get(i);
            try {
                map = new ObjectMapper().readValue(tempMap.toString(), Map.class);
            } catch (JsonProcessingException e) {
                throw new RuntimeException(e);
            }
            //JSONArray에서 꺼낸 객체를 뽑아서 map으로 변경해준다.
            resultArr.add(map);
        }
        return resultArr;
    }
}
```

  

## LoadingController

```Java

    @Override
    public List<Map<String, Object>> stringToJSONArray(String param) {
        //param의 값을 JAONArray로 불러온다.
        JSONArray jsonArr = new JSONArray(param);

        //결과를 담을 resultArr를 생성
        List<Map<String, Object>> resultArr = new ArrayList<>();
        //Object를 Map으로 변경하기 위해 선언
        ObjectMapper objectMapper = new ObjectMapper();

        //param을 통해서 받은 JSONArray를 한 차례씩 돌아준다.
        for (int i = 0; i < jsonArr.length(); i++) {
            Map<String, Object> map = null;

            JSONObject tempMap = (JSONObject) jsonArr.get(i);
            try {
                map = new ObjectMapper().readValue(tempMap.toString(), Map.class);
            } catch (JsonProcessingException e) {
                throw new RuntimeException(e);
            }
            //JSONArray에서 꺼낸 객체를 뽑아서 map으로 변경해준다.
            resultArr.add(map);
        }
        return resultArr;
    }
```

복잡한 파싱작업없이!!! 좋은 결과를 얻을 수 있었다.

  

# REVIEW:

## Spring은 jackson라이브러리를 사용해 자동으로 Map,List,객체를 JSON으로 형변환 해준다.

하지만 여기서 주의할 점은 List형태를 String으로 보내는 경우이다. String의 경우는 단순 텍스트로 반환이 된다.

나는 ArrayList를 String으로 변경하고 넣었으니 String 형태로된 List를 내가 알아서 파싱해야했던 것….

  

## 앞으로 API를 구성할 때…Map<String,String>?

key값에 String이 오는 것은 흔하지만 대신 value값은 다양한 값이 들어갈 수 있다.

되도록 String형식으로 모든 데이터들을 반환하지 말고 Object형식으로 반환해서 Jackson 라이브러리가 serialize할 수있도록 하자…