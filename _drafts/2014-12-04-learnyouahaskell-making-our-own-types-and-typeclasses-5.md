---
layout: post
title:  "Haskell: type と typeclass を作る (5)"
date:  2014-12-14 12:00:00 UTC+9
categories: haskell
license: "by-nc-sa"
---

[前回]({{site.baseurl}}/2014/11/10/learnyouahaskell-making-our-own-types-and-typeclasses-4.html)の続き．

[Learn You a Haskell for Great Good!](http://learnyouahaskell.com/) の Chapter 8, [Making Our Own Types and Typeclasses](http://learnyouahaskell.com/making-our-own-types-and-typeclasses) を元にしたものです．基本的には翻訳のつもりですが，省略や加筆が勝手に入ることもあります．原文は [CC-BY-NC-SA](http://creativecommons.org/licenses/by-nc-sa/3.0/) でライセンスされており，この文書もそれに従います．


今回は Type synonyms から．

---

## Type synonyms

`[Char]` と `String` って一緒で interchangeable じゃん，`String` があるのはそのほうが見やすい/意味が通りやすいから．たとえば
`toUpperString :: [Char] -> [Char]` よりは `String -> String` のほうがわかりやすいでしょ．
これはこういう感じで実現されている

{% highlight haskell %}
type String = [Char]
{% endhighlight %}

それから電話帳なんかも，この本の前のところでは

{% highlight haskell %}
phoneBook :: [(String, String)]
phoneBook =
        [
        ("Betty", "000-0000"),
        ("Richard", "111-1111")
        ]
{% endhighlight %}
こんな感じで書いてたけど `phoneBook :: [(String, String)]` では紛らわしい．

そこで

{% highlight haskell %}
type PhoneNumber = String
type Name = String type PhoneBook = [(Name, PhoneNumber)]
{% endhighlight %}

とするとわかりやすいし `phoneBook :: PhoneBook` と出来て幸せだ．

因みに，この `type synonym` は本当に synonym なので，例えば `s::PhoneNumber` と `t::String` とを `(++)` で繋げたりするのは通る．

さて，この type synonym は例によって引数とるようにできて，
例えばこうだ

{% highlight haskell %}
type AssociationList k v = [(k,v)]
{% endhighlight %}

こうすると例えば getItem みたいな函数は
`(Eq k) => l -> AssociationList k v -> Maybe v` みたいな型を持つことになる  ．

実際の値が持つ型は `AssociationList String Int` みたいな感じ．
わかりやすそうだ．

因みにこういう芸当も可能

{% highlight haskell %}
type IntMap v = Map Int v
{% endhighlight %}
