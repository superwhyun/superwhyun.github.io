---
layout: post
tags: [temporary]
title: temp
---
라즈베리파이에 waveshare servo hat을 설치하여 6개의 서보모터를 제어할 때 주의사항

각 제어명령을 보낼때 동시에 여러개를 제어하게 되면 전력부족으로 라즈베리파이 전체가 먹통이 된다.
그러므로, 하나씩 제어하되 각 제어 명령에 sleep을 걸어주는 것을 잊지 말아야 한다.

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

