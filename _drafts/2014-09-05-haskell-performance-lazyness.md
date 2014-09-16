---
layout: post
title:  "Haskell : performance/laziness"
date:  2014-09-05 12:00:00 UTC+9
categories: haskell
---

[前回]({{site.baseurl}}/2014/08/31/haskell-performance-strictness.html)は正格性の話．
今回はその続き，haskellwiki から [Performance/Laziness](http://www.haskell.org/haskellwiki/Performance/Laziness) について．

## Performance/Laziness

### Laziness: procrastinating for Fun & Profit

Haskell で遅延評価がどう働くか，そしてどうやって効率をよくするか，ということを理解するために，マージソートを実装してみる．
型はこうなるはずだ．

{% highlight haskell %}
mergeSort :: (Ord a) => [a] -> [a]
{% endhighlight %}

<small>(haskellwiki では `merge_sort` と snake_case だったが，camelCase のほうがよく使われる印象を受けているのでそちらに修正した．)</small>

merge sort だからリストを分ける函数も要るよね．ここでは cleave と呼ぶことにして

{% highlight haskell %}
cleave :: [a] -> ([a],[a])
{% endhighlight %}

こっちの `cleave` の実装から考えてみよう．Merge sort で慣習的によく用いられるのは前半と後半で分けるものだ．
ただ配列の長さを求めるには一回余分に配列全体を見ないといけないから[^haskell_linked_list]嬉しくない．
そこで，配列の頭から pair を取っていくことにする．2つ函数を用意して

{% highlight haskell %}
evens [] = []
evens [x] = [x]
evens (x:_:xs) = x : evens xs
{% endhighlight %}
{% highlight haskell %}
odds [] = []
odds [x] = []
odds (_:x:xs) = x : odds xs
{% endhighlight %}

これで `cleave` を書く[^sharing_perhaps]．

{% highlight haskell %}
cleave xs = (evens xs, odds xs)
{% endhighlight %}

さてここで，SML とか OCaml とかのような正格評価を使う言語の経験があると，
[accumulating parameter](www.haskell.org/haskellwiki/Performance/Accumulating_Parameters) を使って別な書き方をするかもしれない[^no_caml]．
別に順番がさかさになっても大丈夫と思えば，こんな感じで書ける：

{% highlight haskell %}
cleave = cleave' ([], []) where
    cleave' (eacc, oacc) [] = (eacc, oaac)
    cleave' (eacc, oacc) [x] = (x:eacc, oacc)
    cleave' (eacc, oacc) (x:x':xs) = cleave' (x:eacc, x':oacc) xs
{% endhighlight %}

パッと見こっちのほうがいい実装のように見える．[末尾再帰](http://www.haskell.org/haskellwiki/Tail_recursion)だし，
strictness analysis に頼るか，明示的に `acc` たちを正格にするかすれば， stack を積み続けて死ぬこともない．

ところが驚くなかれ，いや驚け，最初の実装のほうが良いのだ[^cbc]．

どうしてか？2つに分けたリストの先頭を取ってくることを考えると，2つ目の書き方ではリスト全体を処理しないといけない．
非正格な言語では無限リストを扱うこともあるし，そういうのもうまく扱って欲しい．
例えば

{% highlight haskell %}
head . fst $ cleave [0..10000000]
{% endhighlight %}

をやってみた時に，最初の実装では O(1) で `0` が帰ってくるが，2つ目のでは O(n) かかる．`[0..]` みたいなのだと終わらない．

`evens` の挙動と， haskell でリストがどうなってるのかを見てみよう．List は空リストか要素と残りのリストからなる "cons" cell として表現される．
Haskell もどきみたいな書き方すると，こう．

{% highlight haskell %}
data [a] = [] | a : [a]
{% endhighlight %}

遅延評価する言語では，expression は必要な時しか評価されない．そして `(:)`, 別名 cons[^cons-japanese] は，lazy なコンストラクタだ．
これの実装に使われてるのが thunk という仕組み[^thunk_post]．
で，これは要するに計算された値か，計算の仕方[^th_or]の2種類の状態の一方を持つ値．
Haskell で値を割り当てるとき，実際にやってるのは値の計算の仕方を thunk にして与えてるということになる．
計算が必要になると値が計算され，それがまた thunk に入って，次にその値が必要になった時にはその計算された値が使われる．
Laziness は SML みたいな言語では[^sml]こんな感じのを mutable reference と合わせて実装できる．

さて，再帰的に定義された `evens` に戻る．ここでは，list の ”cons cell” を含む thunk を作っている．
ここでいう cons cell っていうのは，要素とリストの残りという2つの thunk を含んだ塊のことで，
要素のほうは `evens` を適用してるリストから引っ張ってきて，後者の方は `evens` が残りをどうやって作るかを知ってるから，
それ，ということになる．
`evens` と `odds` は input について lazy, というか，値を出すのに必要な分しか入力をつかわないのだ．
Lazy な函数の動きかたの例として，次のを考えてみよう．

{% highlight haskell %}
head (5:undefined)
tail [undefined, 5]
evens (5 : undefined : 3 : undefined : 1 : undefined : [])
take 3 $ evens (5 : undefined : 3 : undefined : 1 : undefined : undefined)
{% endhighlight %}

入力にどれも `undefined`[^undefined] が入っているが，どれもちゃんと動いてる．

[^haskell_linked_list]: haskell の list は [linked list なので](http://stackoverflow.com/questions/15063115)
[^sharing_perhaps]: なんかこれも `odds` と `evens` を2回使ってるの無駄なのではという感じがあるが，噂の sharing とかが効くのかもしれない．またそれは後で．
[^no_caml]: もしくは haskell に入門したての僕のような人間も．
[^cbc]: ケースバイケースというか，一般に `cleave` を書きたいときに常にこっちがいいというわけでは無いとはおもうけれど．
[^cons-japanese]: かっこいい日本語ないのかなあ
[^thunk-post]:[以前の投稿]({{site.baseurl}}/2014/08/haskell-thunk.md)
[^th_or]: 原文:either a computed value, or the process to compute that value
[^sml]: 知らんけど
[^undefined]: `head [undefined,5]` とやると， `*** Exception: Prelude.undefined` となる．
