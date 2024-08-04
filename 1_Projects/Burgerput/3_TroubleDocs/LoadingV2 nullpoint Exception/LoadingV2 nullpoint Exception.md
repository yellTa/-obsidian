---
progress:
  - end
Created time: Invalid date
Last edited time: Invalid date
Review여부: false
post됨: false
post할까?: false
created: 2024-08-03T14:37
updated: 2024-08-04T22:42
---
# OBJECT:

Loading을 수행하면서 Null pointException이 일어나 DB에 값을 세팅하지 못하게된 상황이다.

# ANALYSIS:

## [Problem 1 : addmap = [{code =all}] 인 경우 ]

## Machine의 JsonMakerandDBSet 결과

![[Untitled 41.png|Untitled 41.png]]

결과가 add일때 code =all이라는 결과를 담고 있다.

  

add, edit, del의 결과들은

```Java
ArrayList<Map<String, String>> maps = alertInfo(add, edit, del);
```

메서드로 보내지게 된다.

### alertInfo

```Java
 //addMap parsing Start
        for (Map<String, String> map : addMap) {
            Map<String, String> tempMap = new LinkedHashMap<>();
            tempMap.put("id", map.get("id").toString());
            tempMap.put("name", map.get("name"));
            tempMap.put("min", map.get("min").toString());
            tempMap.put("max", map.get("max").toString());
            tempMap.put("code" ,"add");

            result.add(tempMap);
        }
```

여기서 code=all인경우 해당하는 id가 없기 때문에 위와 같은 결과를 반환한다.

> [!important]  
> code all이 의미하는 것은 Machine/Food의 DB가 완전히 비어져있는 상황이다.즉 프로그램을 처음 수행시켰을 때 딱 한번 뿐이다.  

  

  

# CONCLUSION:

1. alertInfo에서 code= add인경우는 로직을 수행하지 않도록 지정한다.
2. 변경된 값이 없을 때에는 json 파일을 만들지 않는다.

# SOLVE:

## AlertInfo

```Java

   if(!editMap.isEmpty() && !editMap.get(0).containsValue("all")){
                for (Map<String, String> map : addMap) {
                    Map<String, String> tempMap = new LinkedHashMap<>();
                    tempMap.put("id", map.get("id").toString());
                    tempMap.put("name", map.get("name"));
                    tempMap.put("min", map.get("min").toString());
                    tempMap.put("max", map.get("max").toString());
                    tempMap.put("code", "add");

                    result.add(tempMap);
                }

            }
```

  
  
  
`!editMap.isEmpty() && !editMap.get(``**0**``).containsValue("all")`

조건을 추가해서 addMap, editMap의 code가 all인경우를 처리했다.

editMap, addMap의 크기를 비교하는 구문을 먼저 넣어야한다. editMap, addMap이 비어있는 경우도 존재하기 때문이다.

  

del의 결과가 없는 경우

```Java

    if (!delMap.isEmpty()) {
            // del parsing start
            for (Map<String, String> map : delMap) {
                Map<String, String> tempMap = new LinkedHashMap<>();
                tempMap.put("id", map.get("id").toString());
                tempMap.put("name", map.get("name"));
                tempMap.put("min", map.get("min").toString());
                tempMap.put("max", map.get("max").toString());
                tempMap.put("code", "del");

                result.add(tempMap);
            }
        }
```

위처럼 설정해서 실행되지 않도록 설정했다.

  

  

---

# REVIEW:

## @Transactional

해당 에러를 고치면서 정말 애를 먹었던 부분이 있는데

바로 @Transactional부분이다.

통합 테스트파일에서 테스트를 수행했고 애노테이션으로 @Transactional을 적용하고 왜 DB에 적용이 안되는지 한참 찾았다…

  

해당 애노테이션을 Test에 사용하게 되면

DB작업을 수행하고 수행하기 전으로 RollBack을 수행하게 된다. 실제로는 Save가 되었지만 Rollback을 해주기 때문에 TestDB에는 아무런 일도 일어나지 않은 것…

  

## 조건문의 순서

```Java
!editMap.isEmpty() && !editMap.get(0).containsValue("all")
```

!editMap.isEmpty() 구문을 call을 체크하는 구문 뒤로 보내게되면 무조건 true를 반환한다.

그 이유는 edtiMap.get(0)이 정상수행되면 editMap.isEmpty()는 무조건 True값을 가지게 되기 때문이다.

반대로 editMap이 아무런 값도 가지지 않는 경우, 즉 비어있는 경우에는 에러가 났었는데 이는

editMap이 비어있음에도 editMap.get(0)이 수행되서 그렇다.

따라서 조건의 순서를 주의하자.

  

자료들을 비교할 때에는 그 자료들을 담는 그릇이 비어있지 않아야함을 명심하고 있자