---
layout: post
tags: [linux, commands]
title: Not frequently used, but useful Linux command examples
---

많이 사용되지는 않으나, 필요한 명령어들의 사용법들에 대해 요약 기재한다.
비정기적으로 업데이트할 예정이다.


## SSH, SCP, …

ssh와 scp를 이용해 할 수 있는 기능들에 대해 간단히 요약한다.

### SSH Tunneling

#### In host A,
```
$ ssh -R 5353:127.0.0.1:22 USER_B@HOST_B_ADDRESS
```

U can use following script for making re-establishment after connection lost(optional)

```
#!/bin/bash
while :
do
        ssh -R 5353:127.0.0.1:22 USER_B@HOST_B_ADDRESS
        sleep 30
done
```
또는
```
while ! ssh -i some.rpi.key -p 2022 whoever@localhost "tmux a || tmux"; do
        sleep 1;
done;
```

autossh를 쓰면 이 모든 것을 자동으로 해 주나, 최근 우분투 리눅스의 apparmour가 아예 이 프로그램이 실행되는 것을 커널레벨에서 disable 시켜서 더 이상은 사용할 수 없다. (~~그러나 라즈베리파이라면?~~)


#### In host B,
```
$ ssh USER_A@localhost -p 5353
```

### SCP 파일 복사(이제 FTP 따위는 개나 줘버..)

```
$ scp myfiles myid@myhost:~/
...
$ scp myid@myhost:myfiles .
...
```

### SSH로 원격 명령 실행

ssh id@host ls -l
SSH로 원격 데몬형 프로세스 실행

ssh id@host screen -d -m <command>




## Network


특정 port 를 listening 하고 있는 프로세스/프로그램 찾아내기
```
sudo lsof -i -P -n|grep LISTEN
```

## Conda


로그인 할때 자동으로 내가 원하는 environment로 셋팅하려면 .bashrc 파일의 제일 끝에 아래와 같이 해 주면 됨. 이건 뭐 팁도 뭣도 아님.

```
source activate <env-name>
```
### 환경 생성, 삭제
```
conda create -n <name> python=3.7
conda env remove -n <name>
```

## System Administration


### hostname 변경

```
 hostnamectl set-hostname
```

### .DS_Store 파일 삭제

```
find . -name ".DS_Store" -depth -exec rm {} \;
```

### snap과 apt-get의 차이

snap은 sandbox 형태로 필요한 라이브러리까지 모두 포함해서 설치하는 것으로 우분투 16.04 부터 지원하기 시작함. 최근 많은 응용 프로그램들이 snap 기반으로 제공되고 있으며 점차 늘어날 것으로 판단됨.


## Git

### 한글파일명이 깨질때
```
git config --global core.quotepath false
```

### remember id/password
```
git config credential.helper store
또는
git config --global credential.helper 'cache --timeout 7200'
```

### local을 remote에 있는 파일로 덮어 쓰기

```
git fetch --all
git reset --hard origin/master
git pull origin master
```

### git add 취소

```
git reset 
git reset <filename>
```

### git tag 목록 보기

```
git tag
```

### git tag 달기
```
git tag ver.1.0
git tag ver.2.0
git push --tags # git tag를 remote repository에 올리려면,
```
### git tag를 삭제하려면
```
git tag -d ver.1.0
git push origin :ver.1.0
```

## Docker

### remove all containers
```
docker ps -a | awk '{print $1}' | xargs -t docker rm
```


### remove all networks
```
docker network ls | awk '{print $1}' | xargs -t docker network rm
```