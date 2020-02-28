---
layout: post
title: "Source code 예쁘게 프린트 하기"
author: "Wook Hyun"
categories: documentation
tags: [enscript, source, print]
image: source-code.jpg
comments: true
---

<div style="text-align: right; font-size: 50%"> 
 <a href="https://www.crazyegg.com/blog/8-reasons-analyze-source-code/">image from</a>
</div>

Visual Studio/Xcode 등을 이용해서 소스코드 프린트하면 글자 짤리고 폰트 너무 크고 등등의 이유로 보기가 좋지 않다. 예전엔 c2ps, c2pdf등이 있어서 참 잘 썼는데, 이제는 지원이 안되거나 한다.
a2ps를 써도 되긴 하는데, 얘도 거의 노인학대 수준이라 요즘에 쓰기가 어려운 경우가 많다.

그래서 좀 뒤져봤더니,... 몇가지가 찾은 것을 정리함.

## enscript

c2ps, a2ps의 대체자로 자리매김한 듯한 command line 명령어이다. 맥에서는 brew를 이용하면 설치 가능하며, 리눅스 계열은 apt-get으로 설치한다.
소스코드는 예쁘게 잘 뽑아주기는 하나, 한글지원이 안된다.

### Source code printing example
```
enscript -2Gr --color -Eperl naver.py -p a.ps
enscript -2Gr --color -Ejavascript sample.js -o s.ps
```

### Text printing example

```
% enscript -G stuff.txt
  Fancy ("Gaudy") headers
% enscript -2r stuff.txt
  Two-up printing -- two pages side-by-side on each page of paper
% enscript -2Gr stuff.txt
  Two-up with fancy headers
% enscript -P otherps stuff.txt
  Print to the otherps printer instead of the default
% enscript -d otherps stuff.txt
  Ditto
% enscript -i 4 stuff.txt
  Indent every line four spaces
% enscript --pretty-print=cpp Object.cc
  Pretty print C++ source code
% enscript -E doit.pl
  Pretty print doit.pl (and automagically figure out that it's Perl from the .pl suffix)
```

### References
[[1](https://docstore.mik.ua/orelly/unix3/upt/ch45_07.htm)]