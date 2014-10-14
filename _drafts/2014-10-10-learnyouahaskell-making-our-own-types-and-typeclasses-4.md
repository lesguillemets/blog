---
layout: post
title:  "Haskell: type と typeclass を作る (3)"
date:  2014-10-08 15:00:00 UTC+9
categories: haskell
license: "by-nc-sa"
---

[前回]({{site.baseurl}}/2014/10/08/learnyouahaskell-making-our-own-types-and-typeclasses-3.html)の続き．

[Learn You a Haskell for Great Good!](http://learnyouahaskell.com/) の Chapter 8, [Making Our Own Types and Typeclasses](http://learnyouahaskell.com/making-our-own-types-and-typeclasses) を元にしたものです．基本的には翻訳のつもりですが，省略や加筆が勝手に入ることもあります．原文は [CC-BY-NC-SA](http://creativecommons.org/licenses/by-nc-sa/3.0/) でライセンスされており，この文書もそれに従います．


今回は Derived instances から．

---

## Derived instances

[以前](http://learnyouahaskell.com/types-and-typeclasses#typeclasses-101) に typeclass の基本についてはやりました．
Typeclass は何らかの挙動を規定する interface のようなもの，という話でしたね．例えば `Int` が `Eq` typeclass の instance で，

