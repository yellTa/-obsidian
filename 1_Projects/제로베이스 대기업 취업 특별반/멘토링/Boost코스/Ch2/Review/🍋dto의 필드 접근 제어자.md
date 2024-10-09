---
created: 2024-10-09 11:29
updated: 2024-10-09T11:35
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
https://github.com/yellTa/boost2/pull/1#discussion_r1792703494
## 요약 
TaskDTO의 getter만 제공한건 좋으나 필드의 접근 제어자가 default임
# ANALYSIS:
## Brain Storming
dto의 필드의 접근 제어자는 다른 곳에서 변경할 수 없도록 private로 설정해야함


# 수행사항 

``` java
  
public class Task {  
    private int user_id;  
    private String title;  
    @JsonFormat(pattern = "yyyy.MM.dd")  
    private java.sql.Date date;  
    private String owner;  
    private int priority;  
  
    private String progress;  
  
    public Task(){  
  
    }
```
접근 제어자를 모두 private로 변경했다.

---
# CONCLUSION:

## 원인 :
필드의 접근 제어자를 default로 설정 이러면 다른 곳에서 객체를 함부로 변경하게 될 수 있음
## 작업 :
접근 제어자를 private로 변경 

# 결론:
>[!important]
>Dto의 접근 제어자는 모두 private로 지정한다. 외부에서 변경할 일이 없다면 말이다.
# REVIEW:
이 부분도 섬세하게 생각하지 못했던 부분이다 ㅠㅠ 


---
# References

# 연결문서
