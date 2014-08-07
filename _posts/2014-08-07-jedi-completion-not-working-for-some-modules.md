---
layout: post
title:  "matplotlib に纏わる補完を jedi がしてくれない"
date:  2014-08-07 18:00:00 UTC+9
categories: vim python
---

### 補完してくれない?

よーし matplotlib だ！

![no-completion]({{site.baseurl}}/img/2014-08/07-vim-jedi-0.png)

補完してくれない……つらい………
（ついでに，この時 CPU を大量に喰ってるっぽい．これはなんかのバグかもしれない？）

### どうやら

一方 numpy は補完してくれる．軽く調べると特別 matplotlib と jedi で問題が起こるというような状況はない．
そう言えば numpy は apt で， matplotlib はそれからかなり経って pip3 で入れたはず．標準+apt で入れたパッケージ群は補完がきいて，
pip3 で入れた奴にはきいてなさそうな雰囲気がある．

### 複雑な状況，自前ビルドという泥沼

しばらく前，OS が Ubuntu 12.04, `apt` で入る python3 が 3.2 というのに少し悲しんだ僕は自分で python をビルドすることにした．
しかも apt で入れた python3 はそのまま残っている．
結果として `python3` は 僕にとっては `/usr/local/bin/python3` のことであり，例えば pip3 で入れた
matplotlib は `/usr/local/lib/python3.4/site-packages/` に居る．調べかけて今ひとつ理解できず面倒になった上，複数の環境を使うこともあるまいと思った僕は
`virtualenv` なども結局使わずに， ソースを落として make, これでやってしまうことにしたのだった．

### jedi の参照する path

似たような状況の issue が立っていた．

* [question: how to tell jedi to use a local Python environment? · Issue #329 · davidhalter/jedi](https://github.com/davidhalter/jedi/issues/329)

大まかに言えば

* vim 側の `sys.path` が間違っているのでは．`:py print(sys.path)` でチェックしてみて．
* それはそれとして `virtualenv` 使うべき

で，この vim の python 補完に纏わるやつが読み込む `path` という点から言うと，同じ質問がここにある

* [Vim's Omnicompletion with Python just doesn't work - Stack Overflow](http://stackoverflow.com/questions/2084875)

そこで…

### path を調べる

`:py3(print(sys.path))`

{% highlight text %}
['/usr/lib/python3.2', '/usr/lib/python3.2/plat-linux2',
'/usr/lib/python3.2/lib-dynload', '/usr/lib/python3/dist-packages', '_vim_path_']
{% endhighlight %}

で一方

`$ python3 -c "import sys; print(sys.path)"`

{% highlight text %}
['', '/usr/local/lib/python34.zip', '/usr/local/lib/python3.4',
'/usr/local/lib/python3.4/plat-linux', '/usr/local/lib/python3.4/lib-dynload',
'$HOME/.local/lib/python3.4/site-packages', '/usr/local/lib/python3.4/site-packages']
{% endhighlight %}

あーーーーそら見てるの違いますよねーーー．

試しに `vim` 起動 -> まず `:py3(sys.path.append('/usr/local/lib/python3.4/site-packages'))` あたりをしてから `set ft=python` して補完するときちんと補完してくれる．

![yes-completion]({{site.baseurl}}/img/2014-08/07-vim-jedi-1.png)

問題はここにあったわけだ．めでたい．

### まとめと解決策

* 普段使っている python がシステムのそれと違うなどの事情から， Vim が見に行く python の path が違っており，このため僕の環境で `/usr/local` の方にインストールされたモジュールにまつわる補完がなされない．
* 従って，vim 側から `:py3(sys.path.append('/path/to/python/lib'))` などしておけば解決する．これは `.vimrc` にでも書いておくと良いだろう．
* 適当に synbolic link 貼ってもいいかもしれない．
* 根本的には問題は，vim が `:py3` で呼び出す python と普段 `$ python3` で起動する python が異なっていることだから，**Vim を，使う python のバージョンを指定してビルドしたい** ところだが，これについてはやや事情が複雑なようで，また別の post にすることとする．
