---
layout: post
tags: [raspberry pi, install, setupp]
title: 라즈베리파이 설치, 한글설정 등
---

라즈베리파이를 설치하는 과정을 비롯한 각종 기본 셋업에 대해 정리함.

## 설치

Raspian 받아다 설치함. 이 부분은 다른 포스팅들이 많으니 생략하나 몇가지 주의할 점만 터치한다.
- Country 설정은 한국으로 하지말고 그대로 둔다. 한국으로 하면 Wifi가 disable 되는 경우가 잦다.
- Language 설정도 일단 영어로 가자. 나중에 한글 입력기 설치하고 바꿔도 늦지 않다. 아니, 이렇게 해라.
- 설치 이후 시스템 update 하라는 얘기가 나오는데 안 하는 걸로 하고 넘어가자. 기본 repository에서 받아오면 너무 너무 느리다.

## apt source 설정

terminal을 하나 열어 /etc/apt/source.lists 를 vi로 열어서 다음과 같이 한 줄 추가하고, 기존에 있던 source url은 #으로 주석처리 한다.

```
#deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
# Uncomment line below then 'apt-get update' to enable 'apt-get source'
#deb-src http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
deb http://ftp.kaist.ac.kr/raspbian/raspbian/ buster main contrib non-free rpi
```


## 한글 설정

### 폰트, 입력기 설치
일단 폰트와 한글입력기를 설치한다.
```
sudo apt install fonts-unfonts-core ibus-hangul
```

### 한글 설정
Pi Configuration에 들어가서 Language와 Character set을 'ko'와 'UTF-8'로 바꿔준다.
Xwindows 상에서 메뉴->iBUS config 를 눌러 한글을 설정한다.
화면 최우측 상단의 입력기 메뉴에서 한글을 선택
한글을 선택했는데도 한글 입력이 안되걸랑 iBUS 설정 화면에서 '한글상태'에서 시작을 선택하도록 한다.

### iBUS 자동 시작하도록 설정
```
im-config -n ibus
```

## 시스템 업데이트

``` 
sudo apt update -y
sudo apt upgrade -y
```

** HAPPY RASPi **

