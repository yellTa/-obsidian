---
created: 2024-10-09 10:15
updated: 2024-10-09T11:12
tags:
  - develop
Progress:
  - end
---
# 리뷰문서
[[🌳saveTask PR 정리]]
# OBJECT/SUBJECT:
## branch = feat/saveTask
# PR내용:
https://github.com/yellTa/boost2/pull/1#discussion_r1790267299

필요없는 내용은 .gitignore파일에 설정하도록 한다.
# ANALYSIS:

# 수행사항 
## .gitignore 파일에 .idea 경로 추가힉
``` java
### IntelliJ IDEA ###  
.idea/modules.xml  
.idea/jarRepositories.xml  
.idea/compiler.xml  
.idea/libraries/  
.idea  
*.iws  
*.iml  
*.ipr
```

git ignore 파일에 .idea 컨텐츠가 들어가지 않도록 설정했다.

---
# CONCLUSION:

## 원인 :
필요없는 파일을 git에 올렸기 때문

## 작업 :
### gitignore설정
필요없는 설정 파일이 들어가지 않도록 지정했다.

# 결론:

>[!important]
>PR 에 필요없는 파일은 gitignore에 저장하자!
# REVIEW:
크게 신경쓰지 못했던 부분인데 앞으로는 다같이 협업하는 파일에 IDE의 파일을 첨부하지 않도록 하자!


---
# References

# 연결문서
