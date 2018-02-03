---
layout: post
title: "증명사진 이미지 생성 서비스 개발기"
author: "Wook Hyun"
categories: upcoming
tags: [dev log]
image: arctic-1.jpg
---


뭐, 개발기라 할 것도 없고... 오픈소스 이것저것 엮어서 만든 것일 뿐.


# 환경설정 Installation

> $ npm install
package.json에 기재된 dependency, library 등을 설치해 줌

> cairo 에서 에러가 나올꺼임.
libpng 에러가 나올땐 [여기](https://github.com/Automattic/node-canvas/wiki/installation---osx#installing-cairo)를 참고하자.
Pixman 관련 에러가 나오면 [여기](http://macappstore.org/pixman/)를 참고하자.

> node canvas 관련 에러가 뿜뿜할 때는...
[여기](https://github.com/Automattic/node-canvas)를 참고해 보자.
> brew install pkg-config cairo pango libpng jpeg giflib

