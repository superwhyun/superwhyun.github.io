---
layout: post
title: "우분투 17.10.1에 nvidia-docker 올리기"
author: "Wook Hyun"
categories: documentation
tags: [nvidia, gpu, docker]
image: nvidia-docker.png
comments: true
---




# Ubuntu 17.10.1에 Nvidia-Docker 설치하는 순서

nvidia-docker의 공식홈페이지에 연결된 위키에 절차가 나와 있음. 
https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)

그러나, 이 내용만으로는 부족해서 다시 정리함


1. Ubuntu 설치 --> 평소 하던대로
www.ubuntu.com

2. nvidia 비디오 카드 드라이버 다운로드
[http://www.nvidia.com/content/DriverDownload-March2009/confirmation.php?url=/XFree86/Linux-x86_64/390.25/NVIDIA-Linux-x86_64-390.25.run&lang=us&type=TITAN](
http://www.nvidia.com/content/DriverDownload-March2009/confirmation.php?url=/XFree86/Linux-x86_64/390.25/NVIDIA-Linux-x86_64-390.25.run&lang=us&type=TITAN)

3. Nueveo 비디오 드라이버 동작 정지
오픈소스 비디오카드 드라이버인 nouveau를 정지시켜야 한다. 자세한 방법은 [https://codeyarns.com/2017/09/21/how-to-disable-nouveau-driver/](https://codeyarns.com/2017/09/21/how-to-disable-nouveau-driver/) 참고.

4. GUI 모드 해제 작업
> $sudo systemctl set-default multi-user.target

5. 재부팅

6. Nvidia 비디오 드라이버 설치
터미널만 뜬 상태에서 로그인 후 루트 권한으로 실행
> $ sudo ./NVIDIA-Driver-xxxxx.sh 

7. GUI 모드로 전환 후 재부팅
> $sudo systemctl set-default graphical.target

8. docker CE 설치 - 
[https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository](https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository)

9. nvidia-docker 설치/테스트 -
https://nvidia.github.io/nvidia-docker/

**주의** : 커널 패치 한 이후에 software update하면 먹통됨. 왠만하면 우분투 설치하자마자 software update하고.. 커널 패치하는게 좋음.


