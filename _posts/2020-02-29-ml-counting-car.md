---
layout: post
tags: [machine learning, opencv]
title: 이미지에서 특정객체(e.g, 자동차) 숫자 세기
---

인공지능이란 기술은 나날이 발전하고 있고 새로운 알고리즘들이 계속 나오고 있으나, 대부분의 책이나 교재는 인공지능 자체에 대한 내용을 다루는 것이 주를 이루고 있다. 우리가 데이터베이스 내부 시스템 동작 원리를 몰라도 사용할 수 있는 것 처럼 인공지능이란 녀석도 사용자가 필요한 기능만 사용하면 된다고 본다. 인공지능 알고리즘 자체를 개발하는 것은 천재들에게 맡겨두고, 우리는 여러 알고리즘들을 조합해서 사용할 줄 아는 것이 앞으로 더 중요하지 않을까? 천재들이 할 일은 그들에게 맡겨두고 우리는 그들의 결과물을 잘 써주면 된다. 

그런 의미에서, 이번에 하고자 하는 바는 그동안 내가 찍은 사진들 중 자동차 사진만 추려서 이동하고 싶어서 몇 군데 뒤지다보니.. 역시나 그들은 만들어 놓았다. [참고한 원문](https://towardsdatascience.com/count-number-of-cars-in-less-than-10-lines-of-code-using-python-40208b173554)

## 관련 라이브러리 설치, 준비

requirements.txt를 하나 만들어서 다음과 같이 넣는다.
```
opencv-python
cvlib
matplotlib
tensorflow
keras
```

pip를 이용해 관련 패키지들을 설치하자
```
pip install -r requirements.txt
```

## 코드 설명

이 코드의 핵심은 사실 cvlib을 사용하는 것인데, cvlib은 사용자들이 사용하기 쉽게 만든 파이썬용 오픈소스 비전(vision) 라이브러리이다. [github](https://github.com/arunponnusamy/cvlib)

얘네가 제공하는 흥미로운 기능으로
- face detection
- gender detection
- object detection
- video to frames
- creating gif
등이 있다. 좀더 자세한것은 위 github 링크에서 알아보도록 하고, 일단 우리는 먼저 가는거다. 엔지니어는 막힐떄까지 매뉴얼따윈 보지 않지.. (그러다 x되는 경우가 많다는건 덤)

```python
import cv2
import matplotlib.pyplot as plt
import cvlib as cv
from cvlib.object_detection import draw_bbox
im = cv2.imread('photo.png')
bbox, label, conf = cv.detect_common_objects(im)
output_image = draw_bbox(im, bbox, label, conf)
plt.imshow(output_image)
plt.show()


print('자동차 개수 : '+ str(label.count('car')))
print('사람 수 : '+ str(label.count('person')))
```

cvlib의 detect_common_object 함수를 이용하면,
해당 객체의 x,y 좌표(bbox)와 레이블, confidence(참일 확률)를 리턴한다.

아무튼, 이 파이썬 코드를 실행시키면, yolo v3 cfg와 weight 를 다운 받는 것을 알수 있다. 즉, 이 라이브러리는 YOLO v3 방식의 object detection AI engine을 쓴다는 것을 알 수 있는데, 이미지내 객체인식에서 가장 빠른 방식 중 하나로 좀더 자세한 내용은 널리고 널렸다. 궁금하면 찾아보자.

참고로, 다운로드된 weight 및 cfg 파일등은 $HOME/.cvlib 디렉토리에 저장된다. 즉, 실행시킬때마다 다시 다운 받는것은 아니란 얘기 (너무 당연한 얘기)

실행과정에서 아래와 같은 에러를 보게되면, 
```
DATE: W tensorflow/stream_executor/platform/default/dso_loader.cc:55] Could not load dynamic library 'libnvinfer.so.6'; dlerror: libnvinfer.so.6: cannot open shared object file: No such file or directory; LD_LIBRARY_PATH: :/usr/local/cuda/lib64
```
nvidia tensorRT 라이브러리를 설치하지 않아서 그런 것이니 [설치](https://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html)하자. 

설치하지 않더라도 동작은 한다. CPU로... 
다만, 이번과 같이 학습을 수행하지 않고 추론만 하는 경우에는 CPU 만으로도 충분하다.

위 코드에서 label에 들어 있는 값들은 아래처럼 보인다.
```
['car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'bus', 'car', 'bus', 'car', 'car', 'car', 'car', 'bus', 'car', 'car', 'bus', 'car', 'car', 'car', 'car', 'car', 'bus', 'person', 'car', 'person', 'car', 'car', 'car', 'car', 'bus']
```

즉, 감지된 모든 객체들에 대해 순서로 리스트로 나열을 하고 있다.
그럼 bbox는 어떻게 생겼나 쳐다보는 것도 인지상정. 함 보자.
```
[[512, 302, 626, 400], [-2, 291, 68, 369], [104, 259, 208, 359], [70, 189, 138, 243], [9, 222, 103, 294], [246, 239, 330, 325], [440, 179, 496, 227], [208, 150, 258, 192], [282, 176, 340, 230], [179, 334, 297, 412], [380, 382, 512, 412], [411, 138, 457, 168], [512, 148, 680, 278], [418, 162, 466, 196], [104, 105, 192, 193], [340, 98, 380, 128], [226, 72, 254, 92], [222, 132, 266, 160], [314, 72, 344, 98], [474, 95, 562, 201], [199, 86, 235, 112], [256, 86, 286, 108], [395, 89, 447, 151], [356, 260, 458, 364], [168, 199, 220, 265], [239, 109, 277, 137], [301, 144, 331, 178], [342, 124, 386, 156], [354, 42, 394, 78], [114, 226, 140, 274], [191, 108, 221, 140], [290, 106, 304, 124], [669, 179, 701, 213], [670, 202, 700, 292], [260, 73, 290, 93], [346, 154, 394, 204], [413, 45, 451, 69]]
```
뻔한 스토리다. 순서대로 [x1,y1, x2,y2]가 있다.
confidence 값은 뭐 말 안해도 알거라 생략.

암튼, 대충 인터넷에서 자동차 나온 이미지 잡아다가 돌리면 아래처럼 차량에 box를 칠해주는 것을 볼 수 있다.
![Result](/assets/images/2020-02-29-17-45-08.png)


## 이제 쓰는 법을 알았으니, 써먹어야겠지?

아들내미가 자동차 사진을 내 스맛폰으로 하도 찍어대서 내 사진첩이 엉망이 되어 버린 상태.. 자동차만 찍힌 사진을 솎아내는 기능을 만들어 보았다. 뭐, 대단한 건 없고 디렉토리 스캔해서 사람수는 0인데 자동차 수가 1개 이상인 이미지만 잡아내는 거임. 프리뤼 심플.


```
import cv2
import matplotlib.pyplot as plt
import cvlib as cv
from cvlib.object_detection import draw_bbox
import os


def detect_car_person(img_name):
    # print(img_name)
    im = cv2.imread(img_name)
    bbox, label, conf = cv.detect_common_objects(im)

    if(label.count('car') > 0 and label.count('person') ==0 ):
        return img_name
    else:
        return None



if __name__ == '__main__':

    print('scanning....')

    for (path, dir, files) in os.walk("./photos"):
        print('gogogo')
        for filename in files:
            ext = os.path.splitext(filename)[-1]
            if ext == '.jpg':
                car_filtered = detect_car_person(path+'/'+filename)
                if(car_filtered is not None):
                    print(car_filtered)
    
    print('completed')

```
