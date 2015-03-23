---
layout: post
title:  "mit-scheme の REPL, タブ補完とか履歴が効かないのが気に入らない"
date:  2015-03-23 12:00:00 UTC+9
categories: scheme bash
---

## 問題

`$ mit-scheme` すると repl が起動してやりとりができるようになるが，タブ補完も矢印上下のコマンド補完も効かないし，
矢印キーもemacs的なショートカットも効かない．
下手をするとこういう惨状が起こる:

{% highlight text %}
1 ]=> (defni^[[D^[[D^[[A^A
{% endhighlight %}

これはひどすぎる．何とかしたい．Python とかの repl でも採用しているような readline が使えればそれでいいのだけど．


## Ask Stackoverflow

というわけで，Stackoverflow に質問があった．[mit-scheme REPL with command line history and tab completion](http://stackoverflow.com/questions/11908746) ([aaronstacy](http://stackoverflow.com/users/5377) による質問)．

> [SICP](http://mitpress.mit.edu/sicp/full-text/book/book.html) を読んでて， OS X 10.8 に homebrew で mit-scheme 入れて使ってる．
>
> いい感じなんだけど，履歴とか補完をやってくれる Python とか Node.js の REPL の便利さに甘やかされてしまってるらしい．
>
> すごい重いのを求めてるわけじゃなくて，
> こういう機能って最近の REPL なら簡単に使えるようにできるよね（
> Python なら [簡単な startup ファイル](https://docs.python.org/2/library/readline.html#example)で，
> [Node.js でも数行](https://gist.github.com/aaronj1335/3317494)で実装できる）．
>
> 重たい application 入れるとか，emacs に乗り換えるとかじゃなくて（例えば xterm 上で動くような感じで）タブ補完と
> コマンド履歴の機能を mit-scheme で使う方法ってあるだろうか．


そして [Bobby Norton](http://stackoverflow.com/users/1054349/bobby-norton) による回答:

> [readline wrapper](http://utopia.knoware.nl/~hlub/rlwrap/README.txt) を入れましょう．
>
> `brew install rlwrap` [^ub]
>
> インストールすれば， `rlwrap scheme` で履歴，括弧の対応，タブ補完が使えるようになる．
> 個人的には次のようなオプションを渡して使ってる：
>
> `-r`, `--remember` :  put all words seen on in- and outpu on the completion list
> `-c`, `--complete-filenames` : complete filenames
> `-f`, `--file` `file` : Split file into words and add them to the completion word list.
>
> `-f` には [MIT Scheme Reference Manual](http://www.gnu.org/software/mit-scheme/documentation/mit-scheme-ref/Binding-Index.html#Binding-Index)
> から抽出したのを使ってる．[ここ](https://gist.github.com/bobbyno/3325982) に上げといた．
> これを `$HOME/scheme_completion.txt` に保存しておいて
>
> `rlwrap -r -c -f "$HOME/scheme_completion.txt" scheme`
>
>でこんなかんじだ
>
>{% highlight text %}
  1 ]=> (flo:a <tab tab>
  flo:abs    flo:acos   flo:asin   flo:atan   flo:atan2
  1 ]=> (flo:abs -42.0)
 ;Value: 42.
{% endhighlight %}
> めでたい．


ということで `rlwrap` 超便利です．

[^ub]: Ubuntu のレポジトリにもある．

