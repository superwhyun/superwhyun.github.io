---
title: 파이썬으로 초상화 기반 Word Cloud 만들기

categories: information
tags: [python, portrait, mask image, word cloud]
Created: 2022년 6월 6일 오후 5:59
Last Edited Time: 2022년 7월 11일 오후 6:08
---
Status: 완료
요약: Word Cloud를 주어진 이미지에 맞춰 이쁘게 만들어 주는 기능을 만들어 봄. medium에 있는 글을 보고 따라하면서 일부 수정보완했음.
원문링크: https://jelena-ristic.medium.com/create-wordcloud-portraits-with-python-bb5ce794bc91

# ****Create wordcloud portraits with python****

워드 리스트(또는 문장)과 mask로 사용할 이미지를 넣으면, 이에 맞춰 오른쪽 그림과 같은 결과물을 만드는 방법에 대해 설명한다. 한글을 적용하는 과정에서의 델타사항을 제외한 모든 내용은 원문의 내용을 따랐다.

![Untitled](/assets/images/2022-07-11-파이썬으로-초상화-기반-Word-Cloud-만들기/Untitled.png)

![Untitled](/assets/images/2022-07-11-파이썬으로-초상화-기반-Word-Cloud-만들기/Untitled%201.png)

참고 - 위 오른쪽 그림과 같은 결과물을 얻으려면 masking 이미지에 터칭을 해 줘야 한다. 즉, 얼굴에서 눈 부위를 제외한 나머지 부분을 white로 덮어 씌워야 저렇게 이목구비 위주로 표현되게 할 수 있다.

## 필요한 패키지 설치

```bash
pip install wordcloud 
```

## 소스코드

주피터 노트북을 사용하는 환경을 기준으로 코드가 작성되어 있다.

### 관련 패키지를을 import 한다.

```bash
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator
import matplotlib
import matplotlib.pyplot as plt
plt.rcParams["figure.dpi"] = 2000
import pandas as pd
import numpy as np

from PIL import Image
```

### 원하는 문장들을 파일에 담는다.

```bash
You can now start customising it: chose the relevant mask you will apply to model the final wordcloud. It is best to chose one that has a good amount of contrast to get the best out of your wordcloud, also the mask picture size is crucial if you want to get an output that you can blow up significantly without too much pixelation. The bigger the picture, the better the cloud
```

```python
논란을 만들고
사회분열을 조장하고
혐오를 생산하고
그걸로 밥벌어먹고 사는 직업
300톤???일반 가정집에 한달에 30톤정도 물을쓴다..
아파트 열집만 돌리면 끝날 적은양임..
공짜???
수자원공사에 돈 따박따박내고
애시당초 우리나라는 물부족국가도 아니고
그냥 뭐 혐오생산글임...
제일 필요한게 배달앱에서 악성후기쓰는놈 
조지는 법이랑 되도안한 악성기사 끄는 기자
조지는 법을 만들어야함...
개드립 - 기레기가 현재 이 사회에 존나 해악인 이유.. ( https://www.dogdrip.net/409779412 )
```

### 파일로부터 데이터를 읽어와서 간단하게 word cloud를 만들어 보자.

```bash
data = open("words.txt").read()
wordcloud = WordCloud().generate(data)
#and use matplotlib to display generated image
plt.imshow(wordcloud)
plt.axis("off")
plt.show()
```

![Untitled](/assets/images/2022-07-11-파이썬으로-초상화-기반-Word-Cloud-만들기/Untitled%202.png)

- 참고
    - 실행할때마다 random하게 위치가 일부 조정된다.
    - 한글 문장에 대해 워드 클라우드를 만들려면 한글 폰트를 넣으면 된다.
        
        ```python
        wordcloud = WordCloud(font_path="NanumMyeongjo.ttc").generate(data)
        ```
        
        - font를 찾지 못하는 경우, 맥의 ‘서체 관리자'에서 폰트 내보내기로 *.ttc  파일을 만들어 소스코드가 위치한 곳과 같은 디렉토리로 이동시킨다.
        
        ![‘기레기’에 대한 현자의 분석 내용을 샘플로 사용한 사례](/assets/images/2022-07-11-파이썬으로-초상화-기반-Word-Cloud-만들기/Untitled%203.png)
        
        ‘기레기’에 대한 현자의 분석 내용을 샘플로 사용한 사례
        
    - 원문에서는 pd.read_html() 함수를 쓰는 것도 가능하다고는 하지만, 막상 해 보면 갖가지 에러가 뜬다.
        
        ```bash
        data = pd.read_html(input("paste your URL here: "))
        ```
        
        - 요즘 대다수의 웹사이트는 한 페이지에 내용 이외의 잡다한 태그들이 거지같이 달려 있어 분석에 오히려 도움이 안된다.

### Mask용 이미지를 준비하자

위에 있는 이미지를 그대로 사용하면, masking이 전혀 먹히지 않는다. 이유는 배경을 white로 날려주지 않아서 그런것이다.

- 배경 날리기 + 흰색으로 바꾸기
    
    [Remove Background from Image - remove.bg](https://remove.bg)
    
    - Tips: 화면캡처를 하게되면, Display의 해상도가 높은 경우 지나치게 큰 이미지가 만들어져서 변환이 매우 느려지는 문제가 있으니 주의하자.

### Mask를 씌워 보자

```python
cloud_mask = np.array(Image.open("portrait-whitebg.png"))
# plt.imshow(cloud_mask)
# plt.axis("off")
# plt.show()

wordcloud = WordCloud(
                      font_path="Monofur for Powerline.ttf", #add your font here
                      width = 2380, # use the same width and height
                                    #as your mask size for best
                                    #results
                      height = 2879,
                      stopwords=STOPWORDS, #if the staple stopwords
                                           #the module provides is
                                           #not good enough, you can
                                           #list your own
                      background_color = "white",
                      mask = cloud_mask,
                      contour_width = 0,
                      repeat=True,
                      min_font_size = 2, #if you want a tight fit,
                                         #go for a small figure here
                      max_words = 1000, #set max words count
                      ).generate(data)
image_colors = ImageColorGenerator(cloud_mask) #use the mask colours
wordcloud.generate(data)
wordcloud.recolor(color_func=image_colors)

```

### 결과물을 파일로 저장해보자

```python
plt.axis("off")
plt.imshow(wordcloud)
fig1=plt.gcf()
plt.show()
plt.draw()
fig1.savefig("Woolf.svg", format="svg", bbox_inches="tight")
```

- 조금 이상한 것이 이 코드를 2개의 셀로 나눠서 실행시키면 이미지 표현/파일 저장이 되지 않는다. 셀을 넘어가면 메모리 scope이 달라지나? 잘 이해가 안가는데..

![mask 이미지(흰색 배경)](/assets/images/2022-07-11-파이썬으로-초상화-기반-Word-Cloud-만들기/Untitled%204.png)

mask 이미지(흰색 배경)

![words.txt 실행결과](/assets/images/2022-07-11-파이썬으로-초상화-기반-Word-Cloud-만들기/Untitled%205.png)

words.txt 실행결과

![words-kor.txt 실행결과](/assets/images/2022-07-11-파이썬으로-초상화-기반-Word-Cloud-만들기/Untitled%206.png)

words-kor.txt 실행결과

## Future Works

- 웹 서비스로 옮기기
    - 아래는 샘플 사이트
        
        [Word Cloud Generator](https://www.jasondavies.com/wordcloud/)
        
        ![대충 이런 모양으로 나옴](/assets/images/2022-07-11-파이썬으로-초상화-기반-Word-Cloud-만들기/Untitled%207.png)
        
        대충 이런 모양으로 나옴
        

## 참고자료

- 참고. matplotlib의 imshow를 이용하여 이미지 보여주기
    
    ```python
    import matplotlib.image as img
    import matplotlib.pyplot as pp
    
    fileName = "c:\\sample.png"
    
    ndarray = img.imread(fileName)
    
    pp.imshow(ndarray)
    pp.show()
    ```
    
    - imshow()는 이미지를 만들기만 하는 것이며, show는 화면에 보여주는 것?
        - imshow는 원하는 사이즈의 픽셀을 원하는 색으로 채워서 만든 그림
        - 쉽게말하면 원하는 크기의 행렬을 만들어서 각 칸을 원하는 색으로 채우는 것
        - 각 칸을 채우는 방법은 colormap, RGB, RGBA 의 네가지가 있음
            1. colormap 디폴트
            2. colormap 변경방법
            3. RGB
            4. RGBA
    - plt.gcf()
        
        ```
        figure을 많이 만들어 놓으면 어떤 figure이 있는지 알기 어려워진다. 현재 figure를 확인하기 위한 방법으로는 plt.gcf()를 사용한다. gcf는 get current figure의 약어.
        ```