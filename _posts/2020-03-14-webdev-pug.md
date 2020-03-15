---
layout: post
categories: draft
tags: [web, development, pug]
title: PUG 사용방법 
---

PUG 사용 방법에 대해 간략히 정리함


## 파일 분할하여 재활용성 높이기

### 레이아웃  만들기

- Layout 디렉토리 만들고 main.pug 파일을 아래처럼 만든다.

```
doctype html
  html
    head
      title MYTITLE

      body
        header
          h1 HEADER
        main
          block content
        footer
          span &copy; WTF
```

### 레이아웃 불러서 필요한 부분만 채우기

```pug
extends layout/main

block content
  p Hello
```
## partial 사용하기

### 레이아웃 살짝 수정하기

```
doctype html
  html
    head
      link(rel="stylesheet" href="....")
      title MYTITLE

      body
        header
          h1 HEADER
        main
          block content
        include ../partials/footer
```
- stylesheet는 fontaswesom에서 만든 링크를 이용(무료?)


### ../partials/footer.pug 만들기

```
footer.footer
  .footer__icon
    i.fab.fa-youtube
  span.footer__text &copy; #{new Date().getFullYear()} WTF
```
- javascript 코드를 넣고 싶을때는 #{} 안에 넣어줌.
- i는 icon
- a(href="#") LINK_TEXT
- .fab은 <div class=fab> 과 같은 뜻

### JavaScript 코드와 Pug간 데이터 연계

일단 routes에 express의 route가 정의되어 있다고 전제하고.. 모든 http request는 이 함수를 거쳐서 routing된다라고 가정할 때

```
import routes from "./routes";

export const localMiddleware = (req, res, next) => {
    res.locals.variable_name = "value";
    res.locals.routes = routes;
}
```

locals 라는 변수에 하위 변수로 그냥 달아주면, 모든 pug 파일에서 아래와 같이 접근할 수 있다.

```
header.header
    .header__column
        a(href=routes.home)
            i.fab.fa-youtube
    .header__column
        ul
            li
                a(href=routes.join) join
            li
                a(href=routes.login) login
```

또는, pug 파일에서 JavaScript 코드를 embedding 할 때는 아래 처럼 직접 변수이름에 접근하면 된다.
```
footer.footer
    .footer__icon
        i.fab.fa-youtube
    span.footer__text #{variable_name}
```

### Express Controller 부분에서 바로 넘겨줄 때

```
export const home = (req, res) => res.render("home", variable_name: "홈이여!");
```
요로코롬 해도 된다.
단순한 문자열뿐 아니라 object를 넘길 수 있고, ","를 구분자로 해서 여러개 넣을 수 있다.
```
export const home = (req, res) => res.render("home", {variable_name: "홈이여!", fuckin: "개눌당");
```

PUG 파일에서 쓸 때는 이렇게 쓰면 바로 가져다 쓸 수 있다네..
```
extends layouts/main

block content
    p=fuckin
```

### mixin 
주로 자주 사용되는 HTML 파트를 미리 만들어 놓고 필요할때 삽입해서 사용하는 방식.

mixins/videoBlock.pug 를 아래와 같이 만듬.

```
mixin videoBlock(video = {})
    h1=video.title
    p=video.description

--

home.pug에서
```
extends layouts/main
include mixins/videoBlock

block content
    .videos
        each item in videos
            +videoBlock({
                title:item.title, 
                description: item.description
            })

```

## Template

TODO

- 디렉토리 구성 (draft)
  - layout
    - layout.pug
  - partial
    - header.pug
      - html의 header가 이니라, body 내에서의 title 정도에 해당됨
    - footer.pug
      - 날짜 표시
        - JavaScript 활용
  - home.pug
  - example.pug