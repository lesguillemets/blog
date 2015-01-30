---
layout: post
title:  "Haskell: type と typeclass を作る (2)"
date:  2014-10-05 15:00:00 UTC+9
categories: haskell
license: "by-nc-sa"
---

[前回]({{site.baseurl}}/2014/10/02/learnyouahaskell-making-our-own-types-and-typeclasses.html)の続き．

[Learn You a Haskell for Great Good!](http://learnyouahaskell.com/) の Chapter 8, [Making Our Own Types and Typeclasses](http://learnyouahaskell.com/making-our-own-types-and-typeclasses) を元にしたものです．基本的には翻訳のつもりですが，省略や加筆が勝手に入ることもあります．原文は [CC-BY-NC-SA](http://creativecommons.org/licenses/by-nc-sa/3.0/) でライセンスされており，この文書もそれに従います．

---

## Record syntax

例えば人に関する data type を作るとしよう．
first name, last name, 年齢，身長，電話番号，それに好きなアイスクリームのフレーバーを記録したいとする．

こんな感じで出来るよね

{% highlight haskell %}
data Person = Person String String Int Float String String deriving (Show)
{% endhighlight %}

フムー．ちょっと読みづらい．それにもしそれぞれの値にアクセスしようとすると

{% highlight haskell %}
firstName :: Person -> String
firstName ( Person firstname _ _ _ _ _ ) = firstname

lastName :: Person -> String
lastName ( Person _ lastname _ _ _ _ ) = lastname

age :: Person -> Int
age ( Person _ _ age _ _ _ ) = age

height :: Person -> Float
height ( Person _ _ _ height _ _ ) = height

phoneNumber :: Person -> String
phoneNumber ( Person _ _ _ _ number _ ) = number

flavor :: Person -> String
flavor ( Person _ _ _ _ _ flavor) = flavor
{% endhighlight %}

かなり辛いけど，一応動く

{% highlight haskell %}
ghci> let guy = Person "Buddy" "Finklestein" 43 184.2 "526-2928" "Chocolate"
ghci> firstName guy
"Buddy"
ghci> height guy
184.2
ghci> flavor guy
"Chocolate"
{% endhighlight %}

もっといいやり方があるはず，と思うよね．無いんだ，ごめんね．

……

というのは冗談，Haskell を作った人たちは賢くてこうなることを予想していた．
こういう記法が用意されている[^comma]

{% highlight haskell %}
data Person = Person {
  firstName :: String,
  lastName :: String,
  age :: Int,
  height :: Float,
  phoneNumber :: String,
  flavor :: String
} deriving (Show)
{% endhighlight %}

スペースで型を書き並べる代わりに curly bracket を使う．field の名前， `::` (Paamayim Nekudotayim ともいう (haha)[^pn])，そして type を書く．
結果として作られる data type は一緒で，ただしこっちの record syntax を使った場合には，自動的に getter みたいな函数が作られる．
この場合は `firstName`, `lastName`, `age`, `height`, `phoneNumber`, `flavor` が作られている．

{% highlight haskell %}
ghci> :t flavor
flavor :: Person -> String
ghci> :t firstName
firstName :: Person -> String
{% endhighlight %}

使い方は最初に定義した時のような書き方の他に，

{% highlight haskell %}
Person { firstName = "Foo", lastName = "Bar", height=3.2, -- ...
{% endhighlight %}

と同じような syntax でもよい（この時順番はどうでも大丈夫）．

なお，こちらの書き方だと `Show` を derive するときには大分出力がファンシーになる．

{% highlight haskell %}
data Car = Car String String Int deriving (Show)
ghci> Car "Ford" "Mustang" 1967
-- Car "Ford" "Mustang" 1967

data Car = Car {company :: String, model :: String, year :: Int} deriving (Show)
ghci> Car {company="Ford", model="Mustang", year=1967}
-- Car {company = "Ford", model = "Mustang", year = 1967}
{% endhighlight %}

`Int` とか型だけ言われてもどれがどれかわからないぜ！みたいなときには使うといいとおもいます．

---

次が Type parameters の話なのでここで切ります．

---

[第1回]({{site.baseurl}}/2014/10/02/learnyouahaskell-making-our-own-types-and-typeclasses.html)
/ [第2回（これ）]({{site.baseurl}}/2014/10/05/learnyouahaskell-making-our-own-types-and-typeclasses-2.html)
/ [次回]({{site.baseurl}}/2014/10/08/learnyouahaskell-making-our-own-types-and-typeclasses-3.html)
/ [第4回]({{site.baseurl}}/2014/11/10/learnyouahaskell-making-our-own-types-and-typeclasses-4.html)
/ [第5回]({{site.baseurl}}/2015/01/29/learnyouahaskell-making-our-own-types-and-typeclasses-5.html)

[^comma]: 原文ではコンマが行の頭に来るやつで，僕はあれは嫌いなのでこっちにした．確かに最後のコンマがあるとエラー吐くやつでは新しい行を足すのには行頭コンマのほうが楽なのはわかるけれども．
[^pn]: 冗談かと思ったら php とかでは[ほんとにそういうことがあるらしい](https://en.wikipedia.org/wiki/Scope_resolution_operator#PHP)．
