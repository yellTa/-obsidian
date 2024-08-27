---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - end
on Naver: false
업로드할까?: false
created: 2023-12-06T17:51:00
updated: 2024-08-27T17:51
---
# Issue

Aws ubuntu에서 selenium을 실행시킬 때 에러가 발생했다.

주된 에러의 내용은

```Shell
chrome is no longer running so chromedriver is assuming that chrome has crashed.
```

  

So I did it a lots of ways from internet

1. Add chrome option

```Java
chrome_options = webdriver.ChromeOptions()

chrome_options.add_argument('--headless')

chrome_options.add_argument('--no-sandbox')

chrome_options.add_argument('--disable-dev-shm-usage')
```

  

1. Change chrome driver version

# How to solve this problem?

To know the reason I decided to start from first step.

  

## 1. Can Amazon Ubuntu run selenium with web Project?

[[ubuntu with tinySelenium Project]]

## 2. Can My ubuntu Local server run selenium?

[[ubuntu 서버 설정해보기…]]

# What should I prepare for my Test

1. Tiny selenium project
2. Amazon Web Service Linux server

  

---

# ==Conclusion==

The reason was Amazon AWS’s **specification.**

  

### swap (Disk Storage to RAM)

> [!important]  
> Swap → use Disk Storage as a RAM Storageso we got 3GB RAM for our AWS ubuntu server(지민이가 2GB를 스왑으로 사용함)  

  

### My Ubuntu local Server could work with tinySeleniumProject

> [!important]  
> I set up my local ubuntu server and upload TinySeleniumProject then it workedI didn’t add specific setup just add headless option and download chrome and used chromedriver  

  

---

# Prepare Tiny selenium Project

[[Prepare Tiny selenium project]]

## Note - CentOS

CentOS는 서비스를 종료

따라서 사람들이 ubuntu나 다른 것들을 많이 찾아보고있다.

  

---