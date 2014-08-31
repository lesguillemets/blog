---
layout: post
title:  "Haskell : パフォーマンス/正格性"
date:  2014-08-31 00:40:00 UTC+9
categories: haskell
---

[前回の投稿]({{site.baseurl}}/2014/08/30/haskell-thunk.html) で thunk についてフォーマルに習ったところで，今回は正格性をいかに持ち込んで haskell のパフォーマンスを向上させるかみたいな話になる．

[Performance/Strictness - HaskellWiki](http://www.haskell.org/haskellwiki/Performance/Strictness) をベースとします．

## Haskell : Performance/strictness

Haskell は non-strict な言語で，大抵の実装では遅延評価を評価戦略として取る[^strict-lazy]．基本的には laziness == non-strictness + sharing ということらしい．

Lazines[^laziness-link] はパフォーマンスの面からいえば，良い方向に働くこともあるけれども，どっちかといえば，何もかもに overhead を加えることになってパフォーマンスを悪化させることのほうが多い．遅延評価のために，コンパイラは函数の引数を評価して値を渡すことはできず，expression を (前回やった) thunk に積んで覚えとかないといけないわけだ．
後からやるよっていうのを覚えといたり評価するのは costly だし，どっちにしろ評価するんだから，というようなときは必要ないものだ．

### Strictness Analysis (正格性解析)

GHC のように最適化をやってくれる[^ghc-optimisation]コンパイラは
strictness analysis[^sta], 正格性解析[^staj] というものを使って laziness のコストを下げようとしてくれる．
正格性解析というのは，どの引数がその函数によって常に評価される，つまり従って，caller が代わりに評価していいのかを見極めるものだ．
これは場合によってかなり効果的で，例えば strict な `Int` を unboxed value[^unboxed] として渡せるとか，色々すごいことが起こる場合がある．
`fac` の最適化なんかにはもってこいで，

{% highlight haskell %}
fac :: Int -> Int
fac n = if n <= 1 then 1 else n * fac (n-1)
{% endhighlight %}

正格性解析さんはこれを見ると「あっ `n` は strict じゃん， unboxed でおｋ」っていうのがちゃんとわかる．そこで結果としてこの函数は全然 heap を使わずに動作するわけだ．

よくある誤解は fold とかの時．

{% highlight haskell %}
main = print (foldl (+) 0 [1..1000000])
{% endhighlight %}

これを `-O` flag なしでコンパイルすると，大量の heap と stack を食う．僕の環境では（見慣れた）

{% highlight text %}
Stack space overflow: current size 8388608 bytes.
Use +RTS -Ksize -RTS to increase it.
{% endhighlight %}

といってくる[^overflow]．プログラマは [non-strict semantics](http://www.haskell.org/haskellwiki/Non-strict_semantics) や [Lazy vs. non-strict](http://www.haskell.org/haskellwiki/Lazy_vs._non-strict) の記事を読んだので，`[1..1000000]` が thunk として保持されてるというのは知っている．
かれは [Stack overflow](http://www.haskell.org/haskellwiki/Stack_overflow) についても読んだから，明示的にこうして[末尾再帰](http://www.haskell.org/haskellwiki/Tail_recursion) の形で書いて，少しの stack しか食わないようにしたはずだ．
だからこの挙動は奇妙で理解出来ない．

そこでこのプログラマは，このプログラムが i) 何故か長いリスト `[1..1000000]` をまるっと保持することにした か， ii) garbage collector がこの長いリストのいなくなっていい部分をちゃんと処理できないか だと結論付ける．…それは間違い．引数の長いリストに問題はない．

Prelude から [ソースを見てみる](http://hackage.haskell.org/package/base-4.7.0.1/docs/src/GHC-List.html#foldl) とこうなっている．

{% highlight haskell %}
foldl         :: (b -> a -> b) -> b -> [a] -> b
foldl f z0 xs0 = lgo z0 xs0
             where
                lgo z []     =  z
                lgo z (x:xs) = lgo (f z x) xs
{% endhighlight %}
<del>このインデントなんとも奇妙な気がするけどこういう感じなんだろうか</del>

ここの `lgo` で `(f z x)` の thunk が作られ，その中の `z` もその前に `lgo` を呼んだ時に作られた thunk だから，
ガンガン thunk が積み重なって死んでしまう，というのがほんとうのところということだ[^no-opt]．

`-O` を flag として立てると ghc は strictness analysis をしてくれ[^oflag]て， `lgo` は z について strict なので thunk は不必要と判断し，プログラムは問題なく走るようになる．

ちなみに，一度 `-O` なしでコンパイルしたコードを `-O` つけてコンパイルし直す場合（あるいはその逆も），`.o` ファイルを消すか `-fforce-recomp` flag を立てるかしないと前のが使いまわされるっぽい． `-v` を立てると何をやってるか色々見せてくれます．

### Strictness analysis の限界

とはいえ，書いてたら strict じゃないコードになっちまった，みたいなのはよくある話．
Strict にしてもプログラムの意味は変わらないのに，lazy な函数がたまってパフォーマンスを悪化させる，というようなことがある．
例えば

{% highlight haskell %}
suminit :: [Int] -> Int -> Int -> (Int,[Int])
suminit xs len acc = case len == 0 of
  True  -> (acc,xs)
  False -> case xs of
    []   -> (acc,[])
    x:xs -> suminit xs (len-1) (acc+x)
main = print (fst (suminit [1..] 1000000 0))
{% endhighlight %}
<del>これまた読みにくい(特に case の入れ子) 気がするけど慣れてないだけだろうか</del>

たとえば `suminit [1..20] 10 0` が `(55,[11,12,13,14,15,16,17,18,19,20])`
になるような函数ですね．`acc` を使って[^accart]パフォーマンス向上を試みてはいるが，函数を呼んだひとが `acc` を評価する保証がないから `acc` は strict でない．
多分 `len` の方はきちんと unboxed な Int が使われるけれど，
`acc` のほうはそうはいかず， `(acc+x)` の方はその場では評価せずに積まれていくことになる．こういうのは割とよくあるパターン，らしい．そこで…

### Explicit strictness
とうとうやってまいりました，明示的に正格性をいうやりかた．

`foldl` については `foldl’` を使う．<del>そういうのが聞きたいんじゃない</del>

さっきの `suminit` については，`acc` を strict にする必要があったのだった．
これを達成するには `seq` を使う[^seq]．

{% highlight haskell %}
suminit :: [Int] -> Int -> Int -> (Int,[Int])
suminit xs len acc = acc `seq` case len == 0 of
  True  -> (acc,xs)
  False -> case xs of
    []   -> (acc,[])
    x:xs -> suminit xs (len-1) (acc+x)
{% endhighlight %}

差分は 2行目の `seq` だ．seq の[記事](http://www.haskell.org/haskellwiki/Seq)に
挙がっている例によれば，例えば `x::Integer` の時に `seq x b` っていうのはノリとしてはこういう雰囲気のことをするらしい．

{% highlight haskell %}
if x == 0 then b else b
{% endhighlight %}

`seq` 自身が `x` を評価するかというとそういうわけではないが，見かけ上の依存関係を作り出すことになるというような話であるようだ．

[Clean](http://wiki.clean.cs.ru.nl/Clean) などの言語では strictness を type に付記できる感じらしいが，haskell に（今のところ）それはない．

ghc の BangPatterns 拡張を使う[^bpext]ならこう書ける．

{% highlight haskell %}
suminit xs !len !acc = …
{% endhighlight %}

### Evaluating expressions strictly

`($)` の代わりに strict に引数を評価する `($!)` がある．コンパイラの気付かない不必要な suspension を除くのに良い．

例えば

{% highlight haskell %}
f (g x)
{% endhighlight %}

を

{% highlight haskell %}
f $! (g x)
{% endhighlight %}

と書けば， i) どっちにしろ `(g x)` は評価するが， ii) `f` が見るからに strict
だったり inlined というわけでないときにはより効率がいいことになる．
もともと `f` が strict だったり inlined だったらわざわざこう書く必要はないかもしれないね．

一つの例は monadic return で，

{% highlight haskell %}
do
  ...
  return (fn x)
{% endhighlight %}

とか書いてる時は

{% highlight haskell %}
do
  …
  return $! fn x
{% endhighlight %}

と書き直すといいかもしれない．こういう return の引数で遅延が必要なことは殆ど無いからね．

警告: ここで上げたような strictness annotation を使うときは気をつけよう．
プログラムの semantics に予期せぬ影響があって，特にコンパイラが最適化するときには問題になりうる，詳しくは [ここ](http://www.haskell.org/haskellwiki/Correctness_of_short_cut_fusion) を見よ，と書いてあった．

### Rule of Thumb for Strictness Annotation

引数 `x` を取る函数 `f` が次の条件をどちらも満たすときは，使うといいかも．

* `f` calles “a function on a function of `x`” : `(h (g x))`
* `x`  についてすでに strict でないばあい（ `x` の値を調べないとき）

例えば

{% highlight haskell %}
-- Force Strict: Make g's argument smaller.
f x = g $! (h x)

-- Don't force: f isn't building on x, so just let g deal with it.
f x = g x

-- Don't force: f is already strict in x
f x = case x of
   0 -> (h (g x))
{% endhighlight %}

ありがとうございました．

[^strict-lazy]: strict/non-strict と eager/lazy は混同しがちな気がする．
[^laziness-link]: 次回の投稿で扱うつもり
[^ghc-optimisation]: 頼めば ([ghc の users guide](https://www.haskell.org/ghc/docs/7.6.1/html/users_guide/options-optimise.html))
[^sta]: [Wikipedia](http://en.wikipedia.org/wiki/Strictness_analysis)
[^staj]: [Haskell Advent Calendar 2010 の記事](http://msakai.jp/d/?date=20101228)
[^unboxed]: 生の値 / primitive ，みたいな感じっぽい．[ghc 7.6.3 の doc](https://www.haskell.org/ghc/docs/7.6.3/html/users_guide/primitives.html) によれば boxed な type は heap object へのポインタとして値が表現されていて，unboxed っていうのは c でいう Int とかそういうもののこと，というようなことらしい．
[^overflow]: こうして止まってくれればよいが，[ghci などはオプション無しで動かすと際限なくメモリを食](http://stackoverflow.com/questions/3766656/)うっぽいので気をつけよう．たぶん `runghc` でも同じことになる．
[^oflag]: その分コンパイルに時間がかかるから普段はとりあえず  “Please compile quickly; I'm not over-bothered about compiled-code quality.” ということになる[らしい](https://www.haskell.org/ghc/docs/7.6.1/html/users_guide/options-optimise.html)．
[^no-opt]: 原文でこういう流れになってる（とおもう）んだけど，正直なところ「末尾再帰とかも `-O` 付けないと最適化されないZE」っていうのとは違うんだろうかと思わなくもない．僕の読み違いかなぁ
[^accart]: これも後日
[^seq]: この `seq` についても[記事がある](http://www.haskell.org/haskellwiki/Seq)からまた読みたいところ．hoogle では “Evaluates its first argument to head normal form, and then returns its second argument as the result.” と書かれている．多分そもそも遅延評価で言う「必要になった」ら，っていつなのかも理解しないといけない
[^bpext]: 明示的に書くか，`-fglasgow-exts` つけてコンパイルするか
