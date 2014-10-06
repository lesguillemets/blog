---
layout: post
title:  "Haskell: type と typeclass を作る (3)"
date:  2014-10-07 15:00:00 UTC+9
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


[^rem_0]: `:t Just 't'` とかを思い出してみよう．
