---
layout: post
title: "OpenAI - Auto Gamebot"
author: "Wook Hyun"
categories: documentation
tags: [machine leaning, ai, openai]
image: openai-gym.png
comments: true
---


## OpenAI를 이용한 Auto game bot 처음 시작하기

몇가지 게임을 docker container로 제공하고...
VNC를 이용해 원격으로 이미지를 받아오고...
이걸 가지고 ML 학습을 시키는 건데...

함 해보자..

https://www.youtube.com/watch?v=XI-I9i_GzIw&index=6&list=PL2-dafEMk2A64XaBlIUUI96yojneEfsuO
의 내용을 토대로 학습하였다.

다른 학자/교수들은 너무 기초부터 지루하게 설명하는데, 이 사람은 딱 사람들이 궁금해 하는 것에서 시작한다는 점에서 마음에 든다.

### openAI

아래 링크에 앵간한 설명 다 되어있다. 하라는 대로 하면 된다.
https://github.com/openai/universe

setup.py라는 것에 dependency, 설치되어야 할 패키지등이 기술되어 있다.
아래 명령어로 setup.py에 기재된 대로 일괄 설치시킨다. 난 python3을 쓸꺼니까 pip대신 pip3를 썼다.

> pip3 install -e .

아래 게임들이 docker image로 이미 만들어져 있다. 그래서, 일단 시작!하기 좋다. 뭔가 되는 것이 보여야 할 맛이 나지 않겠나?
- Atari and CartPole environments over VNC: gym-core.Pong-v3, gym-core.CartPole-v0, etc.
- Flashgames over VNC: flashgames.DuskDrive-v0, etc.
- Browser tasks ("World of Bits") over VNC: wob.mini.TicTacToe-v0, etc.

게임의 화면을 VNC로 받아오게 해서 쓰는 것 같은데, 좀 많이 unstable할 것 같다.

### 첫 걸음

[여기](https://github.com/llSourcell/OpenAI_Game_Bot_Live_stream)
에서 demo.py를 다운받아서 시작해 보자. 

하라는대로 하면 될것 같지만, 세상 모든 일이 그러하듯 당연히 안될거다. 트러블을 잡아보자.

#### Trouble shooting

무작정 실행하면 다음 에러가 나올 수 있다. (안 나올 수도 있고~)
```
whyunui-MBP2017:OpenAI_Game_Bot_Live_stream whyun$ python demo.py 
Traceback (most recent call last):
  File "demo.py", line 2, in <module>
    import universe
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/__init__.py", line 20, in <module>
    import universe.scoreboard
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/scoreboard/__init__.py", line 1, in <module>
    from gym.benchmarks import scoring
ModuleNotFoundError: No module named 'gym.benchmarks'
```

이상하다. 분명 하라는대로 다 설치했는데? 
아래와 같이 해 보자. 

```
whyunui-MBP2017:OpenAI_Game_Bot_Live_stream whyun$ python
Python 3.6.2 (default, Jul 23 2017, 19:10:13) 
[GCC 4.2.1 Compatible Apple LLVM 8.1.0 (clang-802.0.42)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import gym
>>> gym
<module 'gym' from '/usr/local/lib/python3.6/site-packages/gym/__init__.py'>
>>> 
```

좀 뒤져보니... benchmarks 패키지가 gym에서 갑자기 사라졌다네? 곧 고치겠지만, 아래와 같이 낮은 버전으로 내리면 된다.
[참고](https://github.com/openai/universe/issues/228)
```
pip uninstall gym
pip install gym==0.9.5
```

그럼 될까?
```
whyunui-MBP2017:OpenAI_Game_Bot_Live_stream whyun$ python demo.py 
[2018-02-17 17:49:35,551] Making new env: flashgames.CoasterRacer-v0
Traceback (most recent call last):
  File "demo.py", line 93, in <module>
    main()	
  File "demo.py", line 39, in main
    observation_n = env.reset()
  File "/usr/local/lib/python3.6/site-packages/gym/core.py", line 104, in reset
    return self._reset()
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/wrappers/timer.py", line 18, in _reset
    return self.env.reset()
  File "/usr/local/lib/python3.6/site-packages/gym/core.py", line 104, in reset
    return self._reset()
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/wrappers/render.py", line 28, in _reset
    observation_n = self.env.reset()
  File "/usr/local/lib/python3.6/site-packages/gym/core.py", line 104, in reset
    return self._reset()
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/wrappers/throttle.py", line 42, in _reset
    observation = self.env.reset()
  File "/usr/local/lib/python3.6/site-packages/gym/core.py", line 104, in reset
    return self._reset()
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/envs/vnc_env.py", line 336, in _reset
    self._handle_connect()
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/envs/vnc_env.py", line 510, in _handle_connect
    for remote in self.remote_manager.pop(n=n):
AttributeError: 'VNCEnv' object has no attribute 'remote_manager'
```

에이~ 그럼 재미 없지~!! (라고 말은 하지만 육두문자가 떠오른 것은 인지상정!)
좀 뒤져보니, env.configure(remotes=1)을 넣어줘야 한단다.


```python
def main():

	#init environment
	env = gym.make('flashgames.CoasterRacer-v0')
	env.configure(remotes=1)
	observation_n = env.reset()
```

다시 실행해 보자. 아래와 같이 docker image를 받아오는 것으 ㄹ볼 수 있다.

```
whyunui-MBP2017:OpenAI_Game_Bot_Live_stream whyun$ !p
python demo.py 
[2018-02-17 18:00:29,906] Making new env: flashgames.CoasterRacer-v0
[2018-02-17 18:00:29,913] Writing logs to file: /tmp/universe-81183.log
[2018-02-17 18:00:29,952] Ports used: dict_keys([])
[2018-02-17 18:00:29,952] [0] Creating container: image=quay.io/openai/universe.flashgames:0.20.28. Run the same thing by hand as: docker run -p 5900:5900 -p 15900:15900 --privileged --cap-add SYS_ADMIN --ipc host quay.io/openai/universe.flashgames:0.20.28
[2018-02-17 18:00:29,986] Image quay.io/openai/universe.flashgames:0.20.28 not present locally; pulling
0.20.28: Pulling from openai/universe.flashgames
aed15891ba52: Pull complete
773ae8583d14: Pull complete
d1d48771f782: Pull complete
...
...
```

어, 뭔가 브라우저가 떴다가.... 먹통이 되삔네? 로그 메시지를 보자.

```
[2018-02-17 18:02:36,113] Ports used: dict_keys([])
[2018-02-17 18:02:36,677] Remote closed: address=localhost:5901
[2018-02-17 18:02:36,679] At least one sockets was closed by the remote. Sleeping 1s...
universe-XBY3vd-0 | Setting VNC and rewarder password: openai
universe-XBY3vd-0 | [Sat Feb 17 09:02:40 UTC 2018] Waiting for /tmp/.X11-unix/X0 to be created (try 1/10)
universe-XBY3vd-0 | [Sat Feb 17 09:02:40 UTC 2018] [/usr/local/bin/sudoable-env-setup] Disabling outbound network traffic for none
universe-XBY3vd-0 | [init] [2018-02-17 09:02:40,891] Launching system_diagnostics_logger.py, recorder_logdir=/tmp/demo
universe-XBY3vd-0 | [tigervnc] 
universe-XBY3vd-0 | [tigervnc] Xvnc TigerVNC 1.7.0 - built Sep  8 2016 10:39:22
universe-XBY3vd-0 | [tigervnc] Copyright (C) 1999-2016 TigerVNC Team and many others (see README.txt)
universe-XBY3vd-0 | [tigervnc] See http://www.tigervnc.org for information on TigerVNC.
universe-XBY3vd-0 | [tigervnc] Underlying X server release 11400000, The X.Org Foundation
universe-XBY3vd-0 | [tigervnc] 
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension VNC-EXTENSION
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension Generic Event Extension
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension SHAPE
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension MIT-SHM
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension XInputExtension
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension XTEST
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension BIG-REQUESTS
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension SYNC
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension XKEYBOARD
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension XC-MISC
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension XINERAMA
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension XFIXES
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension RENDER
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension RANDR
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension COMPOSITE
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension DAMAGE
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension MIT-SCREEN-SAVER
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension DOUBLE-BUFFER
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension RECORD
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension DPMS
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension X-Resource
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension XVideo
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension XVideo-MotionCompensation
universe-XBY3vd-0 | [tigervnc] Initializing built-in extension GLX
universe-XBY3vd-0 | [tigervnc] 
universe-XBY3vd-0 | [tigervnc] Sat Feb 17 09:02:40 2018
universe-XBY3vd-0 | [tigervnc]  vncext:      VNC extension running!
universe-XBY3vd-0 | [tigervnc]  vncext:      Listening for VNC connections on all interface(s), port 5900
universe-XBY3vd-0 | [tigervnc]  vncext:      created VNC server for screen 0
universe-XBY3vd-0 | [tigervnc] [dix] Could not init font path element /usr/share/fonts/X11/Type1/, removing from list!
universe-XBY3vd-0 | [tigervnc] [dix] Could not init font path element /usr/share/fonts/X11/75dpi/, removing from list!
universe-XBY3vd-0 | [init] [2018-02-17 09:02:40,906] Launching reward_recorder.py, recorder_logdir=/tmp/demo
universe-XBY3vd-0 | [tigervnc] [dix] Could not init font path element /usr/share/fonts/X11/100dpi/, removing from list!
universe-XBY3vd-0 | [init] [2018-02-17 09:02:40,917] Launching vnc_recorder.py, recorder_logdir=/tmp/demo
universe-XBY3vd-0 | [init] [2018-02-17 09:02:40,927] PID 55 launched with command ['sudo', '-H', '-u', 'nobody', 'DISPLAY=:0', 'DBUS_SESSION_BUS_ADDRESS=/dev/null', '/app/universe-envs/controlplane/bin/controlplane.py', '--rewarder-port=15901']
universe-XBY3vd-0 | [init] [2018-02-17 09:02:41,043] init detected end of child process 59 with exit code 0, not killed by signal
universe-XBY3vd-0 | WebSocket server settings:
universe-XBY3vd-0 |   - Listen on :5898
universe-XBY3vd-0 |   - Flash security policy server
universe-XBY3vd-0 |   - No SSL/TLS support (no cert file)
universe-XBY3vd-0 |   - proxying from :5898 to localhost:5900
[2018-02-17 18:02:37,679] Remote closed: address=localhost:15901
[2018-02-17 18:02:37,681] Remote closed: address=localhost:5901
[2018-02-17 18:02:37,682] At least one sockets was closed by the remote. Sleeping 1s...
universe-XBY3vd-0 | [nginx] 2018/02/17 09:02:41 [error] 63#63: *1 connect() failed (111: Connection refused) while connecting to upstream, client: 172.17.0.1, server: , request: "GET / HTTP/1.1", upstream: "http://127.0.0.1:15901/", host: "127.0.0.1:10003"
universe-XBY3vd-0 | [nginx] 172.17.0.1 - openai [17/Feb/2018:09:02:41 +0000] "GET / HTTP/1.1" 502 182 "-" "-"
universe-XBY3vd-0 | [tigervnc] 
universe-XBY3vd-0 | [tigervnc] Sat Feb 17 09:02:41 2018
universe-XBY3vd-0 | [tigervnc]  Connections: accepted: 172.17.0.1::44036
universe-XBY3vd-0 | [vnc_recorder] [2018-02-17 09:02:41,714] Listening on 0.0.0.0:5899
universe-XBY3vd-0 | [reward_recorder] [2018-02-17 09:02:41,722] Listening on 0.0.0.0:15898
universe-XBY3vd-0 | [init] [2018-02-17 09:02:41,818] init detected end of child process 17 with exit code 0, not killed by signal
universe-XBY3vd-0 | [2018-02-17 09:02:41,939] [INFO:root] Starting play_controlplane.py with the following: command=['/app/universe-envs/controlplane/bin/controlplane.py', '--rewarder-port=15901'] args=Namespace(bot_demonstration=False, demonstration=False, env_id=None, idle_timeout=None, integrator_mode=False, no_env=False, no_rewarder=False, no_scorer=False, no_vexpect=False, remotes='vnc://127.0.0.1:5900', rewarder_fps=60, rewarder_port=15901, verbosity=0) env=environ({'TERM': 'xterm', 'HOME': '/nonexistent', 'SUDO_COMMAND': '/app/universe-envs/controlplane/bin/controlplane.py --rewarder-port=15901', 'HOSTNAME': 'c92bff94be55', 'SUDO_USER': 'root', 'SHELL': '/usr/sbin/nologin', 'PATH': '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin', 'SUDO_UID': '0', 'USERNAME': 'nobody', 'DISPLAY': ':0', 'LOGNAME': 'nobody', 'USER': 'nobody', 'DBUS_SESSION_BUS_ADDRESS': '/dev/null', 'SUDO_GID': '0', 'MAIL': '/var/mail/nobody'})
universe-XBY3vd-0 | [2018-02-17 09:02:41,939] [INFO:root] [EnvStatus] Changing env_state: None (env_id=None) -> None (env_id=None) (episode_id: 0->0, fps=60)
universe-XBY3vd-0 | [2018-02-17 09:02:41,939] [INFO:universe.rewarder.remote] Starting Rewarder on port=15901
universe-XBY3vd-0 | [2018-02-17 09:02:41,942] [INFO:universe.extra.universe.wrappers.logger] Running VNC environments with Logger set to print_frequency=5. To change this, pass "print_frequency=k" or "print_frequency=None" to "env.configure".
universe-XBY3vd-0 | [2018-02-17 09:02:41,942] [INFO:universe.remotes.hardcoded_addresses] No rewarder addresses were provided, so this env cannot connect to the remote's rewarder channel, and cannot send control messages (e.g. reset)
universe-XBY3vd-0 | [2018-02-17 09:02:41,942] [INFO:universe.envs.vnc_env] Using the golang VNC implementation
universe-XBY3vd-0 | [2018-02-17 09:02:41,942] [INFO:universe.envs.vnc_env] Using VNCSession arguments: {'start_timeout': 7, 'compress_level': 9, 'encoding': 'zrle', 'fine_quality_level': 50, 'subsample_level': 2}. (Customize by running "env.configure(vnc_kwargs={...})"
universe-XBY3vd-0 | [2018-02-17 09:02:41,943] [INFO:universe.envs.vnc_env] Printed stats will ignore clock skew. (This usually makes sense only when the environment and agent are on the same machine.)
universe-XBY3vd-0 | [2018-02-17 09:02:41,950] [INFO:universe.envs.vnc_env] [0] Connecting to environment: vnc://127.0.0.1:5900 password=openai. If desired, you can manually connect a VNC viewer, such as TurboVNC. Most environments provide a convenient in-browser VNC client: http://None/viewer/?password=openai
universe-XBY3vd-0 | [2018-02-17 09:02:41,951] [INFO:universe.extra.universe.envs.vnc_env] [0] Connecting to environment details: vnc_address=127.0.0.1:5900 vnc_password=openai rewarder_address=None rewarder_password=openai
universe-XBY3vd-0 | 2018/02/17 09:02:41 I0217 09:02:41.951574 58 gymvnc.go:417] [0:127.0.0.1:5900] opening connection to VNC server
universe-XBY3vd-0 | [2018-02-17 09:02:41,952] [INFO:root] [EnvStatus] Changing env_state: None (env_id=None) -> resetting (env_id=None) (episode_id: 0->1, fps=60)
universe-XBY3vd-0 | [2018-02-17 09:02:41,952] [INFO:root] [MainThread] Env state: env_id=None episode_id=1
universe-XBY3vd-0 | [2018-02-17 09:02:41,952] [INFO:root] [MainThread] Writing None to /tmp/demo/env_id.txt
universe-XBY3vd-0 | [tigervnc]  Connections: accepted: 127.0.0.1::59474
universe-XBY3vd-0 | [tigervnc]  SConnection: Client needs protocol version 3.8
universe-XBY3vd-0 | [tigervnc]  SConnection: Client requests security type VncAuth(2)
universe-XBY3vd-0 | [Sat Feb 17 09:02:41 UTC 2018] [/usr/local/bin/sudoable-env-setup] Disabling outbound network traffic for none
universe-XBY3vd-0 | [2018-02-17 09:02:41,975] [INFO:gym_flashgames.launcher] [MainThread] Launching new Chrome process (attempt 0/10)
universe-XBY3vd-0 | [2018-02-17 09:02:41,975] [INFO:root] Replacing selenium_wrapper_server since we currently do it at every episode boundary
universe-XBY3vd-0 | [tigervnc]  VNCSConnST:  Server default pixel format depth 24 (32bpp) little-endian rgb888
universe-XBY3vd-0 | 2018/02/17 09:02:41 I0217 09:02:41.983761 58 gymvnc.go:550] [0:127.0.0.1:5900] connection established
universe-XBY3vd-0 | [tigervnc]  VNCSConnST:  Client pixel format depth 24 (32bpp) little-endian bgr888
universe-XBY3vd-0 | [2018-02-17 09:02:42,125] [selenium_wrapper_server] Calling webdriver.Chrome()
[2018-02-17 18:02:38,688] Using the golang VNC implementation
[2018-02-17 18:02:38,688] Using VNCSession arguments: {'start_timeout': 7, 'encoding': 'tight', 'fine_quality_level': 50, 'subsample_level': 2}. (Customize by running "env.configure(vnc_kwargs={...})"
universe-XBY3vd-0 | [tigervnc] 
universe-XBY3vd-0 | [tigervnc] Sat Feb 17 09:02:42 2018
universe-XBY3vd-0 | [nginx] 2018/02/17 09:02:42 [info] 63#63: *1 client 172.17.0.1 closed keepalive connection
universe-XBY3vd-0 | [tigervnc]  Connections: closed: 172.17.0.1::44036 (Clean disconnection)
universe-XBY3vd-0 | [tigervnc]  EncodeManager: Framebuffer updates: 0
universe-XBY3vd-0 | [tigervnc]  EncodeManager:   Total: 0 rects, 0 pixels
universe-XBY3vd-0 | [tigervnc]  EncodeManager:          0 B (1:-nan ratio)
[2018-02-17 18:02:38,695] [0] Connecting to environment: vnc://localhost:5901 password=openai. If desired, you can manually connect a VNC viewer, such as TurboVNC. Most environments provide a convenient in-browser VNC client: http://localhost:15901/viewer/?password=openai
2018/02/17 18:02:38 I0217 18:02:38.695987 81183 gymvnc.go:417] [0:localhost:5901] opening connection to VNC server
universe-XBY3vd-0 | [tigervnc]  Connections: accepted: 172.17.0.1::44042
universe-XBY3vd-0 | [tigervnc]  SConnection: Client needs protocol version 3.8
2018/02/17 18:02:38 I0217 18:02:38.708281 81183 gymvnc.go:550] [0:localhost:5901] connection established
universe-XBY3vd-0 | [tigervnc]  SConnection: Client requests security type VncAuth(2)
universe-XBY3vd-0 | [tigervnc]  VNCSConnST:  Server default pixel format depth 24 (32bpp) little-endian rgb888
universe-XBY3vd-0 | [tigervnc]  VNCSConnST:  Client pixel format depth 24 (32bpp) little-endian bgr888
universe-XBY3vd-0 | [2018-02-17 09:02:42,563] [INFO:universe.rewarder.remote] Client connecting: peer=tcp4:127.0.0.1:54308 observer=False
universe-XBY3vd-0 | [2018-02-17 09:02:42,563] [INFO:universe.rewarder.remote] WebSocket connection established
universe-XBY3vd-0 | [nginx] 2018/02/17 09:02:44 [info] 63#63: *5 client sent invalid request while reading client request line, client: 127.0.0.1, server: , request: "CONNECT www.google.com:443 HTTP/1.1"
universe-XBY3vd-0 | [nginx] 2018/02/17 09:02:44 [info] 63#63: *6 client sent invalid request while reading client request line, client: 127.0.0.1, server: , request: "CONNECT www.google.com:443 HTTP/1.1"
universe-XBY3vd-0 | [nginx] 2018/02/17 09:02:44 [info] 63#63: *7 client sent invalid request while reading client request line, client: 127.0.0.1, server: , request: "CONNECT www.google.com:443 HTTP/1.1"
universe-XBY3vd-0 | [2018-02-17 09:02:44,974] [selenium_wrapper_server] Call to webdriver.Chrome() completed: 2.85s
universe-XBY3vd-0 | [2018-02-17 09:02:44,975] [INFO:gym_flashgames.launcher] [MainThread] Navigating browser to url=http://localhost
[2018-02-17 18:02:41,128] Throttle fell behind by 2.39s; lost 143.68 frames
universe-XBY3vd-0 | [2018-02-17 09:02:45,068] [INFO:root] [EnvStatus] Changing env_state: resetting (env_id=None) -> running (env_id=None) (episode_id: 1->1, fps=60)
universe-XBY3vd-0 | [2018-02-17 09:02:45,074] [INFO:root] [MainThread] Writing None to /tmp/demo/env_id.txt
universe-XBY3vd-0 | Manhole[1518858165.0809]: Patched <built-in function fork> and <built-in function fork>.
universe-XBY3vd-0 | Manhole[1518858165.0814]: Manhole UDS path: /tmp/manhole-58
universe-XBY3vd-0 | Manhole[1518858165.0922]: Waiting for new connection (in pid:58) ...
universe-XBY3vd-0 | [2018-02-17 09:02:46,966] [INFO:universe.wrappers.logger] Stats for the past 5.01s: vnc_updates_ps=3.8 n=1 reaction_time=None observation_lag=None action_lag=None reward_ps=0.0 reward_total=0.0 vnc_bytes_ps[total]=357957.6 vnc_pixels_ps[total]=532999.9 reward_lag=None rewarder_message_lag=None fps=22.74
universe-XBY3vd-0 | [2018-02-17 09:02:50,080] [INFO:universe.pyprofile] [pyprofile] period=5.00s timers={"rewarder.compute_reward": {"mean": "411.29us", "calls": 301, "std": "182.74us"}, "vnc_env.VNCEnv.vnc_session.step": {"mean": "169.31us", "calls": 301, "std": "92.46us"}, "rewarder.sleep": {"mean": "15.45ms", "calls": 300, "std": "670.98us"}, "rewarder.frame": {"mean": "17.37ms", "calls": 300, "std": "611.00us"}} counters={"reward.vnc.updates.n": {"mean": 0.06312292358803995, "calls": 301, "std": 0.6678339725107008}} gauges={} (export_time=121.83us)
universe-XBY3vd-0 | [2018-02-17 09:02:50,080] [INFO:universe.rewarder.remote] [Rewarder] Over past 5.00s, sent 1 reward messages to agent: reward=0 reward_min=0 reward_max=0 done=False info={'rewarder.vnc.updates.pixels': 0, 'rewarder.vnc.updates.n': 0, 'rewarder.vnc.updates.bytes': 0, 'rewarder.profile': '<763 bytes>'}
universe-XBY3vd-0 | [2018-02-17 09:02:51,981] [INFO:universe.wrappers.logger] Stats for the past 5.01s: vnc_updates_ps=0.0 n=1 reaction_time=None observation_lag=None action_lag=None reward_ps=0.0 reward_total=0.0 vnc_bytes_ps[total]=0.0 vnc_pixels_ps[total]=0.0 reward_lag=None rewarder_message_lag=None fps=60.03
universe-XBY3vd-0 | [2018-02-17 09:02:55,080] [INFO:universe.pyprofile] [pyprofile] period=5.00s timers={"rewarder.compute_reward": {"mean": "440.98us", "calls": 300, "std": "189.32us"}, "vnc_env.VNCEnv.vnc_session.step": {"mean": "177.15us", "calls": 300, "std": "93.70us"}, "rewarder.sleep": {"mean": "15.29ms", "calls": 300, "std": "603.19us"}, "rewarder.frame": {"mean": "17.48ms", "calls": 300, "std": "496.74us"}} counters={"agent_conn.reward": {"mean": 0.0, "calls": 1, "std": 0}, "reward.vnc.updates.n": {"mean": 0.0, "calls": 300, "std": 0.0}} gauges={} (export_time=115.39us)
universe-XBY3vd-0 | [2018-02-17 09:02:55,080] [INFO:universe.rewarder.remote] [Rewarder] Over past 5.00s, sent 1 reward messages to agent: reward=0 reward_min=0 reward_max=0 done=False info={'rewarder.vnc.updates.pixels': 0, 'rewarder.vnc.updates.n': 0, 'rewarder.vnc.updates.bytes': 0, 'rewarder.profile': '<804 bytes>'}
universe-XBY3vd-0 | [2018-02-17 09:02:56,997] [INFO:universe.wrappers.logger] Stats for the past 5.01s: vnc_updates_ps=0.0 n=1 reaction_time=None observation_lag=None action_lag=None reward_ps=0.0 reward_total=0.0 vnc_bytes_ps[total]=0.0 vnc_pixels_ps[total]=0.0 reward_lag=None rewarder_message_lag=None fps=60.02
universe-XBY3vd-0 | [2018-02-17 09:03:00,081] [INFO:universe.pyprofile] [pyprofile] period=5.00s timers={"rewarder.compute_reward": {"mean": "391.47us", "calls": 300, "std": "172.18us"}, "vnc_env.VNCEnv.vnc_session.step": {"mean": "150.89us", "calls": 300, "std": "76.76us"}, "rewarder.sleep": {"mean": "15.44ms", "calls": 300, "std": "562.19us"}, "rewarder.frame": {"mean": "17.39ms", "calls": 300, "std": "466.06us"}} counters={"agent_conn.reward": {"mean": 0.0, "calls": 1, "std": 0}, "reward.vnc.updates.n": {"mean": 0.0, "calls": 300, "std": 0.0}} gauges={} (export_time=112.53us)
universe-XBY3vd-0 | [2018-02-17 09:03:00,081] [INFO:universe.rewarder.remote] [Rewarder] Over past 5.00s, sent 1 reward messages to agent: reward=0 reward_min=0 reward_max=0 done=False info={'rewarder.vnc.updates.pixels': 0, 'rewarder.vnc.updates.n': 0, 'rewarder.vnc.updates.bytes': 0, 'rewarder.profile': '<803 bytes>'}
universe-XBY3vd-0 | [2018-02-17 09:03:02,013] [INFO:universe.wrappers.logger] Stats for the past 5.02s: vnc_updates_ps=0.0 n=1 reaction_time=None observation_lag=None action_lag=None reward_ps=0.0 reward_total=0.0 vnc_bytes_ps[total]=0.0 vnc_pixels_ps[total]=0.0 reward_lag=None rewarder_message_lag=None fps=60.01
[2018-02-17 18:03:01,127] [0:localhost:5901] ntpdate -q -p 8 localhost call timed out after 20.0s; killing the subprocess. This is ok, but you could have more accurate timings by enabling UDP port 123 traffic to your env. (Alternatively, you can try increasing the timeout by setting environment variable UNIVERSE_NTPDATE_TIMEOUT=10.)
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *10 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *11 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *12 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *13 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *14 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *15 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *16 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *17 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *18 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *19 client closed connection while waiting for request, client: 172.17.0.1, server: 0.0.0.0:15900
universe-XBY3vd-0 | [2018-02-17 09:03:05,038] [INFO:universe.rewarder.remote] CONNECTION STATUS: Marking connection as active: observer=False peer=tcp4:127.0.0.1:54308 total_conns=1
[2018-02-17 18:03:01,187] [0:localhost:5901] Sending reset for env_id=flashgames.CoasterRacer-v0 fps=60 episode_id=0
universe-XBY3vd-0 | [2018-02-17 09:03:05,063] [INFO:universe.rewarder.remote] Received reset message: {'headers': {'episode_id': '0', 'message_id': 10, 'sent_at': 1518858181.187246}, 'body': {'seed': None, 'env_id': 'flashgames.CoasterRacer-v0', 'fps': 60}, 'method': 'v0.env.reset'}
universe-XBY3vd-0 | [2018-02-17 09:03:05,070] [INFO:root] [EnvStatus] Changing env_state: running (env_id=None) -> resetting (env_id=flashgames.CoasterRacer-v0) (episode_id: 1->2, fps=60)
universe-XBY3vd-0 | [2018-02-17 09:03:05,073] [ERROR:root] Closing server (via subprocess.close()) and all chromes (via pkill chromedriver || :; pkill chrome || :)
universe-XBY3vd-0 | [2018-02-17 09:03:05,079] [INFO:root] [Rewarder] Blocking until env finishes resetting
universe-XBY3vd-0 | [init] [2018-02-17 09:03:05,088] init detected end of child process 111 with exit code 0, killed by SIGTERM: 15
universe-XBY3vd-0 | [2018-02-17 09:03:05,091] [INFO:root] [EnvController] RESET CAUSE: changing out environments due to v0.env.reset (with episode_id=0): flashgames.CoasterRacer-v0 -> flashgames.CoasterRacer-v0 (new episode_id=2 fps=60)
universe-XBY3vd-0 | [2018-02-17 09:03:05,092] [INFO:root] [EnvController] Env state: env_id=flashgames.CoasterRacer-v0 episode_id=2
universe-XBY3vd-0 | [2018-02-17 09:03:05,092] [INFO:root] [EnvController] Writing flashgames.CoasterRacer-v0 to /tmp/demo/env_id.txt
universe-XBY3vd-0 | [init] [2018-02-17 09:03:05,102] init detected end of child process 126 with exit code 0, not killed by signal
universe-XBY3vd-0 | [init] [2018-02-17 09:03:05,103] init detected end of child process 332 with exit code 0, killed by SIGTERM: 15
universe-XBY3vd-0 | [init] [2018-02-17 09:03:05,103] init detected end of child process 348 with exit code 0, killed by SIGTERM: 15
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *9 client closed connection while waiting for request, client: 127.0.0.1, server: 0.0.0.0:80
universe-XBY3vd-0 | [nginx] 2018/02/17 09:03:05 [info] 63#63: *8 client 127.0.0.1 closed keepalive connection
universe-XBY3vd-0 | [Sat Feb 17 09:03:05 UTC 2018] [/usr/local/bin/sudoable-env-setup] Allowing outbound network traffic to non-private IPs for git-lfs. (Going to fetch files via git lfs.)
universe-XBY3vd-0 | [init] [2018-02-17 09:03:05,160] init detected end of child process 125 with exit code 0, killed by SIGTERM: 15
universe-XBY3vd-0 | [init] [2018-02-17 09:03:05,160] init detected end of child process 122 with exit code 0, not killed by signal
universe-XBY3vd-0 | [init] [2018-02-17 09:03:05,160] init detected end of child process 123 with exit code 0, not killed by signal
universe-XBY3vd-0 | [init] [2018-02-17 09:03:05,161] init detected end of child process 114 with exit code 0, not killed by signal
universe-XBY3vd-0 | [unpack-lfs] [2018-02-17 09:03:05,240] Fetching files: git lfs pull -I git-lfs/flashgames.CoasterRacer-v0.tar.gz
universe-XBY3vd-0 | [unpack-lfs] [2018-02-17 09:03:05,242] If this hangs, your docker container may not be able to communicate with Github
universe-XBY3vd-0 | [nginx] 2018/02/17 09:04:05 [info] 63#63: *3 upstream timed out (110: Connection timed out) while proxying upgraded connection, client: 172.17.0.1, server: , request: "GET / HTTP/1.1", upstream: "http://127.0.0.1:15901/", host: "localhost:15901"
universe-XBY3vd-0 | [nginx] 172.17.0.1 - openai [17/Feb/2018:09:04:05 +0000] "GET / HTTP/1.1" 101 4455 "-" "AutobahnPython/17.10.1"
universe-XBY3vd-0 | [2018-02-17 09:04:05,090] [INFO:universe.rewarder.remote] WebSocket connection closed: connection was closed uncleanly (peer dropped the TCP connection without previous WebSocket closing handshake)
[2018-02-17 18:04:01,150] [0] Closing rewarder connection
universe-XBY3vd-0 | [2018-02-17 09:04:05,091] [INFO:universe.rewarder.remote] [Twisted] Active client disconnected (sent 11 messages). Still have 0 active clients left
Traceback (most recent call last):
  File "demo.py", line 94, in <module>
universe-XBY3vd-0 | [tigervnc] 
universe-XBY3vd-0 | [tigervnc] Sat Feb 17 09:04:05 2018
universe-XBY3vd-0 | [tigervnc]  Connections: closed: 172.17.0.1::44042 (Clean disconnection)
universe-XBY3vd-0 | [tigervnc]  EncodeManager: Framebuffer updates: 20
universe-XBY3vd-0 | [tigervnc]  EncodeManager:   Tight:
universe-XBY3vd-0 | [tigervnc]  EncodeManager:     Solid: 43 rects, 2.50697 Mpixels
universe-XBY3vd-0 | [tigervnc]  EncodeManager:            688 B (1:14576.1 ratio)
universe-XBY3vd-0 | [tigervnc]  EncodeManager:     Bitmap RLE: 8 rects, 52.512 kpixels
universe-XBY3vd-0 | [tigervnc]  EncodeManager:                 415 B (1:506.371 ratio)
universe-XBY3vd-0 | [tigervnc]  EncodeManager:     Indexed RLE: 24 rects, 314.46 kpixels
universe-XBY3vd-0 | [tigervnc]  EncodeManager:                  11.2979 KiB (1:108.75 ratio)
universe-XBY3vd-0 | [tigervnc]  EncodeManager:   Tight (JPEG):
universe-XBY3vd-0 | [tigervnc]  EncodeManager:     Full Colour: 14 rects, 549.336 kpixels
universe-XBY3vd-0 | [tigervnc]  EncodeManager:                  106.937 KiB (1:20.0681 ratio)
universe-XBY3vd-0 | [tigervnc]  EncodeManager:   Total: 89 rects, 3.42328 Mpixels
universe-XBY3vd-0 | [tigervnc]  EncodeManager:          119.312 KiB (1:112.087 ratio)
    main()	
  File "demo.py", line 89, in main
    observation_n, reward_n, done_n, info = env.step(action_n)
  File "/usr/local/lib/python3.6/site-packages/gym/core.py", line 96, in step
    return self._step(action)
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/wrappers/timer.py", line 23, in _step
    observation_n, reward_n, done_n, info = self.env.step(action_n)
  File "/usr/local/lib/python3.6/site-packages/gym/core.py", line 96, in step
    return self._step(action)
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/wrappers/render.py", line 33, in _step
    observation_n, reward_n, done_n, info_n = self.env.step(action_n)
  File "/usr/local/lib/python3.6/site-packages/gym/core.py", line 96, in step
    return self._step(action)
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/wrappers/throttle.py", line 51, in _step
    accum_observation_n, accum_reward_n, accum_done_n, accum_info = self._substep(action_n)
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/wrappers/throttle.py", line 132, in _substep
    observation_n, reward_n, done_n, info = self.env.step(action_n)
  File "/usr/local/lib/python3.6/site-packages/gym/core.py", line 96, in step
    return self._step(action)
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/envs/vnc_env.py", line 464, in _step
    self._handle_crashed_n(info_n)
  File "/Users/whyun/Devel/Projects/ML_gamebot/universe/universe/envs/vnc_env.py", line 537, in _handle_crashed_n
    raise error.Error('{}/{} environments have crashed! Most recent error: {}'.format(len(self.crashed), self.n, errors))
universe.error.Error: 1/1 environments have crashed! Most recent error: {'0': 'Rewarder session failed: Lost connection: connection was closed uncleanly (peer dropped the TCP connection without previous WebSocket closing handshake) (clean=False code=1006)'}
universe-XBY3vd-0 | [unpack-lfs] [2018-02-17 09:04:05,247] git lfs timed out after 60 seconds. Your docker container probably can't communicate with Github.
universe-XBY3vd-0 | It is fetching from https://github.com/, so make sure your container can connect to public addresses on port 443.
[2018-02-17 18:04:01,338] Killing and removing container: id=c92bff94be55d030bf78246de5c46fb9f377571db256c23b0953f30484e855db
```

뭔가 학습이 진행 되다가... 죽은것 같다. 
다시 실행해 본다. 
어! 된다!
어? 근데 곧 죽었다.
뭔가 소켓쪽 에러가 마구 뿜뿜한다.

openai 공식홈페이지에서 제공하는 예제를 가지고 다시 해보자.
```python
import gym
import universe  # register the universe environments

env = gym.make('flashgames.DuskDrive-v0')
env.configure(remotes=1)  # automatically creates a local docker container
observation_n = env.reset()

while True:
  action_n = [[('KeyEvent', 'ArrowUp', True)] for ob in observation_n]  # your agent here
  observation_n, reward_n, done_n, info = env.step(action_n)
  env.render()
```

잘 된다. 근데 얘는 UP 버튼만 누르기 때문에 수천번 돌려도 아무짝에 쓸모 없다.
그래서 원래 하려던 코드에 나와있는 게임을 교체했더니 잘 동작한다. 

```python 
# env = gym.make('flashgames.CoasterRacer-v0')
env = gym.make('flashgames.DuskDrive-v0')
```

<!-- ![openai screen](openai.png){:class="img-responsive"} -->
![openai flashgame screenshot]({{ "/assets/images/openai.png" }}){:class="img-responsive"}


찬찬히 까보자. 
도커 이미지는 다음을 포함하는 것 같다.
- flashgame 
- vnc server
- chrome
- web server
- websocket server


독특한게, 대개의 docker image/container는 server program이 구동되는 것이 통상적인데, 얘네는 마치 virtual desktop environment가 돌아가는 것 같다. 굉장히 특이하긴 한데, 다른 곳에 응용할 수 있는 가능성을 보여준 것이 꽤 흥미롭다.
GUI application이 docker image에 들어가게 하는 방법은 [여기](https://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker-container)의 내용을 참고하자.


```
...
quay.io/openai/universe.flashgames   0.20.28             e55f692f7c56        11 months ago       1.75GB
...
```

이 이미지/컨테이너가 하는 일이 뭔지 보는 가장 좋은 방법은 Dockerfile을 까 보는 것!!

```yaml
FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y libav-tools \
    python3-numpy \
    python3-scipy \
    python3-setuptools \
    python3-pip \
    libpq-dev \
    libjpeg-dev \
    curl \
    cmake \
    swig \
    python3-opengl \
    libboost-all-dev \
    libsdl2-dev \
    wget \
    unzip \
    git \
    golang \
    net-tools \
    iptables \
    libvncserver-dev \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/pip3 /usr/local/bin/pip \
    && ln -sf /usr/bin/python3 /usr/local/bin/python \
    && pip install -U pip

# Install gym
RUN pip install gym[all]

# Get the faster VNC driver
RUN pip install go-vncdriver>=0.4.0

# Install pytest (for running test cases)
RUN pip install pytest

# Force the container to use the go vnc driver
ENV UNIVERSE_VNCDRIVER='go'

WORKDIR /usr/local/universe/

# Cachebusting
COPY ./setup.py ./
COPY ./tox.ini ./

RUN pip install -e .

# Upload our actual code
COPY . ./

# Just in case any python cache files were carried over from the source directory, remove them
RUN py3clean .

```

대충 눈여겨 봐야 할 것으로..
- go-vncdriver : vnc viewer 역할을 하면서 vnc server로부터 영상(스냅샷?)을 수집하는 기능 
- pytest : 단위별 기능테스트 하는 패키지
- gym[atari] in setup.py

등이 있다. 

또 하나 눈여겨 볼 것이 최종 실행 명령이 없이, 설치에 관련된 명령만이 나열되어 있다는 점이다. 실행을 위한 명령은 다른 곳에서 공급받는 다는 얘기. 
로그 파일을 잘 들여다보면, command=['/app/universe-envs/controlplane/bin/controlplane.py', '--rewarder-port=15901'] 이 있는데, 얘가 실제 관련 프로그램 구동을 담당하는 듯 하고, 15901 포트는 웹소켓 포트로 reward가 발생하면 값을 전달해 주는 포트로 보인다.

도커 컨테이너 내의 브라우저는 Chrome WebDriver를 이용했다. 완전 웹쪽 전문가(특히 브라우저 개발자)가 붙어 있는 모양이다.

어쨌든 궁금했던 것은 다음과 같다.

- 게임을 어떻게 시작되도록 하는가? 클릭되어야 할 좌표는 미리 입력하는 건가? 
    - ㅇㅇ. 게임별 environment가 있고, 게임을 start 하기 위한 마우스 좌표 등을 미리 포함시키도록 하고 있음.
- reward는 어떻게 알아내는가? 즉, 성공/실패 여부는 어떻게 알아내지? 
    - 이것도 미리.. 정해놔야 함.
- VNC에서 화면 데이터를 읽어서 어떻게 처리하는가? 
    - 처리하지 않음. universe에서 다 해줌.
- 학습된 모델을 save/load 할 수 있는가? 
    - 만들면 됨. 별로 어렵진 않음.


## 잠정 결론..

**이거 뭐에 써먹지?**















