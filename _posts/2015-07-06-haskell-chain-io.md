---
layout: post
title:  "Haskell で IO をつなげて [a -> IO a] -> IO a 的なこと"
date: 2015-07-06 12:00:00 UTC+9
categories: haskell
---

Haskell でこういう関数が欲しいことがある:

{% highlight haskell %}
connect :: Monad m => [a -> m a] -> a -> m a
-- 気分的には
connect (f0:f1:..) n = do
    p0 <- f0 n
    p1 <- f1 p0
    ..
    fn pn
{% endhighlight %}

具体的にはこういうこと

{% highlight haskell %}
printAndMultiply :: Int -> Int -> IO Int
printAndMultiply n m = do
    print m
    return (n*m)

main = do
  n <- connect [printAndMultiply 2, printAndMultiply 3] 6
  putStrLn "______"
  print n
{% endhighlight %}

で出力が

{% highlight text %}
6
12
______
36
{% endhighlight %}

とりあえず Hoogle に訊いてみよう． [`[a -> m a] -> a -> m a`](https://www.haskell.org/hoogle/?hoogle=%5ba+-%3E+m+a%5d+-%3E+a+-%3E+m+a&start=21#more)

[このへん](http://hackage.haskell.org/package/base-4.8.0.0/docs/Control-Monad.html#v:-62--61--62-)がそれっぽい？

{% highlight haskell %}
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
{% endhighlight %}

というわけで例えばこう書くことができる
{% highlight haskell %}
import Control.Monad
import Data.List (foldl')

printAndMultiply :: Int -> Int -> IO Int
printAndMultiply n m = do
    print m
    return (n*m)

f = printAndMultiply

fs :: [Int -> IO Int]
fs = [f 2, f 3, f 5, f 1, f 2]

connect :: (Monad m) => [a -> m a] -> a -> m a
connect = foldl' (>=>) return

main = do
    nn <- connect fs 4
    print "__"
    print nn
{% endhighlight %}

出力

{% highlight text %}
4
8
24
120
120
"__"
240
{% endhighlight %}


なんだけどこれでいいのかなあ．なんかもうちょっと綺麗な書き方があるような気がするんですよね．
あと `Functor` とか `Applicative` とかで上手いことできないのだろうか．このへん慣れ親しみかけているところなのでまだよくわかりません．
