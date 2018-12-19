---
layout: post
title: "Python에서 OpenCV 사용하기"
author: "Wook Hyun"
categories: documentation
tags: [blog]
image: nature-1.jpg
comments: true
---




python으로 openCV를 이용해 카메라/영상을 제어하고자 할때..
<hr>
# Background

## 설치

mac에서 설치하고자 할 경우, 

```bash
$ brew install opencv
$ ln -s /usr/local/Cellar/opencv/3.4.3/lib/python3.7/site-packages/cv2.cpython-37m-darwin.so cv2.so
```

opencv library가 설치된 곳을 찾아서 개발하고자 하는 디렉토리에 symbolic link를 만들어 줘야 함.
아니면 library path를 맞춰주던가 해야 하는데.. 일단은 symbolic link로 진행

## Trouble shooting

맥에서 iterms 등을 이용해서 실행하면 privacy issue로 인해 segmentation fault 나면서 중단된다.
이럴 때는 MacOS에서 기본적으로 제공하는 terminal.app을 이용하면 된다.
refer to [https://stackoverflow.com/questions/52634009/opencv-python-scripts-mac-aborts]

<hr>
# Examples

## Basic 01 : 카메라영상을 화면에 띄우기

비디오 화면을 받아서 화면에 띄워 줌

```python

# $ brew install opencv3

import numpy as np
import cv2

cap = cv2.VideoCapture(0)

while(True):
    # Capture frame-by-frame
    ret, frame = cap.read()
    frame = cv2.flip(frame,1)                       # 0: 상하반전, 1: 좌우반전
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)  # 흑백으로 바꽈보자
    cv2.imshow('frame', gray)   
    if cv2.waitKey(1) & 0xFF == ord('q'):           # 터미널이 아닌 Player에서의 Key in을 받아들임.
        break
        

# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()
```


## Basic 02: Mouse cursor 위치 잡아오기, 화면에 도형 그리기


```python

#
# https://opencv-python-tutroals.readthedocs.io/en/latest/py_tutorials/py_gui/py_mouse_handling/py_mouse_handling.html#mouse-handling
#
# 잘 돌아는 간다. 근데 엄청 느리다.
#


import cv2
import numpy as np

drawing = False # true if mouse is pressed
mode = True # if True, draw rectangle. Press 'm' to toggle to curve
ix,iy = -1,-1

# mouse callback function
def draw_circle(event,x,y,flags,param):
    global ix,iy,drawing,mode

    if event == cv2.EVENT_LBUTTONDOWN:
        drawing = True
        ix,iy = x,y

    elif event == cv2.EVENT_MOUSEMOVE:
        if drawing == True:
            if mode == True:
                cv2.rectangle(img,(ix,iy),(x,y),(0,255,0),-1)
            else:
                cv2.circle(img,(x,y),5,(0,0,255),-1)

    elif event == cv2.EVENT_LBUTTONUP:
        drawing = False
        if mode == True:
            cv2.rectangle(img,(ix,iy),(x,y),(0,255,0),-1)
        else:
            cv2.circle(img,(x,y),5,(0,0,255),-1)


img = np.zeros((512,512,3), np.uint8)
cv2.namedWindow('image')
cv2.setMouseCallback('image',draw_circle)

while(1):
    cv2.imshow('image',img)
    k = cv2.waitKey(1) & 0xFF
    if k == ord('m'):
        mode = not mode
    elif k == 27:
        break

cv2.destroyAllWindows()            
```