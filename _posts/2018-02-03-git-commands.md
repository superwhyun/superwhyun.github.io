---
layout: post
title: "Git, Github 활용 팁 정리"
author: "Wook Hyun"
categories: documentation
tags: [git]
# image: nature-1.jpg
comments: true
---


많이들 쓰니까 좋은갑따~ 하긴 하는데, 어떤 X이 git이 쉽다고 그런건지는 모르겠다만,.. 명령어도 많고 옵션도 많고.. 문제도 많이 생기고... 설명들도 개떡같고...



# Git command

![git, github](https://git-scm.com/images/logos/2color-lightbg@2x.png){:class="img-responsive"}

git가 초기 나왔을 때에는 몇가지 커맨드만 사용하면 되었는데, 요즘은 너무 많고 이해하기도 어렵다. 그냥 많이 써본 것과 유용할 것으로 판단되는 몇가지들만 정리해 본다.


## Basic Command

### 소스코드를 다운 받을 때
```
$ git clone [address]
```


### 소스코드를 올릴 때

``` 
$ git init
$ git remote add https://[git-repository-address]
``` 

``` 
$ git add .
$ git commit -m "comments"
$ git push origin master
``` 

### 히스토리 삭제

히스토리가 쌓이면 repository의 크기가 커지고 올리고 내리고 할때마다 시간도 많이 걸린다.
개인 프로젝트의 경우, 굳이 히스토리를 유지하고자 하지 않으면 다음 [링크](https://gutmate.github.io/2017/03/22/git-history-remove/)를 참고한다.



```bash
$ rm -rf .git
$ git init
$ git add .
$ git commit -m "clear history"
$ git remote add origin {url}
$ git push -u --force origin master
```

만일, 아래와 같은 에러를 리턴하게 되면,
```bash
u2pia:UPREP-2017 whyun$ git push -u --force origin master
Counting objects: 1114, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (1050/1050), done.
Writing objects: 100% (1114/1114), 179.19 MiB | 1.17 MiB/s, done.
Total 1114 (delta 306), reused 0 (delta 0)
remote: Resolving deltas: 100% (306/306), done.
remote: GitLab: You are not allowed to force push code to a protected branch on this project.
To http://x.x.x.x/x.git
 ! [remote rejected] master -> master (pre-receive hook declined)
```

해당 브랜치가 보호(protect)되고 있기 때문이다.

By default, protected branches are designed to:

    - prevent their creation, if not already created, from everybody except Masters
    - prevent pushes from everybody except Masters
    - prevent anyone from force pushing to the branch
    - prevent anyone from deleting the branch

자세한 사항은 [여기](https://stackoverflow.com/questions/32246503/how-to-fix-you-are-not-allowed-to-push-code-to-protected-branches-on-this-proje)를 참고하자.


간단히 정리하면,
- GitLab -> Settings -> Repository 에 들어가서 Protected Branches를 'unprotect' 하도록 한다.
- 다시 push해 본다.
- master branch를 다시 protect한다.


```bash
u2pia:UPREP-2017 whyun$ git push -u --force origin master
Counting objects: 1114, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (1050/1050), done.
Writing objects: 100% (1114/1114), 179.19 MiB | 787.00 KiB/s, done.
Total 1114 (delta 305), reused 0 (delta 0)
remote: Resolving deltas: 100% (305/305), done.
To http://x.x.x.x/x.git
 + b4e956d...40a1a05 master -> master (forced update)
Branch 'master' set up to track remote branch 'master' from 'origin'.
```





<hr>


# Github/GitLab/BitBucket

![git, github](https://github.githubassets.com/images/modules/logos_page/Octocat.png){:class="img-responsive"}

<hr>


### Mac에서 github 계정 없애기

가끔 다른 github 계정을 써야 할 경우가 있는데, github account 계정이 시스템 내에 저장되어서 변경이 안된다.
둘을 다 쓰게 하는 방법도 있기는 하나, 해야 할 것이 많다. 걍 날리려면 아래처럼 하면 된다.

- https://help.github.com/articles/updating-credentials-from-the-osx-keychain/