---
created: 2024-08-02T23:58
updated: 2024-08-02T23:59
---
MySQL Database는 기본적으로는 대소문자를 구분하도록 되어있다.(Linux / Unix)

my.cnf파일에

```jsx
[mysqld]
lower_case_table_names = 1
```

로 지정하면 되지만 에러가 나는 경우가 있다.

# 데이터 베이스 초기화 후 세팅

## 데이터 베이스 초기화

완전 삭제 후 재진행으로 수행했다.

```bash
# A Delete Mysql
sudo apt-get remove --purge mysql*

# B mysql 관련 파일 확인
> dpkg -l | grep mysql
삭제가 안되었으면 관련 파일 전부 삭제

# C 폴더 및 관련항목 삭제
> sudo rm -rf /etc/mysql /var/lib/mysql
> sudo rm -rf /var/log/mysql
> sudo rm -rf /var/log/mysql.*
> sudo rm /var/lib/dpkg/info/* 
> sudo apt-get autoremove
> sudo apt-get autoclean

# D 재설치
# D-1.update ubuntu server first
> sudo apt-get update
> apt-get install mysql-server

# E version Check
> mysql --version
```

참고로 초기 root 비밀번호는 root이다.

### Login to Mysql

```jsx
# mysql -u root -p
>root
```

![mysql version check](https://prod-files-secure.s3.us-west-2.amazonaws.com/3cf2a7d4-63a6-42bc-a06c-c86736078f1f/cde02dfc-40c0-4f6a-9c0a-34a83d3c08a4/Untitled.png)

mysql version check

```jsx
mysql> show variables like 'lower%';
```

### 대소문자 옵션 확인

![Check mysql lower_case option](https://prod-files-secure.s3.us-west-2.amazonaws.com/3cf2a7d4-63a6-42bc-a06c-c86736078f1f/88db0359-4cf5-42ee-a707-505b93dd13a1/Untitled.png)

Check mysql lower_case option

## 대소문자 구분 설정 넣기

> Set up lower_case_table_names value after mysql installation or re-initializing Mysql

```bash
#Delete the MySQL data directory
sudo rm-rf  /var/lib/mysql

# recreate the Mysql Data directory
sudo mkdir /var/lib/mysql    
sudo chown mysql:mysql /var/lib/mysql
sudo chmod 700 /var/lib/mysql

# Add lower_case_table_names = 1 to [mysqld] section in 
# /etc/mysql/mysql.conf.d/mysqld.cnf
```

![/etc/mysql/mysql.conf.d/mysqld.cnf](https://prod-files-secure.s3.us-west-2.amazonaws.com/3cf2a7d4-63a6-42bc-a06c-c86736078f1f/2da27f5f-76b4-4d4d-8b61-8d7c11dab7f2/Untitled.png)

/etc/mysql/mysql.conf.d/mysqld.cnf

```bash
# Re-initialize MySQL with --lower_case_table_names=1
sudo mysqld --defaults-file=/etc/mysql/my.cnf --initialize --lower_case_table_names=1 --user=mysql --console

# start MySQL server
sudo service mysql start

# Retrieve the new generated passwrod for MySQL user root :
sudo grep 'temporary password' /var/log/mysql/error.log

> 2023-11-28T09:58:06.960926Z 6 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: %g3(Xjdr,lRM

# Change Passwrod for root
Alter User 'root'@'localhost' Identified by 'root';

# After changing root password 
sudo mysql_secure_installation
```

[[Database] mysql 설치 및 설정, 기본 계정 생성, 권한부여 With Ubuntu](https://info-desk.tistory.com/5)

```bash
# mysql login and check the result
sudo mysql -u root -p

mysql> show variables like 'lower%';
+------------------------+-------+
| Variable_name          | Value |
+------------------------+-------+
| lower_case_file_system | OFF   |
| lower_case_table_names | 1     |
+------------------------+-------+
```

### chown - 파일 소유권 변경

**chown [-R [ -H | -L | -P ]] [ -h ]** _owner_[_:group_] _file ..._

### chmod - 파일 권한

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/3cf2a7d4-63a6-42bc-a06c-c86736078f1f/b7c8d983-e162-40c9-b5b6-3cda8a778974/Untitled.png)

---

[[Ubuntu] Mysql 완전 삭제, 재설치](https://2vup.com/ubuntu-remove-mysql/)