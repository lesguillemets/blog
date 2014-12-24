---
layout: post
title:  "コマンドラインからクリップボードにアクセス on linux"
date:  2014-12-24 12:00:00 UTC+9
categories: bash
---

bash からクリップボードにアクセスしたい時がたまにある．こういう感じのことをしたい

{% highlight text %}
$ echo "Hi there!" > /dev/clipboard
# あるいは
$ echo "Hi there!" | writeclipboard
$ readclipboard
{% endhighlight %}

ジャストの質問：[linux - Pipe to/from Clipboard - Stack Overflow](http://stackoverflow.com/questions/749544/)

[lhunath](http://stackoverflow.com/users/58803/lhunath) による[回答](http://stackoverflow.com/a/750466/3026489): (Licensed under CC-BY-SA)

> この質問は少し曖昧．多分 `X` を使ってる linux ユーザで，X の PRIMARY clipboard について読み書きしたいんだろう．
>
> `bash` 自体はクリップボードを持ってなくて，これを意識するのは大事．`bash` ってのは Windows でも linux でも，X の中でも外でも，
> とにかくいろんな環境で動くのだ．X 自体だって3つクリップボードを持ってる．従って bash にとって，
> 単に「クリップボード」と言った時にそれと決まるようなものはなくて，どれを扱おうとしているのかはわからない．
> 大抵はなにかしたい相手のクリップボードにはそれ用のユーティリティがついてくる．
>
> X だったら `xclip` (など)．
>
> Mac OS X なら `pbcopy`.
>
> Linux で，X のない端末モードであれば `gpm` かな．
>
> GNU Screen もキーボードを持ってるね．これについては `screen` のコマンドの `readreg` というのがある．
>
> Window/cygwin なら `/dev/clipboard` がある．

[Klaas van Schelven](http://stackoverflow.com/users/339144/klaas-van-schelven) による[コメント](http://stackoverflow.com/questions/749544/#comment8440120_750466):

> なお，`xclip -selection c` で，ほとんどのアプリケーションで `^C`, `^V` で動くクリップボードにアクセスできるよ．

というわけで，Ubuntu + X ならこれで解決する．

{% highlight bash %}
# read from clipboard
xclip -o -selection c
# write to clipboard
echo "Hi there!" | xclip -i -selection c
{% endhighlight %}

なお，klipper を使ってる状態でもいい感じに動く．便利．
