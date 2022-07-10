---
title: 라즈베리파이에 Mattermost 설치하기
subtitle: 라즈베리파이에 Mattermost 설치하기
categories: information
tags: raspberry, mattermost, cooperation, tool, slack
date: 2022-07-10 23:40:49 +0000
last_modified_at: 2022-07-10 23:40:49 +0000
---

Created: 2022년 5월 5일 오후 10:33
Last Edited Time: 2022년 5월 22일 오전 1:51
Status: 완료
Type: Techinical Memo

<aside>
💡 Slack이 괜찮은 편이기는 하나 무료 메시지 숫자가 10,000개에 제한되어 있어 금방 소진된다. 오픈소스 대안을 찾아보니, 역시나 있다. 슬랙과 거의 판박이로 똑같다. 집에서 놀고 있는 라즈베리파이에 설치해 보았더니 아주 잘 된다.

</aside>

---

## Installation & Setup

### 0. Preparation

```bash
sudo useradd --system --user-group --no-create-home mattermost
sudo mkdir -p /opt/mattermost
sudo chown -R mattermost:mattermost /opt/mattermost/
su mattermost
```

### 1. Install pacakges

```bash
sudo apt update && sudo apt upgrade
sudo apt install mariadb-server
sudo mysql_secure_installation
```

### 2. Setup mysql database

```bash
sudo mysql -u root -p
```

```sql
create user 'mmuser'@'%' identified by 'YOUR_PASSWD';
create database mattermost;
grant all privileges on mattermost.* to 'mmuser'@'%';
flush privileges;
```

### 3. Install Mattermost Server

```bash
cd /opt/mattermost
sudo -u mattermost wget https://github.com/SmartHoneybee/ubiquitous-memory/releases/download/v6.6.1/mattermost-v6.6.1-linux-arm.tar.gz
sudo -u mattermost tar xvfz *.tar.gz
sudo -u mattermost mv mattermost v6.6.1 

```

### 3.1 Server setting

```bash
sudo -u mattermost vi /opt/mattermost/v6.6.1/config/config.json
```

아래처럼 바꿔줌. (underline)

```bash
"SqlSettings": {
    "DriverName": "mysql",
    "DataSource": "mmuser:YOUR_PASSWD@tcp(localhost:3306)/mattermost?charset=utf8mb4,utf8&readTimeout=30s&writeTimeout=30s",
    "DataSourceReplicas": [],
    "DataSourceSearchReplicas": [],
    "MaxIdleConns": 20,
    "ConnMaxLifetimeMilliseconds": 3600000,
    "ConnMaxIdleTimeMilliseconds": 300000,
    "MaxOpenConns": 300,
    "Trace": false,
    "AtRestEncryptKey": "",
    "QueryTimeout": 30,
    "DisableDatabaseSearch": false,
    "MigrationsStatementTimeoutSeconds": 100000,
    "ReplicaLagSettings": []
  },
```

<aside>
💡 그런데, 기본은 postgres인 것으로 봐서, 그냥 그걸로 해도 될 듯 한데? mariaDB가 더 나은점이 있나?

</aside>

### 3.2 Check

- 잘 설치가 되었는지 확인하기 위해 아래 명령을 실행해 봄.
    
    ```bash
    sudo -u mattermost /opt/mattermost/v6.6.1/bin/mattermost
    ```
    
    ![Untitled](%E1%84%85%E1%85%A1%E1%84%8C%E1%85%B3%E1%84%87%E1%85%A6%E1%84%85%E1%85%B5%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%A6%20Mattermost%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%201a9ad3a2d5c246ed9b4e840ee380d0d1/Untitled.png)
    
    - DB에 Access하는데 문제가 있다네.. config에 mysql db password를 잘못 넣어서 그랬던 것임. 고쳐서 다시 실행해 봄.
    
    ![Untitled](%E1%84%85%E1%85%A1%E1%84%8C%E1%85%B3%E1%84%87%E1%85%A6%E1%84%85%E1%85%B5%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%A6%20Mattermost%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%201a9ad3a2d5c246ed9b4e840ee380d0d1/Untitled%201.png)
    
    - 이번엔 뭔가 잘 되는 것 같았으나, 다시 에러가 주루룩
        
        ![Untitled](%E1%84%85%E1%85%A1%E1%84%8C%E1%85%B3%E1%84%87%E1%85%A6%E1%84%85%E1%85%B5%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%A6%20Mattermost%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%201a9ad3a2d5c246ed9b4e840ee380d0d1/Untitled%202.png)
        
    - 맨 마지막에 잘 listening 한다고 나오면 성공한 것임. 약간 시간이 걸릴 수 있으니 이 메시지가 나올때 까지 느긋하게 기다려주자.

### 3.3 자동 실행 설정

- 새로운 서비스를 제어하기 위한 파일을 생성한다.
    
    ```bash
    sudo vi /lib/systemd/system/mattermost.service
    ```
    
- 내용은 다음과 같이 기입한다.
    
    ```bash
    [Unit]
    Description=Mattermost
    After=network.target
    After=mysql.service
    Requires=mariadb.service
    
    [Service]
    Type=notify
    ExecStart=/opt/mattermost/v6.6.1/bin/mattermost
    TimeoutStartSec=3600
    Restart=always
    RestartSec=10
    WorkingDirectory=/opt/mattermost/v6.6.1
    User=mattermost
    Group=mattermost
    LimitNOFILE=49152
    
    [Install]
    WantedBy=multi-user.target
    ```
    

- 자동실행 등록
    
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl enable mattermost.service
    sudo systemctl start mattermost.service
    ```
    

- 서비스 상태 확인하기
    
    ```bash
    sudo systemctl enable mattermost.service
    ```
    
    ![Untitled](%E1%84%85%E1%85%A1%E1%84%8C%E1%85%B3%E1%84%87%E1%85%A6%E1%84%85%E1%85%B5%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%A6%20Mattermost%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%201a9ad3a2d5c246ed9b4e840ee380d0d1/Untitled%203.png)
    
    - 서비스 상태가  Active 이면 잘 동작하는 것이다.

## References

- Installation Mattermost server on RPI4
    
    아래 링크의 내용을 참고하여 설치하였으며, 이 글은 이 튜토리얼의 요약 성격으로 보면 된다.
    
    [Installing Mattermost server on RaspberryPI4](https://minecraftchest1.wordpress.com/2021/03/15/installing-mattermost-raspberrypi4/)
    
- Mattermost Source Repository
    
    [https://github.com/mattermost/mattermost-server](https://github.com/mattermost/mattermost-server)
    
- Mattermost Binary Repository
    
    [Releases · SmartHoneybee/ubiquitous-memory](https://github.com/SmartHoneybee/ubiquitous-memory/releases)