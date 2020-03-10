---
layout: post
categories: summary
tags: [ai, algorithm, neural network, types, usage]
title: 인공지능 신경망 종류 정리
---

최근 너무나도 빨리 이쪽 분야가 발전되고 있어서 다 알아보는 것은 너무 어려워서 어떤 흐름으로 가고 있고 어떤 용도에 어떤 것을 쓰면 되는 것인지 알아보려고 정리해 봄. 

---

## 분류(Classification)

### 기본 설명
말 그대로 여러 데이터를 각종 카테고리로 분류하는 것으로, 이미지가 고양이인지 강아지인지를 찾아내는 것이 대표적인 예제이다. 단, CNN과 다른 점은 이미지들로부터 feature를 사전에 뽑아낸 것을 전제로 한다는 것이다. (~~**진짜? ==> 좀더 확인해 봐바**~~)

*머신러닝은 맞는데 뉴럴 네트워크로까지 보기에는 애매하지 않을까?*

---

## 회귀(Regression)

### 기본 설명
연속된 값을 예측할 때 사용되는데, 회귀라는 말 그대로 어떤 정해진(그러나 아직 알지는 못하는) 패턴을 데이터에서 찾아내고, 그에 따라 앞으로 생성되는 데이터가 튀어나올것인지를 예측하는데 용이하다.

주식 예측, 패턴 예측 등에 유용할 것 같다.

*머신러닝은 맞는데 뉴럴 네트워크로까지 보기에는 애매하지 않을까?*

---

## RNN (순환학습, Recurrent Neural Network)

> RNN은 Recurrent Neural Network의 약자로 hidden state를 반복해서 돌기 때문에 이런 이름이 붙었습니다. 물론 Recursive Neural Network도 줄이면 RNN이지만 대부분 RNN이라 하면 Recurrent Neural Network를 칭합니다. [출처](http://isukorea.com/blog/home/waylight3/234)

주로 문장, 자연어 처리, 번역 등에 사용되는 신경망으로 볼 수 있다.


### LSTM(Long short term memory network)
Recurrent NN의 대세로 자리잡았음. RNN 쓸 일 있으면 얘 쓰셈.

### GRU(Gated Recurrent Unit) 
LSTM을 개선해서 덜 복잡한 모델인데 성능은 비슷하게 나옴. 얘도 괜찮은 듯.


---

## RNN (강화학습, Reinforcement Neural Network)


### 기본 설명
>강화 학습은 환경으로부터의 피드백을 기반으로 행위자(agent)의 행동을 분석하고 최적화합니다. 기계는 어떤 액션을 취해야 할지 듣기 보다는 최고의 보상을 산출하는 액션을 발견하기 위해 서로 다른 시나리오를 시도합니다. 시행 착오(Trial-and-error)와 지연 보상(delayed reward)은 다른 기법과 구별되는 강화 학습만의 특징입니다.
- https://www.sas.com/ko_kr/solutions/ai-mic/blog/machine-learning-algorithm-cheat-sheet.html

주로 게임 인공지능 등에 많이 활용될 수 있을 것 같고, 각종 산업에 많이 적용되기 좋은 모델인 것 같다. e.g, 작업 로봇의 동작, 자율주행 등등.


### 유용한 자료
- http://blog.naver.com/laonple/221027194402



---

## CNN (Convolutional Neural Network)

### 기본 설명

CNN은 주로 비전(이미지, 영상)쪽에서 사용되는 기술로 이미지/영상에서 객체를 찾아내는데 사용하는 방식으로 기본적으로 supervised learning이다. 즉, train을 위한 labeled image가 대량으로 있어야 한다.


---

## GAN (Generative Adversarial Network)

### 기본 설명
GAN은 Discriminative 모델과 Generative 모델이 경쟁적으로 서로를 속이거나 맞추는 방식으로 모델을 서로 발전시켜가는 방식으로 학습을 위한 데이터가 적을 때 특히나 유용한 방식이다.

일차적으로 Discriminative 모델에 대한 선행 학습은 필요. 
Generative 모델은 가짜를 만들고, Discriminative 모델은 진위 여부를 판단하고 그 결과를 feedback 을 주어 다시 학습시키면서 모델의 지능을 높여가는 방식

화풍모사와 같이 한정된 데이터를 이용하는 경우에 적합.

- Discirminatvie Model
  - 특징
    - 그림에서 화풍을 뽑아내는 요소를 판단
  - 절차
    - Convolution등으로 특징을 모델링
    - Train, Test set 수집 
    - Train
    - Inference
- Generative Model
  - 특징
    - 화풍지식 --> 화풍결정 --> 그림재현
    - 비지도 방식으로 labeled data 없어도 됨
    - class에 대한 확률모델 생성/이용
  - 절차
    - 화풍복제방법 학습하는 ML 모델 
    - Train, Test set 수집
    - Train
    - 실제 example 바탕으로 inference ==> 유사도를 사용해 모델에서 화풍재현 확인


### Variants of GAN 
GAN이 제안된 이후에 DCGAN, cycleGAN, LSGAN, SGAN, ACGAN, StackGAN 등등이 나왔으며 각각의 용도에 따른 특징이 존재
- LSGAN(Least Square GAN)
- SGAN(Semi-Supervised GAN)
- ACGAN(Auxillary Classifier GAN)
- StackGAN(Stack GAN)
- DCGAN
  - 새로운 장면 생성
- SimGAN
  - 모조데이터 보강
- SRGAN(Super Resolution GAN)
  - 저화질 이미지를 고화질로 변환
- Pix2Pix
- CycleGAN
- DiscoGAN

### 추천 영상
- [1시간만에 GAN(Generative Adversarial Network) 완전 정복하기](https://tv.naver.com/v/1947034)
  > 어우.. 대학원생인 것 같은데... 천재여..

---

## 전이학습(Transfer Learning)
이게 공식 용어인지는 모르겠으나.. 이미 학습된 모델을 가져다가 다른 용도로 써먹는 것 정도로 이해하면 될 듯하다. 기존에 학습된 모델을 가지고 새로운 데이터의 feature를 뽑아내기 용이해서 Feature Extractor라고도 불리기도 한다.
가장 유명한 것이 Artistic Style Transfer 가 있겠다.

---

## 오토인코더(Auto Encoder)
데이터에 대한 효율적 압축을 신경망을 통해 자동으로 학습하는 모델
- 비지도 학습 (입력데이터 자체가 label로 사용)

~~유용하다고 하는데 근데 얘를 뭐에 쓰는지에 대해서는 감이 잘 안 오네..~~

가장 유용한 예로는 Semantic Segmentation 이라고 함 (e.g, 항공사진을 입력받아 지도 이미지로)

대표적인 모델로는 U-Net (2015)이 있음
- 원래 생체 데이터 이미지에 대한 segmentation을 목표로 만들어짐
- Encoding 결과를 다시 Decoding 하는 과정에서 이런 역할을 진행
  - 모양새가 U자 처럼 생겨서 U-Net 이라 함
    - 왼쪽 파트는 Encoding, 오른쪽 파트는 Decoding하고 양쪽이 대칭형태
    - Skip connection으로 encoding 시의 정보를 decoding 의 대칭점에 전달해 줌으로써 손실된 데이터 복구에 활용하여 어느정도 meaning을 넘겨 줌


