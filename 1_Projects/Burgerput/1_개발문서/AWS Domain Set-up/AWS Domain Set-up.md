---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - end
on Naver: false
업로드할까?: false
created: 2024-03-07T14:37:00
updated: 2024-08-27T17:56
---
# Domain for EC2

For set-up the Domain

Burgerput backend Service는

[burback.shop](http://burback.shop) 이라는 도메인을 가지고 burgerput.co.kr과 통신해야한다.

  

# 1. Issue domain from 가비아

I bought domain from 가비아 (Service from korea)

  

# 2. AWS set-up

Route 53 select → 호스팅 영역 생성

## 2-1. Create Hosted Zone

![[Untitled 28.png|Untitled 28.png]]

### Tags

Key : Name

Value : [your EC2 Instance Name]

  

## 2-2. Create record

![[Untitled 1 8.png|Untitled 1 8.png]]

  

  

![[Untitled 2 6.png|Untitled 2 6.png]]

Enter your EC2 ip address in the Value

  

![[Untitled 3 6.png|Untitled 3 6.png]]

highlight yellow addresses are connection addresses with nameServer( in my case 가비아)


# 3. 가비아 setup

## 1-1. 가비아 name server 설정

![[Untitled 4 5.png|Untitled 4 5.png]]

  

  

![[Untitled 5 5.png|Untitled 5 5.png]]

Enter the AWS Addresses

  

  

---

> [!info] [AWS] EC2 와 도메인 연결하기 (feat. 가비아)  
> # AWS 설정 1.  
> [https://developer-ping9.tistory.com/320](https://developer-ping9.tistory.com/320)