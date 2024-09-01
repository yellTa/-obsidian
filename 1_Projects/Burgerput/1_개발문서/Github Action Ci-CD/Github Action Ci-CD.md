---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - end
on Naver: false
업로드할까?: true
created: 2024-04-26T14:37:00
updated: 2024-09-01T17:27
---
# CI/CD Using Github Action, AWS, Codeploy
  
# CI/CD

Continuous integration / Continuous delivery

# Given

### our upload process

1. Local source work
2. Merge main branch
3. create jar file from local
4. update jar file and execute jar file

  

# Object

### Object process

1. local source work
2. Merge main branch
3. the CI/CD System make jar file and update and finally execute it automatically

  

### Requirement

If branch merged to Main branch then Ci/CD have to work

  

# Expectation

- Improving process of the deployment
- Establish easy and quick deployment for small unit

  

  

  

---

  

# 1. Create ci.yml file

```Shell
# workflow의 이름
name: burgerputCI

# 해당 workflow가 언제 실행될 것인지에 대한 트리거를 지정
on:
  push:
    branches: [ main ] # main branch로 push 될 때 실행됩니다.
  pull_request:
    branches: [ main ]  # main branch로 pull request될 때 실행됩니다.
    

# workflow는 한개 이상의 job을 가지며, 각 job은 여러 step에 따라 단계를 나눌 수 있습니다.
jobs:
  build:
    name: burgerputCI
    # run ubuntu os
    runs-on: ubuntu-latest
```

create this .github/workflows/Ci.yml

  

  

# 2. Create S3 Bucket

![[Untitled 9.png|Untitled 9.png]]

Other setting is default.

  

# 3. Create IAM user

Github Action uploads source code in the S3 Bucket, and transmits the deployment work through CodeDeploy’s deployment group.

For this, we have to create user who has the permission for the job and Github action has to use that to gain permission for the job.

*plus : IAM User used for sending data from other platform to AWS

## 3-1. Create user

![[Untitled 1 3.png|Untitled 1 3.png]]

  

![[Untitled 2 3.png|Untitled 2 3.png]]

Add the permissions

- AWSCodeDeployFullAccess
- AmazonS3FullAccess

  

## 3-2. Create IAM accesskey

IAM→ Users → click the user

  

![[Untitled 3 3.png|Untitled 3 3.png]]

Create access key

  

![[Untitled 4 3.png|Untitled 4 3.png]]

  

And download the csv file for don’t forget.

  

This information will use for GitHub Actions’s user certification information.

  

  

## 3-3. Save the Accesskey to Github Repository Secrets

![[Untitled 5 3.png|Untitled 5 3.png]]

Add the values

## 3-4. write ci.ytml file

```Shell
name: burgerputCI

# 해당 workflow가 언제 실행될 것인지에 대한 트리거를 지정
on:
  push:
    branches: [ main ] # main branch로 push 될 때 실행됩니다.
  pull_request:
    branches: [ main ]  # main branch로 pull request될 때 실행됩니다.

\#---------Added START ---------------
env:
  S3_BUCKET_NAME: burgerput
  PROJECT_NAME: burgerput_cicd
  APPLICATION_NAME : codeDeploy
  DEPLOYMENTGROUPS : burgerput-back
\#---------Added  END---------------

# workflow는 한개 이상의 job을 가지며, 각 job은 여러 step에 따라 단계를 나눌 수 있습니다.
jobs:
  build:
    name: burgerputCI
    # 해당 jobs에서 아래의 steps들이 어떠한 환경에서 실행될 것인지를 지정합니다.
    runs-on: ubuntu-latest

\#----------------Added START------------------------

    steps:
      # 작업에서 액세스할 수 있도록 $GITHUB_WORKSPACE에서 저장소를 체크아웃합니다.
      - uses: actions/checkout@v2
      - name: Set up JDK 17
        uses: actions/setup-java@v2
        with:
          java-version: '17'
          distribution: 'zulu'

      - name: Grant execute permission for gradlew
        run: chmod +x ./gradlew
        shell: bash

      - name: Build with Gradle
        run: ./gradlew build -x test
        shell: bash

      - name: make Directory for deliver # make directory for jar file
        run: mkdir deploy

      - name: Copy jar file
        run: cp ./build/libs/burgerputProject-0.0.2-SNAPSHOT.jar ./deploy/

      - name : Make zip file and transmit it
        run: zip -r -qq -j ./burgerput.zip ./deploy

      # Configurre AWs credientials
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      # upload jar zip file to S3
      - name: Upload to S3
        run: aws s3 cp --region ap-northeast-2 ./burgerput.zip s3:///$S3_BUCKET_NAME/$PROJECT_NAME/burgerput.zip

\#----------------Added END------------------------
```

and commit the project file.

  

## 3-4. Check the result.

![[Untitled 6 2.png|Untitled 6 2.png]]

Uploaded S3! It worked!

# 4. AWS IAM Role set-up

## 4-1. Create IAM User

![[Untitled 7 2.png|Untitled 7 2.png]]

  

  

![[Untitled 8 2.png|Untitled 8 2.png]]

  

Add Permission - AWSCodeDeployFullAccess || AmazonS3FullAccess

  

![[Untitled 9 2.png|Untitled 9 2.png]]

Save it

  

## 4-2. Connect IAM to EC2 Instance

  

![[Untitled 10.png]]

select IAM

![[Untitled 11.png]]

  

  

# 5. Create AWS CodeDeploy Application

## 5-1. Create codeDeploy IAM

AWS IAM → 역할 → 역할만들기

![[Untitled 12.png]]

## 5-2. Create CodeDeploy Application

![[Untitled 13.png]]

  

![[Untitled 14.png]]

Create Application

  

## 5-3. Create Deployment group

![[Untitled 15.png]]

  

![[Untitled 16.png]]

  

  

![[Untitled 17.png]]

Select Role as previously created codeDeploy from 4-2 step.

  

Tag group

key : Name

value : (Your EC2 Name want to connect)

  

Based on codeDeploy, previously created, Application can do deployment job in the EC2.

  

# 6. Install CodeDeploy-Agent to Ec2

When CodeDeploy deploys source code uploaded from S3 Bucket to specific loaction of EC2, the EC2 has to ==be installed codedeploy-agent==

  

## 6-1. Install awscli

### awscli

> awscli is the Open Source that makes interaction with aws server.  
> When using AWS CLI, you can use commands supported by AWS in the Powershell or Terminal.  

  

### a) installation

```Shell
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
```

  

### b)Enter the configuration

```Shell
$ sudo aws configure
AWS Access Key ID [None]: Enter the value from csv file
AWS Secret Access Key [None]: Enter the value from csv file
Default region name [None]: your ec2 regiron
Default output format [None]: json
```

  

## 6-2. Install codedeploy-agent

### a) Install Ruby

```Shell
$ sudo apt update
$ sudo apt install ruby-full
$ sudo apt install wget
```

  

### b) Install CodeDeploy Agent

```Shell
$ wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
# download codeDeploy agent file from AWS
$ chmod +x ./install
```

  

```Shell
$ sudo service codedeploy-agent status
```

  

![[Untitled 18.png]]

It’s running

  

### C) Auto service start set-up after reboot stystem

```Shell
$ sudo vim /etc/init.d/codedeploy-startup.sh
```

```Shell
#!/bin
sudo service codedeploy-agent restart
```

  

```Shell
$ sudo chmod +x /etc/init.d/codedeploy-startup.sh
```

add the permission to the file.

# 7. CI/CD set script set-up

## 7-1. Write appspec.yml
appspec.yml 파이프라인의 일부로 사용되는 중요한 구성 파일
이 파일의 역할은 배포 프로세스 세부 사항을 정의하는 것
AWS CodeDeploy에서 Ci/CD 파이프 라인의 일부로 사용된다.

```Shell
version: 0.0  
os: linux  
files:  
  - source: /  
    destination: /home/ubuntu/burgerput/cicd/deploy  
file_exists_behavior: OVERWRITE  
  
permissions:  
  - object: /  
    pattern: "**"  
    owner: ubuntu  
    group: ubuntu  
  
hooks:  
  ApplicationStart:    - location: script.sh # Start the script  
      timeout: 60  
      runas: ubuntu
```

  

### Location of the file

![[Untitled 19.png]]

Root folder of the source code

## 7-2. transfer to EC2

Transfer appspec.yml and jar file

```Shell
name: burgerputCI

# 해당 workflow가 언제 실행될 것인지에 대한 트리거를 지정
on:
  push:
    branches: [ main ] # main branch로 push 될 때 실행됩니다.
  pull_request:
    branches: [ main ]  # main branch로 pull request될 때 실행됩니다.

env:
  S3_BUCKET_NAME: burgerput
  PROJECT_NAME: burgerput_cicd

  APPLICATION_NAME : codeDeployApplication \#Created from step 5-2 (AWS codeDeploy Application Name)
  DEPLOYMENTGROUPS : burgerput-deployment-group \#Create from step 5-3 (Aws CodeDeploy Application Deployment group name)

# workflow는 한개 이상의 job을 가지며, 각 job은 여러 step에 따라 단계를 나눌 수 있습니다.
jobs:
  build:
    name: burgerputCI
    # 해당 jobs에서 아래의 steps들이 어떠한 환경에서 실행될 것인지를 지정합니다.
    runs-on: ubuntu-latest

    steps:
      # 작업에서 액세스할 수 있도록 $GITHUB_WORKSPACE에서 저장소를 체크아웃합니다.
      - uses: actions/checkout@v2
      - name: Set up JDK 17
        uses: actions/setup-java@v2
        with:
          java-version: '17'
          distribution: 'zulu'

      - name: Grant execute permission for gradlew
        run: chmod +x ./gradlew
        shell: bash

      - name: Build with Gradle
        run: ./gradlew build -x test
        shell: bash

      - name: make Directory for deliver # make directory for jar file
        run: mkdir deploy

      - name: Copy jar file
        run: cp ./build/libs/burgerputProject-0.0.2-SNAPSHOT.jar ./deploy

\#-------------Added START --------------------
      - name: copy appsepc.yml file
        run: cp ./appspec.yml ./deploy
\#-------------Added END--------------------

      - name : Make zip file and transmit it
        run: zip -r -qq -j ./burgerput.zip ./deploy

      # Configurre AWs credientials
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      # upload jar zip file to S3
      - name: Upload to S3
        run: aws s3 cp --region ap-northeast-2 ./burgerput.zip s3://$S3_BUCKET_NAME/$PROJECT_NAME/burgerput.zip

      \#Transfer to EC2 Instance
      - name: Transfer to EC2 Instance
        run : |
          aws deploy create-deployment \
          --application-name $APPLICATION_NAME \
          --deployment-group-name $DEPLOYMENTGROUPS  \
          --file-exists-behavior OVERWRITE \
          --s3-location bucket=$S3_BUCKET_NAME,bundleType=zip,key=$PROJECT_NAME/burgerput.zip
```

  

![[Untitled 20.png]]

![[Untitled 21.png]]

  

Success!!!!

  

![[Untitled 22.png]]

Finally Successed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  

# 8. Write Deploy Script

Write Deploly Script and send it with jar file!
### logic

1. Find the PID from command netstat -tnlp | grep 8080
2. Infinite loop
    
    2.1) If PID exist
    
    2.1.a) Kill the PID
    
    2.1.b) Recheck the PID
    
      
    
    2.2) IF PID didn’t exiest
    
    2.2.a) Turn on the Server
    
    2.2.b) break the loop
    

```Shell
#!/bin/bash

# Save the executed command result to VAR
 VAR=$(sudo netstat -tnlp | grep 8080)

 IFS=' ' read -ra vStr <<< "$VAR"

 \#PID/java
 VAR2=${vStr[6]}

 \#extract PID
 IFS='/' read -ra vStr <<< "$VAR2"

 PID=${vStr[0]}

 # Date time for log
 DATE=$(date '+%m%d%y-%H:%M:%S')

while true
 do
   echo "loop start"
   echo "PID VALUE  : " $PID

        if [ -z "$PID" ]; then
                echo "it's not working"
                echo "Start the program"
                echo "Start the server"

                echo $(nohup java -jar /home/ubuntu/burgerput/cicd/deploy/burgerputProject-0.0.2-SNAPSHOT.jar > \
/home/ubuntu/burgerput/log/$DATE.log 2>&1 &)

                break

        else
                echo "It's working kill the process : $PID"

                echo $(kill -9 ${PID})
								
								sleep 2
                # Check the result
                VAR=$(sudo netstat -tnlp | grep 8080)
                IFS=' ' read -ra vStr <<< "$VAR"

                \#PID/java
                VAR2=${vStr[6]}

                \#extract PID
                IFS='/' read -ra vStr <<< "$VAR2"

                PID=${vStr[0]}
                echo "Research The PID :"$PID

                
        fi
 done

```

  

## 8-2. Transfer it to EC2

```Shell
name: burgerputCI

# 해당 workflow가 언제 실행될 것인지에 대한 트리거를 지정
on:
  push:
    branches: [ main ] # main branch로 push 될 때 실행됩니다.
  pull_request:
    branches: [ main ]  # main branch로 pull request될 때 실행됩니다.

env:
  S3_BUCKET_NAME: burgerput
  PROJECT_NAME: burgerput_cicd

  APPLICATION_NAME : codeDeployApplication \#Created from step 5-2 (AWS codeDeploy Application Name)
  DEPLOYMENTGROUPS : burgerput-deployment-group \#Create from step 5-3 (Aws CodeDeploy Application Deployment group name)

# workflow는 한개 이상의 job을 가지며, 각 job은 여러 step에 따라 단계를 나눌 수 있습니다.
jobs:
  build:
    name: burgerputCI
    # 해당 jobs에서 아래의 steps들이 어떠한 환경에서 실행될 것인지를 지정합니다.
    runs-on: ubuntu-latest

    steps:
      # 작업에서 액세스할 수 있도록 $GITHUB_WORKSPACE에서 저장소를 체크아웃합니다.
      - uses: actions/checkout@v2
      - name: Set up JDK 17
        uses: actions/setup-java@v2
        with:
          java-version: '17'
          distribution: 'zulu'

      - name: Grant execute permission for gradlew
        run: chmod +x ./gradlew
        shell: bash

      - name: Build with Gradle
        run: ./gradlew build -x test
        shell: bash

      - name: make Directory for deliver # make directory for jar file
        run: mkdir deploy

      - name: Copy jar file
        run: cp ./build/libs/burgerputProject-0.0.2-SNAPSHOT.jar ./deploy

      - name: copy appsepc.yml file
        run: cp ./appspec.yml ./deploy
          \#-----------------ADDED START------------------
      - name: copy Script file
        run: cp ./script.sh ./deploy
\#-------------------ADDED END----------------

      - name : Make zip file and transmit it
        run: zip -r -qq -j ./burgerput.zip ./deploy

      # Configurre AWs credientials
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      # upload jar zip file to S3
      - name: Upload to S3
        run: aws s3 cp --region ap-northeast-2 ./burgerput.zip s3://$S3_BUCKET_NAME/$PROJECT_NAME/burgerput.zip

#      \#Transfer to EC2 Instance
      - name: Transfer to EC2 Instance
        run : |
          aws deploy create-deployment \
          --application-name $APPLICATION_NAME \
          --deployment-group-name $DEPLOYMENTGROUPS  \
          --file-exists-behavior OVERWRITE \
          --s3-location bucket=$S3_BUCKET_NAME,bundleType=zip,key=$PROJECT_NAME/burgerput.zip
```

  

  

# RESULT!!!

![[Untitled 23.png]]

The log file Created!!

- According to My script.sh create log file through executed time

  

---

  

> [!info] Spring Boot + GitHub Actions + AWS CodeDeploy를 활용한 CI/CD 구축  
> 서론 지금까지 매번 프로젝트를 구축할 때마다 이전 코드들을 번거롭게 봐가면서 CI/CD를 구축했었는데, 이번 기회에 한번 문서화를 해보고자 글을 작성하게 되었습니다.  
> [https://dkswnkk.tistory.com/674](https://dkswnkk.tistory.com/674)  

> [!info] github-action 으로 ec2 에 배포하기 - BESPIN Tech Blog  
> Github Actions는 Github 저장소를 기반으로 Github에서 제공하는 Workflow 자동화 도구 입니다.  
> [https://blog.bespinglobal.com/post/github-action-으로-ec2-에-배포하기/](https://blog.bespinglobal.com/post/github-action-으로-ec2-에-배포하기/)  

> [!info] GitHub Actions, AWS CodeDeploy 를 활용한 CI/CD 적용  
> 사내에서는 EC2 에 직접 접속하여 Git 을 통해 새로운 소스 코드를 pull 받고, Docker Image 로 컨테이너를 띄워 배포하는 방식을 사용하고 있었습니다.  
> [https://velog.io/@cataiden/ci-cd-with-github-actions-and-aws-codedeploy](https://velog.io/@cataiden/ci-cd-with-github-actions-and-aws-codedeploy)  

> [!info] [Devops] Github Action을 사용한 Spring boot & gradle CI/CD 구축 - 3  
> github action, AWS S3, AWS CodeDeploy, AWS EC2를 사용하여 CI/CD 환경을 구성해봅시다  
> [https://stalker5217.github.io/devops/github_action_ci_cd_3/](https://stalker5217.github.io/devops/github_action_ci_cd_3/)  

> [!info] Ruby on Jets : AWS Credentials 자격증명  
> " unable to sign request without credentials set " 최근, AWS Cloud9을 통해 배포를 하면서 위와 같은 에러 이슈로 인해 배포가 안되는 사례가 있어 해결법에 대해 공유하고자 합니다.  
> [https://kbs4674.tistory.com/139](https://kbs4674.tistory.com/139)  

> [!info] [AWS] CodeDeploy appspec.yml 파헤치기  
> AWS에서 CodeDeploy를 접하면 가장 난관인게 바로 이 appspec.  
> [https://yoo11052.tistory.com/113](https://yoo11052.tistory.com/113)