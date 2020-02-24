---
layout: post
tags: [linux, ubuntu, golang, install, snap]
title: Ubuntu 18.04에 Go 언어 개발환경 설치하기
---

Ubuntu에서의 대표적인 패키지 관리는 apt이긴 하나, apt를 이용해 golang을 설치하면, 1.10 버전이 설치된다. 이 글을 쓰는 시점에서는 1.13이 최신이었으며, 1.10에는 몇가지 큰 문제가 있어서 되도록이면 최신판을 쓰는 것이 좋다.

한줄요약. apt 쓰지 말고 snap을 쓰셈.

``` 
sudo snap install --classic go
```