---
layout: post
title:  "Learn you a haskell: read the source!"
date:  2014-08-20 19:05:25 UTC+9
categories: haskell
---

## すごい Haskell, source を読もう！

ということで， [Learn you a haskell for great good](http://learnyouahaskell.com/) に出てくる函数などがそれ自身 haskell で書かれてた場合に， [hoogle](http://www.haskell.org/hoogle/) で調べてソースを読んでいこうという企画．

## Chapter 1. Introduction
とくになし

## Chapter 2. Starting Out

*  [`succ`](http://hackage.haskell.org/package/base-4.7.0.1/docs/Prelude.html#v:succ)

{% highlight haskell %}
succ :: Enum a => a -> a
instance  Enum Int  where
    succ x
       | x == maxBound  = error "Prelude.Enum.succ{Int}: tried to take `succ' of maxBound"
       | otherwise      = x + 1
    pred x
       | x == minBound  = error "Prelude.Enum.pred{Int}: tried to take `pred' of minBound"
       | otherwise      = x - 1
{% endhighlight %}

`Bool` とかでも似たような定義がされている． `instance` の使い方，復習しないとね．

*  [`(++)`](http://hackage.haskell.org/package/base-4.7.0.1/docs/Prelude.html#v:-43--43-)

{% highlight haskell %}
(++) :: [a] -> [a] -> [a]
{-# NOINLINE [1] (++) #-}    -- We want the RULE to fire first.
                             -- It's recursive, so won't inline anyway,
                             -- but saying so is more explicit
(++) []     ys = ys
(++) (x:xs) ys = x : xs ++ ys
{% endhighlight %}

素直な再帰のようだ．

*  [`(!!)`](http://hackage.haskell.org/package/base-4.7.0.1/docs/Prelude.html#v:-33--33-)

{% highlight haskell %}
(!!)                    :: [a] -> Int -> a
#ifdef USE_REPORT_PRELUDE
xs     !! n | n < 0 =  error "Prelude.!!: negative index"
[]     !! _         =  error "Prelude.!!: index too large"
(x:_)  !! 0         =  x
(_:xs) !! n         =  xs !! (n-1)
#else
-- この下に  HBC version っていうのがあるが省略
{% endhighlight %}

慣れないと一瞬「あ，それアリなんや」ってなるパターンマッチな気がする．

* [`head`, `tail`, `last`, `init](http://hackage.haskell.org/package/base-4.7.0.1/docs/Prelude.html#v:head)

{% highlight haskell %}
-- | Extract the first element of a list, which must be non-empty.
head                    :: [a] -> a
head (x:_)              =  x
head []                 =  badHead
{-# NOINLINE [1] head #-}

badHead :: a
badHead = errorEmptyList "head"

-- | Extract the elements after the head of a list, which must be non-empty.
tail                    :: [a] -> [a]
tail (_:xs)             =  xs
tail []                 =  errorEmptyList "tail"

-- | Extract the last element of a list, which must be finite and non-empty.
last                    :: [a] -> a
#ifdef USE_REPORT_PRELUDE
last [x]                =  x
last (_:xs)             =  last xs
last []                 =  errorEmptyList "last"
#else
-- eliminate repeated cases
last []                 =  errorEmptyList "last"
last (x:xs)             =  last' x xs
  where last' y []     = y
        last' _ (y:ys) = last' y ys
#endif

-- | Return all the elements of a list except the last one.
-- The list must be non-empty.
init                    :: [a] -> [a]
#ifdef USE_REPORT_PRELUDE
init [x]                =  []
init (x:xs)             =  x : init xs
init []                 =  errorEmptyList "init"
#else
-- eliminate repeated cases
init []                 =  errorEmptyList "init"
init (x:xs)             =  init' x xs
  where init' _ []     = []
        init' y (z:zs) = y : init' z zs
#endif
{% endhighlight %}

(`badHead` だけ浮いてる気がするが……)

今回はここまで．
