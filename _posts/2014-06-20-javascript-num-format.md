---
layout: post
title:  "Javascript で数字の format 的なことは提供されないっぽいという話"
date:   2014-06-20 12:30:00 UTC+9
categories: javascript
---

だいたい表題どおり．やりたいことは

{% highlight python %}
1.toStringwithLeadingZeros(3)
# ==> 003
11.toStringwithLeadingZeros(3)
# ==> 011
211.toStringwithLeadingZeros(3)
# ==> 211
{% endhighlight %}

みたいな感じ．Python ではこんなふうに書く ([ドキュメント](https://docs.python.org/3.3/library/string.html#format-specification-mini-language))([もうちょっと手軽な解説](http://auewe.hatenablog.com/entry/2013/10/16/083627))．

{% highlight python %}
"{:03d}".format(1)
# => '001'
{% endhighlight %}

引数複数渡すなら `{0:03d}` みたいな書き方ができる．

Javascript でこれをやりたいな…と思ったのだが，ちょっと調べた感じ普通には[提供されてなさそう](http://stackoverflow.com/questions/1267283)．[この解答](http://stackoverflow.com/a/1268377/3026489) のようにメソッド作るのが最善のようだ．

なんか Javascript, 全然詳しいわけじゃないけど，DOM とかの関係でいろんな所で文字が幅をきかせてる割に
この辺提供なかったりして微妙に微妙な気分になる．「そこメソッド提供してよ！」と思うところで自前で `for` 回さないといけない
みたいなこともあった気がするぜ．あと型の自動変換が強気すぎてつらい．

{% highlight javascript %}
"4" * 3
// => 12
{% endhighlight %}
