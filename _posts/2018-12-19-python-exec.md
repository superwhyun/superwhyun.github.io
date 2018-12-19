---
layout: post
title: "Python에서 fork, exec등을 위한 subprocess 사용법"
author: "Wook Hyun"
categories: tips
tags: [blog]
image: nature-1.jpg
comments: true
---


# 예제코드

특정 사이트를 미러링하도록 하는 코드

저장되는 위치는 pages 폴더에 위치하도록 wget 파라미터를 넘겨줌.

```python

import subprocess
import time

base_link = "https://a.b.c"
page_cnt = 1

# 1, 354
for cnt in range(41, 50):
    link = base_link+str(cnt)
    p1 = subprocess.Popen(["wget", link, "-P", "pages"], stdout=subprocess.PIPE)
    stdout,stderr = p1.communicate()
    time.sleep(3)
```