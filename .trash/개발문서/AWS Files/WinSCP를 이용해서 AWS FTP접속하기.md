---
created: 2024-08-02T23:53
updated: 2024-08-02T23:54
출처: 
---
![[Pasted image 20240802235339.png]]

ftp의 사용 포트 번호는 20, 21이다. 해당 tcp 포트로 지정하고 저장해준다.

(추가할 때 왼쪽 하단에 규칙 추가를 눌러서 규칙을 추가해 주도록 한다.)

나머지는 putty처럼 접속해 주면 되는데 지금 SSH접속 설정을 못하고 있기 떄문

![[Pasted image 20240802235348.png]]

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

[AWS EC2 서버 구동, WINSCP로 로컬에서 연결하기](https://alkhwa-113.tistory.com/entry/AWS-EC2-%EC%84%9C%EB%B2%84-%EA%B5%AC%EB%8F%99-WINSCP%EB%A1%9C-%EB%A1%9C%EC%BB%AC%EC%97%90%EC%84%9C-%EC%97%B0%EA%B2%B0%ED%95%98%EA%B8%B0)
![[Pasted image 20240802235403.png]]
비밀번호를 사용하지 않고 키 파일을 이용하기 때문에 pem을 puttygen으로 변경한 ppk파일을 선택해준다.
![[Pasted image 20240802235411.png]]
로그인에 성공한 모습