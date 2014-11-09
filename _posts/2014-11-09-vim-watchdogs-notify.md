---
layout: post
title:  "vim-watchdogs でエラーがなかった時に通知する"
date:  2014-11-09 00:00:00 UTC+9
categories: Vim
---

## 問題
[vim-watchdogs](https://github.com/osyo-manga/vim-watchdogs) は，[vim-quickrun](https://github.com/thinca/vim-quickrun) をバックエンドに用いた汎用的でカスタマイズ自在なシンタックスチェックプラグインです．紹介記事をいくつか挙げると

* [watchdogs.vim つくりました - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20120924/1348473304) （作者の osyo-manga さんの記事）
* [vim-watchdogsで快適なシンタックスチェック - Blank File](http://h-miyako.hatenablog.com/entry/2014/10/18/031830)

などがあります．

[vimproc](https://github.com/Shougo/vimproc.vim) と併用すれば(大体任意のタイミングで)非同期に処理できるのが売りの一つですが，逆に非同期で処理してもらっていると，チェック中なのかエラーがなくて黙ってるのかわかりにくくなってしまいます．チェックが終わったらなにかしらの通知が欲しい．どうすればよいのでしょうか．

## 解決

vim-watchdogs が依存している [shabadou.vim](https://github.com/osyo-manga/shabadou.vim) で定義された `hook/echo/enable` を使います．

次のような設定を加えてみます（`g:quickrun_config["watchdogs_checker/_"]` に何かしら入ってる場合はそれに加える感じでやってください）．

{% highlight vim %}
let g:quickrun_config["watchdogs_checker/_"] = {
  \ "hook/echo/enable" : 1,
  \ "hook/echo/output_success": "> No Errors Found."
  \ }
{% endhighlight %}

これで `:WatchdogsRun` するとこのようになります．

![vim-watchdogs-notify.png]({{site.baseurl}}/img/2014-11/watchdogs_noerror.png)

エラーが見つかった時に何かしら `echo` してもらいたければ `output_failure` を使います．

## 簡単な解説

shabadou については [shabadou.vim を使って quickrun.vim をカスタマイズしよう - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20120919/1348054752) が参考になります．

平たくいえばこういう感じ（と理解している）

* quickrun は仕組みとして [`hook`](http://vim-help-jp.herokuapp.com/#quickrun-hook) を提供している．
* vim-watchdogs は quickrun つかって色々やってる
* だから watchdogs のこのタイミングでなんかして欲しい，という時も quickrun の hook を使えば良い．
* 色々便利な hook 集が shabadou で，よしなに使えるのを使う．

`:h shabadow-hook/echo` には次のようにあります．

{% highlight text %}
- "echo"          *shabadou-hook/echo*
  設定された |quickrun-hook-point| にコマンド出力を行います。
  オプション ~
  output_{point}	デフォルト: ""
  {point} 時に設定した文字列をコマンド出力します。
Example >
  " コマンドの成功時に "success"
  " コマンドの失敗時に "failure"
  " を出力する
  :QuickRun
  \   -hook/echo/enable 1
  \   -hook/echo/output_success success
  \   -hook/echo/output_failure failure
{% endhighlight %}

まさに欲しいやつっぽい．めでたい．


## 他には？

基本的になんかしたいんだけどﾅｰって時には先の作者の方による解説記事読んだり，そのの下の方に設定例があるのでそれぞれ眺めてみるとかすると良いと思います．

原理的には要するに quickrun でできることがひと通りできるはずで，時間のかかるチェックであればアニメーションも考慮にはいります．

昨日は [VimConf2014](http://vimconf.vim-jp.org/2014/) でしたが，その中の supermomonga さんの [発表](http://www.slideshare.net/supermomonga/super-cool-presentation-at-vimconf2014) （かなりすごい）にあるような感じで喋らせるのも楽しいかもしれませんね（便利）．
