---
layout: post
title:  "uplatex + dvipdfmx でフォント埋め込み"
date:  2014-12-25 00:00:00 UTC+9
categories: latex
---

ほっとくと確実に忘れるので何やったかだけメモ．情報のない情報ですまぬ．

platex + dvipdfmx なら
[（フォントを）埋め込むか、埋め込まざるか、その設定方法が問題だ（TeX Live 編） - マクロツイーター](http://d.hatena.ne.jp/zrbabbler/20130115/1358197826)
を参考に

{% highlight text %}
$ platex "$texfile" -o "$dvifile"
$ dvipdfmx -f ptex-ipaex.map -f otf-ipaex.map "$dvifile"
{% endhighlight %}

ところが uplatex で同じ感じにしても埋めこめられないっぽい．のでチラチラ探して
[PDFの作り方 - TeX Wiki](http://oku.edu.mie-u.ac.jp/~okumura/texwiki/?PDF%E3%81%AE%E4%BD%9C%E3%82%8A%E6%96%B9#z0e1001a) 
を参考に次のを実行してみる

{% highlight text %}
$ kanji-config-updmap ipaex
{% endhighlight %}

すると

{% highlight text %}
Files generated:
  ~/.texmf-var/fonts/map/dvips/updmap:
       15772 2014-12-25 00:00:00 builtin35.map
       21245 2014-12-25 00:00:00 download35.map
      203894 2014-12-25 00:00:00 psfonts_pk.map
      213150 2014-12-25 00:00:00 psfonts_t1.map
      208493 2014-12-25 00:00:00 ps2pk.map
          14 2014-12-25 00:00:00 psfonts.map -> psfonts_t1.map
  ~/.texmf-var/fonts/map/pdftex/updmap:
      208500 2014-12-25 00:00:00 pdftex_dl14.map
      206835 2014-12-25 00:00:00 pdftex_ndl14.map
          15 2014-12-25 00:00:00 pdftex.map -> pdftex_dl14.map
  ~/.texmf-var/fonts/map/dvipdfmx/updmap:
        5383 2014-12-25 00:00:00 kanjix.map

WARNING: you are switching to updmap's per-user mappings.

You have run updmap (as opposed to updmap-sys) for the first time; this
has created configuration files which are local to your personal account.

Any changes in system map files will *not* be automatically reflected in
your files; furthermore, running updmap-sys will no longer have any
effect for you.  As a consequence, you have to rerun updmap yourself
after any change in the system directories; for example, if a new font
package is added.

If you want to undo this, remove the files mentioned above.
{% endhighlight %}

ほんで

{% highlight text %}
$ uplatex foo.tex
$ dvipdfmx foo.dvi
{% endhighlight %}

で埋めこめられた pdf が一応作成できる．大方よい practice ではなさそうなのでまた調べたい．

全体的には
[upLaTeXを使おう [電脳世界の奥底にて]](http://zrbabbler.sp.land.to/uplatex.html)
あたりを参照するとよさそうだ．
