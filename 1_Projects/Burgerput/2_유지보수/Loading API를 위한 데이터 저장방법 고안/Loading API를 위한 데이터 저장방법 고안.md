---
Created time: Invalid date
Last edited time: Invalid date
Posted to Naver: true
Progress:
  - end
업로드할까?: true
created: 2024-05-07T14:37:00
updated: 2024-08-27T18:02
---
# [Goal]

1. API의 로딩 결과를 어떤 방식으로 저장할 지 최적의 방법을 선택한다.

# [Loading API의 특징]

1. Loading API는 매일 아침 로딩될 때 서로 다른 값(변경된 값, 추가된 값, 삭제된 값)을 가져오는 API이다. 즉 매일 가변할 수 있는 데이터이다.
2. LoadingAPI의 컨텐츠는 그리 많지 않다. 현재 식품/기기 모두 데이터의 레이블이 40개 이상 넘지 않는다.

  

현재 문서에서는 DB를 이용한 저장방법 이외의 최적의 방안을 찾고 찾아가 보려고 한다.

# GPT를 이용한 가이드

챗 지피티를 이용해 가이드를 조금 받았다. 시스템의 분석, 설계 부분에서 GPT의 도움을 받는 것은 섣부른 판단이 될 수도 있지만(경험이 풍부한 사람이 더 좋은 결과를 내놓는 경우가 많기 때문) 지금의 나에겐 절대적인 도움을 줄 수 있는 도구이다.

![[Untitled 32.png|Untitled 32.png]]

위의 답변을 기반으로 사용할 수 있는 기술들을 사전조사 해봤다.

# 1. Cache를 사용한 저장 방법

캐시는 메모리에 데이터를 미리 적재하고 이를 빠르게 읽어 응답한다. 따라서 읽기 동작이 많은 서비스에 캐시를 사용하면 서비스 응답속도를 향상시킬 수 있다.

  

그렇다면 LoadingAPI에서 사용하는 값을 캐시를 사용하면 어떻게 될까?

LoadingAPI는 가변값이다. 매일아침 로딩해서 바뀐 결과값을 리턴한다.

캐시의 특징에 따르면 바뀌지 않는 정적데이터를 캐시에 저장했다가 빠르게 응답해줄 때 최고의 효율이 나온다. 따라서 Cache를 통해 저장하는 방법은 적절하지 않다.

# 2. 파일 시스템에 저장

JSON, CSV파일로 직접 하드디스크에 데이터를 저장하는 방식이다. 특성상 프로그램에서 데이터를 접근하고 조작하는 것 이외에 별도의 제어가 없다. 파일을 읽고 쓰는 기능은 OS에서 기본으로 제공하기 때문에 별도의 설정이 필요하지 않고 간단하다. 또한 DB의 다양한 기능을 사용하지 않는 대신 빠르게 데이터를 읽을 수 있다.

파일 시스템의 단점

- 파일을 누구나 수정할 수 있다.
- 하나의 파일을 동시에 쓸 수 없다.(Data 불일치 문제 발생)
- 중복, 잘못된 데이터가 들어가도 사람이 직접 검사하지 않는 이상 확인할 수 없다.

  

위의 단점을 갖지만 Burgerput의 경우

- file에 read기능만 부여할 것(삭제는 필요하지만 수정 기능을 필요하지 않다.)
- file은 서버가 Loading을 실행하고 그 결과를 저장할 때 딱 한 번만 수행될 것(즉, 보안만 완벽하다면 중복해서 쓰는 경우는 발생하지 않는다.)
- 데이터의 검증은 Spring의 비즈니스 로직에서 이뤄진다.(데이터의 무결성은 Spring의 비지니스 로직에서 이뤄진다. 로직에 이상이 없다면 무결성은 보장된다.)

  

단일 사용자 환경, 규모가 작은 데이터 규모를 가진 Burgerput Project에 적합한 모습이다.

# 3. 메모리에 저장

메모리는 전류가 흘렀다 안흘렀다 하는 성질을 이용해 임시로 데이터를 저장한다. 즉 메모리는 전류가 끊기면 데이터가 사라지는 휘발성을 가진다.

  

메모리의 특징

- 메모리는 디스크에 비해서 액세스 속도가 훨씬 빠르다. 메모리에 데이터를 저장하면 데이터에 빠르게 액세스할 수 있고 빈번한 읽기 및 쓰기작업에서 유용하다.
- 디스크에서 데이터를 읽고 쓰는 것보다는 메모리에서 데이터를 처리하는 것이 더 빠르기 때문에 데이터 처리 성능이 향상된다.
- 메모리의 저장된 데이터는 시스템의 캐시 메커니즘에 의해 자동으로 캐싱될 수 있다.
- 별도의 DB나 파일 시스템같은 복잡한 시스템을 설정할 필요가 없다.
- 상대적으로 적은 오버헤드가 있기 때문에 작은 규모의 데이터에 대해 효율적이다.

# 4. NOSql

Not only SQL, SQL만을 사용하지 않는 데이터베이스 관리 시스템이다. noSQL은 데이터를 메모리에 캐싱하여 빠른 읽기를 제공하기때문에 DBMS보다 빠른 특징을 가지고 있다. 대용량의 데이터를 빠르게 처리할 수 있다.

noSQL 데이터베이스는 확장성, 유연서으 고성능의 장점을 가지고 있지만 일관성 보장, 쿼리 제한 등의 단점이 있다.

# 5. 외부 API

외부에서 API를 불러오는 것이다.

외부에서 불러오기 때문에 속도가 조금 느릴 수 있다.

  

참고로 우리는 사용할 외부 API가 없다…

# 6. 시간대별 데이터베이스 테이블

특정 시간 범위 내의 데이터를 효율적으로 저장하고 쿼리하는데 유용하다. 이벤트로그, 시계열 데이터와 같이 시간 정보가 중요한 데이터에 사용할 수 있다.

시간대별 데이터베이스는 시간대별로 정보를 모아 분석하는데 중요하다.

  

현재 LoadingAPI는 데이터를 따로 모아서 대시보드를 사용한다던가 하는 기능은 아직 생각하지 않고 있다.

  

---

현재 Loading API는 아직까지는 변화된 값을 보는 대쉬보드기능은 없다.

Loading API는 간단하고 데이터 크기가 크지 않다. 또한 현재 Loading된 데이터를 어떤 방식으로 저장할 것인지에 대해 생각하고 있다.

  

  

# 결론

### 1. 파일 시스템에 LoadingAPI 정보를 저장한다.

### 2. 파일시스템을 통해서 API를 읽는다.

  

빠른 성능을 위해 캐시와 메모리를 선택할 수도 있었지만

1. 데이터의 읽고 쓰기가 빈번하지 않다.
2. 데이터는 한 번만 로드되면 된다.

API가 위의 특성을 가지기 때문에 파일 시스템에 LoadingAPI정보를 저장하기로 선택했다.

파일의 형식은

20240425_LoadingAPI.json

20240426_LoadingAPI.json

의 형태로 저장되며 하루에 하나씩 json파일을 저장하기로 했다. 또한 로딩의 결과값이 없을 때도 파일을 저장하기로했다. API에서 읽어와야하기 때문이다.

  

---

> [!info] 파일 시스템 vs 데이터베이스 시스템 장단점 비교  
> 《 파일 시스템(File System)&nbsp;》파일 시스템은 파일(데이터의 모임)을 저장 장치에 저장하고 사용하.  
> [https://m.blog.naver.com/qbxlvnf11/221127762091](https://m.blog.naver.com/qbxlvnf11/221127762091)  

![[Store_API_data__alternatives(%EB%8D%B0%EC%9D%B4%ED%84%B0%EC%A0%80%EC%9E%A5%EB%B0%A9%EB%B2%95).mhtml]]