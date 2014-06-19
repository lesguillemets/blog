---
layout: post
title:  "Vim で timestamp を挿入"
date:   2014-06-19 00:28:00 UTC+9
categories: vim
---

Vim でタイムスタンプ挿入なんていうありふれたネタ．

jekyll を使って記事を書く場合，`_posts` 以下の markdown とかの先頭にヘッダを書くわけだ．
形式は YAML, jekyll では Front-matter として [解説がされている](http://jekyllrb.com/docs/frontmatter/)．

形式は例えばこうだ．

{% highlight text %}
---
layout: post
title:  "Vim で timestamp を挿入"
date:   2014-06-19 00:21:34 UTC+9
categories: vim
---
{% endhighlight %}

この `date` がどういう形式を許してるのか詳らかでないが（後で調べよう），最初のサンプルに記載されていたこの形式なら間違いはなく，
この日付を一発で挿入したい．

`:h strftime`

{% highlight text %}
strftime({format} [, {time}])        *strftime()*
    The result is a String, which is a formatted date and time, as
    specified by the {format} string.  The given {time} is used,
    or the current time if no time is given.
{% endhighlight %}

一般の `strftime` と同じ気分でつかって良いらしいので話は早い．
こういう形式を使いたいのは今のところ jekyll 使う時が専らな気がするので（普段日付書くなら 19Jun2014 の形式が好み），`filetype` 指定してやりましょう．
マップは何でもいいけど…バッティングの可能性を考えるのと覚えるのがめんどくさいので安直に `,tim` か `,time` あたりで行こう．
`\` と `,` はなんとなく気分的にしか使い分けてない…．

こうなる
{% highlight vim %}
autocmd FileType markdown nnoremap <buffer> ,tim a<C-r>=strftime("%Y-%m-%d %H:%M:%S UTC+9")<CR><Esc>
{% endhighlight %}

実際に使うときは勿論 `augroup` を適切につかいましょう．`i` じゃなくて `a` にしたのは行末で使うことが多そうだから．


Jekyll でものを書きやすいような vim の環境づくりを少しづつ進められたらいいなと思っていて，
例えば `highlight python` みたいなのは `emmet` つかって便利しかけている．もうちょっと詰められたら紹介する予定．

あと `.md` とか `.markdown` っていってもふつうの markdown だったり jekyll だったり github flavoured だったりするからやりづらい．
