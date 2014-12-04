---
layout: post
title:  "Haskell: type と typeclass を作る (4)"
date:  2014-11-10 15:00:00 UTC+9
categories: haskell
license: "by-nc-sa"
---

[前回]({{site.baseurl}}/2014/10/08/learnyouahaskell-making-our-own-types-and-typeclasses-3.html)の続き．

[Learn You a Haskell for Great Good!](http://learnyouahaskell.com/) の Chapter 8, [Making Our Own Types and Typeclasses](http://learnyouahaskell.com/making-our-own-types-and-typeclasses) を元にしたものです．基本的には翻訳のつもりですが，省略や加筆が勝手に入ることもあります．原文は [CC-BY-NC-SA](http://creativecommons.org/licenses/by-nc-sa/3.0/) でライセンスされており，この文書もそれに従います．


今回は Derived instances から．

---

## Derived instances

[以前](http://learnyouahaskell.com/types-and-typeclasses#typeclasses-101) に (訳してないけど) typeclass の基本についてはやった．
Typeclass は何らかの挙動を規定する interface のようなもの，という話でしたね．
例えば `Int` が `Eq` typeclass の instance で，それは `Eq` が等値かどうかを判断できるものについて behaviour を定義するものだから，というわけ．
便利さは `Eq` の interface として働く函数，つまるところ `==` と `/=` とともにもたらされる．
ある型が `Eq` typeclass の中にあるなら `==` とか を使えて，こうして `4 == 4`とか `"foo" /= "bar"` が型検査を通る．

もうひとつ書いてあったのは，Python や Java, C++ などの class とはずいぶん違うもので，haskell では typeclass から data を作ったりはしない．まず data type を作って，それからそれがどのように振る舞えるかを考えるという流れになる．
ははあ等値性を比べられるな，と思ったら `Eq` typeclass の instance にするし，順序の入るものであれば `Ord` typeclass の instance にするわけだ．

Typeclass によって定義される函数を実装して type を typeclass の instance にするのはどーするの，ってのは後でやるとして，とりあえず haskell が勝手にやってくれるのを見てみよう．
`deriving` を使えば，`Eq`, `Ord`, `Enum`, `Bounded`, `Show`, `Read` あたりはよしなにやってくれます．

{% highlight haskell %}
data Person = Person {
                firstName :: String,
                lastName :: String,
                age :: Int
            } deriving (Eq)
{% endhighlight %}

こうすると (各 field の型が全部 `Eq` じゃないといけないが) constructor のそれぞれが合ってるかどうかをチェックしてくれる．

{% highlight haskell %}
ghci> let mikeD = Person {firstName = "Michael", lastName = "Diamond", age = 43}
ghci> let adRock = Person {firstName = "Adam", lastName = "Horovitz", age = 41}
ghci> let mca = Person {firstName = "Adam", lastName = "Yauch", age = 44}  
ghci> mca == adRock
False
ghci> mikeD == adRock
False
ghci> mikeD == mikeD
True
ghci> mikeD == Person {firstName = "Michael", lastName = "Diamond", age = 43}
True
{% endhighlight %}

いまや `Eq` 配下なので `Eq a` という constraint のあるやつは使えるようになる． `elem` とかもね．

あとは `Show` とか `Read` とか `Read` とかの話が出ておしまい．

このあとは `type` で作れる synonym とかの話になるが，typeclasses 102 まで飛ばす予定．
