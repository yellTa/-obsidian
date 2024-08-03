---
Created time: Invalid date
Last edited time: Invalid date
Progress: end
on Naver: false
업로드할까?: false
---
# Zenput Cheat 기능 개발

1. Mysql custom table에 min, max 값 추가
2. Spring JPA domain 수정
3. CheatController가 사용하는 PrintData saveData 메소드 작성
    
    1. PrintData와 SaveData는 DB에 있는 정보를 출력하고 가져오는 역할
    
      
    
4. API통신을 위한 CheatController 작성

## 1. Mysql Custom table min max 값 추가

[📙Add min max column for custom_ tables](https://www.notion.so/Add-min-max-column-for-custom_-tables-36565f738fbe43f58c7fa6999d0a0b8f?pvs=21)

  

## 2. Spring JPA domain 수정

### customFood.java

![[images/Untitled 26.png|Untitled 26.png]]

min, max 값 추가

  

### customMachine.java

![[images/Untitled 1 6.png|Untitled 1 6.png]]

  

## 3. PrintData SaveData 메소드 작성

### PrintData Logic

  

![[images/Untitled 2 5.png|Untitled 2 5.png]]

Print Data 인터페이스에 해당 메소드 추가

### 로직 상세

1. customMachineRepository에서 CustomMachine 객체를 가져온다.
2. CustomMachine에 들어있는 객체들의 수 만큼 반복문을 돌린다.(모든 값을 출력하기 위함)
3. MachineRepository에서 id에 해당하는 Machine객체를 가져온다. 이때 Machine은 CustomMachine과 다른 객체이다.  
      
    ==**Machine이 갖는 정보**==  
    id, name, min, max (min, max 는 젠풋을 기준으로 한 값이다.)  
      
      
    ==**CustomMachine이 갖는 정보  
      
    **====i====d, min, max(min, max 는 커스텀 온도 정보이다. 젠풋의 min, max기준을 넘지 않는다.)==
4. Map객체를 생성해 값을 저장할 저장소를 만든다.
5. 반환할 정보들을 Map에 담는다. 이때 들어가야 하는 정보는 id, name, min, max이며 Cheat를 이용하기 때문에 min, max는 CustomMachine에서 정보를 가져오도록 한다.  
    id와 name은 Machine DB에서 가져와도 상관이 없다. 어짜피 이름은 Machine에서만 가져와야 한다.  
    
6. ArrayList에 Map을 저장하여 반환한다.

  

---

## 2023 12/29 changes

API 구성 정보 변경

### 변경 전

### 변경 후

id, name , min (custom), max(custom)

id, name, min(custom), max(custom), initMin(zenput), initMax(zenput)

  

### CustomMachineRepository

```Java
@Modifying(clearAutomatically = true)
    @Query(value = "update custom_machine set min = :min, max = :max where id = :id", nativeQuery = true)
    public void updateMy(@Param("id")int id, @Param("min") int min, @Param("max") int max);
```

  

### CustomFoodRepository

```Java
@Modifying(clearAutomatically = true)
    @Query(value = "update custom_food set min = :min, max = :max where id = :id", nativeQuery = true)
    public void updateMy(@Param("id")int id, @Param("min") int min, @Param("max") int max);
```

  

### SaveDataV1.java[customCheatFoodDataSave()]

![[images/Untitled 3 5.png|Untitled 3 5.png]]

### SaveDataV1.java[customCheatMachineDataSave()]

![[images/Untitled 4 4.png|Untitled 4 4.png]]

  

  

  

  

## 결과

### PostMan Food JSON TEST value

```Java
[
   {
      "id":"34",
      "name":"롱치킨 패티 (Long Chicken patty FULLY)",
      "min":"165",
      "max":"185"
   },
   {
      "id":"1147",
      "name":"콘샐러드 (CORN SALAD) ",
      "min":"38",
      "max":"40"
   },
   {
      "id":"1154",
      "name":"커피 (COFFEE) ",
      "min":"170",
      "max":"200"
   },
   {
      "id":"1168",
      "name":"탄산음료 (SOFT DRINK) ",
      "min":"34",
      "max":"38"
   }
]
```

![[images/Untitled 5 4.png|Untitled 5 4.png]]

DB에 정상적으로 수행된 것을 확인할 수 있다.

### PostMan Machine JSON Data values

```Java
[
   {
      "id":"62",
      "name":"멀티프라이어2",
      "min":"355",
      "max":"360"

   },
   {
      "id":"32",
      "name":"멀티프라이어1",
      "min":"360",
      "max":"363"
   },
   {
      "id":"39",
      "name":"3조싱크칸(세척온수)",
      "min":"121",
      "max":"127"
   }
]
```

![[images/Untitled 6 3.png|Untitled 6 3.png]]

DB에 정상적으로 값이 들어간 것을 확인할 수 있다.