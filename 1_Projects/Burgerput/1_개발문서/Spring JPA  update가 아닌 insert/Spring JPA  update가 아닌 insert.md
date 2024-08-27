---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - end
on Naver: true
업로드할까?: true
created: 2023-12-29T14:37:00
updated: 2024-08-27T20:40
---
# Given

- Spring JPA를 이용해서 데이터를 Update한다.
- CustomMachine과 CustomFood 테이블에 update를 해야한다.
- 사용자는 CustomMachine과 CustomFood에 들어있는 데이터 중 일부를 Update해야한다.

# When

- jpa의 save 메소드를 이용해서 새로운 데이터를 insert하는 것이 아닌 기존의 data를 update 하려한다.

# Then - ==error==

- 기존의 데이터를 선택해서 update하는 것이 아닌 새로운 데이터를 넣어버렸다.

### ==Before==

|   |   |   |   |
|---|---|---|---|
|num(pk)|id|min|max|
|1|82|145|185|
|2|83|145|185|

  

### ==After==

|   |   |   |   |
|---|---|---|---|
|num(pk)|id|min|max|
|1|82|145|185|
|2|83|145|185|
|==3==|==82==|==162==|==180==|
|==4==|==83==|==170==|==190==|

> [!important]  
> 이떄 CustomMachine과 CustomFood 객체 구성은 Mysql DB의 custom_food, custom_machine의 구성과 같다.  

---

# ==Given==

## PrintDataV1.java[customCheatMachine()]

```Java
customCheatMachineMap.put("initMin", Integer.toString(foundCheatMachine.getMin()));
customCheatMachineMap.put("initMax", Integer.toString(foundCheatMachine.getMax()));
```

![[Untitled 5.png|Untitled 5.png]]

  

add initMin , initMax data from machineRepository

  

## PrintDataV1.java[customCheatFood()]

```Java
customCheatFoodMap.put("initMin", Integer.toString(foundCheatFood.getMin()));
customCheatFoodMap.put("initMap", Integer.toString(foundCheatFood.getMax()));
```

![[Untitled 1.png]]

> [!important]  
> MachineRepository, FoodRepository has id ,name , min, max value from zenput  

---

# ==When==

### SaveData logic

  

### SaveData.java[Interface]

![[Untitled 2 2.png|Untitled 2 2.png]]

customCheatMachineDataSave()

customCheatFoodDataSave() 메소드를 인터페이스에 추가해준다.

  

### SaveDataV1.java[customCheatFoodDataSave()]

![[Untitled 3 2.png|Untitled 3 2.png]]

  

CustomFood 객체를 생성해서 post로 전달 받은 인자값을 저장한다.

저장한후 jpa의 save기능을 이용해서 저장한다.

  

### SaveDataV1.java[customCheatMachineDataSave()]

![[Untitled 4 2.png|Untitled 4 2.png]]

CustomMachine 객체를 생성해서 post로 전달 받은 인자값을 저장한다.

저장한후 jpa의 save기능을 이용해서 저장한다.

  

  

---

# ==Then -== ==error==

## SaveData 로직 오류

CustomFood, CustomMachine을 새롭게 생성한 후 저장하니 Update가 아닌 새로운 값을 insert해 버렸다.


---

# ==Solution==

## way1

![[Untitled 5 2.png|Untitled 5 2.png]]

@Modifying 애노테이션은 int 타입밖에 반환을 할 수 없다.

  

> [!important]  
> @Modifying 애노테이션을 이용해서 SQL 쿼리를 직접 날리는 경우 int 타입만 반환하기 떄문에 다른 객체 형식을 리턴할 수 없다.  

그렇기 때문에 @Modifying 애노테이션을 이용한 쿼리를 사용해 CustomFood, CustomMachine객체를 반환할 수 없게 되었다.

  

## 💰way2

> [!important]  
> 1. @Modifying 애노테이션을 사용해서 직접 Update하는 쿼리문 작성하기  

![[Untitled 6.png]]

따라서 해당 modifying 구문을 select 해서 customFood를 찾아주는 것이 아닌 아예 다이렉트로 update를 하는 구문으로 변경했다.

이때 ==@Param 애노테이션을 사용해서 매핑==하도록 설정했다. 자바에서 인자와 이름이 같은 경우 사용하지 않아도 되지만 아직 그렇게 세팅되지 않은 곳이 많기때문에 꼭 써주는 것이 좋다.

만약 CustomFood 객체를 찾아서 업데이트 하는 경우는

CustomFood.set(~~)를 이용해서 값을 업데이트 하면 된다.

  

> [!important]  
> 자동 번호를 num 그리고 젠풋 아이디를 DB에서 테이블 이름을 id로 설정했다. 참고로 JPA는 primary key를 id로 보기 때문에 쿼리 메소드를 사용할 수가 없었다.설계상 자동넘버가 부여되는 num은 id가 되어야 했고 젠풋에서 사용하는 id는 id가 아닌 다른 이름을 가졌어야 했다  

> [!info] 스프링 데이터 JPA - 벌크 업데이트  
> 모든 소스 코드는 여기에서 확인 가능합니다.  
> [https://jaime-note.tistory.com/53](https://jaime-note.tistory.com/53)  

---

  

# 아니다 다른 방법을 찾았다

@Id 는 그냥 Identifier다. 꼭 PK에게 부여하지 않아도 된다. 테스트해보고 알아냈다.