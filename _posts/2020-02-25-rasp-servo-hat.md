---
layout: post
tags: [raspberry pi, servo, motor, hat, waveshare]
title: 라즈베리파이에서 서보모터 제어, 서보 드라이버/햇 사용
---

라즈베리파이에 서보모터를 연결하여 제어하는 두 가지 방식과 주의사항에 대해 정리한다. 서보모터와 스텝모터는 하는 기능은 유사하나 약간의 다소 중요한 차이가 있긴 하나 이 포스트에서 다루지는 않는다. 특히, 주의할 점으로 이 서보모터류들은 회전명령을 내렸으나 움직이지 못하는 상황이 되면 과열되어 금방 부서지는 측면이 있으니 조립하기에 앞서 가용한 구동 각도를 사전에 점검하는 것이 중요하다. 특히나, 여러 관절로 구성된 로봇팔의 경우 하나씩 조립하고 각도 확인한후 다음 관절들을 붙여 나가는 것이 필요하다.

## GPIO를 이용한 서보모터 제어

```
TBD
```

## Servo Driver/Hat을 이용한 I2C 기반 서보모터 제어

여러 종류의 라즈베리파이용 Servo Driver가 있기는 하나, 햇(또는 쉴드) 형태로 고정이 용이한 모델로는 Waveshare 제품이 있다. [제조사 홈페이지](https://www.waveshare.com/servo-driver-hat.htm)

![Servo Driver HAT for Raspberry Pi, 16-Channel, 12-bit, I2C](/assets/images/2020-02-26-00-03-04.png)

서보모터를 각 채널에 연결한 이후 I2C를 통해 제어한다. 우측부분에 VIN에 외부전원을 연결할 수도 있으며 주로 로봇류와 같이 배터리로 움직이는 경우에 사용하며, 라즈베리파이로부터 받아들이는 전원으로도 충분히 제어가능하다.

### 라즈베리파이에 waveshare servo hat을 설치하여 6개의 서보모터를 제어할 때 주의사항

각 제어명령을 보낼때 동시에 여러개를 제어하게 되면 전력부족(또는 I2C 명령이 처리되지 않은 상태에서 다음 명령이 바로 들어감에 따른 병목? --> 아직까진 알수없다)으로 라즈베리파이 전체가 먹통이 된다.
그러므로, 하나씩 제어하되 각 제어 명령에 sleep을 대략 0.1초 정도 걸어주면 안정적으로 **동시에** 움직인다.
아마 전력부족이라기 보다는 I2C 병목이 아닐까 싶다.

좀 더 자세한 내용은 [매뉴얼](https://www.waveshare.com/w/upload/1/1b/Servo_Driver_HAT_User_Manual_EN.pdf) 을 참고하도록 하자. 

그리고, PCA3956 제어 코드는 [Waveshare Wiki](https://www.waveshare.com/wiki/Servo_Driver_HAT)에서 다운 받아서 사용한다.


아래 코드는 다운받은 파이썬3용 라이브러리 파일(PCA9685.py)을 lib 디렉토리에 넣은 후에 사용한 예제이다.

```
from lib import PCA9685
import time



if __name__ == '__main__':
  pwm = PCA9685.PCA9685(0x40, debug=False)
  pwm.setPWMFreq(50)


  for i in range(6):
    pwm.setServoPulse(i, 500)
    time.sleep(0.4)

  for i in range(6):
    pwm.setServoPulse(i, 1000)
    time.sleep(0.4)

  print('Done')
  time.sleep(2)


```

