---
layout: post
title:  "Vim で非空白行の行末スペースをハイライトする正しいやり方"
date:  2014-07-05 12:00:00 UTC+9
categories: vim
---

### 問題

Vim + quickrun で例えばなんかの api からの response を受け取るとする．しばしば改行が入っていなくてかなり長い一行のファイルになる．
それを読み込んだ時に，例えば 1行 5万文字のものを読み込んだ時に，— Vim が， Vim が死んでしまう．
Vim は一行があまりに長いのは得意でない，という噂があったのでちょっと遅くなるのはあまり気にしていなかったのだが，それでもあまりにひどい．
Vim だぜ？ Vim で 5万文字の text file を読み込んで `$ kill -KILL` する羽目になるなんて屈辱ではないか．絶対に何とかなるはず．

試しにこれでやってみる．

{% highlight text %}
$ vim -u NONE -U NONE foo.txt
{% endhighlight %}

起動は一瞬，その後の動きも軽快なものだ．そうだ．これが Vim だ．
半ば闇の道に堕ちてしまった自分を省みつつ `.vimrc` を削ってゆく．git で管理しているから好き放題できてやりやすい．

まず疑わしいのはどうせ `neocomplete` とかそのへん……削っても効果はない（そう言えば `txt` とかではそもそも動いていない），
ならばマッチ系が怪しいか，rainbow parentheses, 多分関係ないけど quickhl .... とうとう plugin をすべてなくしてしまった．

まだ Vim は死んだままだ．どうして，どうして……．`synmaxcol` は `200` で問題ないはず，`cursorline` でも削ってみるか，うーん，……
虱潰しにオプションを削ってゆく，怪しそうなものから順に，ザクザク．ひょっとして `.vimrc` なんて空にしとくべきなんじゃないか．

### 解決

…としばらくやっていると，三番目くらいに目をつけたここを削ると一気に動作が改善した．

{% highlight vim %}
augroup highlightSpaces
    autocmd!
    autocmd ColorScheme * hi ExtraWhiteSpace ctermbg=darkgrey guibg=lightgreen
    autocmd ColorScheme * hi ZenkakuSpace ctermbg=white guibg=white
    autocmd VimEnter,WinEnter,Bufread * call s:syntax_additional()
augroup END
{% endhighlight %}

ご覧の通りこれは全角空白と行末スペースをハイライトする設定．`s:syntax_additional` に飛んでやってみると，なんと問題になっていたのは次の一行．

{% highlight vim %}
matchadd('ExtraWhiteSpace', '\(\S\+\)\@<=\s\+$',0)
{% endhighlight %}

これは「空白行ではないところにある，行末の半角スペースをハイライト」する部分．
この需要があるのは僕がインデントがあるべき空白行には行頭にインデントを入れるからで，例えば python だとこんな感じで書いている（* がスペース）．

{% highlight python %}
class FOO(object):
****
****def __init__(self):
{% endhighlight %}

これを設定したのはしばらく前で，どこかで解説されていた方法に従ったのだが……

…

**あれ？っていうかこれ明らかに重そうでは?????**

前半部分囲われてる意味ないんじゃないですかね………………

この設定を書いた時よりはかなりVim正規表現力が向上しているので書き換えてみる．

{% highlight vim %}
matchadd('ExtraWhiteSpace', '\S\+\zs\s\+\ze$',0)
{% endhighlight %}

---> あ，呆気無く速くなったーーーー！！！！！
(後ろの `\ze` 要らないかもしれないがまあ．)


`:h \@<=`

{% highlight text %}
\@<=  Matches with zero width if the preceding atom matches just before what
  follows. |/zero-width| {not in Vi}
  Like "(?<=pattern)" in Perl, but Vim allows non-fixed-width patterns.
  Example      matches ~
  \(an\_s\+\)\@<=file  "file" after "an" and white space or an
        end-of-line
  For speed it's often much better to avoid this multi.  Try using "\zs"
  instead |/\zs|.  To match the same as the above example:
{% endhighlight %}

ヘルプにも遅いから `\zs` 使えって書いてありますね．あっけねえ．

ありがとうございました．
