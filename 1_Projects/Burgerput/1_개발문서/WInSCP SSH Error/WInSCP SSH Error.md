---
Created time: Invalid date
Last edited time: Invalid date
Progress: end
on Naver: false
업로드할까?: false
---
# WinSCP SSHD Error

> [!important]  
> Installed FileZilla but occurred same problem…  

## Guess 1 : sshd setup problem

```Shell
$ vi /etc/ssh/sshd_config

Subsystem sftp /usr/lib/openssh/sftp-server # 이 부분을 

Subsystem sftp internal-sftp # 다음과 같이 바꾸어준다.

$ service ssh restart
```

But it’s not working

  

> [!info] [Linux] Ubuntu sftp 설정  
> 어쩌다보니 회사에서 서버를 배포해야하는 상황이 와서 맞으면서 배우는 중이다.  
> [https://velog.io/@xangj0ng/Linux-Ubuntu-sftp-설정](https://velog.io/@xangj0ng/Linux-Ubuntu-sftp-설정)  

## 💯Guess 2 : file system storage problem

```Shell
% df -h
```

![[images/Untitled 8.png|Untitled 8.png]]

before It takes 100% but it’s not now… IDK?

but my Ubnunt root folder got 4.1G free space so the SSH Upload error solved

  

### Expand LVM space

```Shell
$ lsblk
```

![[images/Untitled 1 2.png|Untitled 1 2.png]]

sda1, sda2, sda3 → 3 partition

sda3 → installed boot OS

lvm is logical volumn it can be expand.

  

```Shell
$ lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```

use this command to expand sda3 but I setup the volumn size as 20G so my sda3 volumn couldn’t expanded(It’s alread used it all spaces)

  

> [!info] ubuntu lvm 크기 확장  
> 현재 상태는 아래 그림과 같았다.  
> [https://yh-kr.tistory.com/34](https://yh-kr.tistory.com/34)