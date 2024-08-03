![[images/Untitled 55.png|Untitled 55.png]]

puttygen 설치 후 Load 선택→ aws만들 떄 만들었던 key를 불러옴

로드 후 save Private key선택→지워지면 안됨

  

![[images/Untitled 1 23.png|Untitled 1 23.png]]

puttygen 에서만든 .ppk 불러와주기

  

## AWS E2C에서 계정 만들고 SSH로 접속해보기

![[images/Untitled 2 14.png|Untitled 2 14.png]]

  

  

![[images/Untitled 3 12.png|Untitled 3 12.png]]

해당 부분을 전부 복사해준다.

![[images/Untitled 4 11.png|Untitled 4 11.png]]

  

putty에 정보를 입력한다.

  

![[images/Untitled 5 10.png|Untitled 5 10.png]]

private key에 ppk파일을 넣는다.

  

이떄 pem file을 ppk파일로 변경할 때는 puttygen을 사용하도록 한다.

  

open을 누르면 putty로 aws e2c ubuntu 계정을 로그인할 수 있게 된다.