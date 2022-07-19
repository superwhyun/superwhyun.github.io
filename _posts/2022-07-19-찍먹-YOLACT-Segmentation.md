---
title: 찍먹-YOLACT Segmentation

categories: information
tags: [yolact, segmentation, ai]
Created: 2022년 7월 18일 오전 7:56
Last Edited Time: 2022년 7월 19일 오후 11:58
---
Status: 완료

나온지는 조금 된 세그멘테이션을 위한 모델인 YOLACT(You Only Loot At CoefficienTs)를 돌려 본 결과를 기록해 봄. 아마 그 사이에 업데이트가 있었을테니 아래 내용이 일부 안 맞을 수도 있음. 

[https://github.com/dbolya/yolact](https://github.com/dbolya/yolact)

## 간단 설명

- A simple, fully convolutional model for real-time instance segmentation
- DCNv2 를 이용
    - 소스코드에 포함된 DCNv2는 컴파일 단계에서 에러가 뜬다.
    - 다른. repository에서 구해다가 대체해야 한다.
- COCO Dataset을 이용하며, 학습시키려면 별도로 다운로드 받아야 한다.
- Pretrained model을 제공하므로 굳이 처음부터 학습시킬 필요는 없다.
    - [https://github.com/dbolya/yolact#evaluation](https://github.com/dbolya/yolact#evaluation)

## 찍먹하기

1. Download pretrained model
2. put the corresponding weights file in the ./weights directory
3. cd external;
    1. python setup.py build develop
        - 높은 확률로 에러 뜰거임.
            - external에 포함되어 있는 DCNv2 가 old version pytorch용이라 그런거임.
    2. mv DCNv2 _DCNv2
4. git clone [https://github.com/lbin/DCNv2.git](https://github.com/lbin/DCNv2.git)
5. make.sh
6. python eval.py --trained_model=weights/yolact_plus_resnet50_54_800000.pth --score_threshold=0.15 --top_k=15 --image=images/2020080212151464057_l.jpg:images/2020080212151464057_l_segmented.jpg
    - Log1 - cuda 가 설치되어 있지 않기 때문에 발생한 문제임.
    
    ```python
    Traceback (most recent call last):
      File "eval.py", line 2, in <module>
        from yolact import Yolact
      File "/home/whyun/workspace/yolact/yolact.py", line 22, in <module>
        torch.cuda.current_device()
      File "/home/whyun/anaconda3/envs/yolact-env/lib/python3.7/site-packages/torch/cuda/__init__.py", line 366, in current_device
        _lazy_init()
      File "/home/whyun/anaconda3/envs/yolact-env/lib/python3.7/site-packages/torch/cuda/__init__.py", line 172, in _lazy_init
        torch._C._cuda_init()
    RuntimeError: Unexpected error from cudaGetDeviceCount(). Did you run some cuda functions before calling NumCudaDevices() that might have already set an error? Error 804: forward compatibility was attempted on non supported HW
    ```
    
    - Log2 - DCNv2 컴파일 하는 것을 빼 먹어서 그런거임.
    
    ```python
    Config not specified. Parsed yolact_plus_resnet50_config from the file name.
    
    Loading model...Traceback (most recent call last):
      File "eval.py", line 1097, in <module>
        net = Yolact()
      File "/home/whyun/workspace/yolact/yolact.py", line 402, in __init__
        self.backbone = construct_backbone(cfg.backbone)
      File "/home/whyun/workspace/yolact/backbone.py", line 451, in construct_backbone
        backbone = cfg.type(*cfg.args)
      File "/home/whyun/workspace/yolact/backbone.py", line 83, in __init__
        self._make_layer(block, 128, layers[1], stride=2, dcn_layers=dcn_layers[1], dcn_interval=dcn_interval)
      File "/home/whyun/workspace/yolact/backbone.py", line 114, in _make_layer
        layers.append(block(self.inplanes, planes, stride, downsample, self.norm_layer, self.dilation, use_dcn=use_dcn))
      File "/home/whyun/workspace/yolact/backbone.py", line 23, in __init__
        padding=dilation, dilation=dilation, deformable_groups=1)
      File "/home/whyun/workspace/yolact/backbone.py", line 11, in DCN
        raise Exception('DCN could not be imported. If you want to use YOLACT++ models, compile DCN. Check the README for instructions.')
    Exception: DCN could not be imported. If you want to use YOLACT++ models, compile DCN. Check the README for instructions.
    ```
    

## 결과

- 입력이미지
    
    ![Untitled](/assets/images/2022-07-19-찍먹-YOLACT-Segmentation/Untitled.png)
    
- 출력이미지(segmented image)

![Untitled](/assets/images/2022-07-19-찍먹-YOLACT-Segmentation/Untitled%201.png)