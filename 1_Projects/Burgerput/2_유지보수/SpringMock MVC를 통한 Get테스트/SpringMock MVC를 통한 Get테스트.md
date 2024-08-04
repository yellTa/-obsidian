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

Get을 Spring Test로 수행하는 것

  

Json 파일로 저장된 자료를 get메소드로 읽어와서 화면에 뿌려준다.

# ANALYSIS:

json File → LoadingController(loading/result)

json파일을 읽어와 LoadingController에 뿌려주게 된다.

  

해당 테스트를 위해 실제 로컬 서비스를 띄울 수도 있지만 그럼 LoadingLogic에서 문제가 발생하게 된다. 실제 파일 경로도 변경해야하고 테스트를 성공적으로 끝마쳤다고해도 server세팅에 잘 맞게 되돌렸는지의 여부도 알 수 없다.

따라서

MOCK MVC를 사용해서 가짜 요청을 만들어 Controller로 요청이 날아오게 설정할 것이다.

  

  

## MOCK MVC란?

개발한 웹 프로그램을 실제 서버에 배포하지 않고 테스트를 위한 요청을 제공하는 수단

GET, POST, PATCH, DELETE등의 요청을 만들어 보낼 수 있다.

MOCK MVC를 이용한 테스트는 단위 테스트와 통합테스트의 사이 테스트라고도 한다.

# CONCLUSION:

MOCK MVC를 사용해서 서버를 위한 셋팅은 건드리지 않으면서 GET요청을 날리기로 결정했다.

# SOLVE: 테스트 수행해보기

## Loading Controller

```Java
    @GetMapping("/result")
    @ResponseBody
    public String readResult(){
        // JSON 파일 읽기
//        String path = Const.JSONPATH;
        String path = "C:/Users/bbubb/Desktop/Burgerput/jsonFiles/";
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

파일을 가져오는 부분만 local환경으로 변경했다.

  

## TestCode

```Java
        mockMvc.perform(
                get("/loading/result"))
                .andExpect(status().isOk()) // 응답 status를 ok로 테스트
                .andDo(print()); // 응답값 print

    }
```

/loading/result에 get으로 요청한다.

  

![[Untitled 38.png|Untitled 38.png]]

로그에서 결과를 확인할 수 있다.

String을 읽어와서 자동으로 jSON으로 형변환 해준 후 API로 뿌려줄것이라고 생각했는데 아니었다. ㅋ

# REVIEW:

mock MVC를 처음 사용해보면서 꼭 필요한 테스트라고 느꼇다.

지금처럼 API의 작동을 확인할 떄 로컬 테스트를 돌려서 확인하면 변경해야하는 상황이 한 두가지가 아니었는데 test를 사용하면 원본을 크게 변경할 염려도 줄어들고 결과도 확인할 수 있으니 1석2조다.

MVC에 대해서 조금 더 공부를 해야할 듯하다.