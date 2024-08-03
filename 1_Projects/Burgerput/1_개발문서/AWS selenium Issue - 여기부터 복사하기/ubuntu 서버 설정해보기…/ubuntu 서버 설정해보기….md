## 설치

### vmware

![[images/Untitled 51.png|Untitled 51.png]]

![[images/Untitled 1 19.png|Untitled 1 19.png]]

![[images/Untitled 2 11.png|Untitled 2 11.png]]

별도 설정 없이 그대로 진행

  

![[images/Untitled 3 9.png|Untitled 3 9.png]]

이용자이름 : user

비밀번호 : user

  

  

## 고정 아이피 설정하기

![[images/Untitled 4 8.png|Untitled 4 8.png]]

현 사용중인 ip를 확인한다.

|   |   |
|---|---|
|이더넷 명|ens33|
|변경전 IP|192.168.106.130|

![[images/Untitled 5 7.png|Untitled 5 7.png]]

/etc/netplan 경로에서 yaml 파일 수정

![[images/Untitled 6 4.png|Untitled 6 4.png]]

수정하기 전 root 권한 으로 해당 파일 백업진행

```Shell
sudo su 
cp ~~ ~~.back
```

  

  

![[images/Untitled 7 3.png|Untitled 7 3.png]]

수정 전

  

  

![[images/Untitled 8 3.png|Untitled 8 3.png]]

수정 후

gateway 정보는 vmware에서 확인할 수 있다.

  

```Shell
sudo netplan apply 
```

![[images/Untitled 9 3.png|Untitled 9 3.png]]

ping [www.naver.com](http://www.naver.com) 를통해 핑을 날린 모습 정상적으로 실행되는 것을 알 수 있다.

  

## 외부에서 VMware 물리서버 접속 설정해보기

## ubuntu 서버 java, mysql 설치하기

### Install java 17

```Shell
$ sudo apt-get update
$ sudo apt install openjdk-17-jdk

$ java --version
```

  

  

# ubuntu 서버 selelnium 업로드하고 실행해보기…

Upload tinySelenium through WinSCP

![[images/Untitled 10 2.png|Untitled 10 2.png]]

[https://www.lesstif.com/lpt/linux-chown-93127453.html](https://www.lesstif.com/lpt/linux-chown-93127453.html)

  

Change group owner and group to user

```Shell
$ chown user:user file or folder
```

  

### Install Unzip

```Shell
$ sudo apt install unzip
$ unzip -v
```

  

### Install chrome

```Shell
$ sudo apt update
$ sudo apt install wget  # wget download

# google chrome download
$ sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$ sudo apt install ./google-chrome-stable_current_amd64.deb

$ google-chrome --version
```

  

---

tinySeleniumProject 성공

### Install mysql

```Shell
$ sudo apt-get install mysql-server
```