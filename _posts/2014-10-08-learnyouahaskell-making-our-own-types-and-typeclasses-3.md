---
layout: post
title:  "Haskell: type と typeclass を作る (3)"
date:  2014-10-08 15:00:00 UTC+9
categories: haskell
license: "by-nc-sa"
---

[前回]({{site.baseurl}}/2014/10/05/learnyouahaskell-making-our-own-types-and-typeclasses-2.html)の続き．

[Learn You a Haskell for Great Good!](http://learnyouahaskell.com/) の Chapter 8, [Making Our Own Types and Typeclasses](http://learnyouahaskell.com/making-our-own-types-and-typeclasses) を元にしたものです．基本的には翻訳のつもりですが，省略や加筆が勝手に入ることもあります．原文は [CC-BY-NC-SA](http://creativecommons.org/licenses/by-nc-sa/3.0/) でライセンスされており，この文書もそれに従います．

今回は Type parameters から．

---

## Type parameters

Value constructor がパラメータをとって value を作るように，types -> types が type constructors.
ちょっとメタすぎるように感じるかもしれないがそんなに複雑じゃない．
C++ の template と似てるらしいけど， C++ 知らないのでアレですね，アレ．

じつはすでに知り合いだったりするのだ

{% highlight haskell %}
data Maybe a = Nothing | Just a
{% endhighlight %}

ここで a に入るのは type parameter[^rem_0]．そこで `Maybe` を type constructor
といい，結局型としては `Maybe Int` とかそういう感じになる．
それ自身では型ではないから，`Maybe` 型を持つ値などといったものは存在しない．

`Maybe` なんていうと上段に構えた感じだけど実は list もそうで，型として存在するのは `[Int]` だったり `[Char]` だったりするけど，
`[]` 型の値，というものは存在しないというわけだ．

`Maybe` についてしばらく遊んでみよう．`:t Just "hi"` は `Maybe [Char]`,
こういうのはいいけど，`Nothing` も型が `Maybe a` なのに注意しよう．
`:t head [Nothing, Just 'a']` とかやってみるとわかりやすいかもしれない．
これは polymorphic で，`Maybe Int` がほしい時にも `Maybe Char` がほしい時にも
与えられるってわけだ．`[1,2,3] ++ []` とか `"hi" + []` とかが
できるのも同じ理屈．

さて，カッコいいからと言って何でもこれ使ったらいいかというと勿論そういうわけではなく，
普通は折角 type parameter 使ってもまあ結局 `String` が入ってないと役に立たん，みたいなことになるので，
そういう場合に使ってもあまり意味はない．効力を発揮するのはまさに「何の型でもいいからこれとこれ」みたいな奴の時で，
list とか `Maybe` とかはまさにそういう場合にあたる．

もうひとつのそういう例は `Data.Map` の `Map k v`. `k` が keys で `v` が value というやつですね．
こういうかんじでつかう

{% highlight haskell %}
Prelude Data.Map> :t fromList [("foo",3), ("bar",6)]
fromList [("foo",3), ("bar",6)] :: Num a => Map [Char] a
{% endhighlight %}

これは (`k` は `Ord` じゃないとだめだけど） `k`, `v` がそれぞれ何でもよくて，まさに type parameters の出番という感じだ．

ところで，この `Map` を作りたいと思ったらこういう感じで constraint をつけたりしたくなる[^ffp]かもしれない

{% highlight haskell %}
data (Ord k) => Map k v ...
{% endhighlight %}

ところが，**決して data 宣言に type constraints を加えない** というのが非常に強い慣習となっている．
なぜか．それは，結局対して得をしないばかりか，必要のないところにまで type constraints を書きまくる羽目になるから．
例えば，さっき出てきた `Data.Map` の `toList` の型はこんな感じになっている．

{% highlight haskell %}
toList :: Map k a -> [(k,a)]
{% endhighlight %}

ところが `data (Ord k) => Map k v` と書いているとここにも `Ord` じゃないと行けなさがにじみでてくるから，こう書かないといけなくなる．

{% highlight haskell %}
toList :: (Ord k) -> Map k a -> [(k,a)]
{% endhighlight %}

べつにこの函数に `Ord` さは必要ないのに，これはちょっと嫌だなーってことで[^foom]，そういうのは書かないようにしましょうということだ．

---

というわけで，練習問題的に三次元ベクトルを書いてみよう．`Num` のなかの色々に対応できるように書いてみる．

{% highlight haskell %}
data Vector a = Vector a a a deriving (Show)

vplus :: (Num t) => Vector t -> Vector t -> Vector t
(Vector x0 y0 z0) `vplus` (Vector x1 y1 z1) = Vector (x0+x1) (y0+y1) (z0+z1)

vectmult :: (Num t) => Vector t -> t -> Vector t
vectmult (Vector x y z) a = Vector (a*x) (a*y) (a*z)

innerProd :: (Num t) => Vector t -> Vector t -> t
(Vector x0 y0 z0) `innerProd` (Vector x1 y1 z1) = x0*x1 + y0*y1 + z0*z1
{% endhighlight %}

例によって `Vector a` が型，`Vector 3 2.3 4` は値なので型に `Vector a a a` などと書かないように気をつけましょう．

というわけで一旦ここまで．

--- 

[第1回]({{site.baseurl}}/2014/10/02/learnyouahaskell-making-our-own-types-and-typeclasses.html)
/[第2回]({{site.baseurl}}/2014/10/05/learnyouahaskell-making-our-own-types-and-typeclasses-2.html)
/[今回]({{site.baseurl}}/2014/10/08/learnyouahaskell-making-our-own-types-and-typeclasses-3.html)
/[第4回]({{site.baseurl}}/2014/11/10/learnyouahaskell-making-our-own-types-and-typeclasses-4.html)
/[第5回]({{site.baseurl}}/2015/01/29/learnyouahaskell-making-our-own-types-and-typeclasses-5.html)

[^rem_0]: `:t Just 't'` とかを思い出してみよう．
[^ffp]: そもそもこういう書き方出来るんですね? …とおもったら最近のは無理？[Haskell-cafe : Why were datatype contexts removed instead of "fixing them"?](https://groups.google.com/d/msg/haskell-cafe/4G4cSdyEGdE/yMofd2qIe0gJ) というのがあり，それっぽい書き方は ghcmod で `Illegal datatype context (use -XDatatypeContexts): Ord k =>` といわれたりする．
[^foom]: ちょっとふーむという感じだが．
