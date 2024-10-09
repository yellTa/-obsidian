---
created: 2024-10-09 11:14
updated: 2024-10-09T11:19
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
## PR 코멘트 링크
https://github.com/yellTa/boost2/pull/1#discussion_r1790289579
## 요약 
sql 대문자로 예약어 지키기
# ANALYSIS:
# 수행사항:
```java
String sql = "INSERT INTO tasks (title, date, owner, priority) VALUES(?,?,?,?)";
```

예약어를 대문자로 변경했다!

---
# CONCLUSION:

## 원인 :
예약여 규칙을 지키지 않았음
## 작업 :
SQL의 예약어를 대문자로 변경

# 결론:
에약어 규칙은 중요하다 지키려고하자!

# REVIEW:
별거 아니라고 생각했는데 의외로 신경써야하는 부분이어서 좀 놀랬다.

---
# References

# 연결문서
