---
layout: post
categories: summary
tags: [web, development, draft]
title: Web 개발 환경 설정
---

요즘 웹 개발 추세와 웹 개발 환경 설정 방법과 관련 도구들에 대해 정리해 본다. 현업으로 개발에 참여해야 흐름을 놓치지 않을텐데 웹질과 책으로는 맛만 보고 넘어가는 한계가 있네...

나이는 먹어가고... 머리는 굳어가는데.. 세상은 빨리 변해가고.. 에혀..



## JavaScript 의 발전

이제 WWW 웹 서비스뿐 아니라 다양한 플랫폼에서도 구동 가능함.

- Desktop 앱 개발 (Windows/mac/Linux)
  - "Electron" 
    - chromium 기반
- Mobile 앱 개발 (IOS/Android)
  - "React Native" 

## 개발환경 설정

### Front-End Build 도구

#### npm 활용법
npm에 대해서는 대부분 알 거고, package.json을 이용하는 방법을 간단히 정리함
- package.json은 설치되어야 할 package list를 기입하기도 하고
- "scripts" 필드에 각종 명령을 기입할 수 있다.

``` 
"scripts" : {
    "build:dev" : "webpack --mode development"
    "build:prd" : "wepback --mode production"
}
```
이렇게 해 두고 아래와 같이 실행 명령을 간단히 할 수 있다. 
``` 
npm build ==> TODO: check, find, correct
```


#### WebPack

- 여러 CSS. js 간 의존관계 해소할 수 있게 해주며, 하나의 파일로 떨궈줌
##### 설치방법
  ```
  npm install -D webpack webpack-cli
  ```
- webpack.config.js 파일을 만들어 아래의 주요 항목들을 만들어 준다.
  - entry
  - output
  - loader
    - 여러 종류의 loader가 있음
      - babel-loader : old version js 호환성 
      - style-loader : 동적 style tag 생성, css 적용
      - css-loader : css 의존관계 해소
  - resolve
- plug-in

> example template을 하나 만들어 재사용하는 것이 좋음

TODO : Example Template 하나 만들자!