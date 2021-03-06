---
layout: post
title: "각종 Docker images 사용법"
author: "Wook Hyun"
categories: tips
tags: [docker, container]
image: docker.png
comments: true
---

# Nginx 등 웹서버

## Nginx container 사용

### docker-compose.yml 설정

```yaml
  nginx:
    image: nginx:latest
    volumes:
      - ./apps/nginx/conf/nginx.conf:/etc/nginx/nginx.conf
      - ./apps/nginx/www:/usr/share/nginx/html
    ports:
      - "8000:80"
```

### nginx.conf 설정

기본 nginx:latest image를 다운 받고, 아래 처럼 nginx.conf 파일을 수정함.
특히 CORS 설정을 위한 부분 참고필요.

```conf
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    # include /etc/nginx/conf.d/*.conf;

    server {
        listen  80;
        server_name localhost;
        location / {
            root    /usr/share/nginx/html;
            index   index.html  index.htm;

            # Enable CORS
            add_header Access-Control-Allow-Origin *;
 
        }

    }

}

```



# MySQL 등 DB

## Docker container에서 mysql server 실행 안되는 문제

### 증상

- docker build로 특정 Dockerfile을 이용해 image를 만드는 과정에서 mysqld를 실행하는 단계에서 에러가 발생되며 종료한다.
- Docker 내부 로그를 들여다보면, 무슨 파일의 권한(privilege) 문제로 서버가 시동되다가 멈추는 현상이다.

### 원인

- Docker image가 생성될 때의 mysql UID와 실행될 때의 UID가 다르기 때문에 발생
- 좀더 깊은 내용은 [여기](https://stackoverflow.com/questions/50397971/run-mysql-a-prefilled-docker-container-as-random-non-root-linux-user) 참고


### 해결책

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

# 기타 팁

## Docker image 사이즈 줄이기

https://hackernoon.com/tips-to-reduce-docker-image-sizes-876095da3b34

