---
layout: post
title:  "Haskell: type と typeclass を作る"
date: 2014-10-02 15:00:00 UTC+9
categories: haskell
license: "by-nc-sa"
---

よく「えっとどうだっけ」ってなるので，何回かに分けて書いて整理しようと思います．

以下は，[Learn You a Haskell for Great Good!](http://learnyouahaskell.com/) の Chapter 8, [Making Our Own Types and Typeclasses](http://learnyouahaskell.com/making-our-own-types-and-typeclasses) を元にしたものです．基本的には翻訳のつもりですが，省略や加筆が勝手に入ることもあります．原文は [CC-BY-NC-SA](http://creativecommons.org/licenses/by-nc-sa/3.0/) でライセンスされており，この文書もそれに従います．

## Algebraics data types

ここまで，いろんな data type を見てきた．例えば `Bool`, `Int`, `Char`, `Maybe` とかがあったよね．じゃあ自分で作るときはどうしたらいいんだろう．
ひとつのやり方は keyword になっている `data` を使うことだ．例えば `Bool` が標準ライブラリでどのように定義されているかを見てみよう．

{% highlight haskell %}
data Bool = False | True
{% endhighlight %}

`data` ってのは新しい data type を作ってるよってこと． `=` の前の部分が type を表してて，この場合は `Bool` だ．
`=` の後の部分が  **value constructors**. ここではこの type が持ちうる値を規定している． `|` は「または」と読んでいい．
だから全体ではこうなる：`Bool` type は `False` か `True` の値を持てる[^bool-succ]．type の名前と value constructor は両方大文字で始まっている必要がある．

同じように， `Int` という type はこういうふうに定義されてると考えることができる．

{% highlight haskell %}
data Int = -2147483648 | -2147483647 | ... | -1 | 0 | 1 | 2 | ... | 2147483647
{% endhighlight %}

`-2147483648`, `2147483647` が上限と下限，足したり引いたりすると循環する(`succ` は Exception)．
実際にはこうなってるわけではないけど，まあ，という感じだ．

さて，Haskell で単純な図形をどう表現するか考えてみよう．tuple を遣うのはひとつの手で，例えば円なら `(43.1, 55.0, 10.4)`
という感じで `(x,y,r)` で表すことが出来る．悪くなさそうだけど，単なる数の三つ組なら3次元ベクトルかもしれないし，他のあらゆるものと区別がつかない．
そこで自分で type をつくろうという話になるわけだ．円か長方形なら，こういう感じ

{% highlight haskell %}
data Shape = Circle Float Float Float | Rect Float Float Float
{% endhighlight %}

ここまで書けば，ghci で

{% highlight haskell %}
Prelude> data Shape = Circle Float Float Float | Rect Float Float Float Float
Prelude> :t Circle
Circle :: Float -> Float -> Float -> Shape
Prelude> :t Rect
Rect:: Float -> Float -> Float -> Float -> Shape
{% endhighlight %}

なるほどなるほど，value constructor はこれもまた function なわけね．なかなか．

では `shape` を受け取ってその面積を求める函数を書いてみよう:

{% highlight haskell %}
surface :: Shape -> Float
surface Circle (_ _ r) = pi * r^2
surface Rect (x0 y0 x1 y1) = abs $ (x0-x1) * (y0-y1)
{% endhighlight %}

pattern match 出来るんだ！すごい！……凄いんだけど，実はこれはしょっちゅうやってきたことで，`False` とか `5` とか `[]` とか，
全部たまたま field を持たなかっただけで，結局は一緒なんだ．

気をつけるべきは `Circle -> Float` とかは書けないこと． `Circle` は type じゃない．丁度 `True -> Float` がかけないようなものだ．
この type と constructor の違いは多分こまめに意識しといたほうがいい．

ところで，このままでは `ghci` で `Circle 3 3 4` とかやった時に不便だから，こうするといい感じ．

{% highlight haskell %}
data Shape = Circle Float Float Float | Rect Float Float Float Float deriving (Show)
{% endhighlight %}

これで `show` を使えるし， `ghci` でも

{% highlight haskell %}
Prelude> Circle 4 4 45
Circle 4.0 4.0 45.0
{% endhighlight %}

ふむふむ．

---

なかなかいい感じだけど，ちょっと改善できそうなところもある．例えば今円は `(x,y,r)` で表してるけど，`( (x,y), r)` みたいな方が把握しやすい．

{% highlight haskell %}
data Point = Point Float Float deriving (Show)
data Shape = Circle Point Float | Rect Point Point deriving (Show)
{% endhighlight %}

ここで `data Point = Point Float Float` と， value constructor と data type の名前に同じものを使ったが，
これは別にそうである必要はない．ただ constructor が1種類しかない場合はそうするのが慣例ということだ．

こうすると `surface` は

{% highlight haskell %}
surface :: Shape -> Float
surface (Circle _ r) = pi*r*r
surface (Rect (Point x0 y0) (Point x1 y1)) = abs $ (x0-x1) * (y0-y1)
{% endhighlight %}

同じ感じで図形を動かす `nudge` と原点にものを作る `baseCircle :: Float->Shape`, 同様な `baseRect` が定義できる．

これらをモジュール化するならこう：

{% highlight haskell  %}
module Shapes
( Point(..)
, Shape(..)
, surface
, nudge
, baseCircle
, baseRect
) where
{% endhighlight %}

ここで たとえば `Shape(...)` を単に `Shape` と書けば import したひとは constructor を使えなくなり，
補助函数 `baseCircle` と `nudge` であれこれするようになる．プライベートなアレっちゅうこっちゃな．

…ということで長くなったので今日はここまで．

* [次]({{site.baseurl}}/2014/10/05/learnyouahaskell-making-our-own-types-and-typeclasses-2.html)
* [3回目]({{site.baseurl}}/2014/10/08/learnyouahaskell-making-our-own-types-and-typeclasses-3.html)

[^bool-succ]: この順になっているから `succ False` は `True` を返すけど，`succ True` は Exception.
