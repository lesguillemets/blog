---
layout: post
title:  "Haskell で指定の関数の結果を使って sort したい"
date:  2014-08-14 00:00:00 UTC+9
categories: haskell
---

Haskell でリストに対して任意の関数を適用した結果を使ってソートしたい．python で言うと

{% highlight python %}
# a is a list
a.sort(key = lambda x: str(x)[::-1])
{% endhighlight %}

みたいな感じ．

なんか `sortBy` とかあったなーと思って書くと型がちゃうで，とエラーが出る．

{% highlight haskell %}
sortBy :: (a -> a -> Ordering) -> [a] -> [a]
{% endhighlight %}

ということで，`Ordering` ってのは `compare` が吐くような `LT` とかそういうので，これは python でいうと多分 `__comp__` を自前で定義するのにちかそう．

というわけで Hoogle で検索しよう．

{% highlight haskell %}
(Ord b) => (a -> b) -> [a] -> [a]
{% endhighlight %}
とかこの辺りのはず．とりあえずこれで検索すると見事にあって，名前が近いけど僕が欲しかったのは `GHC.Exts` にある
[`sortWith`](http://hackage.haskell.org/package/base-4.7.0.1/docs/GHC-Exts.html#v:sortWith).

> The sortWith function sorts a list of elements using the user supplied function to project something out of each element.

とのことで，まさにこれが欲しかったものっぽい．多分元を正せば `sortBy` で書いているんだろうなーと思って
[ソースを見てみる](http://hackage.haskell.org/package/base-4.7.0.1/docs/src/GHC-Exts.html#sortWith)と，

{% highlight haskell %}
sortWith :: Ord b => (a -> b) -> [a] -> [a]
sortWith f = sortBy (\x y -> compare (f x) (f y))
{% endhighlight %}

ははぁなるほど綺麗なもんだ（部分適用のところまでしか書いていないのも綺麗だよね）．
自分で書こうとした時には `compareWith f [x,y]` みたいな雰囲気のことをしたくなったりしたので，バランス感覚が重要という感じである．
