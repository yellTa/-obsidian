---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress:
  - end
업로드할까?: false
created: 2024-08-04T18:06:00
updated: 2024-08-27T18:06
---
# OBJECT/SUBJECT:

현재 젠풋 로딩에서 달라진 값이 있으면 JSON파일로 이를 저장하고 읽어들이도록 설정했다.

  

# ANALYSIS:

```Java
    @GetMapping
    public Map<String,String> loadingV2(){

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
        log.info("Loading json ArrayResult = {}", jsonArray.toString());
        alertLoading.jsonMaker(jsonArray, Const.JSONPATH);
        //로딩의 성공 여부
        log.info("result Map = {}", resultMap);
//        return resultMap;

        //로딩의 성공 여부
        return resultMap;

    }
```

현재 로딩 컨트롤러에서 로딩 후 JSON파일을 만드는 로직을 추가했다.(원래 안되어있었음;; ㅎㅎ

)

  

달라진 값의 파일을 확인하기 위해서 몇 가지 실험이 필요하다.

  

추가된 값 : DB에 없는 값 추가됐는지 확인

달라진 값 : DB에 있는 값이 변경된 것이 있는지 확인

삭제 된 값 : DB에는 있었지만 젠풋에서는 삭제된 값 확인

  

위의 조건을 확인해야한다.

# HOW TO:

## 추가된 값

DB에 값을 삭제한다.

id 1154번인 커피를 삭제했다.

  

## 달라진 값

18 | 1168 | 800 | 200 | 김뚱뚱

탄산음료의 값을 위와 같이 변경했다.

  

## 삭제된 값

DB에 해당 아래의 값을 추가했다.

num, id, max,min, name순이다.

| 200 | 50000 | 90 | 1 | 우어어엉 |

  

> [!important]  
> LoadingController  

```Java
        //최종 로딩의 결과 파일에 저장되는 값의 결과
        log.info("Loading json ArrayResult = {}", jsonArray.toString());
        alertLoading.jsonMaker(jsonArray, Const.JSONPATH);
        //로딩의 성공 여부
        log.info("result Map = {}", resultMap);
```

로딩의 결과를 jsonMaker메소드를 이용해서 file로 저장하는 로직이다.

  

> [!important]  
> AlertLoadingV2  

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

위와 같은 방법으로 JSON 파일을 생성한다.

# CONCLUSION:

## 원인 :

일단 LoadingController에 JSON파일을 만드는 작업을 추가해놓지 않았었다.

## 작업 :

LoadingController에 JSON파일 만드는 로직을 추가했다!!

## 결과 :

DB의 값을 변경하고 아침에 로딩의 결과를 확인한다.

  

## 추가된 값

DB에 값을 삭제한다.

id 1154번인 커피를 삭제했다.

  

## 달라진 값

18 | 1168 | 800 | 200 | 김뚱뚱

탄산음료의 값을 위와 같이 변경했다.

  

## 삭제된 값

DB에 해당 아래의 값을 추가했다.

num, id, max,min, name순이다.

| 200 | 50000 | 90 | 1 | 우어어엉 |

  

  

> [!important]  
> 아침에 로딩된 json파일의 결과  

```Java
[
    {
        "name": "커피 (COFFEE) ",
        "id": "1154",
        "min": "170",
        "code": "add",
        "max": "185"
    },
    {
        "name": "김뚱뚱",
        "diff": [
            {
                "name": [
                    "김뚱뚱",
                    "탄산음료 (SOFT DRINK)"
                ]
            },
            {
                "min": [
                    "200",
                    "32"
                ]
            },
            {
                "max": [
                    "800",
                    "40"
                ]
            }
        ],
        "id": "1168",
        "code": "edit"
    },
    {
        "name": "우어어엉",
        "id": "50000",
        "min": "1",
        "code": "del",
        "max": "90"
    }
]
```

  

# SOLVE:

이제 [burback.shop:8080/result](http://burback.shop:8080/result) 페이지에서 파일을 읽어들여 HttpBody에 뿌려준다.

# Question:

front-end단에서 체크를 해야하는데 /result페이지를 JWT토큰 검사페이지에서 제거하지 않았다. 아침에 메인에 접근 하는 것 자체가 JWT토큰이 있기 때문에 정상작동하는지 아니면 불러들이지 못하는지 체크해야할 것 같다.