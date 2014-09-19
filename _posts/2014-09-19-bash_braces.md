---
layout: post
title:  "Bash の curly bracket とかについて"
date:  2014-09-19 15:00:00 UTC+9
categories: bash
---

スコットランドの独立は否決されそうですね．朝から開票結果が気になってだいたいべったり睨んでたので何も手につきませんでした．

さて，時々どこかの blog とかで見る次のようなカッコいいやつ：

{% highlight bash %}
mv myfile{.JPG,.jpg}
{% endhighlight %}

このあたりについての覚書．[Advanced Bash-Scripting Guide](http://www.tldp.org/LDP/abs/html/abs-guide.html)[^abs] というとんでもないものがあって，
それの [Chapter 3](http://www.tldp.org/LDP/abs/html/abs-guide.html#SPECIAL-CHARS) あたりからお届けします．

### `{xxx,yyy,zzz...}`

これは **Brace expansion** というもので，上の例で使われたのもこれだ．
こういう使い方になる[^benri]

{% highlight bash %}
echo \"{These,words,are,quoted}\"
# => "These" "words" "are" "quoted"
{% endhighlight %}

ふむふむ．この expand するってのがどうしっくり理解できてないところがあって，
つい ruby の `.each` とかそういう雰囲気で見てしまいがち．
多分展開したのがそのまま書かれてるつもりで見ればいいんだろうな．

{% highlight bash %}
cat {file0,file1,file2} > combined_file
{% endhighlight %}

これは `cat f0 f1 f2 > cf` と等価，と見てよさげ（？）．
Guide には shell がこの brace expansion をして，コマンドはその結果にかかるという感じのことが書かれている．

ほんでまあカッコいい例

{% highlight bash %}
cp myfile.{txt,backup}
# copies "myfile.txt" to "myfile.backup"
{% endhighlight %}

スペースなどは escape しないといけないらしい．

### `{a..z}`

**Extended Brace expansion**[^from3]. こう

{% highlight bash %}
echo {a..z} # a b c d e f g h i j k l m n o p q r s t u v w x y z
{% endhighlight %}

こういうのはこうなるようだ

{% highlight bash %}
echo {a..c} {2..4} # a b c 2 3 4
echo {a..c}{2..4} # a2 a3 a4 b2 b3 b4 c2 c3 c4
{% endhighlight %}

2つの違いには何かで嵌りそう．くわばらくわばら．

### xargs で名前を再利用
{} : **placeholder for text** と書かれている．

{% highlight bash %}
ls . | xargs -i file {}
#            ^^      ^^
{% endhighlight %}

`file` みたいな引数1つのには旨味もないが，`cp` とかで使いたいときは多いはず．


というわけで今回の範囲っぽいのはこのあたり．膨大な文書なので折りにふれ見ていこうと思う．すぐ Python とかに頼るのも(状況によっては)あんまりよくないし．

[^abs]: by Mendel Cooper. Granted to the Public Domain. (マジかよ！）
[^benri]: これ Vim で書くとき，たとえばコード打つ→`Y`→`o#<C-o>:r!<C-r>0<CR>` とかで行けていいですね．
[^from3]: 因みに bash の version 3 からの機能らしい．今僕が使ってるのは 4.3.11.
