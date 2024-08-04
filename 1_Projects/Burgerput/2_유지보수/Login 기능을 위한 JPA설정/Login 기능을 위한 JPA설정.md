---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: false
Progress: end
업로드할까?: false
created: 2024-08-03T14:37
updated: 2024-08-04T22:42
---
# Domain 추가

![[Untitled 37.png|Untitled 37.png]]

MasterAccount추가

  

### MasterAccount

```Java
@Data
@Entity
public class MasterAccount {

    @Id
    @JsonIgnore
    @Column(name="master_id")
    private String masterId;

    @Column(name="master_pw")
    private  String master;

}
```

컬럼은 단 2개

ID와 PW만 필요하기 때문에 두 가지만 사용했고 로그인 용도로만 사용된다. 즉 회원의 정보를 가입하는 기능은 부여하지 않았다.

  

## 프로그램 수행 결과

![[Untitled 1 13.png|Untitled 1 13.png]]

TEST DB에 정상적으로 Table이 생성된 것을 확인할 수 있다.

  

## 회원가입을 고려하지 않은 이유

1. 사용하는 매장이 단 한 곳이다.
2. 모르는 사용자의 진입을 막기위해 로그인 기능을 만들기로 했다. 하지만 매장당 한 번의 로그인을 수행하도록 즉, 되도록이면 로그인 자동저장 기능을 사용해서 한 번만 로그인하면 쭉 사용할 수 있도록 세팅하고 싶었다. (생각보다 유저들은 많은 것을 귀찮아 한다. 사용할 때마다 로그인하면 귀찮아서 안쓸 것 같았다.)