---
layout: post
title:  "Firefox で漢字など一部の書体に droid sans が使われるなどの件"
date:  2014-09-01 06:00:00 UTC+9
categories: linux
---

たとえば 「いくつかのサイトで firefox で見てる時に漢字だけ何故か頼んでもいないのに droid-sans で描画されてるひどい」なときにみるべきところ

* [本の虫: GNU/Linuxでfontconfigにより日本語フォントを優先させる方法](http://cpplover.blogspot.jp/2012/03/gnulinuxfontconfig.html)
* [How to change the fallback font for missing languages? - Ask Ubuntu](http://askubuntu.com/questions/13708)
* [Ubuntu – trusty の language-selector-common パッケージに関する詳細](http://packages.ubuntu.com/trusty/language-selector-common)
* [Ubuntu日本語フォーラム / Firefoxで漢字のフォントが別のフォントに置き換わる](https://forums.ubuntulinux.jp/viewtopic.php?id=3124)
* [独学Linux : Ubuntu 11.10（Oneiric）の日本語環境に関する注意点](http://blog.livedoor.jp/vine_user/archives/51900371.html)

とりあえず本の虫を読んで droid-sans を消して何とかしていた自分について反省し，後をつらつら読み，language-selector-common に cn とかがあるのに ja がないのをみて一瞬???を飛ばしまくり，さしあたっては

{% highlight text %}
$ wget https://www.ubuntulinux.jp/fonts.conf.d/oneiric-69-language-selector-ja-jp.conf
{% endhighlight %}

して中身を `~/.config/fontconfig/fonts.conf` に書き加えて再起動したらいけている．
なおこうしてもらってきたファイルは proportional な文脈では IPAPGothic などの p 系を指定しており，個人的な感慨ではこれらは句読点の幅に難があるので全部 P じゃないのに書き換えた．そんでもって全体の設定は Ubuntu にして，IPAGothic に fallback する感じになってる…とおもう．

さしあたってはこれでいけてるんだけど，

* `fontconfig` の書き方を理解してなくて何がどう影響してるのか今ひとつ把握してない
* 問答無用で漢字が fallback というかデフォルトさん見に行く感じになってる（それに対して平仮名は firefox の設定での変更が効く）のは firefox さんが漢字について cjk どれか判断しかねてるんだと思うんだけど，そっちの方の設定を何とかしたい．「だいたいは en / ja」のつもりでいてほしい．
  - このために今場当たり的に，firefox さんには「基本的に dejavu sans とか使ってね」→「日本語は Ubuntu 使ってね（和文中欧文用）→「見つからなかったら IPA だよ」みたいなことになってカオスさがやばい．和文中の漢字をいい感じに日本語として扱い，また和文中の欧文を欧文のつもりで見せてくれたらいいんだけどなぁ．
* Chromium で同様の問題は発生していないのが気になる．Firefox たん，確か日本語文脈中でのギリシャ文字は和文フォント（→全角{やめてくれ(直球)}）で表示する癖があったり，漢字がうんたらとか，そもそも両者で「フォント設定」というとき私は何を設定しているのかとか，どうもこの辺り調査の必要がありそう．

上のことは全体にあんまり理解しないまま適当書いていて，とりあえずこの記事の内容は最初に掲げたリンクだけと思ってください．

### 結論
cjk つらい．
