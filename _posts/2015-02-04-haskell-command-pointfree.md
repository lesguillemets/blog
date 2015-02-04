---
layout: post
title:  "Haskell の函数を pointfree にするコマンド pointfree"
date: 2015-02-04 00:00:00 UTC+9
categories: haskell
---

もう closed になっているが，Stackoverflow に投稿された
[sof](http://stackoverflow.com/users/363663/sof) 氏による[質問](http://stackoverflow.com/questions/28130574):

> Haskell で，楽で正確に，函数を point free な形にできるやり方を探している．
> Readable な結果を得られるものがいい．どうするのがいいだろうか？

[Jamshidh](http://stackoverflow.com/users/2827654/jamshidh) による回答:

> "pointfree" っていうプログラムがある．
>{% highlight bash %} cabal install pointfree {% endhighlight %}
> でインストールして，
> {% highlight bash %}
$ pointfree "\x -> x+1"
 (1 +){% endhighlight %}
> 警告：すごくいい感じに pointfree になることもあるけど，かなり scary な結果になることもある…

なるほど．

いろいろ試してみよう

{% highlight bash %}
$ pointfree "\x y -> x y"
id
$ pointfree "\x y -> f (g x y)"
(f .) . g
$ pointfree "\f (x,y) -> f x y"
(`ap` snd) . (. fst)
$ pointfree "\(a,b) -> (b,a)"
uncurry (flip (,))
$ pointfree "\x -> x*x"
join (*)
$ pointfree "\f l -> zipWith (,) (map (f . fst) l) (map snd l)"
(`ap` map snd) . (zip .) . map . (. fst)
$ pointfree "\x y -> (f x == f y)"
(. f) . (==) . f
{% endhighlight %}

ほー(後半ひどい）．`let ..in` とかも使えるようになっているようだ．
`ap` は [Control.Monad](http://hackage.haskell.org/package/base-4.7.0.2/docs/Control-Monad.html#v:ap) にあるようだ．

Pointfree についてはいくつか参考になる記事があります：

* [ポイントフリースタイルの歪んだ美 - capriccioso String Creating(Object something){ return My.Expression(something); }](http://d.hatena.ne.jp/its_out_of_tune/20120215/1329327403)
* [ポイントフリースタイル入門 - melpon日記 - HaskellもC++もまともに扱えないへたれのページ](http://d.hatena.ne.jp/melpon/20111031/1320024473)
* [ポイントフリーコンバータ - MEMO:はてな支店](http://d.hatena.ne.jp/katona/20120813/p1)
* [ポイントフリー - 西尾泰和のはてなダイアリー](http://d.hatena.ne.jp/nishiohirokazu/20100520/1274364170)

見比べてみるのも良さそう．

ちなみにもうひとつの，[maxgabriel](http://stackoverflow.com/users/1176156/maxgabriel)氏による回答では
[HaskellWiki](https://wiki.haskell.org/Pointfree#Tool_support) での記述が紹介されています．Lambdabot もこの機能を持っているらしい．
