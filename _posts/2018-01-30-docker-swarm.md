---
layout: post
title: "Docker, Docker swarm 사용기"
author: "Wook Hyun"
categories: documentation
tags: [blog]
image: docker-swarm.jpg
comments: true
---

# Vagrant commands

```
실행 - vagrant up
상태 - vagrant status
삭제 - vagrant destroy
중지 - vagrant halt
로긴 - vagrant ssh [machine name]
```
**TODO** : 다른 포스트로 옮길 것.

# Docker

먼저 Docker를 제대로 활용하려면 다음을 이해해야 함
- image
- container
- swarm
- service

<hr>
## Docker 기본 명령어 ##

**Docker image 설치**

> $ docker pull [img_name]

    공식 image repository인 hub.docker.com에 등록된 이미지를 받아온다. 자체 구축한 repository에서 받아오게 할 수도 있으나, 그건 다음 기회에 설명.

**Docker container 실행**
> $ docker run -d -p 9999:80 [img_name]

**Docker image 생성**
> $ docker build -t [maker/name] .

    Dockerfile 이 위치한 디렉토리에서 실행해야 함.

**Docker container의 터미널에 접근**
> $ docker exec -it [container] /bin/bash

**Docker container에 있는 명령어 한번만 실행하기**
> $ docker run -it --rm alpine /bin/sh
    
    rm 옵션은 해당 프로세스가 종료되면 컨테이너도 같이 종료시킴


<hr>
## Docker swarm 관련 명령어

Docker swarm은 여러개의 machine들이 마치 하나의 클러스터처럼 동작하도록 하는 것인데, 불행히도 docker for mac/windows는 single node만 지원한다. 제대로된 클러스터링을 하려면 리눅스에서만 가능하다. 즉, 윈도우/맥은 개발할 때만 쓰란 얘기임. 이 이유가 어차피 윈도우/맥은 native가 아니니까 자체적으로 virutal machine을 띄우고 그 위에 리눅스를 올릴 수 밖에 없어서 성능의 20~30% 이상은 손해보고 들어가는 구조라 정식 서비스에서는 아무래도 낭비요소가 있기 때문일 것으로 생각한다.

개념적으로 swarm이라는 것을 manager와 일반 node로 나눠서 동작을 볼 필요가 있다. 


**In manager**
> $ docker swarm init --advertise-addr [host-ip-address] 

    * 이 명령어를 실행하면 해당 swarm에 할당된 token 과 일반 다른 node에서 실행해야 할 command를 알려준다. 복사해 두자.
    * host-ip-address는 실제 machine의 ip 주소를 의미한다.

**In nodes**
> $ docker swarm join --token [token] [host-ip-address:2377]

    * 조금 전 manager node가 알려준 command를 실행한다. machine이 여러 대면 같은 작업을 반복한다. 메뚝메뚝!
    
**In manager**
> $ docker node ls

    * 클러스터에 join되어 있는 모든 node들의 목록을 보여준다.

<hr>
## Docker service 관련 명령어

swarm mode가 아니어도 동일하게 실행 할 수 있ㄷ. 혹시 swarm cluster에서 구동시키고자 한다면 manager node에서 동작시키도록 한다.

> $ docker service create --name [service_name] --name [name] --network=[net_name] --replicas [num] -e [environment value] -p [port]:[port] [img_name:img_ver]

    * 하나의 docker image를 service로 cluster에서 구동시키는 명령으로, swarm 내의 적절한 노드에 알아서 구동된다.
    * manager machine에 해당 이미지가 없으면 docker hub에서 다운로드 하며, local repository에서 받아오게 할 수도 있음.
    * -p : port mapping
    * --network : 서비스가 연결될 가상의 network 이름 
    * --replicas : 몇개의 프로세스 복제본을 돌릴 것인가
    * -e : container에서 환경변수를 사용함

> $ docker service ls

    * 현재 구동되고 있는 서비스의 목록을 보여준다.

> $ docker service ps [service_name]

    * 어느 노드에서 몇 개의 replica가 돌고 있는지 등의 상세 정보를 보여준다.

> $ docker service update [image_name]=[number]

    * 이미 서비스가 진행 중인 상태에서 image가 업데이트 되는 경우, 동작중인 container들을 대체하는 역할을 한다.
    * 무중단 서비스에 적합하다.
    * 참고로, trouble shooting을 위해 replica당 5개의 최근 프로세스를 남겨두고 있으니, 그게 보이더라도 놀라지는 말자.

> $ docker service rm

    * 진행 중인 서비스를 shutdown할 때 사용

<hr>
## Docker network 관련 명령어

container간 연동할 때 사용되는 가상의 overlay network을 생성 할 수 있다.

> $ docker network ls

    * network 목록을 보여준다.


> $ docker network create —attachable —driver overlay backend
 
    * 'backend'라는 overlay network을 만든다.

<hr>
## Docker stack 관련 명령어

여러개의 서비스를 한번에 구동시킬 때 사용된다. 목적하는 바는 docker-compose와 유사한 데 이 명령은 swarm에 적용 가능하다는 차이가 있다. 
swarm mode가 아니어도 동작 가능하다.

> $ docker stack deploy --compose-file docker-compose.yml [stack_name]

    * docker-compose.yml에 있는 내용을 읽어 여러 서비스들을 한번에 구동시켜준다.

> $ docker stack ls
    
    * 목록을 보여준다.

> $ docker stack rm [stack_name]
    
    * 삭제한다.


<hr>
## References

자세한 내용과 실습을 위해서는 [[Docker Swarm을 이용한 쉽고 빠른 분산 서버 관리]](https://subicura.com/2017/02/25/container-orchestration-with-docker-swarm.html)를 참고하자. 별 다섯개도 모자라다. 단, 아래 내용을 참고하자.
- local.dev 도메인은 쓰지 말자. 자동으로 https로 바뀌면서 페이지를 못 찾을 거다.
- traefik 관련된 부분에서 labels 입력하는 부분이 조금 바뀌었다. 안되더라도 좌절말고 아래 내용 참고하자. labels만 잘 만져주면 된다.
```yml
  portainer:
    image: portainer/portainer
    command: -H unix:///var/run/docker.sock
    ports:
      - 9000:9000
    networks:
      - frontend
      - traefik
    labels:
      - 'traefik.port=9000'
      - 'traefik.enable=true'
      - 'traefik.docker.network=traefik'
      - 'traefik.backend=portainer'
      - 'traefik.frontend.rule=Host:portainer.u2pia.local'
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      # - type: bind
      #   source: /var/run/docker.sock
      #   target: /var/run/docker.sock
    deploy:
      # replicas: 1
      placement:
        constraints:
          - node.role == manager
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
```
