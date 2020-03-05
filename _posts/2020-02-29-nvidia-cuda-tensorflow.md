---
layout: post
tags: [nvidia, cuda, tensorrt, install, draft]
title: Ubuntu 18.04에 cuda, tensorrt 등 설치하기
---

머신러닝에서는 nvidia 카드를 쓰는게 이제 거의 필수이다시피 한데 (AMD 미안 ㅠㅠ), 사용하려면 손대야 하는게 솔찬히 구찮다.
매번 하는데 매번 까먹고 다시 공부하는 내 메멘토같은 뇌를 위해 다시 정리해 본다. 소스코드를 이용해 설정하는 것 보다 최대한 기존 빌드된 패키지를 이용하는 것으로 하겠다.

 - NVIDIA graphic card driver 설치
 - CUDA 라이브러리 설치
 - 


## TensorRT 설치
https://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html#downloading 에서 하라는 대로 해서 되면 좋겠지만, 언제나 그러하듯 문제가 생긴다.
순서를 보게되면,
### tensorrt 패키지 다운로드     

nvidia sdk 아이디가 있어야 함. 자신의 시스템 버전과 설치된 cuda버전에 맞는 녀석을 다운 받자.

 
### sudo apt-get update
혹시 apt update를 했을때, 이런 류의 에러가 뜰 때는 
```
W: Failed to fetch https://nvidia.github.io/libnvidia-container/ubuntu18.04/amd64/InRelease  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 6ED91CA3AC1160CD
```
아래와 같이 해 준다.
```
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
```

### sudo apt-get install tensorrt

잘 설치되고 넘어갔는가? 축하한다. 그럼 다음으로 넘어가자.
하지만, 이 명령을 실행했을때 다음과 같은 에러가 뜨면 쫌 꼬인거다.
```
The following packages have unmet dependencies:
 tensorrt : Depends: libnvinfer7 (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-plugin7 (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvparsers7 (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvonnxparsers7 (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-bin (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-dev (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-plugin-dev (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvparsers-dev (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvonnxparsers-dev (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-samples (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-doc (= 7.0.0-1+cuda10.0) but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
```
불행히도 나는 이게 떴다. 아마 cudnn 등을 설치할 때 사용한 방식과 차이가 있어서 그런가 보다. [참고](https://devtalk.nvidia.com/default/topic/1042683/unmet-dependencies-tensorrt-depends-libnvinfer5/?offset=22)

내 상태를 찍어보니 아래와 같다. 버전도 동일하게 설치된 것 같은데 왜 문제일지는 잘 모르겠다만, 여기에 시간 쏟지 말자.
```
$ apt list|grep cudnn

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

libcudnn7/unknown 7.6.5.32-1+cuda10.0 amd64
libcudnn7-dev/unknown 7.6.5.32-1+cuda10.0 amd64
```

지워버리자

```
$ sudo apt autoremove libcudnn7

Reading package lists... Done
Building dependency tree
Reading state information... Done
Package 'libcudnn7' is not installed, so not removed
The following packages will be REMOVED:
  libssl-doc
0 upgraded, 0 newly installed, 1 to remove and 0 not upgraded.
After this operation, 5470 kB disk space will be freed.
Do you want to continue? [Y/n]
(Reading database ... 221455 files and directories currently installed.)
Removing libssl-doc (1.1.1-1ubuntu2.1~18.04.5) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
```

NVIDIA SDK 홈페이지에서 다시 다운받자. 이번에는 꼭 .deb 파일을 받도록 하자. 참고로, runtime, dev 둘 다 받아서 설치해야 한다. 샘플은 옵션.
![download](/assets/images/2020-02-29-19-03-12.png)

```
sudo dpkg -i libcudnn7_7.6.5.32-1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.6.5.32-1+cuda10.0_amd64.deb
```

자, 다시 tensorRT를 설치해 보자.
```
sudo apt-get install tensorrt
```

**칙쇼!**
```
Reading package lists... Done

Building dependency tree
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 tensorrt : Depends: libnvinfer7 (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-plugin7 (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvparsers7 (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvonnxparsers7 (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-bin (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-dev (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-plugin-dev (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvparsers-dev (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvonnxparsers-dev (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-samples (= 7.0.0-1+cuda10.0) but it is not going to be installed
            Depends: libnvinfer-doc (= 7.0.0-1+cuda10.0) but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
```

아~ 뭐야~!!!????


아마 cudnn 설치할 때 deb 파일이 아닌 *.run 파일을 이용해서 그런 모양이다.


다시 하라고? 하...

보아하니, 내가 예전에 설치한 cuda는 cuda10이기는 하지만 버전이 7.0.0인데 tensorrt가 필요로 하는 것은 7.6.5이여야 해서 그런 모양이다.

이 참에 10.2 버전으로 모두 다시 올려버리자. 줸장. 세상에 쉬운게 없다니까..

### 예전에 설치된 10.0 버전 삭제~! 
```
sudo apt autoremove libcudnn7
sudo apt-get --purge remove 'cuda*'
sudo apt-get autoremove --purge 'cuda*'
sudo rm -rf /usr/local/cuda
sudo rm -rf /usr/local/cuda-10.0
```

어라? 재부팅하고 난 이후에 서버가 뻗은 모양인지 살아나지 않네...
원격이 뻗어버렸으니 어찌할 방법이 없네...
나중에 다시 해야 할듯.


### cuda 10.2 설치
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
```



어라라..
tensorflow 2.0의 경우, cuda 10.1 만 지원하네? 하하 미촤버리겠네.

```
# Add NVIDIA package repositories
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt-get update
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt-get update

# Install NVIDIA driver
sudo apt-get install --no-install-recommends nvidia-driver-430
# Reboot. Check that GPUs are visible using the command: nvidia-smi

# Install development and runtime libraries (~4GB)
sudo apt-get install --no-install-recommends \
    cuda-10-1 \
    libcudnn7=7.6.4.38-1+cuda10.1  \
    libcudnn7-dev=7.6.4.38-1+cuda10.1


# Install TensorRT. Requires that libcudnn7 is installed above.
sudo apt-get install -y --no-install-recommends libnvinfer6=6.0.1-1+cuda10.1 \
    libnvinfer-dev=6.0.1-1+cuda10.1 \
    libnvinfer-plugin6=6.0.1-1+cuda10.1
```

그냥 이렇게 하래.. ㅎㅎ 미촤...



## References
- https://hwiyong.tistory.com/233
- https://tablefi.tistory.com/133
- https://devtalk.nvidia.com/default/topic/1042683/tensorrt/unmet-dependencies-tensorrt-depends-libnvinfer5/2
- https://www.tensorflow.org/install/gpu
- https://teddylee777.github.io/linux/CUDA-이전버전-삭제후-재설치하기
- 




