---
layout: post
title:  "tac コマンド"
date:  2014-08-10 12:00:00 UTC+9
categories: bash
---

`tac` というコマンドがあるのでそれを．こういうシンプル系のツール，知ってると便利に使えるのだが知らないと（シンプルな分）自分でスクリプト書いたりしがちなので，積極的に拾っていきたい．


{% highlight text %}
NAME
       tac - concatenate and print files in reverse
SYNOPSIS
       tac [OPTION]... [FILE]...
DESCRIPTION
       Write each FILE to standard output, last line first.
       With no FILE, or when FILE is -, read standard input.
{% endhighlight %}

ということで，ファイルを読み込んで逆順に出力．`cat` の逆で `tac` なんでしょうね．

オプションに  `-b`, `-s`, `-r` があり，`-s` は newline じゃなくて任意の文字列で区切る，`-r` はそれの regex, `-b` はセパレータの場所を (after じゃなくて) `before` に規定する感じ．

`$ cat cat.txt`

{% highlight text %}
Here comes the cat
there goes THE dog
{% endhighlight %}

`$ tac cat.txt`

{% highlight text %}
there goes THE dog
Here comes the cat
{% endhighlight %}

`$ tac -s " " cat.txt` (`.` はスペース)

{% highlight text %}
dog
THE goes cat
there the comes Here.
{% endhighlight %}

`$ tac -s " " -b cat.txt`

{% highlight text %}
.dog
.THE goes cat
there the comesHere
{% endhighlight %}


なるほど．newline が混じってるから `-s` とかちょっとわかりにくいけど，まあそういうことだ．
