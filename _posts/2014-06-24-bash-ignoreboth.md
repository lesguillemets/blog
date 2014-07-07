---
layout: post
title:  "bash で unique な history だけを保存"
date:   2014-06-24 12:00:00
categories: bash
---

bash で `history` すると `vim` とか `ls` とかダブりがあってかなしい．

そういうときはこうするといいよ

{% highlight bash %}
export HISTCONTROL="ignoreboth"
{% endhighlight %}

これで並んだダブりは記録されなくなる．

{% highlight text %}
$ vim
$ ls
$ ls
$ history | tail -n 3
{% endhighlight %}

では `vim` と `ls` (と `history`)が出る．

ところがこれは [離れたダブりは消去してくれなくて](http://serverfault.com/questions/121396/),
こういう場合には

{% highlight bash %}
export HISTCONTROL="ignoreboth:erasedups"
{% endhighlight %}

で解決する．なんで今まで設定してなかったんだろうという感じだ．

(追記 7 Jul 2014)

…と思ったし一応確認したつもりだったんだけど，どうも `HISTCONTROL="erasedups"` だけにしないとだめっぽい?

