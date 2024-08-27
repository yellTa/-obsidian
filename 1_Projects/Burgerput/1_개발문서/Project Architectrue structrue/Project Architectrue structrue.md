---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - end
on Naver: false
업로드할까?: true
created: 2024-01-31T14:37:00
updated: 2024-08-27T17:56
---
# AWS : Application Load Balancer

## Application Load Balancer

![[Untitled 25.png|Untitled 25.png]]

  

ALB(Application Load Balancer)

복잡한 최신 애플리케이션에는 단일 애플리케이션 기능을 전담하는 여러 서버를 포함하는 서버 팜(Farm)이 있다.

ALB는 HTTP헤더 또는 SSL세션 ID와 같은 요청 콘텐츠를 확인하여 트래픽을 리다이렉션 한다.

로드 밸런서는 사용자와 리소소를 이어주는 연결점을 제공한다.

Load Balancer 는 Application에 들어오는 트래픽을 분산처리하여 타겟(아마존 EC2 instance, multiple Availability Zones)으로 보낸다.

위와 같이 분산처리를 해서 Application이 가용할 수 없는 범위를 넓힌다.

아마존 AWS에서는 하나 이상의 Listeners를 로드 밸런서에 추가할 수 있다.

## Load Balancer의 동작원리

Listener는 등록된 프로토콜과 포트를 이용해서 사용자의 연결 요청을 확인한다.

Listener에 등록된 규칙에 따라서 로드 밸런서가 등록된 대상으로 요청을 라우팅하는 방법이 결정된다.

규칙은 우선 순위, 하나 이상의 작업, 하나 이상의 조건으로 구성되며 규칙에 대한 조건이 충족되면 작업이 수행된다. 필요에 따라 추가 규칙을 정의할 수 있다.

  

![[Untitled 1 5.png|Untitled 1 5.png]]

  

Application Load Balancer는 개방형 시스템간 상호 연결(OSI)모델의 일곱 번째 계층인 애플리케이션 계층에서 작동한다.

  

### 로드 밸런서가 요청을 받으면?

1. 우선 순위에 따라 리스너 규칙을 평가하여 적용할 규칙을 정한다.
2. 규칙 작업의 대상 그룹에서 대상을 선택한다. → 애플리케이션 트래픽의 콘텐츠를 기반으로 다른 대상 그룹에 요청을 라우팅하도록 리스너 규칙을 구성할 수 있다.

  

---

## Load Balancer와 Listener

### listener의 구성

protocol : HTTP, HTTPS

port : 1 ~ 65535

  

Listener 프로토콜이 HTTPS인 경우에는 반드시 한 개 이상의 SSl 서버 인증서를 배포해야 한다.

AWS는 ==AWS Certificate Manager== 를 사용해 로드 밸런서를 위한 인증서를 생성하는 기능이 있다.  
  

> ==AWS Certifivate Manager==
> 
> AWS 웹 사이트와 애플리케이션을 보호하는 퍼블릭 및 프라이빗 SSL/TLS X.509 인증서와 키를 만들고, 저장하고, 갱신하는 복잡성을 처리한다.

### ==Listener의 규칙==

![[Untitled 2 4.png|Untitled 2 4.png]]

URL로 리디렉션 - 클라이언트 요청이 리디렉션 될 URL을 지정한다. FULL URL을 지정하면 https://#{host}:443/#{path}?#{query} 와 같은 형식으로 쿼리를 날릴 수도 있다.

  

프로토콜 : HTTP, HTTPS 혹은 그 외 프로토콜을 지정한다.

포트 : 포트번호를 지정한다.

### EX) HTTP에 80포트로 들어오는 요청에 대한 리스너 규칙

리스너의 규칙

URL 부분 : HTTPS

프로토콜 : 443

  

위 처럼 적용하면 HTTP:80 으로 들어온 사용자의 요청을 Application Load Balancer가 캐치해서 HTTPS:443으로 리디렉션을 수행한다.

  

  

## Listener의 대상그룹

### 대상그룹

지정한 프로토콜과 포트 번호를 사용하며 EC2 인스턴스 같은 개별 등록된 대상으로 요청을 라우팅할 수 있다.

Listener규칙을 생성하고 해당 조건이 충족되면 해당하는 대상 그룹으로 트래픽이 전달된다.

서로 다른 유형의 요청에 대해 서로 다른 대상 그룹을 지정할 수 있다.

  

### 라우팅 구성

지정한 프로토콜과 포트 번호를 사용하여 대상그룹으로 요청을 라우팅한다.

프로토콜 : HTTP, HTTPS

포트 : 1 ~ 65535

  

대상 그룹이 HTTPS 프로토콜로 구성되거나 HTTPS 상태 확인을 사용하는 경우, 로드 밸런서는 대상에 설치된 인증서를 사용하여 대상과의 TLS 연결을 설정한다.

로드 밸런서는 이러한 인증서를 검증하지 않으므로, ==자체 서명된 인증서나 만료된 인증서를 사용할 수 있다.==

  

> ==자체 서명된 인증서, 만료된 인증서==  
> 공개적으로 신뢰할 수 있는 인증 기관이 아닌 개발자나 회사가 서명한 인증서  
> CA에서 서명한 것이 아니기때문에 일반적으로 안전하지 않은 것으로 간주된다.  
> 이러한 인증서는 보안 경고를 일으킬 수 있다.  

  

### Load Balancer를 품고있는 Amazon VPC

### 로드 밸런서는 자체 서명된 인증서, 만료된 인증서를 사용할 수 있다. 그러면 위험성은?

Amazon Virtual Private Cloud(Amazon VPC)를 사용하면 정의한 논리적으로 격리된 가상의네트워크에서 AWS 리소스를 시작할 수 있다.

![[Untitled 3 4.png|Untitled 3 4.png]]

  

### VPN(Virtual Private Network)과 보안

물리적으로 같은 환경 내에서, private한 사설 네트워크를 구성한다.

컴퓨팅, 네트워크, 스토리지 등 하드웨어로 제공되던 IT 인프라의 구성 요소를 추상화하여 소프트웨어 기반 솔루션으로 전환한다.

VPN을 구성하면 가상화된 네트워크를 서브렛으로 잘개 쪼개서 사용할 수 있다. 서브넷 안에 IT인프라 구성요소를 넣을 수 있다.

  

### VPC와 보안

쉽게 말하자면 VPC는 AWS에서 사용하는 VPN이다. VPC는 인터넷에 액세스할 수 있는 웹 서버를 위해 퍼블릭 서브넷을 지정할 수 있고 서브넷에 DB나 애플리케이션 서버 같은 백엔드 시스템을 배치하도록 지원한다.

Amazon VPC를 사용하여 보안 그룹 및 네트워크 액세스 제어 목록을 포함한 다중 보안 계층을 사용하여 각 서브넷에서 EC2 인스턴스에 대한 액세스를 제어하도록 지원할 수 있다.

  

### VPC와 보안그룹

연결된 EC2 인스턴스에 대한 방화벽 역할을 하도록 보안 그룹을 생성하여 인스턴스 수준에서 드래픽을 제어한다.

  

  

### 대상그룹 지정

진행한 프로젝트의 경우 대상그룹을 instance로 지정했다. 즉 로드밸런서에서 대상그룹으로 라우팅이 된다면 instance로 라우팅해준다는 의미이다.

  

---

# References

> [!info]  
>  
> [https://www.smileshark.kr/post/what-is-a-load-balancer-a-comprehensive-guide-to-aws-load-balancer](https://www.smileshark.kr/post/what-is-a-load-balancer-a-comprehensive-guide-to-aws-load-balancer)  

> [!info] Amazon VPC란 무엇인가? - Amazon Virtual Private Cloud  
> Amazon VPC를 사용하여 AWS 클라우드에서 논리적으로 격리된 영역인 가상 네트워크에서 AWS 리소스를 시작할 수 있습니다.  
> [https://docs.aws.amazon.com/ko_kr/vpc/latest/userguide/what-is-amazon-vpc.html](https://docs.aws.amazon.com/ko_kr/vpc/latest/userguide/what-is-amazon-vpc.html)  

> [!info] [AWS] 가장쉽게 VPC 개념잡기  
> 가장쉽게 VPC 알아보기  
> [https://medium.com/harrythegreat/aws-가장쉽게-vpc-개념잡기-71eef95a7098](https://medium.com/harrythegreat/aws-가장쉽게-vpc-개념잡기-71eef95a7098)