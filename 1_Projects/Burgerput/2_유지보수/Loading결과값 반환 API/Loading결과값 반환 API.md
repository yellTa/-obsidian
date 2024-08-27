---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress:
  - end
업로드할까?: false
created: 2024-04-22T14:37:00
updated: 2024-08-27T18:01
---
# 반환해야하는 API형태

id

name

diff[ name : { [before Value , after Value] } ,

min : { [before Value , after Value] },

max : { [before Value, afterValue] }

]

code : edit

  

id

name

min

max

code : add or del

add와 del은 반환하는 값이 code만 빼고 같다.

  

diff: [] → 배열 구조, 달라진 값(이름, 최솟값, 최댓값)이 들어가게 된다. diff 안에는 변경된 사항이 존재할 때만 들어간다.

  

diff의 배열안에는 Map<array>가 들어간다. array는 before Value와 After Value를 담고있다.

# AlertLoadingV1의 분석

AlertLoading 은 Machine/FoodLoadingAndZenput.java의 getInfo 리턴값을 받아 정보를 가공한다.

  

  

## AlertLoading의 반환값

```Java
edit result = [{
    id = 2,
    name = [탐탐이, 온도계(탐침1)],
    min = 31,
    max = 33,
    code = edit
}, {
    id = 50,
    name = PHU내제품온도4,
    min = [185, 190],
    max = [185, 190],
    code = edit
}]

add result = [{
    min = 155,
    code = add,
    max = 190,
    name = 통모짜 패티(Tong Mozza Patty),
    id = 1266
}]

del result = [{
    id = 1252,
    name = 큐브 스테이크(Cube Steak),
    min = 140,
    max = 190,
    code = del
}]
```

각각 edit, add, del 의 반환값이다. ArrayList형태를 띄고 있다.

code를 이용해 edit, add, del을 구분한다.

edit에는 달라진 값이 before,after값이 배열로 들어가있다.

  

## AlertLoading의 logic

### Edit

1. DB에 저장된 Machine/Food의 값을 가져온다.
2. DB의 ID만을 가지고 있는 배열을 생성한다. dbIdStore
3. dbIdStore에서 id를 이용해 DB에 저장된 Machine객체를 가져온다.(dbMachine)
4. getInfo에서 3번에서 가져온 Machine객체의 id와 일치하는 객체를 가져온다.(zenputMachine)
5. zenputMachine과 dbMachine을 비교한다.

  

DB데이터가 없는 경우에는 모든 데이터가 추가된 경우로 간주한다.

### add

1. DB에 저장된 Machine/Food의 값을 가져온다.
2. DB의 ID만을 가지고 있는 배열을 생성한다. dbIdStore
3. getInfo로 가져온 데이터에서 key값을 추출한다. (zenputMachineDatum)
4. zenputMachineDatum과 dbIdStore의 값을 비교한다.
5. 겹치는 값이 없다면(zenputMachineDatum의 key값이 dbIdStore의 값에 들어 있지 않다면) 해당 값은 이번 로딩에서 새롭게 추가된 값이다.

  

DB데이터가 없는 경우에는 모든 데이터가 추가된 경우로 간주한다.

  

### del

1. DB에 저장된 Macine/Food의 값을 가져온다. DB에는 값이 들어있어야 한다.
2. DB의 Id만을 가지고 있는 배열을 생성한다. dbIdStore
3. DB데이터가 존재하는 경우 dbIdStore의 값과 zenput getInfo데이터와 비교한다. zenput getInfo데이터에서 dbIdStore의 값이 없다면 지워진 값이다.

  

## 반환 받은 값의 가공

![[Untitled 35.png|Untitled 35.png]]

현재 값은 LoadingController에서 가공이 이루어지고 있다.

  

![[Untitled 1 11.png|Untitled 1 11.png]]

반환 받은 값을 가공하는 로직, DB에 업로드하는 로직이 모두 LoadingController에서 이루어지고있다. 분리가 필요하다.

  

# AlertLoading에서 수정되어야 하는 사항들

1. AlertLoading에서 사용하는 DB에 관련한 값을 가져올 떄 JPQL이 아닌 JPA기술로 변경하도록 한다.

![[Untitled 2 8.png|Untitled 2 8.png]]

1. 반환 받은 값을 가공하는 로직을 Service로직으로 따로 분리하여 구성하고 Spring Bean으로 LoadingController에 주입시킨다.
2. DB에 업데이트하는 부분을 Service Logic으로 옮겨서 수행하도록 한다. (2번의 서비스 로직)

  

# AlertLoading 수정

## 1. JPQL to JPA

### edit(Machine/Food)

![[Untitled 3 7.png|Untitled 3 7.png]]

  

### del (Machine/Food)

![[Untitled 4 6.png|Untitled 4 6.png]]

  

## 반환 받은 값 가공하는 Service 로직 생성

### edit

```Java

            Map<String, String> tempMap = new LinkedHashMap<>();

            String id = map.get("id").toString();
            String name = map.get("name");
            String min = map.get("min");
            String max = map.get("max");


            tempMap.put("id", id);
            tempMap.put("name", name);

            // map save arrayList
            List< Map<String, List<String>>> diffList = new ArrayList<>();

            //check the name
            if (name.contains("[")) { //arrayList so it has diff value
                String pid = "name";
                //기존의 이름을 넣어주는 작업
                String[] temp = name.substring(1, name.length() - 1).split(",");
                String beforename = temp[0];
                tempMap.put("name", beforename);

                diffList.add(makeArray(name,pid));
            }


            if (min.contains("[")) {
                String pid = "min";
                diffList.add(makeArray(min,pid));
            }

            if (max.contains("[")) {
                String pid = "max";
                diffList.add(makeArray(max,pid));
            }

            if(!diffList.isEmpty()){
                tempMap.put("diff", diffList.toString());
            }

            result.add(tempMap);
```

code가 edit인 map을 검사한다.

  

1. 달라진 값을 넣을 diffList를 생성한다.
    
    diffList는[ {name = [before, after ] } ] 와 같은 구조를 띄고 있다. 달라진 값을 모두 저장하는 저장소라고 보면 된다. diffList에 들어갈 수 있는 값은 name, min, max 키를 가진 Map이다. (세 값 중에 변경된 값만 들어가면 된다.)
    
2. name, min ,max 순서대로 검증을 수행한다.
    
    ```Java
     private static  Map<String, List<String>> makeArray(String diffString, String pid) {
    			 // 문자열을 잘라서 before after값 추출
            String[] temp = diffString.substring(1, diffString.length() - 1).split(",");
            //temp 0 : before값
            //temp 1 : after값
            //온도를 새롭게 저장할 ArrayList
            List<String> temperList = new ArrayList<>();
    
            temperList.add(temp[0]);
            temperList.add(temp[1]);
    
            // { key : [ temp1 ,temp2  ]} 의 구조에서 가장 바깥 Map
            Map<String, List<String>> tempMap = new LinkedHashMap<>();
    
            tempMap.put(pid, temperList);
    
    //        log.info("tempMap ={} ", tempMap.toString());
    
            return tempMap;
        }
    ```
    

pid가 의미하는 것은 name, min, max 값이다. 셋을 구분하는 코드가 된다.

diffString은 달라진 값을 가지고 있다. [before, after]을 의미한다.

  

```Java
String[] temp = diffString.substring(1, diffString.length() - 1).split(",");
        //temp 0 : before값
        //temp 1 : after값
```

문자열을 잘라서 before, after값을 준비한다. temp[0] = before 값이

temp[1] = after값이 들어간다.

  

```Java
 List<String> temperList = new ArrayList<>();

        temperList.add(temp[0]);
        temperList.add(temp[1]);
```

배열의 값을 List로 옮겨준다. 배열은 주소값을 반환하기 때문에 메모리 주소에 들은 value가 아닌 주소값을 반환하게 된다. 그래서 List로 옮겨준다.

  

Object의 toString은 representation을 반환한다는 java docs  
  
  
`getClass().getName() + '@' + Integer.toHexString(hashCode())` 위와 같은 형태로 반환한다.

> [!info] Object (Java Platform SE 8 )  
> The actual result type is Class<?  
> [https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#toString--](https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#toString--)  

  

Collection의 toString은 사람이 읽을 수 있는 값 즉 주소가 가지고 있는 값을 반환한다. ( [ 1,2,3 ] 형태 )

element들은 `St``==ring.valueOf()==` 로 변환이 되기 때문에 Object의 String 반환과는 다르다.

> [!info] AbstractCollection (Java Platform SE 8 )  
> To implement an unmodifiable collection, the programmer needs only to  
> [https://docs.oracle.com/javase/8/docs/api/java/util/AbstractCollection.html#toString--](https://docs.oracle.com/javase/8/docs/api/java/util/AbstractCollection.html#toString--)  

  

  

name = [ before, after] 의 값는 가지는 Map을 리턴하고 종료한다.

```Java
 // { key : [ temp1 ,temp2  ]} 의 구조에서 가장 바깥 Map
        Map<String, List<String>> tempMap = new LinkedHashMap<>();

        tempMap.put(pid, temperList);

//        log.info("tempMap ={} ", tempMap.toString());

        return tempMap;
```

  

  

해당 맵을 diffList에 넣으면 name, min, max의 변경된 값이 들어가게 된다.

```Java
diffList.add(makeArray(name,pid));
```

  

  

1. 검증을 마친뒤 diffList를 key(diff) = value(diffList) 형태를 갖는 Map에 저장한다.

```Java
 //check the name
            if (name.contains("[")) { //arrayList so it has diff value
                String pid = "name";
                //기존의 이름을 넣어주는 작업
                String[] temp = name.substring(1, name.length() - 1).split(",");
                String beforename = temp[0];
                tempMap.put("name", beforename);

                diffList.add(makeArray(name,pid));
            }


            if (min.contains("[")) {
                String pid = "min";
                diffList.add(makeArray(min,pid));
            }

            if (max.contains("[")) {
                String pid = "max";
                diffList.add(makeArray(max,pid));
            }
```

위의 과정으로 diffList생성을 끝마친다.

  

```Java

            if(!diffList.isEmpty()){
                tempMap.put("diff", diffList.toString());
            }

            result.add(tempMap);
```

diffList가 비어있다면 변경된 값이 없는 경우이므로 diff키 값을 넣지 않는다. (애초에 edit이면 무조건 diff값이 있지만 diffList값이 없는데 diff키가 있다면 나중에 front단에서 문제가 생기므로 예외를 방지하기 위해서 넣었다.)

  

diff 결과를 tempMap에 key = “diff” value = diffList의 값으로 넣는다.

해당 검사 Map값을 최종반환 ArrayList result에 넣는다.

  

  

### add/ del

```Java
  for (Map<String, String> map : delMap) {
            Map<String, String> tempMap = new LinkedHashMap<>();
            tempMap.put("id", map.get("id").toString());
            tempMap.put("name", map.get("name"));
            tempMap.put("min", map.get("min").toString());
            tempMap.put("max", map.get("max").toString());
            tempMap.put("code" ,"del");

            result.add(tempMap);
        }

        return result;
    }
```

add와 del은 간단하다.

받은 map값을 code만 추가하고 전체 결과값을 반환하는 result ArrayList에 담으면 된다.

  

### 결과

```Java
[{
    id = 1266,
    name = 통모짜 패티(Tong Mozza Patty),
    min = 155,
    max = 190,
    code = add
}, {
    id = 1252,
    name = 큐브 스테이크(Cube Steak),
    min = 140,
    max = 190,
    code = del
}]
```

  

  

# 최종 반환 값

```Java
{
    "result": "true",
    "loadingResult": "
  [{
    id = 1266,
    name = 통모짜 패티(Tong Mozza Patty),
    min = 155,
    max = 190,
    code = add
}, {
    id = 1252,
    name = 큐브 스테이크(Cube Steak),
    min = 140,
    max = 190,
    code = del
}, {
    id = 2,
    name = 탐탐이,
    code = edit,
    diff = [{
        name = [탐탐이, 온도계(탐침1)]
    }]
}, {
    id = 44,
    name = PHU내제품온도1,
    code = edit,
    diff = [{
        min = [185, 190]
    }, {
        max = [185, 190]
    }]
}] 

"}
```

  

  

  

---

> [!info] [Java / json-simple] Map을 JSON으로 변경하기  
> 이번에는 json-simple 라이브러리를 이용하여 Map 객체를 JSONObject로 변경하는 방법을 알아보도록 하겠습니다.  
> [https://hianna.tistory.com/626](https://hianna.tistory.com/626)