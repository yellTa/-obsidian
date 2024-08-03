==Created : 2023 12 06==

==Modified :==

---

  

## Tiny selenium project update to AWS

![[images/tinySeleniumProject 2.zip|tinySeleniumProject 2.zip]]

tinyProject zip file

  

![[images/Untitled 50.png|Untitled 50.png]]

upload to AWS EC2

  

## Result

### Error

![[images/Untitled 1 18.png|Untitled 1 18.png]]

chrome driver download completed but no longer error occurred

  

## Reason - 추측

아마도 GUI를 지원하지 않는 ubuntu에서 셀레니움을 돌리면 에러가 나는 듯 하다. 이를 방지하기 위헤

chrome headless 옵션을 추가하는 것

  

> GUI모드로 돌리면 이미지, 기타등등을 로딩해야하기 때문에 자원도 많이 소모하고 시간도 많이 돌린다. 효율성을 위해서는 headless로 자원을 아끼는 것이 좋다.

> [!info] [파이썬-셀레니움] 셀레니움 속도 향상을 위한 5가지 팁  
> 셀레니움으로 크롤링을 하다 보면 보다 빠르게 크롤링을 하고 싶을 때가 있다.  
> [https://dsconsulting.tistory.com/entry/파이썬-셀레니움-셀레니움-속도-향상을-위한-5가지-팁](https://dsconsulting.tistory.com/entry/파이썬-셀레니움-셀레니움-속도-향상을-위한-5가지-팁)  

  

  

---

  

### way1 - tinyProject에 headless option 추가해보기(실 프로젝트에선 작동하지 않았음)

```Shell
WebElement naverLogin = driver.findElement(By.className("MyView-module__login_text___G0Dzv"));
text = naverLogin.getText();
log.info("[RESULTTTTTTT] :   {}", text );
```

네이버 홈페이지에서 로그인 창 위

“네이버를 더 안전하고 편리하게 이용하세요” 문구를 가져오는 코드

```Java
options.addArguments("--disable-popup-blocking");       //팝업안띄움
options.addArguments("--disable-gpu");			//gpu 비활성화
options.addArguments("--blink-settings=imagesEnabled=false"); //이미지 다운 안받음
options.addArguments("--no-sandbox");
options.addArguments("--headless=new");
options.addArguments("--disable-dev-shm-usage");
```

위의 옵션을 추가했다.

> 로컬 실험 환경에서는 새로운 창을 띄우지 않고 정상 작동했다.

![[images/Untitled 2 10.png|Untitled 2 10.png]]

TimeoutException Occured

정상작동하지 않는다.

> [!important]  
> 아마도!… 사양이 너무 낮아서 그런것 같다. chromeDriver가 제대로 실행은 되는데 너무 오래걸려서…  

### way2 - ubuntu에 selenium xvfb설치 selenium standaloneserver 구동시켜보기

아래와 같이 selenium standalone server를 설치했다…

> [!info] How to Setup Selenium with ChromeDriver on Ubuntu 22.04, 20.04 & 18.04 – TecAdmin  
> How to setup Selenium with ChromeDriver on Ubuntu, and LinuxMint systems.  
> [https://tecadmin.net/setup-selenium-chromedriver-on-ubuntu/](https://tecadmin.net/setup-selenium-chromedriver-on-ubuntu/)  

  

> [!info] setup-headless-selenium-xvfb.sh  
> setup-headless-selenium-xvfb.  
> [https://gist.github.com/alonisser/11192482](https://gist.github.com/alonisser/11192482)  

  

위의 링크에 나온 방법으로 xvfb를 켜보았지만 SpringBoot에 selenium을 이식하고 작동하지 않았다.

root 계정으로 새로운 user 생성

username : remote

userpasswd : remote

  

  

### way3 - ubuntu에 GUI 환경 설치해보기…

> [!info] [AWS] [활용] EC2 Ubuntu RDP(원격데스크톱) 연결하기  
> 기본적으로 EC2 Ubuntu로 인스턴스 시작 해주시고요.  
> [https://cloud-oky.tistory.com/3421](https://cloud-oky.tistory.com/3421)  

xrdp패키지와 xfce4 패키지를 다운로드 받아서 GUI환경 설치

![[images/Untitled 3 8.png|Untitled 3 8.png]]

Unable to locate package 에러 발생

```Shell
apt-get update 를 통해서 업데이트 후 진행
sudo apt-get install xrdp
sudo apt-get install xfce4
sudo echo xfce4-session>~/.xsession   
sudo service xrdp restart
 
passwd ubuntu
여기서 비밀번호는 ubuntu로 지었음
```

  

![[images/Untitled 4 7.png|Untitled 4 7.png]]

검정화면만 나옴 파란화면만 나왔다가 그래도 검정화면으로 바뀜 유저 이름을 ubuntu로 지정하니까 바꼇다.

> [!info] [우분투] Xrdp 원격접속 시 검정화면 만 뜰 경우 (빈 화면만 뜰 경우)  
> Xrdp를 활용하면 윈도우나 Mac에서 우분투로 GUI 원격 접속이 가능함을 확인했습니다.  
> [https://lapina.tistory.com/147](https://lapina.tistory.com/147)  

![[images/Untitled 5 6.png|Untitled 5 6.png]]

cp 명령어를 이용해 /etc/xrdp/startwm.sh 파일 복사

  

```Shell
unset DBUS_SESSION_BUS_ADDRESS 
unset XDG_RUNTIME_DIR 
. $HOME/.profile
```

copy code and paste it in the startwm.sh

## problems

AWS의 시스템이 일시 정지됨… 말 그대로 들어가니까 검정화면만 나오고 putty도 로딩하는데 오래 걸렸다. 시스템이 렉이 걸린 것 처럼…

시스템 사양때문에 지금까지 제대로 된 테스트를 돌릴 수 없던게 아닐까?…