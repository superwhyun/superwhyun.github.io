---
layout: post
title: "증명사진 포토프린팅용 콜라주 이미지 만들기"
author: "Wook Hyun"
categories: documentation
tags: [dev log]
image: id_photo.png
---


증명사진 스캔 파일을 업로드하면, 여권/비자/반명함/증명사진 규격으로 프린트할 수 있도록 크기를 잡아주고 collage를 만들어 주는 웹 서비스로 뜻밖에 유료로 서비스하는 곳이 많음. express, node.js를 이용해서 drag & drop으로 file upload하고, 원하는 규격별로 사이즈 잡은 후에 photo-collage 라이브러리를 이용해 A4 한장에 여러 장의 사진이 배치되도록 함.

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
- node.js는 비동기로 동작하기 때문에 생성된 collage 사진을 지우면 오동작함. 그래서, 할수없이 container내에 위치시키도록 했음. 즉, 컨테이너 내려가면 같이 삭제됨. 또한, 파일이름은 난수로 생성되어 외부 접근이 불가하므로 프라이버시 이슈는 없을 듯하나... 개선은 필요한 부분.


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




