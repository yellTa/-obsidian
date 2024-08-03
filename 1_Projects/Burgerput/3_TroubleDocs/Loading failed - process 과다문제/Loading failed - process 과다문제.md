---
progress:
  - end
Created time: Invalid date
Last edited time: Invalid date
Review여부: false
post됨: false
post할까?: false
---
# Error Message

> [!important]  
> unknown error: session deleted because of page crash  

# Reason

> [!important]  
> chrome driver need more shm Memory  

  

## ps -ef | grep chrome

My program using chromDriver and it needed Memory quite a lot. so I checked the using ChromeDriver in my Server

![[images/Untitled 39.png|Untitled 39.png]]

  

### What is /dev/shm

  

```Shell
df -h

Filesystem      Size  Used Avail Use% Mounted on
/dev/root        25G  8.7G   16G  36% /
tmpfs           475M  160M  316M  34% /dev/shm
tmpfs           190M  944K  189M   1% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/xvda15     105M  6.1M   99M   6% /boot/efi
tmpfs            95M  8.0K   95M   1% /run/user/1000
```

/dev/shm is share memory, and it’s like a RamDisk

The initial size is half of physical Memory. If other programs using RAM and exceeding using Memory of the RAM, then Using swap memory instead of the RAM.

  

# Solution

## 1. Kill the process

![[images/Untitled 1 14.png|Untitled 1 14.png]]

I kill the All Chrome process

  

Setup this line to crontab

```Java

00 4 * * *  pkill chrome
```

process end to chrome at 4:00

## 2. quit() the Driver after work

I checked my code then found it, if error occurred then my code handle the error but don’t quit the driver.

So I need to set-up quit the driver when error occurred.

  

## 2-1. Machine Loading Zenput(getInfo logic) and FoodLoadingZenput

![[images/Untitled 2 9.png|Untitled 2 9.png]]

When Error occurred after execute MachinegetInfo logic.

  

the Method used for getinfo logic throws Exception and getinfo Logic handle it

so the driver must quit() in the getinfo Logic whether loading success or not.

  

## 3. Do not use dev/shm memory when using selenium

### MovinPageServiceV1

  

  

  

```Shell
 options.addArguments("--disable-dev-shm-usage");
```

Add this option to MovePageServiceV1

This option means selenium doesn’t use dev/shm memory.

  

---

> [!info] unknown error: session deleted because of page crash  
> 라즈베리파이에서 잘 돌던 크롤러가 갑자기 동작하지 않아서 로그를 보니 unknown error: session deleted because of page crash 가 남아 있었다.  
> [https://leehyunseok.com/unknown-error-session-deleted-because-of-page-crash/](https://leehyunseok.com/unknown-error-session-deleted-because-of-page-crash/)