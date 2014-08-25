---
layout: post
title:  "Vim で直前の検索パターンを部分的に再利用する"
date:  2014-08-05 12:00:00 UTC+9
categories: vim
---

### 問題
Vim で直前の検索パターンを部分的に再利用したい．直前の検索パターンをそのまま利用するのであれば，

{% highlight text %}
/foo
{% endhighlight %}

で検索の後

{% highlight text %}
:%s//bar
{% endhighlight %}

で `:%s/foo/bar/` と同等になる．そうではなくて，直前に使った検索パターンを再利用して置換のパターンを作りたい．

{% highlight text %}
/,\n\s*}
{% endhighlight %}

で何気なく javascript で残念なアレの存在を確かめてから，滑らかに

{% highlight text %}
:%s/\zs,\ze\n\s*}//
{% endhighlight %}

へと移行して，object を開いて書くときの最終行にくっついてる `,` を取り除きたい． `q/` を使えばやや楽に `/\zs,\ze\n\s*}` を検索してから `:%s///` できるが，そこにふた手間使いたくはない．

### 解決

Last search pattern register を使う ([`:h quote/`](http://vim-help-jp.herokuapp.com/#quote%252F))．

このレジスタ `"/` には直前に検索した pattern が入っていて，`hlsearch` などもこれを使っているらしい．これを使えば

{% highlight text %}
:%s/<C-r>/
{% endhighlight %}

と打てば

{% highlight text %}
:%s/,\n\s*/
{% endhighlight %}

と同等になる．めでたい．

### 参考
[Vim - General - Reuse search pattern?](http://vim.1045645.n5.nabble.com/Reuse-search-pattern-td1188177.html) に載ってた．

### 別の解決法
(25 Aug 2014 追記)

「何気なく使う検索から置換への滑らかな移行」なら上のが良いと思われるが，「置換パターンを実験したりしつつ定めたい」のであれば [osyo-manga/vim-over](https://github.com/osyo-manga/vim-over) を使うのがいいかもしれない．作者による解説記事は [http://d.hatena.ne.jp/osyo-manga/20131105/1383664737](こちら)．
