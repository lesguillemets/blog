---
layout: post
title:  "lh"
date: 2014-08-05 17:25:13 UTC+9
categories: 
---

以下は，[Learn You a Haskell for Great Good!](http://learnyouahaskell.com/) の Chapter 8, [Making Our Own Types and Typeclasses](http://learnyouahaskell.com/making-our-own-types-and-typeclasses) を元にしたものです．基本的には翻訳のつもりですが，省略や加筆が勝手に入ることもあります．原文は [CC-BY-NC-SA](http://creativecommons.org/licenses/by-nc-sa/3.0/) でライセンスされており，この文書もそれに従います．

## 代数的データタイプ

ここまで，いろんな data type を見てきた．例えば `Bool`, `Int`, `Char`, `Maybe` とかがあったよね．じゃあ自分で作るときはどうしたらいいんだろう．
ひとつのやり方は keyword になっている `data` を使うことだ．例えば `Bool` が標準ライブラリでどのように定義されているかを見てみよう．

{% highlight haskell %}
data Bool = False | True
{% endhighlight %}

`data` ってのは新しい data type を作ってるよってこと． `=` の前の部分が `type` を表してて，この場合は `Bool` だ．
`=` の後の部分が  **value constructors**. ここではこの type が持ちうる値を規定している． `|` は「または」と読んでいい．
だから全体ではこうなる：`Bool` type は `True` か `False` の値を持てる．type の名前と value constructor は両方大文字で始まっている必要がある．

同じように， `Int` という type はこういうふうに定義されてると考えることができる．

{% highlight haskell %}
data Int = -2147483648 | -2147483647 | ... | -1 | 0 | 1 | 2 | ... | 2147483647
{% endhighlight %}
