---
created: 2024-08-03T14:21
updated: 2024-08-03T14:25
---
# Issue

Aws ubuntu에서 selenium을 실행시킬 때 에러가 발생했다.

주된 에러의 내용은

```bash
chrome is no longer running so chromedriver is assuming that chrome has crashed.
```

So I did it a lots of ways from internet

1. Add chrome option

```java
chrome_options = webdriver.ChromeOptions()

chrome_options.add_argument('--headless')

chrome_options.add_argument('--no-sandbox')

chrome_options.add_argument('--disable-dev-shm-usage')
```

1. Change chrome driver version

# How to solve this problem?

To know the reason I decided to start from first step.

## 1. Can Amazon Ubuntu run selenium with web Project?

### ubuntu with tinySelenium Project
#### Tiny selenium project update to AWS
![[tinySeleniumProject.zip]]

tinyProject zip file

![[Pasted image 20240803142538.png]]
upload to AWS EC2

#### Result

#### Error
![[Pasted image 20240803142545.png]]
chrome driver download completed but no longer error occurred

#### Reason - 추측

아마도 GUI를 지원하지 않는 ubuntu에서 셀레니움을 돌리면 에러가 나는 듯 하다. 이를 방지하기 위헤

chrome headless 옵션을 추가하는 것

> GUI모드로 돌리면 이미지, 기타등등을 로딩해야하기 때문에 자원도 많이 소모하고 시간도 많이 돌린다. 효율성을 위해서는 headless로 자원을 아끼는 것이 좋다.

[[파이썬-셀레니움] 셀레니움 속도 향상을 위한 5가지 팁](https://dsconsulting.tistory.com/entry/%ED%8C%8C%EC%9D%B4%EC%8D%AC-%EC%85%80%EB%A0%88%EB%8B%88%EC%9B%80-%EC%85%80%EB%A0%88%EB%8B%88%EC%9B%80-%EC%86%8D%EB%8F%84-%ED%96%A5%EC%83%81%EC%9D%84-%EC%9C%84%ED%95%9C-5%EA%B0%80%EC%A7%80-%ED%8C%81)

---

#### way1 - tinyProject에 headless option 추가해보기(실 프로젝트에선 작동하지 않았음)

```bash
WebElement naverLogin = driver.findElement(By.className("MyView-module__login_text___G0Dzv"));
text = naverLogin.getText();
log.info("[RESULTTTTTTT] :   {}", text );
```

네이버 홈페이지에서 로그인 창 위

“네이버를 더 안전하고 편리하게 이용하세요” 문구를 가져오는 코드

```java
options.addArguments("--disable-popup-blocking");       //팝업안띄움
options.addArguments("--disable-gpu");			//gpu 비활성화
options.addArguments("--blink-settings=imagesEnabled=false"); //이미지 다운 안받음
options.addArguments("--no-sandbox");
options.addArguments("--headless=new");
options.addArguments("--disable-dev-shm-usage");
```

위의 옵션을 추가했다.

> 로컬 실험 환경에서는 새로운 창을 띄우지 않고 정상 작동했다.

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/3cf2a7d4-63a6-42bc-a06c-c86736078f1f/e87b942d-b28c-4770-821f-5715f6ff21df/Untitled.png)

TimeoutException Occured

정상작동하지 않는다.

<aside> 💡 아마도!… 사양이 너무 낮아서 그런것 같다. chromeDriver가 제대로 실행은 되는데 너무 오래걸려서…

</aside>

#### way2 - ubuntu에 selenium xvfb설치 selenium standaloneserver 구동시켜보기

아래와 같이 selenium standalone server를 설치했다…

[How to Setup Selenium with ChromeDriver on Ubuntu 22.04, 20.04 & 18.04 – TecAdmin](https://tecadmin.net/setup-selenium-chromedriver-on-ubuntu/)

[setup-headless-selenium-xvfb.sh](https://gist.github.com/alonisser/11192482)

위의 링크에 나온 방법으로 xvfb를 켜보았지만 SpringBoot에 selenium을 이식하고 작동하지 않았다.

root 계정으로 새로운 user 생성

username : remote

userpasswd : remote

#### way3 - ubuntu에 GUI 환경 설치해보기…

[[AWS] [활용] EC2 Ubuntu RDP(원격데스크톱) 연결하기](https://cloud-oky.tistory.com/3421)

xrdp패키지와 xfce4 패키지를 다운로드 받아서 GUI환경 설치

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/3cf2a7d4-63a6-42bc-a06c-c86736078f1f/2f302071-b57c-42b7-abc1-336df2cc8e01/Untitled.png)

Unable to locate package 에러 발생

```bash
apt-get update 를 통해서 업데이트 후 진행
sudo apt-get install xrdp
sudo apt-get install xfce4
sudo echo xfce4-session>~/.xsession   
sudo service xrdp restart
 
passwd ubuntu
여기서 비밀번호는 ubuntu로 지었음

```

![검정화면만 나옴 파란화면만 나왔다가 그래도 검정화면으로 바뀜 유저 이름을 ubuntu로 지정하니까 바꼇다.](https://prod-files-secure.s3.us-west-2.amazonaws.com/3cf2a7d4-63a6-42bc-a06c-c86736078f1f/c94ac5e0-b193-4c94-8361-46f005424866/Untitled.png)

검정화면만 나옴 파란화면만 나왔다가 그래도 검정화면으로 바뀜 유저 이름을 ubuntu로 지정하니까 바꼇다.

[[우분투] Xrdp 원격접속 시 검정화면 만 뜰 경우 (빈 화면만 뜰 경우)](https://lapina.tistory.com/147)

![cp 명령어를 이용해 /etc/xrdp/startwm.sh 파일 복사](https://prod-files-secure.s3.us-west-2.amazonaws.com/3cf2a7d4-63a6-42bc-a06c-c86736078f1f/8f0a9709-7086-4ffe-9618-4bfb604422a4/Untitled.png)

cp 명령어를 이용해 /etc/xrdp/startwm.sh 파일 복사

```bash
unset DBUS_SESSION_BUS_ADDRESS 
unset XDG_RUNTIME_DIR 
. $HOME/.profile
```

copy code and paste it in the [startwm.sh](http://startwm.sh)

## problems

AWS의 시스템이 일시 정지됨… 말 그대로 들어가니까 검정화면만 나오고 putty도 로딩하는데 오래 걸렸다. 시스템이 렉이 걸린 것 처럼…

시스템 사양때문에 지금까지 제대로 된 테스트를 돌릴 수 없던게 아닐까?…

## 2. Can My ubuntu Local server run selenium?

[ubuntu 서버 설정해보기…](https://www.notion.so/ubuntu-46167344f85a46e9be6f48e72dedb3f0?pvs=21)

# What should I prepare for my Test

1. Tiny selenium project
2. Amazon Web Service Linux server

---

# Conclusion

The reason was Amazon AWS’s **specification.**

### swap (Disk Storage to RAM)

<aside> 💡 Swap → use Disk Storage as a RAM Storage so we got 3GB RAM for our AWS ubuntu server(지민이가 2GB를 스왑으로 사용함)

</aside>

### My Ubuntu local Server could work with tinySeleniumProject

<aside> 💡 I set up my local ubuntu server and upload TinySeleniumProject then it worked I didn’t add specific setup just add headless option and download chrome and used chromedriver

</aside>

---

# Prepare Tiny selenium Project

[Prepare Tiny selenium project](https://www.notion.so/Prepare-Tiny-selenium-project-d827ae1f21f2457890ae9049e9895da7?pvs=21)

## Note - CentOS

CentOS는 서비스를 종료

따라서 사람들이 ubuntu나 다른 것들을 많이 찾아보고있다.

---