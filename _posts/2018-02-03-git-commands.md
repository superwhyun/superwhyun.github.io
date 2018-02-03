---
layout: post
title: "Git, Github 활용 팁 정리"
author: "Wook Hyun"
categories: upcoming
tags: [blog]
image: nature-1.jpg
comments: true
---
## Git command


### 소스코드를 다운 받을 때
```
$ git clone [address]
```

<span style="color:blue">aaa</span>

### 소스코드를 올릴 때

``` 
$ git init
$ git remote add https://[git-repository-address
``` 

``` 
$ git add .
$ git commit -m "comments"
$ git push origin master
``` 





## Github

![git, github](https://linode.com/docs/assets/git-github-workflow-1000w.png){:class="img-responsive"}



## Trouble Shooting

### Q. Git commit 이 많이 쌓이면?

commit이 많은 코드를 git clone할 때 마다 모든 히스토리가 따라오기 때문에 크기가 커지는 것 같다. 정말 이러한 것인지, 히스토리를 날릴 수 있는지 확인해 보자.

### Mac에서 github 계정 없애기

가끔 다른 github 계정을 써야 할 경우가 있는데, github account 계정이 시스템 내에 저장되어서 변경이 안된다.
둘을 다 쓰게 하는 방법도 있기는 하나, 해야 할 것이 많다. 걍 날리려면 아래처럼 하면 된다.

- https://help.github.com/articles/updating-credentials-from-the-osx-keychain/