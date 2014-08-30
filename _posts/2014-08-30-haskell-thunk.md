---
layout: post
title:  "Haskell : thunk とは"
date:  2014-08-30 00:00:00 UTC+9
categories: haskell
---

Haskell で例えば [atcoder](http://atcoder.jp/) の問題を解くときに，漠然と解くと遅延された評価が溜まりに溜まって stack overflow 的なアレを起こして悲しみがある．
最近急速に “Haskell こわくないよ” 感を感じ始めていて，お絵かきとかもしてみたいのだが，その準備として haskell の中の正格性を少しは使えるようになっておきたい．その準備として [Thunk - HaskellWiki](http://www.haskell.org/haskellwiki/Thunk)[^hwlicense] を元に thunk について．翻訳というにはちょっと色々手を加えてます．

## Thunk

というのは **まだ評価されていない値** のこと[^thunk]．
Haskell では non-strict な[^nonstrict] semantics と lazy evaluation を使うのでよく出てくる．
内部では (tree でなく) graph に変換されて，STG (Spinless Tagless G-machine) がさらにぷちぷちやっていくということらしいけれど，それはまあよい．不必要な thunk は評価されないままもぎ取られるんだそうだ．

### なにが便利なの？

要するに「評価しなくていいならほっとこうぜ」ができる．例えば `(&&)` について

{% highlight haskell %}
False && _ = False
True && x = x
{% endhighlight %}

前が `False` なら二個目の値は何であろうと問答無用だし，前が `True` の時も別に必要ないから二個目の `x` をわざわざ評価したりしない．
Naïve ながら直観的においしいのはたとえば（実際にはこんな書き方しないだろうけど），

{% highlight haskell %}
-- the non-trivial factors are those who divide the number so no remainder
factors n = filter (\m -> n `mod` m == 0) [2 .. (n - 1)]
-- a number is a prime if it has no non-trivial factors
isPrime n = n > 1 && null (factors n)
{% endhighlight %}

と書いたら非素数について factor を見つけた段階で評価が終了するよ，ということがある．

### なにが不便なの？

`fold` を習うときに必ず出てくるだろう例[^sof]

{% highlight haskell %}
foldl (+) 0 [1,2,3]
==> foldl (+) (0 + 1) [2,3]
==> foldl (+) ((0 + 1) + 2) [3]
==> foldl (+) (((0 + 1) + 2) + 3) []
==> ((0 + 1) + 2) + 3
==> (1 + 2) + 3
==> 3 + 3
==> 6
{% endhighlight %}

うーん，でもこれ `((0+1)+2)` とかって先に計算しとけるよね？っていうときは `foldl’` を使いましょう．[ソースを見る](http://hackage.haskell.org/package/base-4.7.0.1/docs/src/Data-List.html#foldl%27)と

{% highlight haskell %}
-- | A strict version of 'foldl'.
foldl'           :: (b -> a -> b) -> b -> [a] -> b
foldl' f z0 xs0 = lgo z0 xs0
    where lgo z []     = z
          lgo z (x:xs) = let z' = f z x in z' `seq` lgo z' xs
{% endhighlight %}

この `seq` は正格評価のところで使いどころのある関数のようで，このあたりのことや，あれでも `foldl` って末尾再帰になってるのでは，とかそういう話を学んでいきたい．

ついでだから復習しよう． `foldr` だとこういう感じになる

{% highlight haskell %}
foldr (+) 0 [1,2,3]
==> 1 + (foldr (+) 0 [2,3])
==> 1 + (2 + foldr (+) 0 [3])
==> 1 + (2 + (3 + foldr (+) 0 []))
==> 1 + (2 + (3 + 0))
==> 1 + (2 + 3)
==> 1 + 5
==> 6
{% endhighlight %}

この辺のことは [wikibooks](http://en.wikibooks.org/wiki/Haskell/List_processing) とかもいいですね．

[^hwlicense]: 2006年辺り以降の投稿分は[非常に permittive なライセンスで公開されている](http://www.haskell.org/haskellwiki/HaskellWiki:Copyrights)
[^nonstrict]: ‘subexpression’ の中に値が決まらないものがあっても expression が値を持てる，みたいな話らしい．`noreturn x = negate (noreturn x)` とした時に `nonreturn 3` の値は定まらないが，`elem 2 [2,3,nonreturn 5]` は `True` と評価される，という例が [挙がっている](http://www.haskell.org/haskellwiki/Non-strict_semantics)．この文脈で出てくる ⊥ という記号，Gray code で bottom と言われて使ってるもののはずで，なるほどこういうところでも使うのかという感じだ．
[^thunk]: Wikipedia にも [項目](https://en.wikipedia.org/wiki/thunk) があり，特に haskell の用語というわけではないようだ．
[^sof]: ちなみに `ghci` とか `runghc` でやると下手をすると節操無くメモリを食い続けて周りを巻き込んで死亡みたいなことがありえるから気をつける
