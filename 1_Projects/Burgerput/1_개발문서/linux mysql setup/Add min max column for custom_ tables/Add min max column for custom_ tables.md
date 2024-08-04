---
created: 2024-08-03T14:37
updated: 2024-08-04T22:42
---
### 컬럼 추가

사용자를 위해 랜덤으로 zenput에 값을 넣는 로직을 구현하기 위해서는 custom_food, custom_machine테이블에 min max값이 추가로 설정되어야 한다.

  

![[Untitled 58.png|Untitled 58.png]]

```Java
mysql> Alter table custom_food add column min int;
mysql> Alter table custom_food add column max int;
mysql> Alter table custom_machine add column min int;
mysql> Alter table custom_machine add column max int;
```

  

테스트를 위해 데이터를 추가해준다.

![[Untitled 1 26.png|Untitled 1 26.png]]

```Java
mysql>Update custom_food set min=165, max = 182 where id =60;
```

  

  

---

## 추가!

null값으로 설정하고 스프링 프로젝트를 구동시키니 int value에 null값을 불러올 수 없다는 에러가 나타났다. 따라서 해당 테이블 컬럼을 모두 삭제하고 default값을 줘서 만드는 방향으로 수정했다.

  

### column 삭제

```Java
alter table custom_food drop column max;
alter table custom_food drop column min;

alter table custom_machine drop column max;
alter table custom_machine drop column min;


\#default값 설정
alter table custom_food add min int not null default 999;
alter table custom_food add max int not null default 999;

alter table custom_machine add min int not null default 999;
alter table custom_machine add max int not null default 999;
```

  

  

  

> [!info] [MySQL] 컬럼명 변경 / 컬럼 타입 및 디폴트값 변경 / 컬럼 삭제 및 추가 (예시로 쉽게)  
> - 칼럼명 변경하는 방법 > 기본 구조 ALTER TABLE 테이블명 CHANGE 변경 전이름 변경 후이름 칼럼타입; * 주의사항 not null이나 default 그리고 제약조건이 있는 칼럼의 이름을 변경할 때, 칼럼타입까지만 입력해주면 뒤에 설정한 값들이 초기화되고 컬럼타입만 유지가 됩니다.  
> [https://wnwa.tistory.com/50](https://wnwa.tistory.com/50)