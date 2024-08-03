  

![[images/Untitled 56.png|Untitled 56.png]]

ftp의 사용 포트 번호는 20, 21이다. 해당 tcp 포트로 지정하고 저장해준다.

(추가할 때 왼쪽 하단에 규칙 추가를 눌러서 규칙을 추가해 주도록 한다.)

  

나머지는 putty처럼 접속해 주면 되는데 지금 SSH접속 설정을 못하고 있기 떄문

  

  

![[images/Untitled 1 24.png|Untitled 1 24.png]]

WInSCP의 로그인 화면이다.

hostName: Elastic IP로 연결 받은 것

userName :

  

**사용자 이름** :

- Amazon Linux AMI의 경우 사용자 이름은 ec2-user
- RHEL AMI의 경우 사용자 이름은 ec2-user 또는 root
- Ubuntu AMI의 경우 사용자 이름은 **ubuntu** 또는 root
- Centos AMI의 경우 사용자 이름은 centos
- Fedora AMI의 경우 사용자 이름은 ec2-user
- SUSE의 경우 사용자 이름은 ec2-user 또는 root

> [!info] AWS EC2 서버 구동, WINSCP로 로컬에서 연결하기  
> EC2 서버 구동시키기 https://aws.  
> [https://alkhwa-113.tistory.com/entry/AWS-EC2-서버-구동-WINSCP로-로컬에서-연결하기](https://alkhwa-113.tistory.com/entry/AWS-EC2-서버-구동-WINSCP로-로컬에서-연결하기)  

![[images/Untitled 2 15.png|Untitled 2 15.png]]

비밀번호를 사용하지 않고 키 파일을 이용하기 때문에 pem을 puttygen으로 변경한 ppk파일을 선택해준다.

  

  

![[images/Untitled 3 13.png|Untitled 3 13.png]]

로그인에 성공한 모습