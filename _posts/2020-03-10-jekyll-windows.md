---
layout: post
categories: information
tags: [jekyll, windows]
title: 윈도우10에서 Jekyll 블로그 사용하기
---

github.io 에 올리기 이전에 로컬에서 확인해 볼 필요가 있는데, 그럴려면 로컬에 ruby와 jekyll 이 설치되어야 함. mac이나 linux는 명령어 몇 줄이면 되는데, 윈도우는 어떨까? ~~크게 다르지 않음~~

## Windows 환경(cmd 나 powershell)에서 쓸 때


### Ruby Download

https://rubyinstaller.org/downloads/ 에 가서 적당한 녀석(Recommend 하는 녀석)을 다운받아 설치한다.
몇가지 묻는 얘기가 나오는데 적당히 알아서 설치. 
설치 위치를 program files 밑으로 해 두면 쪼까 번잡스러운 일이 생길 수 있으니, 디폴트 위치로 해 주자.
- program files 밑에 설치하면, jekyll install 과정에서 compile 에러가 나올꺼다.
  - 중간에 공백 때문이란 얘기도 있고..
  - 허가권 얘기도 있고...

### Jekyll, Bundler Install

윈도우 cmd 창을 열어서...
```
gem install jekyll bundler
```
을 해 준다.

### 내 블로그를 위한 웹서버를 띄워보자

```
jekyll serve
```

에러가 좌라락 뜨면서 멈추면 당신은 나와 같은 꽈! 
안 뜨면 당신은 행복한 사람. 쉐트!!

```
Resolving dependencies...
Traceback (most recent call last):
        19: from C:/Ruby26-x64/bin/jekyll:23:in `<main>'
        18: from C:/Ruby26-x64/bin/jekyll:23:in `load'
        17: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/jekyll-4.0.0/exe/jekyll:11:in `<top (required)>'
        16: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/jekyll-4.0.0/lib/jekyll/plugin_manager.rb:52:in `require_from_bundler'
        15: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler.rb:149:in `setup'
        14: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/runtime.rb:20:in `setup'
        13: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/runtime.rb:101:in `block in definition_method'
        12: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/definition.rb:226:in `requested_specs'
        11: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/definition.rb:237:in `specs_for'
        10: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/definition.rb:170:in `specs'
         9: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/definition.rb:258:in `resolve'
         8: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/resolver.rb:22:in `resolve'
         7: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/resolver.rb:50:in `start'
         6: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/vendor/molinillo/lib/molinillo/resolver.rb:43:in `resolve'
         5: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/vendor/molinillo/lib/molinillo/resolution.rb:182:in `resolve'
         4: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/vendor/molinillo/lib/molinillo/resolution.rb:257:in `process_topmost_state'
         3: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/vendor/molinillo/lib/molinillo/resolution.rb:308:in `unwind_for_conflict'
         2: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/vendor/molinillo/lib/molinillo/resolution.rb:308:in `tap'
         1: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/vendor/molinillo/lib/molinillo/resolution.rb:310:in `block in unwind_for_conflict'
C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/vendor/molinillo/lib/molinillo/resolution.rb:328:in `raise_error_unless_state': Unable to satisfy the following requirements: (Bundler::Molinillo::VersionConflict)
```

i18n도 깔아 봤으나, 여전히 같은 에러가 계속 나온다.

그래서 아래처럼 bundle update를 해 줬다. 
뭔가 엄청난 작업들을 주루룩 하는 것이 보인다.


```
bundle update
```


다시 해보자.

```
C:\workspace\repository\superwhyun.github.io>jekyll serve
Traceback (most recent call last):
        10: from C:/Ruby26-x64/bin/jekyll:23:in `<main>'
         9: from C:/Ruby26-x64/bin/jekyll:23:in `load'
         8: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/jekyll-4.0.0/exe/jekyll:11:in `<top (required)>'
         7: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/jekyll-4.0.0/lib/jekyll/plugin_manager.rb:52:in `require_from_bundler'
         6: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler.rb:149:in `setup'
         5: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/runtime.rb:26:in `setup'
         4: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/runtime.rb:26:in `map'
         3: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/spec_set.rb:147:in `each'
         2: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/spec_set.rb:147:in `each'
         1: from C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/runtime.rb:31:in `block in setup'
C:/Ruby26-x64/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/runtime.rb:312:in `check_for_activated_spec!': You have already activated i18n 1.8.2, but your Gemfile requires i18n 0.9.5. Prepending `bundle exec` to your command may solve this. (Gem::LoadError)
```

오... 아까와는 다른 에러~!! 가능성이 보였으.

하라는대로 이번엔 bundle 을 이용해보자

```
bundle exec jekyll serve
```

되네? 

```
C:\workspace\repository\superwhyun.github.io>bundle exec jekyll serve
Configuration file: C:/workspace/repository/superwhyun.github.io/_config.yml
            Source: C:/workspace/repository/superwhyun.github.io
       Destination: C:/workspace/repository/superwhyun.github.io/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
   GitHub Metadata: No GitHub API authentication could be found. Some fields may be missing or have incorrect data.
                    done in 17.448 seconds.
  Please add the following to your Gemfile to avoid polling for changes:
    gem 'wdm', '>= 0.1.0' if Gem.win_platform?
 Auto-regeneration: enabled for 'C:/workspace/repository/superwhyun.github.io'
    Server address: http://127.0.0.1:4000
  Server running... press ctrl-c to stop.
```



bundler는 ...
> 번들러는 필요한 정확한 gem과 버전을 추적하고 설치하여 루비 프로젝트를 위한 일관된 환경을 제공합니다. 번들러는 의존성 지옥에서 벗어나게 하고, 필요한 gem이 개발, 스테이징, 프로덕션에 있는지 확인해 줍니다. bundle install을 실행해 간단히 프로젝트에서 사용해 보세요.
> [출처](https://ruby-korea.github.io/bundler-site/)


## WSL 환경에서 쓸 때

ubuntu linux랑 똑같음. 

[공식 홈피](https://jekyllrb.com/docs/installation/windows/) 참고