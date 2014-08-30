---
layout: post
title:  "Javascript で文字列から数値への冴えた変換"
date:  2014-07-13 00:00:00 UTC+9
categories: javascript
---

### 問題

{% highlight javascript %}
var i_want_number = document.getElementById("num0");
{% endhighlight %}

`i_want_number` は残念ながら文字列だ．これを回避するには `parseInt` や `parseFloat` があるが，ちょっとだるい感じがある気もする．

### 解決

{% highlight javascript %}
var i_want_number = +document.getElementById("num0");
{% endhighlight %}

これはつまり何かを `bool` にしたい時に

{% highlight javascript %}
!!foo
{% endhighlight %}

とやるのと同じような話だ．気持ち悪いといえば気持ち悪いけど，いい感じに使えるのではないだろうか．

これは [d3.js の tutorial](http://bost.ocks.org/mike/bar/2/) 読んでる時に見つけたものです．

### 追記

`Number` というのがあるので多分こっちを使うべきなんだとおもう．

{% highlight javascript %}
Number("3.3") // => 3.3
Number("3") // => 3
Number("3ab") // => NaN
{% endhighlight %}
