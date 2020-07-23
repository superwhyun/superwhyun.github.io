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

### Trouble Shooting

bash에서는 잘 되던 것이 zsh를 이용해서 디렉토리를 recursive하게 가져오려고 할 경우 다음과 같은 에러가 나올 수 있다.
```
(base) whyun@u2pia tmp % scp -r user@host:*.jpg .
zsh: no matches found: pi@u2pia.duckdns.org:*.jpg
```

이럴때는 아래처럼 *을 사용하기 전에 \을 붙여준다.
```
(base) whyun@u2pia tmp % scp -r user@host:\*.jpg .

```


## Network


### 특정 port 를 listening 하고 있는 프로세스/프로그램 찾아내기

```
sudo lsof -i -P -n|grep LISTEN
```

### 원격지에 위치한 리눅스 서버의 X-window에 GUI 응용 띄우기

간혹 X-window GUI 응용을 띄워야 할 경우가 있는데, 원격지에서는 이게 되지 않는다.

원격지로 GUI 자체를 전송하는 것은 xhost와 DISPLAY 환경변수 조합만 맞춰주면 예전(20년....)에는 되었는데, 이제 조금 복잡한 과정을 거쳐야 한다. 

일단, 지금 필요한 것은 리눅스 원격지 서버에 띄워진 X window에 GUI 응용을 실행시키는 것이므로...
아래처럼 해 주고 실행하면 된다.

```
export DISPLAY=:1
```

간혹, 안되는 경우, 뒤의 숫자를 0에서 시작해서 하나씩 올려보는 것도 한 방법이다.



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