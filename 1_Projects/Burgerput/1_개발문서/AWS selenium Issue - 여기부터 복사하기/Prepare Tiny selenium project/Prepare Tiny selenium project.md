## 프로젝트 생성

![[images/Untitled 52.png|Untitled 52.png]]

  

  

  

## 프로젝트 셋업

  

### Build.gradle

```Java
//	implementation 'org.seleniumhq.selenium:selenium-java:3.141.59'
	implementation group: 'org.seleniumhq.selenium', name: 'selenium-java', version: '4.11.0'

	//webDriverManger
	implementation group: 'io.github.bonigarcia', name: 'webdrivermanager', version: '5.6.2'
```

WebDriver manager → for auto update chrome driver

selenium →for controlling web site

### NaverController.java

```Java
@Slf4j
@ResponseBody
@Controller
public class NaverController {

    @GetMapping("/naver")
    public String naverSelenium() {

        log.info("start Selenium");

        System.setProperty("java.awt.headless", "false");
        try {
//            System.setProperty("webdriver.chrome.driver", DRIVERLOCATION);
            //chrome driver use

            //remove being controlled option information bar
            ChromeOptions options = new ChromeOptions();
            options.setExperimentalOption("excludeSwitches", new String[]{"enable-automation"});;
            //서버에서 돌려서 안돼서 추가한 옵션
            options.addArguments("--no-sandbox");
            options.addArguments("--headless=new");
            options.addArguments("--disable-dev-shm-usage");
            options.addArguments("--single-process");
            options.addArguments("--remote-allow-origins=*");
//            options.setBinary("/opt/google/chrome/");
            //서버에서 돌려서 어쩌구 옵션 끝
            WebDriver driver = new ChromeDriver(options);
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
//            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
            //==============================Scrape LOGIC START============================

            //GO TO PAGE
            driver.get("https://www.naver.com");

            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(20));
            Thread.sleep(3000);
            //no thanks button click
            WebElement search = driver.findElement(By.id("query"));
            search.sendKeys("됐다");
            search.click();

        } catch (StaleElementReferenceException e) {
            log.info("noSuchEletmet = {}", e);

        } catch (Exception e) {
            log.info("Thread.sleep error [{}]", e);
        }

        return "start";
    }
}
```

  

### Resources/static

### index.html

```HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hello Naver</title>
    <link rel="stylesheet" href="/css/css.css" type="text/css">
</head>
<body>
    <p class="description">A simple pure CSS hover effect</p>
    <button class="btn" onClick="location.href='/naver'" ><span>Hover me!</span></button>
</body>
</html>
```

버튼을 누르면 /naver 링크로 이동하는 사이트

/naver링크로 이동하면 검색 창에서 글자를 쓰는 selenium 코드이다.

  

## Chrome Driver 매니저 설치 - chromedriver자동 설치

Build.gradle 에서 webdriverManager 의존성 추가

  

```Java
//automatic web driver management through webdrivermanager
            WebDriverManager.chromedriver().setup();
```

> [!info] Selenium_WebDriverManager  
> 웹 자동화를 하면서 웹 드라이버를 사용했습니다.  
> [https://sw-test.tistory.com/31](https://sw-test.tistory.com/31)  

  

---

  

# ==Error - selenium not support cdp 119version==

![[images/Untitled 1 20.png|Untitled 1 20.png]]

selenium 이 해당 119 cdp를 지원하지 않음

  

## build.gradle

```Java
//	implementation 'org.seleniumhq.selenium:selenium-java:3.141.59'
	implementation group: 'org.seleniumhq.selenium', name: 'selenium-java', version: '4.15.0'
```

selenium version 4.15.0 으로 업데이트

# ==Error - not working==

not working…

  

---

# ==solution==

## NaverController.java

```Java
//            options.addArguments("--no-sandbox");
//            options.addArguments("--headless=new");
//            options.addArguments("--disable-dev-shm-usage");
//            options.addArguments("--single-process");
//            options.addArguments("--remote-allow-origins=*");
//            options.setBinary("/opt/google/chrome/");
```

comment out options