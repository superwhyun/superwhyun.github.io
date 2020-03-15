---
layout: post
categories: summary
tags: [web, development, draft]
title: Web 개발 환경 설정
---

요즘 웹 개발 추세와 웹 개발 환경 설정 방법과 관련 도구들에 대해 정리해 본다. 현업으로 개발에 참여해야 흐름을 놓치지 않을텐데 웹질과 책으로는 맛만 보고 넘어가는 한계가 있네...

~~나이는 먹어가고... 머리는 굳어가는데.. 세상은 빨리 변해가고.. 에혀..~~




## JavaScript 의 발전

이제 WWW 웹 서비스뿐 아니라 다양한 플랫폼에서도 구동 가능함.

- Desktop 앱 개발 (Windows/mac/Linux)
  - "Electron" 
    - chromium 기반
- Mobile 앱 개발 (IOS/Android)
  - "React Native" 

## 개발환경 설정

### Front-End Build 도구

---

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
npm run build:dev
```
몇가지 키워드들이 있긴한데, 자세한건 공식 홈페이지 내용 참고할 것.


---

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

---

#### Babel
- ES6로 개발된 JavaScript를 오래된 브라우저들도 인식할 수 있도록 예전 문법으로 변환시켜주는 툴 (https://babeljs.io)

##### 설치
```
npm install @babel/node
npm install @babel/core
```

- 여러 preset 들이 있으며, 적당한 것을 선택
  - env
  - stage-0
  - stage-1
  - stage-2
  - stage-3

##### preset 설치
```
npm install --save-dev @babel/preset-env
```
##### .babelrc 파일 만들기
```
{
  "presets": ["@babel/preset-env"]
}
```

##### package.json수정
```
"scripts": {
  "start": "babel-node index.js"
}
```

##### 실행
```
npm start
```

---

#### Nodemon
- node.js 를 개발할 때 source code의 변화가 생길때마다 자동으로 node.js 를 재실행 시켜주는 프로그램

##### 설치
```
npm install nodemon -D
```
- D 옵션을 넣으면 package.json의 dependency에 들어가지 않도록 함
- nodemon은 개발시에만 사용하는 것이니 배포용에는 포함되지 않도록 하는 것임

##### package.json 수정
  
- nodemon을 설치한 이후에, package.json을 아래처럼 함

```

  "scripts": {
    "start": "nodemon --exec babel-node init.js --delay 2"
  },
```
- babel을 쓸 경우에는 어느정도 delay를 넣어주는 게 좋다.


---

#### morgan

TODO

---

#### Helmet

TODO

---

#### Pug

##### 설치
```
npm install pug
```
##### 설정(node.js express에서)
  - node.js의 express에서 view engine을 pug로 바꿔줘야 함 - [참고](http://expressjs.com/en/4x/api.html)

  ```javscript
  import express from "express"

  const app = express();

  app.set("views", "/views");
  app.set("view engine", "pug");
  ```
  - views디렉토리내에 pug 파일들이 위치한다.
  - /views에 homes.pug 파일이 있다고 할 때 아래처럼 바꿔줌


  ```express const home = (req, res) => res.render("home")```


##### 사용하기

```
p HELLO ==> <p> HELLO </p>
```

더 많은 내용을 다루기에는 내용이 너무 길어질 것 같아 사용방법에 대해서는 [다른 포스트](TBD)에서 다룸


[Resources]
- [https://fontawesome.com/](https://fontawesome.com/)


[References]
- [유튜브 클론코딩](https://github.com/nomadcoders/wetube/)