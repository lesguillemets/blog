---
layout: post
title:  "Haskellのunfoldr用例収集"
date:  2015-08-10 12:00:00 UTC+9
categories: haskell
---

Haskellの`Data.List` には [`unfoldr`](http://hackage.haskell.org/package/base-4.8.1.0/docs/Data-List.html#v:unfoldr) というものが定義されている．
[Haskell競技プログラミング入門 - Qiita](http://qiita.com/myuon_myon/items/ad006568bd187223f494)ではDPなどにおすすめという感じなのだけれど，
これはちょっとなじまないと使いにくいやつかも知れないということで，用例をいくつか集めてみた．全然使わない→濫用する→いい感じに落ち着く，の流れが今から見えるようだ．

### ドキュメント

何はともあれドキュメントを見てみましょう．

型

{% highlight haskell %}
unfoldr :: (b -> Maybe (a, b)) -> b -> [a] 
{% endhighlight %}

ふむふむ？

> The `unfoldr` function is a “dual” to `foldr:` while `foldr` reduces a list to a summary value, `unfoldr` builds a list from a seed value.
> The function takes the element and returns `Nothing` if it is done producing the list or returns `Just (a,b)`, in which case,
> `a` is a prepended to the list and `b` is used as the next element in a recursive call.

つまり，`foldr` の双対<small>(でいいのかな)</small> として定義されていて，動きとしてはこう：

* `f :: b -> Maybe (a,b)` と始める値を受け取って再帰的に動く．
* `Nothing` が返ればそこで終わり
* `Just (a,b)` が返ってきたらリストに `a` を足して，次は `f` を `b` に適用してすすめる．

あ，これ前からしたかったやつだ！！ Run-length encoding とか書く時にこういうのが欲しかった憶えがありますね．

ここには例としてこれが挙がっています：

{% highlight haskell %}
iterate f == unfoldr (\x -> Just (x, f x))
{% endhighlight %}

Nothing が返ってくることはないので無限リストができることになります．

さらに

{% highlight haskell %}
unfoldr (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
-- [10,9,8,7,6,5,4,3,2,1]
{% endhighlight %}

### 用例

[Collatz sequence](https://en.wikipedia.org/wiki/Collatz_conjecture#Examples) とか綺麗に書けそうですね：

{% highlight haskell %}
collatz = unfoldr f where
    f 0 = Nothing
    f 1 = Just (1,0)
    f x
        | even x = Just (x, x`div`2)
        | otherwise = Just (x, x*3 +1)
-- collatz 19
-- [19,58,29,88,44,22,11,34,17,52,26,13,40,20,10,5,16,8,4,2,1]
{% endhighlight %}

陽に再帰で書くのとどちらが綺麗か問題．

Run-length encoding （の一歩手前）

{% highlight haskell %}
runLength :: (Eq a) => [a] -> [(a,Int)]
runLength = unfoldr f where
    f [] = Nothing
    f (x:xs) = let (pre,post) = span (== x) xs
                     in Just ((x,length pre +1), post)
-- runLength "aaabaabbbcd"
-- [('a',3),('b',1),('a',2),('b',3),('c',1),('d',1)]
{% endhighlight %}

[Round 1A (Google Code Jam 2009) - 落書き、時々落学](http://d.hatena.ne.jp/jeneshicc/20090914/1252943600)にある例

{% highlight haskell %}
expand :: Integral a => a -> a -> [a]
expand b = reverse.unfoldr f
    where f 0 = Nothing
          f x = let (q,r) = divMod x b
                 in Just (r,q)
-- expand 10 8223424
-- [8,2,2,3,4,2,4]
-- expand 2 68
-- [1,0,0,0,1,0,0]
{% endhighlight %}

これは整数を`n`進で展開するものですね．


同じく [Problem 102 - 落書き、時々落学](http://d.hatena.ne.jp/jeneshicc/20081123/1227446858)から若干改変，
これはリストで与えられた要素を2つづつ組にするもの．奇数個の時は最後を無視するようにしました．

{% highlight haskell %}
toTuples :: [a] -> [(a, a)]
toTuples = unfoldr t
    where t [] = Nothing
          t [_] = Nothing
          t (x:y:zs) = Just ((x,y),zs)
{% endhighlight %}


これは少し変わった例で，[ちょっと変わったリストのトラバースはunfoldrでできる - 取り急ぎブログです](http://d.hatena.ne.jp/Otter_O/20080225/1203923543) から．

{% highlight haskell %}
takeLess :: (Int, [a]) -> Maybe ([a], (Int, [a]))
takeLess (0,_) = Nothing
takeLess (_,[]) = Nothing
takeLess (a,xs) = Just (x, (a-1,xs')) where
    (x,xs') = splitAt a xs
--  unfoldr takeLess (5,[1..20])
-- [[1,2,3,4,5],[6,7,8,9],[10,11,12],[13,14],[15]]
{% endhighlight %}

ふむふむ．

----

[Blow your mind - HaskellWiki](https://wiki.haskell.org/Blow_your_mind) には変なのを含めいろんな用例があります．

`words` の書き換えとして

{% highlight haskell %}
unfoldr (\b -> fmap (const . (second $ drop 1) . break (==' ') $ b) . listToMaybe $ b)
{% endhighlight %}

`second` は `Control.Arrow.second`. パッと見相当 tricky なんですが実情はそこまででもありません．`listToMaybe` と `fmap`
は組み合わせて空文字列の検査に使われていて（`null` と `guard` とか使っても良さそう），その過程で入る `Just (head b)` を無視するのに
`const` が入ってるので，そのへんを書き下して，ついでに見やすいようにλに名前をつけるとこうなる

{% highlight haskell %}
words' = unfoldr f where
    f "" = Nothing
    f b = Just . second (drop 1) . break (== ' ') $ b
{% endhighlight %}

`break (== ' ') "hi there"` が `("hi", " there")` になるので `second (drop 1)` で空白を落として `unfoldr` に渡しているわけですね．
`unfoldr` では tuple の扱いが多いので，`Control.Arrow`とかと仲良さそうな予感もあります．


続いてはリストを`N`個ごとに切り分ける函数．なぜか（？）`Data.List`とかに入ってなくて何回も手書きした覚えがあります．

{% highlight haskell %}
  -- "1234567" -> ["12", "34", "56", "7"]
unfoldr (\a -> toMaybe (not $ null a) (splitAt 2 a))
-- あるいは
takeWhile (not . null) . unfoldr (Just . splitAt 2)
{% endhighlight %}

ただし

{% highlight haskell %}
toMaybe b x = if b then Just x else Nothing
{% endhighlight %}

----

うまくやれば色々をかなりスッキリ書けそうな予感．`foldr` の双対というのにも気をつけて，使っていきたいですね．
