---
layout: post
title:  "Python3 + matplotlib.pyplot で描画がされない"
date:  2014-07-29 12:00:00 UTC+9
categories: python matplotlib
---

### 問題

Ubuntu 12.04 の gnuplot は[古く](https://launchpad.net/ubuntu/precise/+package/gnuplot)，ちょうどこのあとに追加された機能や fix された bug
も結構あるので，とりあえず matplotlib/pyplot を使うことにする．個人的には最近は python3 に移行しきっているので，python3 上で叩いてみると

{% highlight python %}
import matlotlib.pyplot as plt
plt.plot([1,2,3,4])
plt.show()
{% endhighlight %}

描画がされない．例外の発生などもなく， `plt.show()` がなかったかのように静かにプログラムが終了する．

### 解決

**[tk などがきちんとインストールされているかを確認し， matplotlib を 再 build する](http://stackoverflow.com/a/15920545/3026489)．**

少し前に[記事に書いた]({{site.baseurl}}/2014/07/21/python_no_module_tkinter.html) ように，もともと自前ビルドした python 3 が
`tkinter` 使えなかったので，最近 `tk-dev` などをインストールして python3 をビルドしなおした経緯がある．
matplotlib はその前にインストールしていたので，tk を認識しておらず（みたいな大雑把な理解），静かに黙っていたという事らしい．

pip の細かい使い方はよく把握してないんだが，[このへん](http://stackoverflow.com/questions/19548957/) 参考にして matplotlib を再 build.
これできちんと表示されるようになりました．

黙って終了するんじゃなくてなんかエラーかなんか吐いてくれてもいい気がしたけど，どうなんだろう．`savefig` だけしたい時にそんなん言われると邪魔も邪魔だけど，
ウィンドウに描いてねっていう時ぐらいなんか喋ってくれてもいいのではないだろうか．
