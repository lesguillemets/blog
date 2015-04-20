---
layout: post
title:  "Vim-watchdogs と shellcheck でシェルスクリプトのシンタックスチェック"
date:  2015-04-20 12:00:00 UTC+9
categories: vim bash vim-watchdogs
---

Vim で bash のコードをたまに書いたりすると，シンタックスチェッカが欲しくなる．
[vim-watchdogs](https://github.com/osyo-manga/vim-watchdogs) と [shellcheck](http://www.shellcheck.net/) を使ってかなり快適にできるので，やってみる．

<small>ちなみに shellcheck は[namaristats.com](http://namaristats.com/)[^namari] 経由で知りました．ありがとうございます．</small>

## Vim-watchdogs とは
quickrun をバックエンドに多様な言語についてカスタマイズしやすいシンタックスチェックを提供するプラグイン．解説記事は多いのでまあ適当にどうぞ．

## shellcheck とは
[haskell で書かれた](https://github.com/koalaman/shellcheck) シェルスクリプトの静的解析ツール．よいが，さすがにエラーメッセージが不親切なことがある．
もう shell 的なことも haskell で書きたくなってきますね．

インストールは先のレポジトリに行ってビルドするか，
`cabal update; cabal install shellcheck` か，Debian 系なら `apt` で行けるようです（`apt-get install shellcheck`）．

## では設定
`man shellcheck` より

{% highlight text %}
shellcheck [ -f format ] [ -e code ] [ -s shell ] files
OPTIONS
       -f format, --format format
              Select the format used for printing diagnostics.
              Available formats are checkstyle (XML based format), gcc, json and tty (colorful).
{% endhighlight %}

`gcc` が vim で使うには都合良さそうですね．というわけで必要ツールをインストールして `.vimrc` に以下

{% highlight vim %}
let g:quickrun_config["watchdogs_checker/shellcheck"] = {"command" : "shellcheck", "cmdopt" : "-f gcc"}
let g:quickrun_config["sh/watchdogs_checker"] = {"type" : "watchdogs_checker/shellcheck"}
{% endhighlight %}

こんな感じで行けると思います．
あとは

{% highlight vim %}
autocmd FileType sh nnoremap <buffer> <Space>q :<C-u>WatchdogsRun<CR>
{% endhighlight %}

などで便利に使えばよろしうございます．めでたし．

[^namari]: [解説記事](http://qiita.com/belbomemo/items/d2ab69082cf200a176e8)
