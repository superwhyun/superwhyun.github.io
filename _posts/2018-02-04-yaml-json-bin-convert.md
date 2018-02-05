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

소스코드는 [https://github.com/superwhyun/sfdata_convert](https://github.com/superwhyun/sfdata_convert) 에서 다운가능합니다.
- 개발목표
    - 데이터에 대한 notation 방식/설정은 YAML로 하고, 예제 데이터를 JSON으로 생성케 하고, JSON 데이터를 바이너리로 변환하는 기능
        - YAML에서 스키마를 조정할 때마다 자동으로 JSON 예제 만들어지고, ~~관련 Parser/Generator 또한 연계되어 작성되도록 하는 것을 목표로 함.~~
    - 부동소수점/음수 표기법
        - 시스템에서 사용하는 부동소수점, 2의 보수 표기법을 쓰면 데이터 가독성이 매우 떨어지기 때문에 갖은 천재성 꼼수들이 등장하여 활용 중에 있음.
          - 음수 : 변수가 수용가능한 최대값의 1/2을 더해 줌. 즉, 변수최대값의 1/2이 안되는 값은 음수.
          - 부동소수점 : 소수점을 없애기 위해 곱한 10의 배수값을 별도 기재

        ```yaml
        Temperature:
                code : 1
                type : number
                decimal_point : 0
                # 0 이면 integer
                unit : celcius
                min : -100
                max : 100
                byte : 4
        ```

- 개발기록
    - YAML은 PyYaml을 이용
    - binary 표기법은 [bitstring](http://pythonhosted.org/bitstring/index.html) 패키지를 이용
- 개발현황
    - ~~YAML loading~~
    - ~~JSON loading/dumping~~
    - ~~바이너리 포맷 출력~~
    - ~~라이브러리 자동 생성 --> X ~~

```python
import yaml, json
import random
import bitstring


role2type_dic = {
    "sensor":1,
    "actuator":2
}

func2code_dic = {
    "temperature":1, 
    "humidity":7, 
    "CO2":32,
    "pyranometer":11,
    "winddirection":8,
    "windspeed":9,
    "rain":28,
    "quantum":16,
    "soilmoisture":29,
    "soiltension":22,
    "EC":24,
    "PH":25,
    "soiltemperature": 18,
    "uppermotor": 1,
    "sidemotor" : 2,
    "warmmotor" : 11,
    "curtainmotor" : 6,
    "ventilationfan" : 3,
    "circulationfan" : 12,
    "irrigationpump" : 8,
    "irrigationvalve" : 13,
    "coolingheater" : 4    
    }

# actuator2code_dic = {
#     "uppermotor": 1,
#     "sidemotor" : 2,
#     "warmmotor" : 11,
#     "curtainmotor" : 6,
#     "ventilationfan" : 3,
#     "circulationfan" : 12,
#     "irrigationpump" : 8,
#     "irrigationvalve" : 13,
#     "coolingheater" : 4
# }


unit2code_dic = {
    "none":0,
    "default":1,
    "celsius":2,
    "fahrenheit":3,
    "percentage":4,
    "ppm":5,
    "W/m2":6,
    "degree":7,
    "m/s":8,
    "umol/m2s":9,
    "%vol":10,
    "kPa":11,
    "dS/m":12,
    "pH":13
}

def gen_rand_values(conf, dtype, identifier):

    if(conf is None):
        print("error: argument error")
        return
    
    if(identifier ==-1):
        identifier = random.randint(0, 127)

    data=conf[dtype]
    if(data["value"]["type"] != 3):
        value = random.randint(data["value"]["min"], data["value"]["max"])
    else:
        value = random.uniform(data["value"]["min"], data["value"]["max"])
        value = round(value,int(data["value"]["precision"]))

    D = dict()
    D1 = dict()
    D1['identifier']=identifier
    D1['type']=data["type"]
    D1['code']=data["code"]
    D1['value']=value
    D1['unit']=data["value"]["unit"]
    D1['precision']=data["value"]["precision"]

    D[dtype]=D1

    return D


def gen_bitstring(val, len):

    if( type(val) == int ):
        genbit = bitstring.BitArray(int=val, length=len*8)
    else:
        genbit = bitstring.BitArray(float=val, length=len*8)

    return "0x"+genbit.hex+" ==> "+genbit.bin


def gen_binary_values(conf, dval):
    D = dict()

    D["identifier"] = gen_bitstring(dval["identifier"], conf["identifier"])
    D["type"] = gen_bitstring(role2type_dic[dval["type"]], conf["type"])
    D["code"] = gen_bitstring(func2code_dic[dval["code"]], conf["code"])
    D["length"] = gen_bitstring(conf["value"], conf["length"])
    D["value"] = gen_bitstring(dval["value"], conf["value"])
    D["unit"] = gen_bitstring(unit2code_dic[dval["unit"]], conf["unit"])


    # TLV 파라미터가 필요한 경우 (drafting...)
    # attr_cnt=0
    # for attr in conf["attr"]:
    #     if(attr == "unit"): 
    #         D["unit"] = gen_bitstring(unit2code_dic[value["unit"]], 1)
    #         attr_cnt = attr_cnt+1
        

    return D


stream = open('sfdata_cfg.yml','r')
            


# print("-----------------YAML-----------------");
yaml_dict = yaml.load(stream)
# print (yaml_dict)

# print("-----------------JSON-----------------");
# print (json.dumps(yaml_dict, sort_keys=False, indent=2))

value_list = [
    "temperature",
    "humidity",
    "CO2",
    "pyranometer",
    "winddirection",
    "windspeed",
    "rain",
    "quantum",
    "soilmoisture",
    "soiltension",
    "EC",
    "PH",
    "soiltemperature",
    "uppermotor",
    "sidemotor",
    "warmmotor",
    "curtainmotor",
    "ventilationfan",
    "circulationfan",
    "irrigationpump",
    "irrigationvalve",
    "coolingheater"
    
]




for val_type in value_list:
    # val_type = "temperature"
    print("--------------[", val_type , "]-----------")
    rand_val = gen_rand_values(yaml_dict, val_type, -1)
    binary_val = gen_binary_values(yaml_dict[val_type]["binary"], rand_val[val_type])

    print("[JSON]\n", json.dumps(rand_val, indent=2))
    print("[Binary]\n", json.dumps(binary_val, indent=2))




```
```yaml
...
--------------[ curtainmotor ]-----------
[JSON]
 {
  "curtainmotor": {
    "identifier": 65,
    "type": "actuator",
    "code": "curtainmotor",
    "value": 0,
    "unit": "none",
    "precision": 0
  }
}
[Binary]
 {
  "identifier": "0x41 ==> 01000001",
  "type": "0x02 ==> 00000010",
  "code": "0x06 ==> 00000110",
  "length": "0x04 ==> 00000100",
  "value": "0x00000000 ==> 00000000000000000000000000000000",
  "unit": "0x00 ==> 00000000"
}
...
```

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
6. [https://codebeautify.org/text-to-binary](https://codebeautify.org/text-to-binary)
7. [http://pythonhosted.org/bitstring/creation.html](http://pythonhosted.org/bitstring/creation.html)
8. [https://stackoverflow.com/questions/16444726/binary-representation-of-float-in-python-bits-not-hex](https://stackoverflow.com/questions/16444726/binary-representation-of-float-in-python-bits-not-hex)
9. [2의 보수 구하는 C함수](http://smeffect.tistory.com/entry/C%EC%96%B8%EC%96%B4-%EC%9E%85%EB%A0%A5%EB%90%9C-%EC%A0%95%EC%88%98%EC%9D%98-2%EC%9D%98-%EB%B3%B4%EC%88%98%EB%A5%BC-%EA%B5%AC%ED%95%98%EC%97%AC-10%EC%A7%84%EC%88%98-16%EC%A7%84%EC%88%98-%ED%98%95%ED%83%9C%EB%A1%9C-%EC%B6%9C%EB%A0%A5%ED%95%98%EB%8A%94-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%A8)
10. [파이썬 dict 사용법](http://story.wisedog.net/python-programming-language-tutorial/python-datatype/dictionary/)
11. [부동소수점 변환](https://gregstoll.dyndns.org/~gregstoll/floattohex/)