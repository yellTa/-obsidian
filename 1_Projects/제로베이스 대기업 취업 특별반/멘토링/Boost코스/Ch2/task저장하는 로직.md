---
created: 2024-10-05 01:50
updated: 2024-10-07T00:37
tags:
  - develop
Progress:
  - ongoing
---
# OBJECT/SUBJECT:
## branch = feat/saveTask

# ANALYSIS:
## 과정 파악하기
### 사전 작업
DTO 객체 만들기

``` java
package boost.chaper2.dto;  
  
  
import java.util.Date;  
  
public class Task {  
    int user_id;  
    String title;  
    Date date;  
    String owner;  
    int priority;  
  
    public Task(){  
  
    }    public Task(String title, Date date, String owner, int priority){  
        this.title= title;  
        this.date = date;  
        this.owner = owner;  
        this.priority = priority;  
    }  
  
    public Task(int userId,String title, Date date, String owner, int priority){  
        this.user_id = userId;  
        this.title= title;  
        this.date = date;  
        this.owner = owner;  
        this.priority = priority;  
    }  
  
    public int getUser_id() {  
        return user_id;  
    }  
  
    public String getTitle() {  
        return title;  
    }  
  
    public Date getDate() {return date;}  
  
    public String getOwner() {  
        return owner;  
    }  
  
    public int getPriority() {  
        return priority;  
    }  
}
```

조회할 때는 user_id도 보내줄 생각이기 때문에 user_id를 auto_increment 설정을 DB에 부여했다.

만약 user_id가 없다면 데이터를 조회하고 조회해서 가져와야하는데 편리한 인덱싱을 위해서 설정했다.


### 1. Servlet에서 API 받아오기
request를 이용해서 API받아오기]

###### TaskServlet
``` java
@Override  
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {  
    request.setCharacterEncoding("utf-8");  
  
    StringBuilder jsonRead = new StringBuilder();  
  
    String line;  
    try(BufferedReader reader = request.getReader()){  
        while((line = reader.readLine()) !=null){  
            jsonRead.append(line);  
        }  
    }  
  
    String jsonString = jsonRead.toString();  
    ObjectMapper objectMapper = new ObjectMapper();  
    Task task = objectMapper.readValue(jsonString,Task.class);  
  
    response.setContentType("application/json");  
    response.setCharacterEncoding("UTF-8");  
    response.getWriter().write(task.toString());  
}
```

1. Request를 이용해서 body의 값을 읽어온다. 
2. 만들어진 String을 ObjectMapper를 통해서 json데이터를 Task객체로 생성한다. 


### 2. TaskDao객체 이용해서 값 저장하기
Date 객체 사용하기
Dao에서 sql을 사용해서 데이터 저장하기

1. driver연결
2. connection객체 가져오기
3. PreparedStatement가져오기
4. ResultSet(결과를 저장) 생성하기





---
## 가설 세우기



---

## 수행하기
### 설계 

### 실험해보기 (설계가 제대로 작동하는지)

### 수행할 작업 단위

---


# CONCLUSION:

## 원인 :

## 작업 :

## 결과 :

# 결론:
>[!important]


# REVIEW:


---
# References

# 연결문서
