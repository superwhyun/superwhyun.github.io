---
layout: post
tags: [ssh, tunneling, reverse, firewall, mosh, raspberry]
title: Reverse tunneling using ssh, and one more thing; mosh
---

SSH reverse tunneling 은 방화벽 등으로 인해 외부에서 접속하여 작업하지 못하는 환경을 위해 *임시로* 만들어 두는 연결방법이다. 
다만, 연결 해 놓고 일정 시간 지나거나 장비 재부팅 등으로 인해 문제가 생길 경우 원격으로 연결 복구가 불가한 문제가 있다. 
이를 위해 autossh 라는 패키지를 이용하면 되나, 최근의 리눅스 시스템에서는 커널 레벨에서 apparmour 를 통해 실행을 못하게 막아두고 있다.
다만, 라즈베리파이는 상대적으로 심플한 OS이기 때문에 아직 막아두지 않고 있어 이를 사용하면 가능하다.

## 준비물

- 라즈베리파이
- 외부 ssh 접속이 가능한 서버, 계정 (이하 외부서버)


## SSH 기본 설정

### (라즈베리파이) ssh 로그인 설정 

HOME 디렉토리의 .ssh 디렉토리내에 "config" 라는 파일 생성하고 다음을 기입한다.
주기적으로 데이터를 송신하여 해당 connection이 끊기는 것을 막는다.
```
ServerAliveInterval 60
```

그리고 아래 명령을 통해 pem 파일을 생성하고 원격지 서버에 전송/등록한다.

```
ssh-keygen -t rsa
ssh-copy-id [USER]@[SERVER]
```
주의할 사항으로 ssh-keygen을 사용할 때 passphrase는 안 넣어줘야 자동으로 로그인이 된다.
여기에 passphrase를 입력하면, 매번 비번을 입력해야 해서 자동으로 로그인하는 맛이 떨어진다. (음?)

### autossh 실행

```
autossh -M 20000 -f -N REMOTE_USER@REMOTE_SERVER -R 9999:localhost:22
```


### (REMOTE_SERVER) ssh 로그인


## 외부 접속
```
ssh PI_USER@localhost -p 9999
```





## mosh 사용
mosh를 사용하면 조금 재미있는 것들을 해 볼 수 있을 것 같기는 하나, 일단 나중에 해 보자.
[함 해보자](http://blog.mattgauger.com/2012/04/21/mosh-ssh-tunnels-tmux/)