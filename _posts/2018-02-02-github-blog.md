---
layout: post
title: "Github.io Blog 만들기 "
author: "Wook Hyun"
categories: documentation
tags: [blog]
image: cuba-1.jpg
---


## Github.io 에 블로그  만들기

다양한 블로그 사이트가 있기는 하나, git을 이용해서 관리가 가능하다는 장점이 있으며 markdown을 쓸 수 있어서 ithub.io를 이용해 보기로 함.

<hr>

### Github.io에 블로그 주소 만들기

1. Github에 계정만들기
2. 새로운 repository를 '계정명.github.io'로 만든다.
* 예전에는 새로운 브랜치를 만들어서 했는데, 이제 그렇게 하지 않아도 된다.
3. git push를 통해 내가 만든 홈페이지를 올린다. 끗.

<hr>

### Jekyll 템플릿 이용하기

내가 만든 홈페이지가 있다면 그냥 github에 올리면 되지만, 새로 만들려면 이미 만들어진 템플릿을 쓰는 것도 좋다. 마침 github.io에서 jekyll 이라는 프레임워크를 지원하니 이것을 사용해 보도록 하자.


일단 로컬에서 작업한 이후 Github에 push를 하는 형태로 개발하면 되는데, 로컬에서 작업할 때 Jekyill로 만들어진 페이지들은 일반 웹서버에서는 보여지지 않는다. 그렇기 떄문에 전용 웹서버를 jekyill 툴로 구동시켜야만 한다. 자세한 내용은 [여기](https://mycyberuniverse.com/web/how-fix-jekyll-build-serve-error-message.html)를 참고하자.

**[1] 템플릿 다운로드**

템플릿을 [여기](http://jekyllthemes.org/)에서 다운받아 압축을 푼 디렉토리로 가서.. 아래 명령을 실행한다.

> $ gem install bundler

> $ bundle install

> $ bundle exec jekyll serve 


**[2] 로컬 서버 접속하기**

그리고 웹 브라우저에서 잘 동작하는지 들여다 보자. 브라우저를 열고 주소창에 http://localhost:4000 를 입력하자

**[3] 원격 서버에 업로드하기**

잘 만들어진 것 같으면 github에 push하기

> $ git push origin master

**[4] 원격 서버 접속하기**

https://계정명.github.io 에 접속해 보기. 끗.


**[5] Jekyll 설정 잡아보기**

_config.yml 과 _settings.yml 만 만지면 된다. 보면 안다.

<hr>
### Jekyll 기반 글쓰기

_post/ 디렉토리 밑에 naming 규칙에 맞게 파일을 생성하고, YAML front matter block에 간단한 메타데이터를 입려하면 자동으로 페이지가 생성된다.

주의할 점으로,..
* YML font matter block에 포함된 image 파라미터에는 external link image를 달 수가 없다. 즉, assets/img/ 밑에 위치한 이미지만 로딩 가능하다.


<hr>

### 댓글 달기 기능 추가하기

**TBD**

<hr>

### Markdown 사용 팁

전체 목록은 [[마크다운 깃헙 가이드]](https://guides.github.com/features/mastering-markdown/)를 참고하고, 
기본적인 것들은 [https://jekyllrb.com/docs/posts/](https://jekyllrb.com/docs/posts/)를 참고하자.

가급적이면, 이 포스트에서는 그 외의 것들을 다뤄본다.

- 글자에 색상을 넣고, 글자 크기도 조정하고 싶어요

```css
<span style="color:blue;font-size:8pt">aaa</span>
```

이미지를 넣고 싶으면 아래 태그를 이용하고, 
이미지는 assets/img 폴더 밑에 넣어주자.

![screenshot]({{ "/assets/images/openai.png" }}){:class="img-responsive"}


<hr>
## Trouble shooting
- 새로만든 페이지가 보이지 않는다. 
  - 여러 가능성이 있지만, 아래 명령을 실행한 후 로그 메시지를 확인한다.
> bundle exec jekyll build --verbose 
    - 파일명에 기술된 날짜가 future 인지 확인. 오늘 날짜보다 다음 날짜인 경우 인식하지 않는다.


- jekyll 실행시 에러가 나온다.
  - 명령어 실행구문이 바뀐 모양이다. 아래 명령을 실행하자.
> bundle exec jekyll serve --watch

<hr>

## References
1. [https://stackoverflow.com/questions/30625044/jekyll-post-not-generated](https://stackoverflow.com/questions/30625044/jekyll-post-not-generated)