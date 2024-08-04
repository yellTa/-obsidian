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
# PROBLEM:

git을 통해 main브랜치가 아닌 브랜치에 push해도 cicd가 작동되는 현상이 발생했다…

ci/cd에서 문제가 발생한 만큼 yml파일을 고쳐보기로 했다.

# ANALYSIS:

### .github/workflows/cicd.yml

```CoffeeScript
name: burgerputCICD

# 해당 workflow가 언제 실행될 것인지에 대한 트리거를 지정
on:
  push:
    branches: [ main ] # main branch로 push 될 때 실행됩니다.
  pull_request:
    branches: [ main ]  # main branch로 pull request될 때 실행됩니다.

env:
```

  

![[Untitled 45.png|Untitled 45.png]]

front-end단의 ci/cd 지민이가 준 자료이다.

여기서 보면 나랑 조금 다른부분이 있다.

![[Untitled 1 17.png|Untitled 1 17.png]]

공식문서에도 보면 이런식으로 작성하라고 적혀있다.

  

  

# CONCLUSION:

### 공식 문서에 나온 방법으로 고쳐보자!

# SOLVE:

main브랜치로 push가 실행될 때 수행하도록 설정하고 fix/jpa에 push를 진행해보도록 하자

```CoffeeScript
name: burgerputCICD

# 해당 workflow가 언제 실행될 것인지에 대한 트리거를 지정
on:
  push:
    branches:
     - main # main branch로 push 될 때 실행됩니다.
#  pull_request:
#    branches: [ main ]  # main branch로 pull request될 때 실행됩니다.

env:
```

main브랜치로 설정을 해줬다.

  

## 결과 : CICD가 수행되지 않았따!!!!

  

이제 해당 파일을 main에 merge해보도록 하자 (실제 배포작업)

  

```CoffeeScript
5월 24 13:17 052424-13:17:35.log
```

merge후 서버에서 실행되고 생성된 log파일이다. 정상적으로 작동한다!!!

# REVIEW:

예전에 셋업할 때는 이리저리 블로그 글을 찾아서 했는데 공식문서를 찾아보고 예제를 블로그에서 찾아보는 방식이 더 정확한 것같다.

공식 문서만큼 정확한 것이 없으니 공식문서를 잘 활용하도록 하자

  

---

> [!info] 스크립트를 사용하여 실행기에서 코드 테스트 - GitHub Docs  
> CI(연속 통합)를 위해 필수 GitHub Actions 기능을 사용하는 방법입니다.  
> [https://docs.github.com/ko/actions/examples/using-scripts-to-test-your-code-on-a-runner](https://docs.github.com/ko/actions/examples/using-scripts-to-test-your-code-on-a-runner)