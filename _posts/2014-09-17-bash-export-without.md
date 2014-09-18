---
layout: post
title:  "Bash で export 付けるのと付けないのとでどう違うのか"
date:  2014-09-17 18:00:00 UTC+9
categories: bash
---

## 問題

bash で変数を定義したい．

{% highlight bash %}
foo=bar
echo $foo
# => bar
{% endhighlight %}

でも，`.bashrc` で書くときとかってこうするよね

{% highlight bash %}
export $foo=bar
echo $foo
# => bar
{% endhighlight %}

どう違うの？

## 答え

`export` をつけるとそこから出た subprocess みんながそれを参照できるようになる．(cf. [stackoverflow](http://stackoverflow.com/questions/1158091))

つまりこうだ

{% highlight text %}
$ export foo=bar
$ baz=moo
$ echo $foo,$baz
bar,moo
$ python3
Python 3.4.0 (default, Apr 11 2014, 13:05:18) 
[GCC 4.8.2] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import os
>>> os.environ['foo']
'bar'
>>> 'baz' in os.environ
False
{% endhighlight %}

## ついでに background

勿論 .bashrc とかで使うのもそうだが，heroku では環境変数を設定しとけるので，例えば api key などをリポジトリには含めずにソースを公開したいけど
そういう情報はどっかから見られないと困る，という時に，設定した環境変数を参照するようにすればそういうところを隠して動作させることが出来る．
ローカルにも走らせたければ何らかの `.gitignore` に入ったファイルにそれらを書き込んでおけば良くて，というような話．
