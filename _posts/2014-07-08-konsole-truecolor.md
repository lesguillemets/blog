---
layout: post
title:  "実は Konsole は true color に対応している"
date:  2014-07-08 12:00:00 UTC+9
categories: terminal
---

### 問題

以前，ANSI escape sequence で色付けをして，半角スペースを並べて terminal 上で画像を表示するスクリプトを書いた．
これをベースに作った，terminal 上で動く tumblr の見るだけクライアントは未完成ながら結構気に入って使っている．
このとき256色にどう落としこむかというのは，画素の少なさとともにひとつの問題になり（なお後者については K-means とか使ったりしてみたりはした），
まあいいかってことで結局色空間上の区画の端っこに揃えることにした．できればもっと綺麗に色を表示したい．

### 解決
実は [Konsole](https://github.com/robertknight/konsole/blob/master/user-doc/README.moreColors) はじめ幾つかの
terminal emulator は true color に対応している．リンク上を見ながら簡単に試してみよう．

{% highlight python %}
#!/usr/bin/env python3

SEQ = '\033[{}m{{}}\033[0m'
color_format = "48;2;{};{};{}"

def colorscheck():
    for r in range(256):
        for g in range(256):
            color = color_format.format(r,g,120)
            color_seq = SEQ.format(color)
            print(color_seq.format(" "), end='')
        print('')

if __name__ == "__main__":
    colorscheck()
{% endhighlight %}

結果

<img src="{{site.baseurl}}/img/2014-07/08_kterm_truecolor.png" alt="trucolor.png" style="width:600px;">

他の terminal については以下の gist にまとまっている．

* [True Color (16 million colors) support in various terminal applications and terminals](https://gist.github.com/XVilka/8346728)

<del>これで terminal での画像表示が捗りますね!!</del>
