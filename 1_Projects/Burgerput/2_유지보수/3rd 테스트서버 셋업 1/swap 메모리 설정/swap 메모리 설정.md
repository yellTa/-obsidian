---
created: 2024-08-03T14:37
updated: 2024-08-04T22:42
---
# ubuntu swap메모리 지정

swap메모리는 RAM의 용량이 부족할 떄 하드디스크의 일부를 RAM처럼 사용하는 것

  

- 장점
    - RAM의 필요 용량보다 부족할 경우 RAM 추가없이(비용X) 사용 가능
- 단점
    - RAM에 비해 Read/Write의 속도가 느리다.
    - 하드 디스크 수명이 줄 수 있다.

  

# 하드디스크 용량 보기(파티션 나누는 거 나중에 해보기…)

```Java
//하드디스크 용량 확인
df-h
//현재 사용중인 메모리 확인
free-m
//어떤 시트크에서 스왑파일을 사용하는지 확인
swapon -s
// 현재 디바이스 정보 확인
lsblk
```

  

# Swap파일 생성하기

```Java
sudo fallocate -l 2G /swapfile

cd / 

ll
```

![[Untitled 59.png|Untitled 59.png]]

2G의 파일이 생성된 것 확인

  

```Java
ubuntu@:/$ sudo chmod 600 /swapfile  // 권한 수정
ubuntu@:/$ sudo mkswap /swapfile    // 활성화 준비
Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
no label, UUID=4b5091f7-4d3e-44ee-a201-26eb54bed9b8

ubuntu@:/$ sudo swapon /swapfile  // 활성화
```

  

```Java

sudo vim /etc/fstab


LABEL=cloudimg-rootfs   /        ext4   discard,commit=30,errors=remount-ro     0 1
LABEL=BOOT      /boot   ext4    defaults        0 2
LABEL=UEFI      /boot/efi       vfat    umask=0077      0 1


##추가된 내용 - 재부팅 후에도 사용할 수 있도록 설정
#[CUSTOM SETUP]

/swapfile swap swap defaults 0 0
~
~
```

  

```Java
ubuntu@:/$ free -m
               total        used        free      shared  buff/cache   available
Mem:             957         660         108           0         347         296
Swap:           2047           0        2047
```

메모리 설정 완료

  

---

> [!info] ubuntu swap 메모리 설정  
> swap 메모리는 RAM의 용량이 부족할 때 하드디스크의 일부를 사용해서 프로그램을 실행하는 것으로, 마치 RAM의 용량이 늘어난 것과 같다.  
> [https://velog.io/@shi9476/ubuntu-swap-메모리-설정](https://velog.io/@shi9476/ubuntu-swap-메모리-설정)  

> [!info] Ubuntu 20.04에서 swap 메모리 설정하기  
> Swap 메모리는 하드디스크의 일부를 RAM처럼 사용하도록 만들어진 메모리입니다.  
> [https://lovedh.tistory.com/entry/Ubuntu-2004에서-swap-메모리-설정하기](https://lovedh.tistory.com/entry/Ubuntu-2004에서-swap-메모리-설정하기)