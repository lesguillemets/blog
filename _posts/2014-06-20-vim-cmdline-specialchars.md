---
layout: post
title:  "Vim の command line で使う % とか"
date:   2014-06-19 16:09:50 UTC+9
categories: vim
---

Vim で最近 command line で `%` とかを考えずに使えるようになってきたので，その仲間たちの話．

[`:h cmdline-special`](http://vim-help-jp.herokuapp.com/#cmdline-special)

{% highlight text %}
  %  Is replaced with the current file name.      *:_%* *c_%*
  #  Is replaced with the alternate file name.    *:_#* *c_#*
    This is remembered for every window.
  #n  (where n is a number) is replaced with      *:_#0* *:_#n*
    the file name of buffer n.  "#0" is the same as "#".     *c_#n*
  ##  Is replaced with all names in the argument list    *:_##* *c_##*
    concatenated, separated by spaces.  Each space in a name
    is preceded with a backslash.
  #<n  (where n is a number > 0) is replaced with old    *:_#<* *c_#<*
    file name n.  See |:oldfiles| or |v:oldfiles| to get the
    number.              *E809*
    {only when compiled with the |+eval| and |+viminfo| features}
{% endhighlight %}

これらは `expand` とかと組み合わせて使うことができて，例えば
{% highlight vim %}
" これはお馴染み(?)
:vimgrep foo %<CR>
" insert mode から
<C-r>=expand(“%”)<CR>
{% endhighlight %}
みたいなこともできる．`fnamemodify` みたいな `eval.txt` にある関数たちと組み合わせると複雑なこともできるっちゅうわけや．

`#n` はなんとなく status line に表示させてたのが活きてきそう．
{% highlight vim %}
set statusline=[%n]\ %f\ %m\ %y\ %<[%{fnamemodify(getcwd(),':~')}][%{GitBranch()}]\ %=L[%4l/%4L]\ C[%3c]%5P
" [4] .vimrc [+] [vim] [~/] [master]                      L[ 474/ 981] C[ 65] 45%
{% endhighlight %}

そしてちょっと気になるのが `alternate file name` と `argument list`.
後者はなんか僕は今のところあまりお世話にならなさそうなので省略だ．

`:h alternate-file`

{% highlight text %}
If there already was a current file name, then that one becomes the alternate
file name.  It can be used with "#" on the command line |:_#| and you can use
the |CTRL-^| command to toggle between the current and the alternate file.
However, the alternate file name is not changed when |:keepalt| is used.
An alternate file name is remembered for each window.
{% endhighlight %}

つまりいま例えば `foobar.md` を編集してて `:ed ~/.vimrc` した所で
`:echo expand(“#”)` したら `foobar.md` になるといわけだ．


あと似た使い方ができるのは
`<cword>`, `<cWORD>`, `<cfile>`, `<afile>`, `<abuf>`, `<amatch>`, `<sfile>`, `<slnum>` あたりがあって，
このあたりは必要があれば調べて使える感じだけどもっと息を吸うように使えるようになりたい．
