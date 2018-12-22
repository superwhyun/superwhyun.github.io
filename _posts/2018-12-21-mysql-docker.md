---
layout: post
title: "Docker container에서 mysql server 실행 안되는 문제"
author: "Wook Hyun"
categories: tips
tags: [blog]
image: docker.png
comments: true
---


# 증상

- docker build로 특정 Dockerfile을 이용해 image를 만드는 과정에서 mysqld를 실행하는 단계에서 에러가 발생되며 종료한다.
- Docker 내부 로그를 들여다보면, 무슨 파일의 권한(privilege) 문제로 서버가 시동되다가 멈추는 현상이다.

# 원인

- Docker image가 생성될 때의 mysql UID와 실행될 때의 UID가 다르기 때문에 발생
- 좀더 깊은 내용은 [여기](https://stackoverflow.com/questions/50397971/run-mysql-a-prefilled-docker-container-as-random-non-root-linux-user) 참고


# 해결책

해결법은 아래와 같이 /var/lib/mysql, /var/run/mysql 의 소유권을 mysql:mysql 로 해주면 된다.


- Dockerfile에서 mysql 관련된 명령을 실행하기 전에 /var/lib/mysql에 대한 허가권을 다시 터치해 줌
```yml
    RUN chown -R mysql:mysql /var/lib/mysql && chown -R mysql:mysql /var/run/ && service mysql start 
```
주의할 점은 반드시 이 줄은 하나의 RUN 명령줄에 포함되어 있어야 함. 별도의 RUN을 만들어 쓰게 되면 중간단계의 container 이미지가 삭제되기 때문에 명령의 결과가 반영되지 않는다. 

- docker-compose.yml에서 명령을 실행할 때 허가권 바꿔주는 명령을 실행하도록 함
```yml
  ixs:
    image: ixs:1.3.1
    ports:
      - "9000:9000"
      - "9010:9010"
    command: bash -c "chown -R mysql:mysql /var/lib/mysql && /uprep/ixs.sh 192.168.1.4:9000 9010"
    container_name: uprep_ixs_1.3.1
    tty: true
```

