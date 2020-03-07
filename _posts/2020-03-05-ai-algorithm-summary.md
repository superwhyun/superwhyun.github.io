---
layout: post
categories: draft
tags: [ai, algorithm, usage, draft]
title: AI 알고리즘 정리
---

최근 너무나도 빨리 이쪽 분야가 발전되고 있어서 다 알아보는 것은 너무 어려워서 어떤 흐름으로 가고 있고 어떤 용도에 어떤 것을 쓰면 되는 것인지 알아보려고 정리해 봅니다. 주로 제가 이해하기 쉽게 정리한 것이라 정통방식(~~그런게 있기는 한가?~~)의 주된 분류 방식은 아니니 참고해 주세요~

한 달 프로젝트로 보고 있어서 지속적으로 업데이트 할 예정임.

## Classification

### 기본 설명
말 그대로 여러 데이터를 각종 카테고리로 분류하는 것으로, 이미지가 고양이인지 강아지인지를 찾아내는 것이 대표적인 예제이다. 단, CNN과 다른 점은 이미지들로부터 feature를 사전에 뽑아낸 것을 전제로 한다는 것이다. (**진짜? ==> 좀더 확인해 봐바**)

*머신러닝은 맞는데 뉴럴 네트워크로까지 보기에는 애매하지 않을까?*

## Regression

### 기본 설명
연속된 값을 예측할 때 사용되는데, 회귀라는 말 그대로 어떤 정해진(그러나 아직 알지는 못하는) 패턴을 데이터에서 찾아내고, 그에 따라 앞으로 생성되는 데이터가 튀어나올것인지를 예측하는데 용이하다.

주식 예측, 패턴 예측 등에 유용할 것 같다.

*머신러닝은 맞는데 뉴럴 네트워크로까지 보기에는 애매하지 않을까?*


## RNN (Reinforcement Neural Network)

### 기본 설명
>강화 학습은 환경으로부터의 피드백을 기반으로 행위자(agent)의 행동을 분석하고 최적화합니다. 기계는 어떤 액션을 취해야 할지 듣기 보다는 최고의 보상을 산출하는 액션을 발견하기 위해 서로 다른 시나리오를 시도합니다. 시행 착오(Trial-and-error)와 지연 보상(delayed reward)은 다른 기법과 구별되는 강화 학습만의 특징입니다.
- https://www.sas.com/ko_kr/solutions/ai-mic/blog/machine-learning-algorithm-cheat-sheet.html

주로 게임 인공지능 등에 많이 활용될 수 있을 것 같고, 각종 산업에 많이 적용되기 좋은 모델인 것 같다. e.g, 작업 로봇의 동작, 자율주행 등등.

### 추천 영상
  - https://www.youtube.com/watch?v=W_gxLKSsSIE

## CNN (Convolutional Neural Network)

### 기본 설명

CNN은 주로 비전(이미지, 영상)쪽에서 사용되는 기술로 이미지/영상에서 객체를 찾아내는데 사용하는 방식으로 기본적으로 supervised learning이다. 즉, train을 위한 labeled image가 대량으로 있어야 한다.


## GAN (Generative Adversarial Network)

### 기본 설명
GAN은 Discriminative 모델과 Generative 모델이 경쟁적으로 서로를 속이거나 맞추는 방식으로 모델을 서로 발전시켜가는 방식으로 학습을 위한 데이터가 적을 때 특히나 유용한 방식이다.

일차적으로 Discriminative 모델에 대한 선행 학습은 필요. 
Generative 모델은 가짜를 만들고, Discriminative 모델은 진위 여부를 판단하고 그 결과를 feedback 을 주어 다시 학습시키면서 모델의 지능을 높여가는 방식

### Variants of GAN 
GAN이 제안된 이후에 DCGAN, cycleGAN, LSGAN, SGAN, ACGAN, StackGAN 등등이 나왔으며 각각의 용도에 따른 특징이 존재
- LSGAN(Least Square GAN)
- SGAN(Semi-Supervised GAN)
- ACGAN(Auxillary Classifier GAN)
- StackGAN(Stack GAN)

### 추천 영상
- [1시간만에 GAN(Generative Adversarial Network) 완전 정복하기](https://tv.naver.com/v/1947034)
  > 어우.. 대학원생인 것 같은데... 천재여..