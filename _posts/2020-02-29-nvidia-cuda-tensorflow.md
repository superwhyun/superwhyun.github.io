---
layout: post
categories: information
tags: [nvidia, cuda, tensorrt, install]
title: Ubuntu 18.04에 cuda, tensorrt 등 설치하기
---

이 포스트는 Ubuntu 18.04에 Nvidia Driver, cuda, cudnn, tensorRT를 설치하는 방법에 대해 기술한다. 참고로 이 글을 쓰는 시점에서 Tensorflow 2.1은 Cuda 10.1 까지만 지원하고 있다. 곧 10.2도 지원할 수 있을 것이라 생각되니 설치 전에 확인 바람. 소스레벨에서 컴파일 하면 10.2도 가능하다고는 한다(~~뭘 굳이 그렇게 까지..~~)


## 이전 버전 삭제

혹시 이전 버전이 설치되어 있을 경우, 라이브러리가 꼬일 수 있으므로 사전에 미리 정리해주자.

먼저 뭐가 있나 살펴 보고..

```
$ apt list|grep cudnn

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

libcudnn7/unknown 7.6.5.32-1+cuda10.0 amd64
libcudnn7-dev/unknown 7.6.5.32-1+cuda10.0 amd64
```

지워버리자

```
sudo apt autoremove libcudnn7
sudo apt-get --purge remove 'cuda*'
sudo apt-get autoremove --purge 'cuda*'
sudo rm -rf /usr/local/cuda
sudo rm -rf /usr/local/cuda-10.0
```



## Nvida의 deb 파일을 이용한 설치

 - NVIDIA graphic card driver 설치
 - CUDA 라이브러리 설치
 - CUDNN 설치
 - TensorRT 설치

NVIDIA SDK 홈페이지에서 필요한 설치파일들을 다운받자. deb 파일을 다운 받는 것을 기준으로 이후 설명을 진행하겠다.
![download](/assets/images/2020-02-29-19-03-12.png)

### Nvidia Driver 설치

얘도 Nvidia 홈페이지에서 다운 받아 설치할 수 있기는 한데, 쉽게 가자.

```
sudo apt-get install --no-install-recommends nvidia-driver-430
```

### CUDA 설치
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
```

### CUDNN 설치

자신의 시스템 버전에 맞는 cudnn을 다운 받자. deb 파일로 하자. 
```
sudo dpkg -i libcudnn7_7.6.5.32-1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.6.5.32-1+cuda10.0_amd64.deb
```
이렇게 하면, /var/cudnn-xx-xx-xx 라는 폴더에 deb 파일들이 쭈욱 풀린다.
이후에 이 폴더를 apt 로 검색이 가능하도록 아래 명령을 실행한다.
```

```
이제 apt 명령을 사용해서 /var 밑에 있는 deb 파일들을 설치하자.
```
sudo apt update
sudo apt install cudnn
```


### TensorRT 설치
이번에는 __자신의 시스템 버전__, __설치된 cuda버전__ 에 맞는 녀석을 다운 받자.

https://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html#downloading (~~에서 하라는 대로 해서 되면 좋겠지만, 언제나 그러하듯 문제가 생긴다. ~~) 에서 하라는 대로 하면 된다.

```
sudo dpkg -i libtensorrt7-xxxx
sudo apt update
sudo apt-get install tensorrt
```




## APT를 이용한 설치

비슷한 방법이긴 한데, 이게 약간 좀 더 쉬운 면은 있다.
대동소이하다.

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


## Trouble Shooting
 
### Public Key signature error
혹시 apt update를 했을때, 이런 류의 에러가 뜰 때는 
```
W: Failed to fetch https://nvidia.github.io/libnvidia-container/ubuntu18.04/amd64/InRelease  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 6ED91CA3AC1160CD
```
아래와 같이 해 준다.
```
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
```

nvidia의 gpgkey가 만료되었기 때문에 그런거다.



## References
- https://hwiyong.tistory.com/233
- https://tablefi.tistory.com/133
- https://devtalk.nvidia.com/default/topic/1042683/tensorrt/unmet-dependencies-tensorrt-depends-libnvinfer5/2
- https://www.tensorflow.org/install/gpu
- https://teddylee777.github.io/linux/CUDA-이전버전-삭제후-재설치하기
- 




