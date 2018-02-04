---
layout: post
title: "센서 데이터 Text-Binary 변환 엔진"
author: "Wook Hyun"
categories: upcoming
tags: [blog]
image: conversion.jpg
comments: true
---

# 데이터 notation/serialization 변환 기능 

- 개발목표
    - 데이터에 대한 notation 방식/설정은 YAML로 하고, 예제 데이터를 JSON으로 생성케 하고, JSON 데이터를 바이너리로 변환하는 기능
        - YAML에서 스키마를 조정할 때마다 자동으로 JSON 예제 만들어지고, 관련 Parser/Generator 또한 연계되어 작성되도록 하는 것을 목표로 함.

<hr>

### YAML/JSON
- YAML은 JSON보다 human 가독성은 더 좋음. 그래서 설정파일 다룰때 많이 씀
- JSON은 데이터를 담을 때 많이 씀


### 기본자료형

- **스칼라(scalar)** : 문자열, 숫자 

- **시퀀스(sequence)** : 배열, 리스트를 표현하며, 들여쓰기/'-'를 구분자로 이용

- **맵핑(mapping)** : 해시, 딕셔너리, key/value 등을 표현하며, ':'를 구분자로 이용

<hr>
### 예제

#### 배열

<span style="color:blue; font-size:5pt">YAML</span>
```yaml
        - Mark McGwire
        - Sammy Sosa
        - Ken Griffey
```
<span style="color:blue; font-size:5pt">JSON</span>
```json
        [
        "Mark McGwire",
        "Sammy Sosa",
        "Ken Griffey"
        ]
```

#### Key/Value
<span style="color:blue; font-size:5pt">YAML</span>
```yaml        
        # Mapping of scalars to scalars(player statics)
        hr:  65    # Home runs
        avg: 0.278 # Batting average
        rbi: 147   # Runs Batted In
```
<span style="color:blue; font-size:5pt">JSON</span>

```json
        {
        "hr": 65,
        "avg": 0.278,
        "rbi": 147
        }
```

#### Key/Array
<span style="color:blue; font-size:5pt">YAML</span>

```yaml
        # Mapping of scalars to sequences(ball clubs in each league)
        american:
        - Boston Red Sox
        - Detroit Tigers
        - New York Yankees
        national:
        - New York Mets
        - Chicago Cubs
        - Atlanta Braves
```
<span style="color:blue; font-size:5pt">JSON</span>

```json
        {
        "american": [
            "Boston Red Sox",
            "Detroit Tigers",
            "New York Yankees"
        ],
        "national": [
            "New York Mets",
            "Chicago Cubs",
            "Atlanta Braves"
        ]
        }
```

#### Array 
<span style="color:blue; font-size:5pt">YAML</span>

```yaml
        # in-line flow style for compact notation
        - [name        , hr, avg  ]
        - [Mark McGwire, 65, 0.278]
        - [Sammy Sosa  , 63, 0.288]
```
<span style="color:blue; font-size:5pt">JSON</span>

```json
        [
            [
                "name",
                "hr",
                "avg"
            ],
            [
                "Mark McGwire",
                65,
                0.278
            ],
            [
                "Sammy Sosa",
                63,
                0.288
            ]
        ]
```

#### ETC 
얘네는 conversion error가 생기네.. 왜 그런지 모르겠음. 공부가 필요할 뿐!

```yaml
        # Sequence of mappings(players' statics)
        -
        name: Mark McGwire
        hr:   65
        avg:  0.278
        -
        name: Sammy Sosa
        hr:   63
        avg:  0.288
        
        # in-line flow style for compact notation
        Mark McGwire: {hr: 65, avg: 0.278}
        Mark McGwire: {hr: 65, avg: 0.278}
        Sammy Sosa: {
            hr: 63,
            avg: 0.288
        }
```


## References
1. [https://www.sitepoint.com/data-serialization-comparison-json-yaml-bson-messagepack/](https://www.sitepoint.com/data-serialization-comparison-json-yaml-bson-messagepack/)
2. [http://anitoy.pe.kr/yaml-format/](http://anitoy.pe.kr/yaml-format/)
3. [yaml to json](https://www.browserling.com/tools/yaml-to-json)
4. [json to yaml](https://www.browserling.com/tools/json-to-yaml)
5. [http://sjava.net/tag/protocol-buffer/](http://sjava.net/tag/protocol-buffer/)