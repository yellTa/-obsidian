---
created: 2024-09-14 23:30
updated: 2024-09-15T13:14
tags:
  - develop
Progress:
  - end
post할까?: false
post됨: false
---
# OAuth를 통한 로그인처리... Issue 조사
# 네이버, 카카오, 구글같은 간편로그인으로 크롤링 페이지에서 로그인을 할 수 있을까?
말 그대로 셀레니움을 통해 WebDriver를 띄우고 OAuth를 활용한 간편로그인을 수행할 수 있을까 하는 실험이다.

# ANALYSIS:

## 간단하게 알아본 시나리오(테스트는 안해봄)
1. OAuth 로그인을 사용해 사용자가 로그인을 수행, 세션 쿠키와 토큰을 저장해 세션을 유지한다. 이때 세션쿠키의 정보와 토큰은 메모리 DB에 저장하던가 DB에 저장해서 사용하던가 로컬에서 저장관리해야하는 항목
   
2. WebDriver를 실행할 때 (즉, 크롤링이 실행될 때) 이전에 저장된 세션정보를 복원해 로그인된 상태를 유지한다.
   하지만 이것도 refresh토큰이 만료된 경우 다시 로그인해야됨 이건 어쩔 수 없음
   refreshToken이 만료된 경우에는 로그아웃이 된 경우임을 뜻하기 때문

![[Pasted image 20240913220131.png]]

# CONCLUSION:

구현은 가능하나 아주 많이 복잡하고 신경쓸 것이 많다...


---
# References

# 연결문서