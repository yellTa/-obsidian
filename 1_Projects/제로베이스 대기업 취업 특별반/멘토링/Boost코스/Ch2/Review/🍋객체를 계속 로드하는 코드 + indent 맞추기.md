---
created: 2024-10-09 10:26
updated: 2024-10-09T11:06
tags:
  - develop
Progress:
  - ongoing
---
# 리뷰문서
[[🌳saveTask PR 정리]]


# OBJECT/SUBJECT:
## branch = feat/saveTask

# PR내용: 
https://github.com/yellTa/boost2/pull/1#discussion_r1790269371

호출때마다 계속 재사용 드라이버를 호출하는 문제 

https://github.com/yellTa/boost2/pull/1#discussion_r1790277507
indent가 맞지 않던 문제
# ANALYSIS:
## Brain Storming
1. 싱글톤 패턴을 사용해서 객체를 재사용 하도록 변경하자


## 고려해야할 사항

# 수행사항 

## 싱글톤 패턴 사용해서 driver 로드하기
### 1. DatabaseManager 생성
```java  
public class DatabaseManager {  
	// instance는 DatabaseManager의 유일한 인스턴스 
	//static으로 선언되어 클래스 로딩 시 메모리에 올라가고 전역적으로 접근이 가능하다. 
	//method Area에 저장된다. 이 공간은 JVM이 클래스를 도르할 때 클래스에 대한 메타 데이터(클래스 정보, static 변수, static 메서드를 저장하는 영역  )

//static으로 지정된 변수와 메서드 는 클래스가 로드될 때 한 번만 생성되고, 프로그램 실행중 모든 클래스가 인스턴스에서 동일한 값을 참조할 수 있다.  

    private static DatabaseManager instance;  
    
    private static String dburl = "jdbc:mysql://localhost:3306/tables_in_connectdb";  
    private static String dbUser = "boost";  
    private static String dbpasswd = "boost";  
  
    private DatabaseManager(){  
        try {  
        //private생성자는 외부에서 Databasemanager클래스의 인스턴스를 생성하지 못하도록 막음 이를 통해 싱글톤 패턴을 유지하고 드라이버 로드는 한 번만 실행된다.
            Class.forName("com.mysql.cj.jdbc.Driver");  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }  
//싱글톤 인스턴스 반환 메서드 
// 멀티 스레드 환경에서의 동시성 문제를 해결하기 위해 synchronized 사용
// 두개 이상의 스레드가 동시에 getInstance 메서드를 호출해도 하나의 스레드만 instance를 생성할 수 있도록 보장한다. 

/*
만약 synchronized 가 없다면 동시에 여러 스레드가 getInstance 메서드를 호출해 instance가 중복으로 생성될 수 있다.

즉 synchronized 의 역할은 멀티 스레드 환경에서 싱글톤 인스턴스의 중복 생성을 방지학 ㅣ위함이다.
동기화는 멀티 스레드 환경에서 스레드 간의 동시 접근을 막는 역할을 한다.

하나의 스레드만이 이 메서드를 실행할 수 있도록 보장한다.
즉, 하나의 스레드만 접근 수 있어 다른 스레드가 코드 블록을 실행할 때 기다리게 된다. 이를 통해 instance가 null일때  여러 스레드가 동시에 접근하여 여러개의 인스턴스를 생성하는 것을 막는다.
*/
    public static synchronized  DatabaseManager getInstance(){  
        if(instance == null){  
            instance = new DatabaseManager();  
        }  
        return instance;  
    }  
  
  
    public Connection getConnection() throws SQLException {  
        return DriverManager.getConnection(dburl, dbUser, dbpasswd);  
    }  
  
    public void closeConnection(Connection conn, PreparedStatement ps ){  
        try {  
            if (ps != null) ps.close();  
            if (conn != null) conn.close();  
        } catch (SQLException e) {  
            e.printStackTrace();  
        }  
    }  
}
```
### 2.TaskDao 수정
```java

public class TaskDao {  
  
    public void saveData(Task task) {  
        Connection conn = null;  
        PreparedStatement ps = null;  
  
        String sql = "Insert into tasks (title, date, owner, priority) values(?,?,?,?)";  
        try {  
            conn = DatabaseManager.getInstance().getConnection();  
            ps = conn.prepareStatement(sql);  
  
            ps.setString(1, task.getTitle());  
            ps.setDate(2, task.getDate());  
            ps.setString(3, task.getOwner());  
            ps.setInt(4, task.getPriority());  
  
            ps.executeUpdate();  
  
        } catch (Exception e) {  
            e.printStackTrace();  
        } finally {  
            DatabaseManager.getInstance().closeConnection(conn, ps);  
        }  
    }  
}
```





---

## indent가 맞지 않던 부분 
``` java
try{  
    Class.forName("com.mysql.cj.jdbc.Driver");  
}catch(Exception e){  
    e.printStackTrace();  
}  
String sql = "Insert into tasks (title, date, owner, priority) values(?,?,?,?)";  
try (Connection conn = DriverManager.getConnection(dburl, dbUser, dbpasswd);  
PreparedStatement ps = conn.prepareStatement(sql)) {  
  
    ps.setString(1, task.getTitle());  
    ps.setDate(2, task.getDate());  
    ps.setString(3, task.getOwner());  
    ps.setInt(4, task.getPriority());  
  
    ps.executeUpdate();  
} catch (Exception e) {  
    e.printStackTrace();  
}
```

자세히 보면 catch문의 indent가 맞지 않는 것을 확인할 수 있다. intellij 의 ctrl + alt + j를 눌러서 맞춰주도록 하자 !



---
# CONCLUSION:

## 1. 싱글톤 패턴으로 Driver 로드하기
## 원인 : 
드라이버가 호출 때 마다 생성된다. 드라이버는 재사용될 수 있는 객체임에도 불구하고 호출 때 마다 생긴다.

## 작업 :

### DatabaseDriverManager를 이용해 싱글톤 패턴을 만들었다.

생성자를 private로 만들어서 외부에서 생성자를 만들 수 없도록 수행하고

synchronized를 이용해서 멀티 스레드 환경에서 인스턴스가 하나만 만들어질 수 있도록 지정했다. 

#### synchronized의 역할
getInstance() 메소드를 사용하면, Instance객체가 null인지 확인하고 없다면 새로 생성해서 리턴한다. synchronized는하나의 스레드만 접근가능하게 해서 인스턴스의 중복 생성을 방지한다.

#### static의 역할
static으로 생성된 변수, 메서드는 클래스 수준에서 하나만 존재하면 , 모든 인스턴스나 다른 클래스에서 접근할 수 있다. 

이는 Method Area에 저장이되고 이 공간은 JVM이 클래스를 로드할 때 클래스에 대한 메타 데이터를 저장하는 영역이다. 

## 결과 :
싱글톤 패턴으로 변경해서 객체를 하나만 불러오게 되었다!!! 


## 2. Indent 지정하기 
## 원인 :
들여쓰기를 맞춰서 하지 않았음

## 작업 :
인텔리제이의 코드 자동 정렬 기능을 사용해서 변경했다.
## 결과 :
code style이 적용되었다!!

# 결론:
>[!important]
# REVIEW:


---
# References

# 연결문서
