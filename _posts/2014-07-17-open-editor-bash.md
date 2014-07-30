---
layout: post
title:  "Bash で長いコマンド書いてる時にエディタ起動"
date:  2014-07-17 00:00:00 UTC+9
categories: bash
---

したいときは `<C-x><C-e>` しましょう．

ホントは他の bash tips みたいなのとまとめて記事にするつもりだったんだけどその前に覚えときたいので．
[ちなみにここを参照](http://cfenollosa.com/misc/tricks.txt).

<!-- * TODO : `<C-x><C-e>` で起動した時に `set ft=bash` しておきたいところ． -->

さて，せっかくこれしたなら `set ft=bash` したいじゃないですか．

例によって stackoverflow に[質問がありました](http://stackoverflow.com/questions/7115324/syntax-highlighting-in-bash-vi-input-mode/7115478#7115478)．
ここに上がっている方法はいずれもファイル名が `bash-fc-3537253897` みたいな形をしていることを利用したもので，

{% highlight vim %}
if expand('%:t') =~?'bash-fc-\d\+'
    setfiletype sh
endif
{% endhighlight %}

または

{% highlight vim %}
au BufRead,BufNewFile bash-fc-* set filetype=sh
{% endhighlight %}

いずれもやっていることは大体一緒だけれども，多分前者は Vim 起動時にだけ発動するのに対して，後者はバッファ読み込み時に全部やる感じ（試してないけど）．
`<C-x><C-e>` の時だけという観点から言うと前者のほうがそれっぽいだろうか．
