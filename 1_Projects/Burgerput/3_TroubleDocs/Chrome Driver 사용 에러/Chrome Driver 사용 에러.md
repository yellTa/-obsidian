---
progress:
  - end
Created time: Invalid date
Last edited time: Invalid date
Review여부: true
post됨: false
post할까?: false
created: 2024-06-24T14:37:00
updated: 2024-10-02T18:51
---
# SUBJECT:

6월 4일 이후로 Burgerput사용이 중지되었음 → 확인해보니 프로그램을 사용할 수 없는 지경

그리고 매일 아침 로딩이 실패하고 있었다…

메일에서는 현재 공란으로 오기때문에 실제로 로딩이 잘 됐는지 되지 않았는지 확인할 수 없었음

# ANALYSIS:

## 문제 상황

```Java

2024-06-24T08:34:08.823+09:00  INFO 540230 --- [nio-8080-exec-6] b.p.z.web.altPages.LoadingController     : Machine getInfo logic False
2024-06-24T08:34:08.823+09:00  INFO 540230 --- [nio-8080-exec-6] b.p.z.web.altPages.LoadingController     : io.github.bonigarcia.wdm.config.WebDriverManagerException: java.lang.NumberFormatException: For input string: "public"
2024-06-24T08:34:13.958+09:00  INFO 540230 --- [io-8080-exec-10] p.z.S.l.z.MachineLoadingAndEnterZenputV2 : Food Get Info Logic Start f rom MachineLoadingAndEnterZenputV2
Hibernate: select a1_0.num,a1_0.rbi_id,a1_0.rbi_pw,a1_0.zenput_id from accounts a1_0
2024-06-24T08:34:13.971+09:00  INFO 540230 --- [io-8080-exec-10] i.g.bonigarcia.wdm.WebDriverManager      : Using chromedriver public (resolved driver for Chrome 122)
2024-06-24T08:34:13.977+09:00  INFO 540230 --- [io-8080-exec-10] i.g.b.wdm.cache.ResolutionCache          : Clearing WebDriverManager resolution cache
2024-06-24T08:34:13.977+09:00  WARN 540230 --- [io-8080-exec-10] i.g.bonigarcia.wdm.WebDriverManager      : There was an error managing chromedriver public (For input string: "public") ... trying again avoiding reading release from repository
2024-06-24T08:34:14.067+09:00  WARN 540230 --- [io-8080-exec-10] i.g.bonigarcia.wdm.WebDriverManager      : There was an error managing chromedriver (latest version) (For input string: "public") ... trying again using latest driver stored in cache
2024-06-24T08:34:14.069+09:00  INFO 540230 --- [io-8080-exec-10] i.g.bonigarcia.wdm.WebDriverManager      : Using chromedriver public (resolved driver for Chrome 122)
2024-06-24T08:34:14.071+09:00 ERROR 540230 --- [io-8080-exec-10] i.g.bonigarcia.wdm.WebDriverManager      : There was an error managing chromedriver public (For input string: "public")
...
```
에러 코드에서보면 "public"문자열이 입력되고 그걸 처리하는데 문제가 생긴것 같다. 
## 해당 에러의 원인

> [!important]  
> MovePageServiceV1  

```Java
 @Override
    public WebDriver gotoListWithLogin() {

        //zenputAccoutns setup
        zenputAccountSetting();

        System.setProperty("java.awt.headless", "false");
        WebDriverManager.chromedriver().setup();

        //remove being controlled option information bar
        ChromeOptions options = new ChromeOptions();
        options.setExperimentalOption("excludeSwitches", new String[]{"enable-automation"});

        //서버에서 돌려서 안돼서 추가한 옵션
        options.addArguments("--headless=new");
        options.addArguments("--single-process");
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        
        ...
        
```

WebDrivermanager.chromeDriver().setup() 으로 크롬드라이버를 가져온다.

기본적으로 최신 버전의 ChromeDriver를 자동으로 설정하도록 되어있지만 public이라는 문자열이 어디선가 잘못된 값으로 전달되어 발생하는 것 같다.

내가 짠 코드에서 아무리 찾아봐도 public이라는 문자를 사용하는 곳이 없었기 때문에 버전 충돌 문제라는 생각이 들었다.

### 디버그 레벨 설정하기

왜 에러가 나는지 정확하게 체크하기 위해서 DEBUG기능을 사용하기로 했다.

#### 1. Add Logback Dependency

```Java
    // SLF4J and Logback for logging
    implementation 'org.slf4j:slf4j-api:1.7.32'
    implementation 'ch.qos.logback:logback-classic:1.2.6'
```

  

#### 2. Application.properties지정

```Java
# Root logging level
logging.level.root=INFO
# root loggin level을 INFO로 지정

# Package-specific logging levels
logging.level.org.springframework.web=DEBUG
logging.level.io.github.bonigarcia.wdm=DEBUG

#지정한 패키지들의 loggig level을 DEBUG로 지정

# Logging pattern for console output
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} - %msg%n
# 콘솔에 뿌려질 로깅 패턴 지정

# Logging pattern for file output
logging.pattern.file=%d{yyyy-MM-dd HH:mm:ss} - %msg%n
# 콘솔에 뿌려진 파일 지정

# Path to store the log files
logging.file.path=logs
# log 파일이 어디에 저장되는지

# Name of the log file
logging.file.name=application.log
#로그파일의 이름을 지정
```

로그파일을 보기위한 세팅을 추가한다.

  

#### 3. webDriverManager DEBUG레벨 단에서 체크

```Java

WebDriverManager.chromedriver().setup()
```

웹 드라이버에러를 확인하기위해서 로그레벨을 지정한다.

이떄 WebDriverManager 5.6.2버전이랑 호환이 되지 않는 것 같았다.

  

#### 4. 호환문제를 위해 WebDriverManager 업그레이드  
  

> [!important]  
> build.gradle  

```Java
 //webDriverManger
//    implementation group: 'io.github.bonigarcia', name: 'webdrivermanager', version: '5.6.2'
    implementation 'io.github.bonigarcia:webdrivermanager:5.8.0' // 버전 업그레이드 
```

WebDriverManager파일을 업그레이드 했다. 했는데 여전히 되지 않았다.

  

알고보니 이미 Application.properties에서 지정을 해놓았기 때문에

```Java
WebDriverManager.chromedriver().setup()
```

위의 코드만 보아도 됐었다.

  

### 2. 버전 업그레이드

버전을 업그레이드하는 것으로 버그의 꽤 많은 것을 고칠 수 있다.


현재 버전 : 5.6.2 → 업그레이드 할 최신 버전 5.8.0

[https://mvnrepository.com/artifact/io.github.bonigarcia/webdrivermanager/5.8.0](https://mvnrepository.com/artifact/io.github.bonigarcia/webdrivermanager/5.8.0)

  

### 5.6.2 에서 5.8.0으로 변하면서 바뀐 점 - 간단하게

- Driver 관리 향상
- Dependncy 업데이트
- 버그수정
- 신기능
- 설정변경
- 보안 업데이트
-

해당 사안은 GitHub사이트와 Maven Central사이트를 참고해서 비교한 자료이다.

chatgpt제공

Searched 4 sites

Upgrading from WebDriverManager version 5.6.2 to 5.8.0 includes several key changes, enhancements, and bug fixes. Here are the notable differences and improvements:

### Changes and Enhancements:

1. **Driver Management Improvements**:
    - Enhanced support for detecting and managing browser drivers, ensuring compatibility with newer versions of browsers and operating systems ([GitHub](https://github.com/bonigarcia/webdrivermanager/blob/master/CHANGELOG.md)) ([Maven Central](https://central.sonatype.com/artifact/io.github.bonigarcia/webdrivermanager)).
2. **Dependency Updates**:
    - Dependencies such as `httpclient5`, `commons-lang3`, and `commons-compress` have been updated to their latest versions, improving overall stability and performance ([Maven Central](https://central.sonatype.com/artifact/io.github.bonigarcia/webdrivermanager)).
3. **Bug Fixes**:
    - Numerous bug fixes have been implemented to address issues such as the proper handling of cache paths, better support for ARM64 architecture, and improved handling of browser version detection on different platforms ([GitHub](https://github.com/bonigarcia/webdrivermanager/blob/master/CHANGELOG.md)).
4. **New Features**:
    - Introduction of new API methods to support Docker integration, including methods to specify extra hosts and manage Docker containers for running browsers. These features enhance the flexibility of running tests in isolated environments ([GitHub](https://github.com/bonigarcia/webdrivermanager/blob/master/CHANGELOG.md)).
5. **Configuration Changes**:
    - Improvements in configuration management, including more robust handling of environment variables and better support for customizing the behavior of WebDriverManager through configuration files ([Maven Central](https://central.sonatype.com/artifact/io.github.bonigarcia/webdrivermanager)).

### Security Fixes:

- The update includes fixes for vulnerabilities in dependencies, ensuring that the overall security of the WebDriverManager setup is improved. Specific vulnerabilities addressed are not detailed, but the general practice of updating dependencies typically includes such fixes ([Maven Central](https://central.sonatype.com/artifact/io.github.bonigarcia/webdrivermanager)).

Upgrading to version 5.8.0 should provide better compatibility with the latest browser versions, improved performance, and enhanced security. Always review the [release notes](https://github.com/bonigarcia/webdrivermanager/releases) for detailed information on each update.

  

### 3. 캐시를 지우고 수행하기
이미 서버에 캐시 메모리에 지정된 드라이버를 사용하는 과정에서 문제가 발생할 수 있다.

#### 캐시를 지우고 수행하는 방법의 장 단점 - pros/cons
##### pros:

**충돌이슈 해결** : 캐시를 지워 새로운 파일을 다운받아서 수행하기 때문에 기존 driver가 가지고 있는문제를 해결할 수 있다.

  

**최신버전 사용 유지**: 캐시를 지우므로 WebDrivermanager가 최신을 사용할 수 있도록 유지한다. 최신버전을 사용하면 업데이트, 버그 fix가 된 기능을 사용할 수 있게 된다.


##### cons

**느린 초기화 :** 캐시를 지우고 새로 파일을 매번 받아야하기 때문에 속도가 저하될 수 있다.

네트워크에 의존적: 네트워크가 수행되는 상황에서만 가능하다.(파일을 새로 받아야하기 때문 )

# HOW TO:

## 1. 1번과 2번의 방법을 채택(WebDriver버전 올리기, 디버그레벨에서 확인하기)

### 1. 디버그 레벨 확인하기

이 방법은 문제를 해결하기 위한 방법은 아니고 원인을 파악하기 위한 방법이다. 문제의 정확한 원인을 파악하기 위해 넣었다.  

### 2. 웹 드라이버의 버전 올리기

디버그 레벨을 확인하기위해 필연적으로 웹 드라이버의 버전을 올렸다. 이제 DEBUG로그를 통해서 webDriverManger.setup()이 일어날때 정확히 어떤일이 일어나는지 확인하게 되었다.

위의 방법을 수행하고 만약 성공한다면 문제는 Chrome WebDriver의 버전 때문에 문제가 일어난 것으로 판단이 된다.

---

위의 과정을 통해서 빌드를 다시 수행하고 일단 Selenium이 서버에서 구동이 되는 것을 확인했다.

이때 build과정에서 충돌이 일어나서 애를 먹고 다시 logBack 의존성을 삭제했다.

```Java
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
    implementation 'org.springframework.boot:spring-boot-starter-web'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'
    testCompileOnly 'org.projectlombok:lombok'
    testAnnotationProcessor 'org.projectlombok:lombok'
    
    // Selenium and WebDriverManager
    implementation 'org.seleniumhq.selenium:selenium-java:4.15.0'
    implementation 'io.github.bonigarcia:webdrivermanager:5.8.0'
    
    // JSON Data parsing dependency
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.json:json:20211205'

    // Database dependencies
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    runtimeOnly 'com.h2database:h2'
    implementation 'mysql:mysql-connector-java:8.0.33'
    
    // Thymeleaf layout dialect
    implementation 'nz.net.ultraq.thymeleaf:thymeleaf-layout-dialect'
    
    // Without Tomcat reload
    implementation 'org.springframework:springloaded:1.2.6.RELEASE'
}
```

현재 사용하는 Dependencies의 목록이다.

Spring boot starter는 기본적으로 Srping-boot-starter-logging을 포함하기 때문에 별도의 Logback을 추가하지 않아도 된다.  

```Java
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
```

또한 Application.properties에 출력 구문을 위 처럼 변경했다.

2023-06-24 15:30:45 [main] INFO com.example.MyClass - This is an info message

위와 같은 구문을 가지게 된다.


# CONCLUSION:

이번 사건은 WebDriverManager의 버전과 관련된 문제라고 봐도 무방할 것같다.

## 원인 :

1. WebDriverManager가 제대로 드라이버를 가져오지 못해서 아예 웹 접근 로직이 수행되지 못함
2. 서버의 관리자가 서버의 수행사항을 제대로 돌보지 않음  
    이건 온전히 나의 잘못이다. 서버를 배포하고 제대로 신경쓰지 않은 탓에(잘 돌아가겠거니 하고 믿어버림) 서버가 먹통되었었다. 실제로 나의 고객(눈물)들은 괜히 이거저거 할꺼 미안하다며 에러사항을 말해주지 않았다 ㅋㅋㅋㅋ  
    

## 작업 :

WebDriverMangaer의 버전 업데이트 수행
## 결과 :

Selenium 라이브러리 내용 정상작동
### 결론

> _**아 서버는 언제나 많은 신경을 기울여야하는구나… 기능 개발이 제일 중요한 것은 아니구나…**_

---

일단은 서버에 BugFIX버전을 올려놓았다. 나중에 main에 업데이트하고 수행해봐야겠다.

---

# REVIEW

CS기본지식의 필요성을 느끼게 된 결과였다.

단순히 내가 서버를 제대로 체크하지 않은 것도 있지만 하지만 처리 방법중 캐시에 있는 데이터를 지우고 수행하면 작동한다는 가설도 있었다.

하지만 단순히 캐시를 지우고 다시시작했을 때 서버의 속도가 저하될 수 있다는 사실을 CS공부를 통해서 미리 알고있었기 때문에 해당 조건을 배제시킬 수 있었다.

프로젝트를 진행하면서 문제를 해결하는 조건이 주어졌을 때 그 조건을 뒤따르는 여러 문제들 장/단점을 CS배경지식을 조금 더 폭넓게 바라보게 되는 계기가 되었다.

이런 부분은 미리 습득하고 있지 않으면 직접 조사해 찾아봐야하는 사안들이다. 실제 개발을 수행 할때는 문제 해결에 포커싱이 되어 있기 때문에 여러 조건을 다방면으로 생각하기에는 단순 조사로는 부족하다는 생각이 들었다.

그래서 기본적인 CS지식을 습득해 해당 문제를 해결할때 어떤 결과를 초래하고, 왜 이런 결과가 나오는지 아는것이 중요하다고 생각한다.

또한 기억은 발화하기때문에 자주자주 보면서 꼭꼭 머릿속에 두어야겠다는 생각이 들었다.