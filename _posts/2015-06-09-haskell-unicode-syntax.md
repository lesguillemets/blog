---
layout: post
title:  "Haskell の Unicode syntax あれこれ"
date: 2015-06-09 00:00:00 UTC+9
categories: haskell
---

突然だが，以下のコードはきちんとコンパイルの通る haskell コードである．

{% highlight haskell %}
{-# LANGUAGE UnicodeSyntax #-}
import System.Time

f ∷ Num a ⇒ a → b → a
f a _ = a + a

main = do
    t ← getClockTime
    print t
{% endhighlight %}

これは [UnicodeSyntax](https://downloads.haskell.org/~ghc/7.6.3/docs/html/users_guide/syntax-extns.html) という ghc extension によるもので，
∷ とか 矢印とかが使えるというものだ．&forall; も使えるらしい．

普段は端末の vim で使っていて，基本的に `ambiwidth=half` で使っているので，⇒ とかはちょっと使いづらいところがあるけれど，
∷ とか ← は使って行ってもいいかもしれない…いいかもしれない？

それだけの一発ネタでした．

