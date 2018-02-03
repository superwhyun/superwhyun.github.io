---
layout: post
title: "증명사진 이미지 생성 서비스 개발기"
author: "Wook Hyun"
categories: documentation
tags: [dev log]
image: id_photo.png
---


증명사진 스캔 파일을 업로드하면, 여권/비자/반명함/증명사진 규격으로 프린트할 수 있도록 크기를 잡아주고 collage를 만들어 주는 웹 서비스.

오픈소스 이것 저것 엮어서 만들어 봄.

# 소스코드 다운 받기

TBD: github에 업로드 예정.

# 개발/구동 환경설정

package.json에 기재된 라이브러리들을 설치해 준다. 

```json

{
        "name": "IDphoto",
        "version": "0.1.0",
        "private": true,
        "scripts": {
                "start": "node app.js"
        },
        "dependencies": {
                "body-parser": "~1.13.2",
                "bootstrap": "~3.3.7",
                "canvas": "1.6.9",
                "ejs": "~2.5.2",
                "ejs-locals": "~1.0.2",
                "express": "~4.14.0",
                "jquery": "~3.1.0",
                "multer": "~1.2.0",
                "multiparty": "~4.1.2",
                "photo-collage": "~1.0.0",
                "serve-index": "~1.8.0"
        }
}
```

package.json이 있는 디렉토리에서 아래 명령을 실행.
> $ npm install

맥의 경우에는 아래의 명령어를 통해 필요한 라이브러리들을 설치하도록 한다. 리눅스의 경우에는 딱히 신경 쓰지 않아도 된다.

> brew install pkg-config cairo pango libpng jpeg giflib

### Trouble shooting
- node canvas 관련 에러 나오면, [여기](https://github.com/Automattic/node-canvas) 참고
- libpng 에러가 나올땐 [여기](https://github.com/Automattic/node-canvas/wiki/installation---osx#installing-cairo) 참고
- Pixman 관련 에러가 나오면 [여기](http://macappstore.org/pixman/) 참고



# 도커 이미지로 만들기

도커에서 구동되게 하기 위해 이미지를 만들때 아래와 같이 함.

```yaml
FROM node
WORKDIR /usr/src/app
COPY ./site /usr/src/app
EXPOSE 5959
RUN npm install
CMD npm start
```

docker-compose.yml에는 아래와 같이 구성함.

```yaml
  idphoto:
    image: idphoto
    ports:
      - 5959:5959
    build: ./app/ID_photo
    networks:
      - frontend
      - traefik
    labels:
      - 'traefik.port=5959'
      - 'traefik.enable=true'
      - 'traefik.docker.network=traefik'
      - 'traefik.backend=idphoto'
      - 'traefik.frontend.rule=Host:idphoto.u2pia.local'   
    deploy:
      replicas : 1    
      restart_policy:
        condition: on-failure
```




