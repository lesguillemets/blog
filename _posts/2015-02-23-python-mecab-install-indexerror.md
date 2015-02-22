---
layout: post
title:  "MeCab の Python バインディングをインストールしようとしてIndexError on linux"
date:  2015-02-22 00:00:00 UTC+9
categories: Python
---

手短に．

ちょっと書捨てたいものがあって MeCab の Python(-3) binding をインストールしよう

* [python3対応 Mecabの紹介 - Python, web, Algorithm 技術的なメモ](http://samurait.hatenablog.com/entry/Mecab-python3)

さて

{% highlight text %}
$ pip3 install mecab-python3
Downloading/unpacking mecab-python3
  Downloading mecab-python3-0.7.tar.gz (41kB): 41kB downloaded
  Running setup.py (path:/tmp/pip_build_lesguillemets/mecab-python3/setup.py) egg_info for package mecab-python3
    /bin/sh: 1: mecab-config: not found
    Traceback (most recent call last):
      File "<string>", line 17, in <module>
      File "/tmp/pip_build_lesguillemets/mecab-python3/setup.py", line 41, in <module>
        include_dirs=cmd2("mecab-config --inc-dir"),
      File "/tmp/pip_build_lesguillemets/mecab-python3/setup.py", line 21, in cmd2
        return cmd1(strings).split()
      File "/tmp/pip_build_lesguillemets/mecab-python3/setup.py", line 18, in cmd1
        return os.popen(strings).readlines()[0][:-1]
    IndexError: list index out of range
    Complete output from command python setup.py egg_info:
    /bin/sh: 1: mecab-config: not found

Traceback (most recent call last):

  File "<string>", line 17, in <module>

  File "/tmp/pip_build_lesguillemets/mecab-python3/setup.py", line 41, in <module>

    include_dirs=cmd2("mecab-config --inc-dir"),

  File "/tmp/pip_build_lesguillemets/mecab-python3/setup.py", line 21, in cmd2

    return cmd1(strings).split()

  File "/tmp/pip_build_lesguillemets/mecab-python3/setup.py", line 18, in cmd1

    return os.popen(strings).readlines()[0][:-1]

IndexError: list index out of range

{% endhighlight %}

なんや，と思うと

> `/bin/sh: 1: mecab-config: not found`

 `mecab-config` が実行したいのにないで，という感じらしい．

`setup.py` を書き換えることで回避もできるらしいが


* [MeCab&mecab-pythonをインストール　その１ - ふゆみけ](http://d.hatena.ne.jp/fuyumi3/20120113/1326383644)
* [CentOSにmecab-pythonをインストールする - Qiita](http://qiita.com/saicologic/items/ab70e14f7e2ec2ee0b4d)


terminal で

{% highlight bash %}
$ mecab-config
  The program 'mecab-config' is currently not installed. You can install it by typing:
  sudo apt-get install libmecab-dev
{% endhighlight %}

とありがたいお言葉を頂いたのでそれを行い

{% highlight bash %}
$ sudo apt-get install libmecab-dev
{% endhighlight %}

改めて

{% highlight bash %}
$ pip3 install mecab-python3
{% endhighlight %}

で成功します．
