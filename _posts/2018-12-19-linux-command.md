---
layout: post
title: "각종 유용한 Linux 명령어들"
author: "Wook Hyun"
categories: tips
tags: [linux, command, xargs, bash]
image: bash.jpg
comments: true
---

기초적인 것들은 제외..


# SCP를 이용해 터미널 상에서 SSH 연결을 이용해 파일 전송하기

SSH를 이용해서 다른 서버로 파일 전송하기가 참 용이하다. FTP 등을 쓸 필요도 없고, SSH 서버에 직접 전송하기 떄문에 사용하기도 용이하다.

```bash
    scp -P <port> <filenames> <username>@IP:<dest-folder>

    ex>
        그 디렉토리에 있는 파일들을 통으로 옮길 경우,
            scp -P 122 * whyun@x.x.x.x:~/SERVICE/UPREP

        Recursive 하게 할 경우,
            scp -r -P 122 * whyun@x.x.x.x:~/SERVICE/UPREP
```



https://unix.stackexchange.com/questions/106480/how-to-copy-files-from-one-machine-to-another-using-ssh




# AWK, Xargs 등 bash script

특정 사이트의 html 내용 분석해서 mp4 파일만 다운로드하는 shell script

awk, xargs 등의 사용예제를 확인가능함.

```bash
rm article/*
rm pages/*
python3 app.py
grep wr_id pages/board.php\?bo_table\=korea\&page\=*|grep Hot|awk -F 'a href=\"' '{ print $2 }'|awk -F '&amp;page' '{print $1}' | sed 's/\&amp;/\&/' | xargs wget -P article
grep mp4 article/* | awk -F '=http://a.b.c/' '{print "http://a.b.c/" $2}'| awk -F '&amp' '{print $1}'| xargs wget -x
```

