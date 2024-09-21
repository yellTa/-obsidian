---
created: 2024-09-21 16:25
updated: 2024-09-21T16:47
tags: 
출처: 
---
# 깃헙으로 프로젝트 관리하기
## 1.초기세팅 완료하기 
init 연동
remote 연결
readmd.md추가
첫번째 커밋 완료
## 2. develop 브랜치 만들기
Master는 유저가 쓰는거임 건드리면 안됨

## 3.Main branch 보호하기
근데 main브랜치는 default 브랜치로 protection rule이 이미 적용되어 있음
다른 브랜치를 보호하고 싶다면 사용함

## 4. github 프로젝트
프로젝트 만들어서 이슈 만들기 그리고 issue로부터 브랜치 따기

![[Pasted image 20240921163827.png]]
해야하는 일을 task로 등록하고 issue로 올린다음에 create a branch를 통해서 만들 수 있음

![[Pasted image 20240921163918.png]]
develop에서 만든다. 
왜냐?

feature에서 내감 ㅏㄴ들고 develop에 추가하고 develop이 안정적이면 그때 main에 넣는거니까

저런식으로 task하나 만들고 그 task에 맞는 그거 브랜치 따는거임
그래서 issue 다 따주고 시작하라고 하는 거임

팀원이라면 project에 들어가서 issue에 들어가서 확인한 다음에 branch 따서 만든 다음에 그대로 프로젝트 시작하면 되는 거임

## 5. feature에서 수정하고 push하기
코드를 수정하고 push한다.


``` java
C:\Users\bbubb\Desktop\Spring공부\demo>git add *

C:\Users\bbubb\Desktop\Spring공부\demo>git commit -m "feature A"
[feature/login 361679e] feature A
 2 files changed, 11 insertions(+)
 create mode 100644 src/main/java/OAuth/practice/demo/web/Sample.java

C:\Users\bbubb\Desktop\Spring공부\demo>git push

```

이때 branch에서 git push 하게되면 자기가 작업하는 branch에서 push함
## 6. pullrequest하기! master 말고 develop으로
![[Pasted image 20240921164655.png]]

main이 아니라 develop으로 보내야한다. 


# 설명

# 출처/참고
https://www.youtube.com/watch?v=tkkbYCajCjM
# 연결 문서

