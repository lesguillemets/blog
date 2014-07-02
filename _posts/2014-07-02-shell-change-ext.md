---
layout: post
title:  "Bash で複数ファイルの拡張子を一括で変更"
date:  2014-07-02 12:00:00 UTC+9
categories: bash
---

Bash で（も何でもいいが，とにかく手近なツールで）current directory にある複数ファイルの拡張子を一括で変更したい．どうするだろうか．
ここでは細かい例外処理とか扱いづらいファイル名とかはだいたい無視して良いし，上書きも気にしない．

### これまで

ずいぶん前の，bash に触れたての僕なら多分こうしていたと思う（本気で）．以下 `*.JPEG` を `*.jpg` に変えたいとしよう．

{% highlight bash %}
for f in `ls -1 *.JPEG`; do
  newfilename=`echo $f | sed -e "s/JPEG$/jpg/"`
  mv $f $newfilename
done
{% endhighlight %}

わりとやばい感じがする．まず Vim と仲良くなったので，次に僕が仲良くなろうとしたのは sed だったのだ．
ついでにこのままだと空白の入ったファイル名で死ぬがきちんと quote して避けられるかどうか自信がない．


それから少し経って Python に馴染み，昨日までなら微妙にめんどくさがりつつ python で書いただろうとおもう．
特にもっと複雑なことをしたくなったときに無いなりに python 力を援用できるので．

{% highlight python %}
#!/usr/bin/env python3
import os

from_ext = ".JPEG"
to_ext = ".jpg"

for f in os.listdir('.'):
    if f.endswith(from_ext):
        print(f)
        os.rename(f, f[:-len(from_ext)]+to_ext)
{% endhighlight %}

まあこんな感じ? 単純な rename にあんまり頭使うのも悔しい感じでこういうことになった．
色々対応する必要があるなら適宜 `isfile` とか使っていくといいんだと思う．

Ruby なら `Dir.foreach('.'){|f|}` とかやれば綺麗にあげぽよに書ける気がする．普段触らないから分からないが．

### 知見

まず `rename` というすごくそれらしい名前のコマンドの存在を知る．これの本体は perl のスクリプトで，システムによっては別のものを指してるかもなので注意だとかいうことだ．

`$ man rename`
{% highlight text %}
rename [ -v ] [ -n ] [ -f ] perlexpr [ files ]
{% endhighlight %}

`-v`, `--verbose` はファイル名を出力， `-n`, `--no-act` は実際には rename しない， `-f`, `--force` は上書きするというオプション．
これを使えば
{% highlight text %}
$ rename 's/\.JPEG$/.jpg/' *.JPEG
{% endhighlight %}
で行けそうだ．

こちらはそんなに使い勝手はよくないのかもしれないが `basename` ってのがあって

{% highlight text %}
$ mv "$file" "`basename $file .JPEG`.jpg"
{% endhighlight %}

みたいな感じで使うことが出来る．

### そして革命

実は ([Advanced Bash-Scripting Guide](http://www.tldp.org/LDP/abs/html/abs-guide.html#INTORSTRING) を読んでいて知ったんだが)，
bash なら変数内で文字列置換みたいなことをすることが出来る．

例えば
{% highlight bash %}
a="foobar"
echo ${a/foo/bar}
# => barbar
echo ${a//o/0}
# => f00bar
{% endhighlight %}
と言った具合で，これについては [shとbashでの変数内の文字列置換など - ろば電子が詰まっている](http://d.hatena.ne.jp/ozuma/20130928/1380380390) に詳しい．

これを使えば

{% highlight bash %}
for f in *.JPEG; do
  mv "$f" "${f%.JPEG}.jpg"
done
{% endhighlight %}

で行ける．`${f%.JPEG}` で後方最短マッチの削除，空白なども簡単に quote できていて，なかなかすっきりしていていい感じだ．
たとえば `2014-07-01-my-post.md` とかいう長ったらしいのを `07-01` から `07-02` にしたいみたいなときにも楽そうで life-changing.

Bash もかなり色々機能があって，そこでゴリゴリ頑張るか python とかに流れるかは難しいところだが，つい python や ruby で全部やってしまいがちなので
もうちょっと bash で色々やるようにしたい．
